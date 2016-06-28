#!/bin/bash

# Renew SSL cert
/opt/letsencrypt/letsencrypt-auto renew >> /var/log/le-renew.log

# combine letsencrypt files for mongo
cat /etc/letsencrypt/archive/<YOURDOMAIN>/{fullchain1.pem,privkey1.pem} | tee /etc/ssl/mongo.pem

# set rights for mongo.pem 
chmod 600 /etc/ssl/mongo.pem
chown mongodb:mongodb /etc/ssl/mongo.pem

# restart mongo
/sbin/restart mongod

# restart nginx
/etc/init.d/nginx reload


#### parse user crontab #####
# Restart pm2 with your parse user NOT root # make sure log folder exists
12 2 * * 2 /usr/bin/pm2 /sbin/restart 0 >> ~/logs/pm2/pm2-cron.log 2>&1
