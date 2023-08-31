from AquilaCore import *
import os 
import traceback
import sys
from modelscope.pipelines import pipeline
from modelscope.utils.constant import Tasks
from modelscope.utils.input_output import (get_pipeline_information_by_pipeline, 
                                           call_pipeline_with_json,
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
# curl -XPOST -H 'content-type: application/json' -H 'x-request-id:123' -H 'Expect:' -d '{"callback_url":"http://www.aliyun.com/", "foo":1}' localhost:8080/api
# curl -XPOST -H 'content-type: application/json' -H 'x-request-id:123' -H 'Expect:' -H 'x-callback-url:https://www.aliyun.com/' -H 'x-callback-headers: {"a": "1"}' -d '{"foo":1}' localhost:8080/api
# curl -XPOST -H 'content-type: application/json' -H 'x-request-id:123' -H 'Expect:' -d '{"callback_url":"http://www.aliyun.com/", "callback_headers": {"a": "1"}, "foo":1}' localhost:8080/api

## Map Node
# input: one msg
# output: must be one msg
class MyProcessor(MapFunction):
    def Init(self, config):
        Logger.notice("MyProcessor Init")
        print("MyProcessor config:", config)
        global pipe 
        if pipe is None:
            pipe = pipeline(task=task, model=model_id, model_revision=model_revision)
        print("Model task:", task)
        return True

    def Process(self, msg):
        ## input msg
        input_msg = msg
        response = None
        request_id = msg.Request().RequestId()
        try:
            pipeline_info = get_pipeline_information_by_pipeline(pipe)

            data = input_msg.Body()['payload']
            if pipeline_info.task_name == Tasks.fid_dialogue:
                data['input']['history'] = data['input']['prompt']
            else:
                data['input']['text'] = data['input']['prompt'] 
            del data['input']['prompt']

            infer_result = call_pipeline_with_json(pipeline_info,
                                pipe,
                                data)
            result = pipeline_output_to_service_base64_output(task, infer_result) 
            if pipeline_info.task_name == Tasks.fid_dialogue:
                result = result['text']

            response ={
                        "header":{
                            "request_id":request_id, 
                            "status_code":"200", 
                            "status_name":"Success",
                            "status_message":"Success.",
                        },
                        "payload":{
                            "output":{
                                "text":result
                            }
                        }
                    }
        except Exception as e:
            exc_info = sys.exc_info()
            trace = traceback.format_tb(exc_info[2])
            response ={
                        "header":{
                            "request_id":request_id, 
                            "status_code":"400", 
                            "status_name":"Failed",
                            "status_message":trace,
                        },
                        "payload":{
                            "output":{
                                "text":""
                            }
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