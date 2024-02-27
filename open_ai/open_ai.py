#!/usr/bin/env python3
import sys
import json
import requests

if len(sys.argv) != 2:
    print("Usage: {} <prompt>".format(sys.argv[0]))
    sys.exit(1)

# Headers
headers = {
    'Content-Type': 'application/json',
    'Authorization': ''
}

# Array values provided as parameter
prompt = sys.argv[1]

# This helps with formatting dramatically
prompt += ". Return only the actual code. "
prompt += "Dont include any meta formatting or quotes, just code"

# JSON data with dynamic "prompt" property
json_data = {
    "model": "gpt-3.5-turbo",
    "messages": [{
        "role": "user",
        "content": prompt
    }]
}

# Make the request
url = 'https://api.openai.com/v1/chat/completions'
response = requests.post(url, headers=headers, json=json_data)

# Check if the request was successful (status code 2xx)
if response.status_code // 100 != 2:
    print("Error: Request failed with status code {}"
        .format(response.status_code))
    sys.exit(1)

# Parse the response for certain fields (adjust as needed)
response_json = response.json()
choices = response_json.get('choices')
print(choices[0].get('message').get('content'))
