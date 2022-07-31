import json
import logging
import os
import math

from flask import Flask, request

app = Flask(__name__)

@app.route('/', methods=['POST'])
def handle_post():
    content = json.loads(request.data)
    input = float(content['input'])
    return f"{math.floor(input)}", 200
    
app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
