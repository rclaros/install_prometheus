#!/bin/sh

 if [ -d /opt/monitor ] 
 then
     echo "/opt/monitor OK"
 else
     mkdir -p /opt/monitor
     echo "/opt/monitor CREATED OK"
 fi

username="prometheus"
if [ `sed -n "/^$username/p" /etc/passwd` ]
then
    echo "User [$username] already exists"
else
    echo "User [$username] doesn't exist"
    sudo useradd -r -s /bin/false prometheus
    chown -R prometheus:prometheus /opt/monitor
fi

cd /opt/monitor

wget -O server.tar.gz https://github.com/rclaros/install_prometheus/raw/main/prometheus-1.7.2.linux-amd64.tar.gz
wget -O node.tar.gz https://github.com/rclaros/install_prometheus/raw/main/node_exporter-0.14.0.linux-amd64.tar.gz

tar xvfz server.tar.gz
tar xvfz  node.tar.gz
mv prometheus-1.7.2.linux-amd64 server
mv node_exporter-0.14.0.linux-amd64 node
cat /opt/monitor/prometheus.yml >> /opt/monitor/server/prometheus.yml
sudo chmod 700 start_server.sh

chown -R prometheus:prometheus /opt/monitor

echo "SUCCESS";
