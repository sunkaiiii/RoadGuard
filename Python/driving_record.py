from speed_measurement import SpeedRecordExtractor
from datetime import datetime
from firebase import FireStoreSaver
import uuid

# Each time the service is started, a new drivingRecord is generated. id is the amount of id stored on the firestore.
class DrivingRecordRecorder:
    def __init__(self):
       
        self.record_data = {}
        self.file_store_saver = FireStoreSaver("drivingRecord")
        self.document_id = str(uuid.uuid4())
        print(self.document_id)
        self.recorder = SpeedRecordExtractor(1,"SpeedRecordExtractorThread",1,self.document_id)

    def start_recording(self):
        self.document_id = str(uuid.uuid4())
        self.recorder = SpeedRecordExtractor(1,"SpeedRecordExtractorThread",1,self.document_id)
        # get current date and time, references on https://www.programiz.com/python-programming/datetime/current-time
        self.record_data["startTime"] = datetime.now()
        self.record_data["startLocation"] = {}
        self.record_data["startLocation"]["latitude"] = self.recorder.location.latitude
        self.record_data["startLocation"]["logitude"] = self.recorder.location.longitude
        self.recorder.running = True
        self.recorder.start()
        print("Recording start")

    # Save the recorded results on the firestore when you end the service    
    def end_recording(self):
        self.record_data["path"] = self.recorder.path
        self.record_data["endTime"] = datetime.now()
        self.record_data["endLocation"] = {}
        self.record_data["endLocation"]["latitude"] = self.recorder.location.latitude
        self.record_data["endLocation"]["logitude"] = self.recorder.location.longitude
        self.record_data["drivingDistance"] = self.recorder.driving_distance
        self.recorder.running = False
        print(self.record_data)
        doc = self.file_store_saver.save_to_firestore(self.record_data,self.document_id)
        return doc

    def is_running(self):
        return self.recorder.running
    
    def get_speed_limit(self):
        return self.recorder.current_speed_limit

    def get_current_speed(self):
        return self.recorder.get_current_speed()
        
if __name__=="__main__":
    recorder = DrivingRecordRecorder()
    recorder.start_recording()
    import time
    time.sleep(20)
    recorder.end_recording()