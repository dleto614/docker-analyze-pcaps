#!/usr/bin/env bash

echo "[*] Building dockerfile"

# So I don't have to continue typing the same command over and over again
sudo docker build -t pcap_analysis .

echo "[*] Done"
