import functions_framework
from flask import jsonify

@functions_framework.http
def multiply(request):
    request_json = request.get_json()
    multiplied = 2 * request_json['input']
    output = {"multiplied": multiplied}
    return jsonify(output)
