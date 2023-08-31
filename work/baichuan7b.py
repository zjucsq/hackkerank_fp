import dashscope
from dashscope import Generation
from http import HTTPStatus
import json

dashscope.api_key = 'sk-0e1038016e9749c09148e1d823ba9f7f'

response = Generation.call(
    model='baichuan-7b-v1',
    prompt="Hamlet->Shakespeare\nOne Hundred Years of Solitude->",
    temperature=0.5,
    min_length=10,
    max_length=20
)

if response.status_code == HTTPStatus.OK:
    print(json.dumps(response, indent=4, ensure_ascii=False))
else:
    print(response)
    print('Code: %d, status: %s, message: %s' %
          (response.status_code, response.code, response.message))
