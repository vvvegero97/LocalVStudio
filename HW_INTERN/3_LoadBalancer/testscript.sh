#!/bin/bash

sudo apt install nginx -y
sleep 10
echo "This is html page of host "$HOSTNAME | sudo tee -a /var/www/html/index.html