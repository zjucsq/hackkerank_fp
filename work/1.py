import json
import requests
API_URL = "https://api-inference.modelscope.cn/api-inference/v1/models/damo/mgeo_geographic_elements_tagging_chinese_base"
# 请用自己的SDK令牌替换{YOUR_MODELSCOPE_SDK_TOKEN}（包括大括号）
headers = {"Authorization": f"Bearer 380d346d-fc6b-46d4-bdd3-b28a6a7c9bcc"}
def query(payload):
    data = json.dumps(payload)
    response = requests.request("POST", API_URL, headers=headers, data=data)
    return json.loads(response.content.decode("utf-8"))
payload = {"input": "浙江杭州市江干区九堡镇三村村一区"}
output = query(payload) 
print(output)