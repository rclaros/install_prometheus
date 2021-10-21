#!/bin/sh

# check path
 if [ -d /opt/monitor ] 
 then
     echo "/opt/monitor OK"
 else
     mkdir -p /opt/monitor
     echo "/opt/monitor CREATED OK"
 fi
# check user
username="prometheus"
if [ `sed -n "/^$username/p" /etc/passwd` ]
then
    echo "User [$username] already exists"
else
    echo "User [$username] doesn't exist"
    sudo useradd -r -s /bin/false prometheus
    chown -R prometheus:prometheus /opt/monitor
fi

# clean path
rm -rf /opt/monitor/*

# copy files
cp prometheus-1.7.2.linux-amd64.tar.gz /opt/monitor/
cp node_exporter-0.14.0.linux-amd64.tar.gz /opt/monitor/
cp prometheus.yml /opt/monitor/
cp start_server.sh /opt/monitor/
cp prometheus.service /opt/monitor/
cp node_exporter.service /opt/monitor/

# mode to path
cd /opt/monitor

# extract file
tar xvfz prometheus-1.7.2.linux-amd64.tar.gz
tar xvfz node_exporter-0.14.0.linux-amd64.tar.gz

# rename files
mv prometheus-1.7.2.linux-amd64 server
mv node_exporter-0.14.0.linux-amd64 node

# copy content
cat /opt/monitor/prometheus.yml > /opt/monitor/server/prometheus.yml

# permission bash
sudo chmod 700 start_server.sh

# permission user
chown -R prometheus:prometheus /opt/monitor

 if [ -f /etc/systemd/system/prometheus.service ] 
 then
     echo "prometheus.service OK"
     echo "node_exporter.service OK"
 else
     mv prometheus.service /etc/systemd/system/prometheus.service
     mv node_exporter.service /etc/systemd/system/node_exporter.service
     sudo systemctl daemon-reload
     sudo systemctl enable prometheus.service
     sudo systemctl enable node_exporter.service
     echo "Services CREATED OK"
 fi
 
# clean files
rm -rf prometheus-1.7.2.linux-amd64.tar.gz
rm -rf node_exporter-0.14.0.linux-amd64.tar.gz
rm -rf prometheus.yml

# msm ok
echo "INSTALL SUCCEFULL"

echo "enter systemctl start node_exporter"
echo "enter systemctl start prometheus"

