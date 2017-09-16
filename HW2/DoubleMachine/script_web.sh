#!/usr/bin/env bash
sudo apt-get update 
sudo apt-get -y install apache2
sudo apt-get -y install curl
sudo curl https://raw.githubusercontent.com/AndresHerrera/DS-2017-Fall/master/HW2/SingleMachine/index.html > /var/www/index.html 

