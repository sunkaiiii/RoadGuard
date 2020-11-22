import obd
import time

# open debug log
obd.logger.setLevel(obd.logging.DEBUG)

# emulator.answer['SPEED'] = '\0 "7E8 03 41 0D %.2X" % randint(20,100) \0\r'

# explicitly define the portstr when using windows
connection = obd.OBD(portstr="/dev/tty4",fast=False,baudrate=9600,timeout=30)


def get_current_speed():
    try:
        queryResult = connection.query(obd.commands.SPEED)
    # get exactly value of the spped, referenes on https://pint.readthedocs.io/en/stable/tutorial.html
        if queryResult is not None and queryResult.value is not None:
            return int(queryResult.value.magnitude)
        import sys
        return -sys.maxsize
    except:
        return -sys.maxsize

def close_connection():
    connection.close()




if __name__=="__main__":
    get_current_speed()