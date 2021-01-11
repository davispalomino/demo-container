from boto3.dynamodb.conditions import Key, Attr
import boto3, time,json, logging
from datetime import datetime
from flask import Flask, Response, request, jsonify
from flask_cors import CORS
app = Flask(__name__)
logging.basicConfig(level=logging.DEBUG)
CORS(app)

@app.route('/start')
def welcome():
    logging.info('starting welcome function')
    time_now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    logging.info('capturing date and time')
    return app.response_class(
        response=(json.dumps({"result":"success","message":"welcome microservice","data":[f"{time_now}"]},sort_keys="true", default=str)),
        status=200,
        mimetype='application/json'
    )

@app.route('/health')
def healthCheck():
    return app.response_class(
        response=(json.dumps({"result":"success","message":"health UP","data":[]},sort_keys="true", default=str)),
        status=200,
        mimetype='application/json'
    )

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)