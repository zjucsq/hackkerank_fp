curl -XPOST -H 'content-type: application/json' -H 'Authorization:ZWJjNDk2ZWItZmFkYS00ZDgxLWJmN2UtMGFkOGQ5YTRlNWFi'  -d '{"header":{"request_id":"0072e7df-5dff-9ce6-a41b-39624e78268d"},"payload":{"input":{"prompt": "你好[SEP]你好!很高兴 与你交流![SEP]帮忙写一首关于夜色的诗歌","bot_profile": "我是达摩院的语言模型ChatPLUG,是基于海量数据训练得到。"}},"parameters":{}}' http://ds-0c79c942.1656375133437235.cn-beijing.pai-eas.aliyuncs.com/invoke


curl -XPOST -H 'content-type: application/json' -d '{"header":{"request_id":"0072e7df-5dff-9ce6-a41b-39624e78268d"},"payload":{"input":{"prompt": "你好[SEP]你好!很高兴 与你交流![SEP]帮忙写一首关于夜色的诗歌","bot_profile": "我是达摩院的语言模型ChatPLUG,是基于海量数据训练得到。"}},"parameters":{}}' 


{"input":
  {
    "prompt": 
    {
      "你好[SEP]你好!很高兴 与你交流![SEP]帮忙写一首关于夜色的诗歌",
      "bot_profile": "我是达摩院的语言模型ChatPLUG,是基于海量数据训练得到。"
    },
    "parameters":
    {

    }
  }
}


python -u /usr/src/app/app.py



{
  "HTTP_PORT":"9000",
  "TASK":"fid-dialogue",
  "MODEL_ID":"damo/ChatPLUG-3.7B",
  "MODEL_VERSION":"v1.0.1",
  "MODELSCOPE_CACHE":"/root/modelscope",
  "AQUILA_USE_CUSTOM_RESPONSE":"1"
}

{
  "HTTP_PORT":"9000",
  "TASK":"text-generation",
  "MODEL_ID":"AI-ModelScope/moss-moon-003-sft",
  "MODEL_VERSION":"v1.0.4",
  "MODELSCOPE_CACHE":"/root/modelscope",
  "AQUILA_USE_CUSTOM_RESPONSE":"1"
}

{
  "HTTP_PORT":"9000",
  "TASK":"text-generation",
  "MODEL_ID":"baichuan-inc/baichuan-7B",
  "MODEL_VERSION":"v1.0.5",
  "MODELSCOPE_CACHE":"/root/modelscope",
  "AQUILA_USE_CUSTOM_RESPONSE":"1"
}

{
  "HTTP_PORT":"9000",
  "TASK":"text-generation",
  "MODEL_ID":"baichuan-inc/Baichuan-13B-Chat",
  "MODEL_VERSION":"v1.0.3",
  "MODELSCOPE_CACHE":"/root/modelscope",
  "AQUILA_USE_CUSTOM_RESPONSE":"1"
}

{
  "HTTP_PORT":"9000",
  "TASK":"text-generation",
  "MODEL_ID":"AI-ModelScope/bloomz-7b1-mt",
  "MODEL_VERSION":"v1.0.0",
  "MODELSCOPE_CACHE":"/root/modelscope",
  "AQUILA_USE_CUSTOM_RESPONSE":"1"
}

1
{
  "HTTP_PORT":"9000",
  "TASK":"translation",
  "MODEL_ID":"damo/nlp_csanmt_translation_zh2en",
  "MODEL_VERSION":"v1.0.1",
  "MODELSCOPE_CACHE":"/root/modelscope",
  "AQUILA_USE_CUSTOM_RESPONSE":"1"
}
4d64f155

2
{
  "HTTP_PORT":"9000",
  "TASK":"translation",
  "MODEL_ID":"damo/nlp_csanmt_translation_en2zh",
  "MODEL_VERSION":"v1.0.1",
  "MODELSCOPE_CACHE":"/root/modelscope",
  "AQUILA_USE_CUSTOM_RESPONSE":"1"
}
a2eef59e

3
{
  "HTTP_PORT":"9000",
  "TASK":"token-classification",
  "MODEL_ID":"damo/mgeo_geographic_elements_tagging_chinese_base",
  "MODEL_VERSION":"v1.1.1",
  "MODELSCOPE_CACHE":"/root/modelscope",
  "AQUILA_USE_CUSTOM_RESPONSE":"1"
}
803910f2

4
{
  "HTTP_PORT":"9000",
  "TASK":"siamese-uie",
  "MODEL_ID":"damo/nlp_structbert_siamese-uie_chinese-base",
  "MODEL_VERSION":"v1.2",
  "MODELSCOPE_CACHE":"/root/modelscope",
  "AQUILA_USE_CUSTOM_RESPONSE":"1"
}
85f0753f


5
{
  "HTTP_PORT":"9000",
  "TASK":"named-entity-recognition",
  "MODEL_ID":"damo/nlp_raner_named-entity-recognition_chinese-base-news",
  "MODEL_VERSION":"v1.0.0",
  "MODELSCOPE_CACHE":"/root/modelscope",
  "AQUILA_USE_CUSTOM_RESPONSE":"1"
}
f03d4c10

6
{
  "HTTP_PORT":"9000",
  "TASK":"text-to-speech",
  "MODEL_ID":"damo/speech_sambert-hifigan_tts_zh-cn_16k",
  "MODEL_VERSION":"v1.0.2",
  "MODELSCOPE_CACHE":"/root/modelscope",
  "AQUILA_USE_CUSTOM_RESPONSE":"1",
  "OSS_ACCESS_KEY_ID":"LTAI5tECEGVAZjM2AhBMRb6Y",
  "OSS_ACCESS_KEY_SECRET":"ECQs3ep3vwZpwE9KXMrIfGqK28PgR8"
}
008a61ed

7
{
  "HTTP_PORT":"9000",
  "TASK":"text-to-video-synthesis",
  "MODEL_ID":"damo/text-to-video-synthesis",
  "MODEL_VERSION":"v1.1.0",
  "MODELSCOPE_CACHE":"/root/modelscope",
  "AQUILA_USE_CUSTOM_RESPONSE":"1",
  "OSS_ACCESS_KEY_ID":"LTAI5tECEGVAZjM2AhBMRb6Y",
  "OSS_ACCESS_KEY_SECRET":"ECQs3ep3vwZpwE9KXMrIfGqK28PgR8"
}
7f8c24dc

8
{
  "HTTP_PORT":"9000",
  "TASK":"multimodal-dialogue",
  "MODEL_ID":"damo/multi-modal_mplug_owl_multimodal-dialogue_7b",
  "MODEL_VERSION":"v0.1",
  "MODELSCOPE_CACHE":"/root/modelscope",
  "AQUILA_USE_CUSTOM_RESPONSE":"1",
  "OSS_ACCESS_KEY_ID":"",
  "OSS_ACCESS_KEY_SECRET":""
}
515ee4c3



sk-cddcf0e0735c4bb2b50f8f06efd736bc