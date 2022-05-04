#!/bin/bash
set -x
chown -R ubuntu:ubuntu /home/ubuntu/python-backend/


sleep 10
cp /opt/env/local.py /home/ubuntu/python-backend/config/
echo "***starting python-backend application ***" >> /tmp/python-backend-deploy_logs

runuser -l ubuntu -c 'cd /home/ubuntu/python-backend && virtualenv -p /usr/bin/python3.8 venv'
sleep 10
runuser -l ubuntu -c 'cd /home/ubuntu/python-backend && source venv/bin/activate && pip3 intsll -r requirement.txt'
sleep 10
runuser -l ubuntu -c 'cd /home/ubuntu/python-backend && python3 manage.py migrate ' >> /tmp/python-backend-deploy_logs
sleep 5
runuser -l ubuntu -c 'cd /home/ubuntu/scripts && sudo pm2 start python-backend.sh --name python-backend --silent'
s1=`sudo pm2 status | grep -we python-backend | awk '{print $12}'`
sleep 5
s2=`sudo pm2 status | grep -we python-backend | awk '{print $12}'`
if [ $s1 == $s2 ]
then

echo "BUILD SUCCESSFUL" >> /tmp/python-backend-deploy_logs
echo >> /tmp/python-backend-deploy_logs
else
echo "Node process is restarting" >> /tmp/python-backend-deploy_logs
echo >> /tmp/python-backend-deploy_logs
fi
