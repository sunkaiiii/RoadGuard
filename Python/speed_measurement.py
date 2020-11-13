import OBD2Helper

from gps_loader import GPSInformationExtractor

gps_extractor = GPSInformationExtractor()

print(gps_extractor.get_current_position().latitude)

class SpeedRecordExtractor:
    class Location:
        def __init__(self):
            self.latitude = 0.0
            self.longitude = 0.0
    def __init__(self):
        self.current_place_id = ""
        self.current_speed_limit = -1
        self.location = self.Location()
        gps_info = gps_extractor.get_current_position()
        self.location.latitude = gps_info.latitude
        self.location.longitude = gps_info.longitude
        print(self.location.latitude,",",self.location.longitude)


if __name__=="__main__":
    SpeedRecordExtractor()