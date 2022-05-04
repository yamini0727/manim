#!/bin/bash
set -x
echo "** python-backend-logs **" >> /tmp/python-backend-deploy_logs
runuser -l ubuntu -c 'sudo pm2 status' | grep -wo python-backend
if [  $? -ne 0 ];
then
   echo "############################## pm2 not running #################################" >> /tmp/python-backend-deploy_logs
else
   echo "############################## pm2 already running Deleting ####################" >> /tmp/python-backend-deploy_logs
    runuser -l ubuntu -c 'sudo pm2 delete python-backend'
fi
rm -rf /home/ubuntu/python-backend/
if [ ! -d /home/ubuntu/python-backend ]; then
runuser -l ubuntu -c 'mkdir -p /home/ubuntu/python-backend' >> /tmp/python-backend-deploy_logs
fi
