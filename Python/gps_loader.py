from gps import *
import time

running = True
gpsd = gps(mode=WATCH_ENABLE|WATCH_NEWSTYLE)

# Extract GPS information from the GPS module.
# References on https://maker.pro/raspberry-pi/tutorial/how-to-read-gps-data-with-python-on-a-raspberry-pi

class GPSInformationExtractor:
    class GPSInformationResult:
        def __init__(self):
            self.latitude = 0
            self.longitude = 0
            self.speed = 0
    def get_current_position(self):
        nx = gpsd.next()
        result = self.GPSInformationResult()
        if nx['class'] == 'TPV':
            print(nx)
            latitude = getattr(nx,'lat', "Unknown")
            longitude = getattr(nx,'lon', "Unknown")
            result.latitude = latitude
            result.longitude = longitude
            print("Your position: lon = " + str(longitude) + ", lat = " + str(latitude))
        return result

def getPositionData(gps):
    nx = gpsd.next()
    # For a list of all supported classes and fields refer to:
    # https://gpsd.gitlab.io/gpsd/gpsd_json.html
    if nx['class'] == 'TPV':
        print(nx)
        latitude = getattr(nx,'lat', "Unknown")
        longitude = getattr(nx,'lon', "Unknown")
        print("Your position: lon = " + str(longitude) + ", lat = " + str(latitude))



try:
    print("Application started!")
    while running:
        getPositionData(gpsd)
        time.sleep(1.0)

except (KeyboardInterrupt):
    running = False
    print("Applications closed!")