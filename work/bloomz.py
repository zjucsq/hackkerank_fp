import dashscope
from dashscope import Generation
from http import HTTPStatus
import json

dashscope.api_key = 'sk-0e1038016e9749c09148e1d823ba9f7f'

response = Generation.call(
    model='bloomz-7b1-mt-v1',
    prompt="""who are you?""",
    max_new_tokens=100
)

if response.status_code == HTTPStatus.OK:
    print(json.dumps(response, indent=4, ensure_ascii=False))
else:
    print(response)
    print('Code: %d, status: %s, message: %s' %
          (response.status_code, response.code, response.message))
