#!/bin/sh

cd /opt/monitor/server

sudo -u prometheus ./prometheus --config.file=prometheus.yml
