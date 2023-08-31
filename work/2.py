import json
import requests
API_URL = "https://api-inference.modelscope.cn/api-inference/v1/models/damo/nlp_csanmt_translation_zh2en"
# 请用自己的SDK令牌替换{YOUR_MODELSCOPE_SDK_TOKEN}（包括大括号）
headers = {"Authorization": f"Bearer 380d346d-fc6b-46d4-bdd3-b28a6a7c9bcc"}
def query(payload):
    data = json.dumps(payload)
    response = requests.request("POST", API_URL, headers=headers, data=data)
    return json.loads(response.content.decode("utf-8"))
payload = {"input": "阿里巴巴集团的使命是让天下没有难做的生意"}
output = query(payload) 
print(output)
