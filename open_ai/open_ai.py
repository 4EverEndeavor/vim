#!/usr/bin/env python3
import sys
import json
import requests
import os
import json

def get_api_key():
    with open(os.path.expanduser('~/.api_keys/open_ai'), 'r') as file:
        api_key = file.read().strip()
    return api_key


with open("/Users/eric/vim/open_ai/chat-message-history.json", 'r') as file:
    messages = json.load(file)

# Headers
headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ' + get_api_key()
}

# print("messages in python: " + str(messages))

# JSON data with dynamic "messages" property
json_data = {
    "model": "gpt-3.5-turbo",
    "messages": messages
}

# Make the request
url = 'https://api.openai.com/v1/chat/completions'
response = requests.post(url, headers=headers, json=json_data)

# print(response.content)

# Check if the request was successful (status code 2xx)
if response.status_code // 100 != 2:
    print("Error: Request failed with status code {}"
            .format(response.status_code))
    sys.exit(1)

# Parse the response for certain fields (adjust as needed)
response_json = response.json()
choices = response_json.get('choices')
print(choices[0].get('message').get('content'))
