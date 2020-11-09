import obd
import time

# open debug log
obd.logger.setLevel(obd.logging.DEBUG)

# explicitly define the portstr when using windows
connection = obd.OBD(portstr="COM3",fast=False,baudrate=9600,timeout=30)

count = 0
while count < 300:
    queryResult = connection.query(obd.commands.SPEED)
    print(queryResult.value)
    print(count)
    time.sleep(1)
    count += 1

connection.close()