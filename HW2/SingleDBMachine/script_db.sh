#!/usr/bin/env bash
sudo apt-get update 
sudo apt-get -y install postgresql postgresql-contrib
sudo sed -i "s/#listen_address.*/listen_addresses = '*'/" /etc/postgresql/9.1/main/postgresql.conf
sudo cat >> /etc/postgresql/9.1/main/pg_hba.conf <<EOF
host	all 	all	0.0.0.0/0 	md5
EOF

sudo su postgres -c "psql -c\"CREATE ROLE vagrant SUPERUSER LOGIN PASSWORD 'vagrant'\" "

sudo su postgres -c "createdb -E UTF8 -T template0 --locale=en_US.utf8 -O vagrant dbtest"

sudo /etc/init.d/postgresql restart
