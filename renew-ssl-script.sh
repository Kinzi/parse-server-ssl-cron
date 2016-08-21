#!/bin/bash

# stop nginx
/etc/init.d/nginx stop

# check for new cert
/opt/letsencrypt/letsencrypt-auto renew >> /var/log/le-renew.log

# combine latest letsencrypt files for mongo

# find latest fullchain*.pem
newestFull=$(ls -v /etc/letsencrypt/archive/server.packtor.com/fullchain*.pem | tail -n 1)
echo "$newestFull"

# find latest privkey*.pem
newestPriv=$(ls -v /etc/letsencrypt/archive/server.packtor.com/privkey*.pem | tail -n 1)
echo "$newestPriv"

# combine to mongo.pem
cat {$newestFull,$newestPriv} | tee /etc/ssl/mongo.pem

# set rights for mongo.pem
chmod 600 /etc/ssl/mongo.pem
chown mongodb:mongodb /etc/ssl/mongo.pem

# restart mongo
/sbin/restart mongod

# start nginx
/etc/init.d/nginx start
