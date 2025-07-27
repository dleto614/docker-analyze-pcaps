#!/usr/bin/env bash

echo "[*] Starting docker in the background"

mkdir -p drop_files/scripts/logs
mkdir -p drop_files/results
mkdir -p drop_files/pcaps

chmod +x drop_files/scripts/*

sudo docker run -t -d -v $(pwd)/drop_files:/opt/drop_files pcap_analysis

echo "[*] Done"
