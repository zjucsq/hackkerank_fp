from AquilaCore import *
import os 
import traceback
import sys
import json
from modelscope.pipelines import pipeline
from modelscope.utils.constant import Tasks
from modelscope.utils.input_output import (get_pipeline_information_by_pipeline, 
                                           call_pipeline_with_json,create_pipeline,
                                           pipeline_output_to_service_base64_output,
                                           )
# graph
# map_node
global pipe
pipe = None
task = os.getenv('TASK', '')
model_id = os.getenv('MODEL_ID', '')
model_revision = os.getenv('MODEL_VERSION', '')

# test
# curl -XPOST -H 'content-type: application/json' -H 'x-request-id:123' -H 'Expect:' -H 'x-callback-url:https://www.aliyun.com/' -d '{"foo":1}' localhost:8080/api

## Map Node
# input: one msg
# output: must be one msg
class MyProcessor(MapFunction):
    def Init(self, config):
        Logger.notice("MyProcessor Init")
        print("MyProcessor config:", config)
        global pipe 
        if pipe is None:
            pipe = create_pipeline(model_id, model_revision)
        print("Model task:", task)
        return True

    def Process(self, msg):
        ## input msg
        input_msg = msg
        response = None
        request_id = msg.Request().RequestId()
        try:
            pipeline_info = get_pipeline_information_by_pipeline(pipe)

            data = input_msg.Body()
            print(len(data), data)
            # infer_result = call_pipeline_with_json(pipeline_info,
            #                     pipe,
            #                     data)
            # result = pipeline_output_to_service_base64_output(task, infer_result) 
            result = pipe(input=data['input'],)
            print(type(result),result)
            if isinstance(result, dict):
                result = str(result['output'])
            print(type(result),result)
            
            response ={
                        "request_id":request_id,
                        "status_code":"200",
                        "status_name":"Success",
                        "status_message":"Success.",
                        "output":{
                            "text":result
                        }
                    }
        except Exception as e:
            exc_info = sys.exc_info()
            trace = traceback.format_tb(exc_info[2])
            response ={
                        "request_id":request_id, 
                        "status_code":"400", 
                        "status_name":"Failed",
                        "status_message":trace,
                        "output":{
                        }
                    }
        ## output msg
        output_msg = Message(response)
        return output_msg


class ServEngine(Engine):
    
    def Environment(self):
        # self.envs("AQUILA_REGRESS_MODE=1")
        pass      

    def Build(self):
        # build graph, graph name is related with your request_api
        graph = self.CreateGraph("invoke")
        # build node
        my_processor_node = graph.CreateNode(MyProcessor, name="my_processor", config=None)
        # build node topology
        my_processor_node

    def Test(self):
        pass

serv = ServEngine()
serv.Run()
