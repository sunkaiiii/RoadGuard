from flask import request
from flask import Flask
from driving_record import DrivingRecordRecorder
import json
import OBD2Helper
import sys

app = Flask(__name__)
recorder = DrivingRecordRecorder()

@app.route('/api/start_recording',methods=['GET'])
def start_recording_service():
    result = {}
    if recorder.is_running():
        result["isError"] = True
        result["errorMessage"] = 'The services is already running!'   
    else:
        recorder.start_recording()
        result["isError"] = False
    return json.dumps(result)

@app.route('/api/stop_recording', methods = ['GET'])
def stop_recording_service():
    result = {}
    if recorder.is_running():
        doc = recorder.end_recording()
        result["documentId"] = doc.id
        result["isError"] = False
    else:
        result["isError"] = True
        result["errorMessage"] = 'The services is already stoped!'   
    return json.dumps(result)

@app.route('/api/get_running_status', methods = ['GET'])
def get_running_status():
    result = {}
    result["isRunning"] = recorder.is_running()
    return json.dumps(result)

@app.route('/api/get_current_speed', methods = ['GET'])
def get_current_speed():
    result = {}
    speed = recorder.get_current_speed()
    result["isError"] = False
    if speed == -sys.maxsize:
        result["isError"] = True
    result["speed"] = int(speed)
    return json.dumps(result)

@app.route('/api/get_current_speed_limit',methods = ['GET'])
def get_current_speed_limit():
    result = {}
    speed_limit = recorder.get_speed_limit()
    result["speedLimit"] = int(speed_limit)
    if speed_limit > 0:
        result["isError"] = False
    else:
        result["isError"] = True
    print(result)
    return json.dumps(result)
    
@app.route('/api/get_service_status',methods = ['GET'])
def get_service_running_status():
    result = {}
    result["isRunning"] = recorder.is_running()
    return json.dumps(result)


if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=False, port=5000)