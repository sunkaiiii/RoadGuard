# FIT5140_Assignment 3, Python part
#### equipments
1. [Raspberry pi 4](https://www.amazon.com.au/gp/product/B085PVKJ6L/ref=ppx_yo_dt_b_asin_title_o05_s00?ie=UTF8&psc=1)
2. [ELM327 OBD2 extractor](https://www.amazon.com.au/gp/product/B07H2XQY21/ref=ppx_yo_dt_b_asin_title_o05_s00?ie=UTF8&psc=1)
3. [USB GPS Module](https://www.amazon.com.au/gp/product/B07N2L59DW/ref=ppx_yo_dt_b_asin_title_o04_s00?ie=UTF8&psc=1)
4. [Camera module](https://www.amazon.com.au/gp/product/B01ER2SKFS/ref=ppx_yo_dt_b_asin_title_o06_s00?ie=UTF8&psc=1)


## Installation
sudo apt-get update && sudo apt-get -y install gpsd gpsd-clients python-gps
sudo apt-get install gpsd gpsd-clients
sudo gpsd /dev/ttyACM0 -F /var/run/gpsd.sock
sudo systemctl restart gpsd.socket
sudo cgps -s
pip3 install gps
pip3 install obd
pip3 install firebase_admin
pip3 install mpu
pip3 install boto3
pip3 install picamera

Enable function of Raspberry pi camera
Put aws credentials information on ~/.aws

