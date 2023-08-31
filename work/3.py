import json
import requests
API_URL = "https://api-inference.modelscope.cn/api-inference/v1/models/damo/nlp_structbert_siamese-uie_chinese-base"
# 请用自己的SDK令牌替换{YOUR_MODELSCOPE_SDK_TOKEN}（包括大括号）
headers = {"Authorization": f"Bearer 380d346d-fc6b-46d4-bdd3-b28a6a7c9bcc"}
def query(payload):
    data = json.dumps(payload)
    response = requests.request("POST", API_URL, headers=headers, data=data)
    return json.loads(response.content.decode("utf-8"))
payload = {"input": "1944年毕业于北大的名古屋铁道会长谷口清太郎等人在日本积极筹资，共筹款2.7亿日元，参加捐款的日本企业有69家。", "parameters": {"schema": "{\"人物\": null, \"地理位置\": null, \"组织机构\": null}"}}
output = query(payload) 
print(output)