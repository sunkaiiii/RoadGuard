import obd
import time

# open debug log
obd.logger.setLevel(obd.logging.DEBUG)

# explicitly define the portstr when using windows
connection = obd.OBD(portstr="/dev/pts/4",fast=False,baudrate=9600,timeout=30)

count = 0
while count < 300:
    queryResult = connection.query(obd.commands.SPEED)
    print(queryResult.value)
    time.sleep(1)
    count += 1

connection.close()

# emulator.answer['SPEED'] = '\0 "7E8 03 41 0D %.2X" % randint(0,100) \0\r'