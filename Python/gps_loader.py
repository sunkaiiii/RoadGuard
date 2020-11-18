from gps import *
from json import JSONEncoder
import time

running = True
gpsd = gps(mode=WATCH_ENABLE|WATCH_NEWSTYLE)

# sudo apt-get update && sudo apt-get -y install gpsd gpsd-clients python-gps
# sudo apt-get install gpsd gpsd-clients
# sudo gpsd /dev/ttyACM0 -F /var/run/gpsd.sock
# sudo cgps -s
# pip3 install gps

# Extract GPS information from the GPS module.
# References on https://maker.pro/raspberry-pi/tutorial/how-to-read-gps-data-with-python-on-a-raspberry-pi

class GPSInformationExtractor:
    class GPSInformationResult():
        def __init__(self):
            self.latitude = 0
            self.longitude = 0
    def get_current_position(self):
        result = self.GPSInformationResult()
        while(result.latitude == 0):
            nx = gpsd.next()
            if nx['class'] == 'TPV':
                print(nx)
                latitude = getattr(nx,'lat', "Unknown")
                longitude = getattr(nx,'lon', "Unknown")
                result.latitude = latitude
                result.longitude = longitude
                print("Your position: lon = " + str(longitude) + ", lat = " + str(latitude))
                return result
        return result
    
    def get_current_gps_speed(self):
        nx = gpsd.next()
        import sys
        if nx['class'] == 'TPV':
            return getattr(nx,"speed",-sys.maxsize) * 3.6
        return -sys.maxsize

def getPositionData():
    nx = gpsd.next()
    # For a list of all supported classes and fields refer to:
    # https://gpsd.gitlab.io/gpsd/gpsd_json.html
    if nx['class'] == 'TPV':
        print(nx)
        latitude = getattr(nx,'lat', "Unknown")
        longitude = getattr(nx,'lon', "Unknown")
        print("Your position: lon = " + str(longitude) + ", lat = " + str(latitude))

if __name__=="__main__":

    GPSInformationExtractor().get_current_position()
    # try:
    #     print("Application started!")
    #     while running:
    #         getPositionData()
    #         time.sleep(1.0)

    # except (KeyboardInterrupt):
    #     running = False
    #     print("Applications closed!")