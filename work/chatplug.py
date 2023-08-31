import dashscope
from dashscope import Generation
from http import HTTPStatus
import json

dashscope.api_key = 'sk-0e1038016e9749c09148e1d823ba9f7f'

response = Generation.call(
    model='chatplug-3.7b-v1',
    prompt="视障人士是否应该被允许驾驶汽车？",
    # prompt= "你好[SEP]你好!很高兴与你交流![SEP]狂飙的导演是谁呀",
    # bot_profile= "我是达摩院的语言模型ChatPLUG， 是基于海量数据训练得到。",
    # knowledge= "《狂飙》由徐纪周执导的。《狂飙》的导演徐纪周也是编剧之一，代表作品有《永不磨灭的番号》《特战荣耀》《心理罪之城市之光》《杀虎口》《胭脂》等 [SEP]《狂飙》（The Knockout）是一部由 张译、张颂文、李一桐、张志坚 领衔主演，韩童生 特邀主演，吴健、郝平 友情出演，高叶、贾冰、李健 主演，徐纪周 执导，朱俊懿、徐纪周 担任总编剧的 刑侦 [SEP] 狂飙是由中央政法委宣传教育局，中央政法委政法信息中心指导，爱奇艺，留白影视出品，徐纪周执导，张译，李一桐，张志坚领衔主演的刑侦剧。不是。是徐纪周，1976年12月19日出生，毕业于中央戏剧",
    bot_profile="我是达摩院的语言模型ChatPLUG，是基于海量数据训练得到。",
    parameters={
        "forward_params": {
            "do_sample": True,
            "early_stopping": True,
            "length_penalty": 1.2,
            "max_length": 512,
            "min_length": 100,
            "no_repeat_ngram_size": 6,
            "num_beams": 3,
            "repetition_penalty": 1.2,
            "temperature": 0.8,
            "top_k": 50,
            "top_p": 0.8
        }
    }
)

if response.status_code == HTTPStatus.OK:
    print(json.dumps(response, indent=4, ensure_ascii=False))
else:
    print(response)
    print('Code: %d, status: %s, message: %s' %
          (response.status_code, response.code, response.message))
