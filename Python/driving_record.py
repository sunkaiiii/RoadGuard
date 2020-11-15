from speed_measurement import SpeedRecordExtractor
from datetime import datetime
from firebase import FireStoreSaver
import uuid

class DrivingRecordRecorder:
    def __init__(self):
       
        self.record_data = {}
        self.file_store_saver = FireStoreSaver("drivingRecord")
        self.document_id = str(uuid.uuid4())
        print(self.document_id)
        self.recorder = SpeedRecordExtractor(1,"SpeedRecordExtractorThread",1,self.document_id)

    def start_recording(self):
        # get current date and time, references on https://www.programiz.com/python-programming/datetime/current-time
        self.record_data["startTime"] = datetime.now()
        self.record_data["startLocation"] = {}
        self.record_data["startLocation"]["latitude"] = self.recorder.location.latitude
        self.record_data["startLocation"]["logitude"] = self.recorder.location.longitude
        self.recorder.start()
    def end_recording(self):
        self.record_data["path"] = self.recorder.path
        self.record_data["endTime"] = datetime.now()
        self.record_data["endLocation"] = {}
        self.record_data["endLocation"]["latitude"] = self.recorder.location.latitude
        self.record_data["endLocation"]["logitude"] = self.recorder.location.longitude
        self.record_data["drivingDistance"] = self.recorder.driving_distance
        self.recorder.running = False
        print(self.record_data)
        self.file_store_saver.save_to_firestore(self.record_data,self.document_id)

if __name__=="__main__":
    recorder = DrivingRecordRecorder()
    recorder.start_recording()
    import time
    time.sleep(20)
    recorder.end_recording()