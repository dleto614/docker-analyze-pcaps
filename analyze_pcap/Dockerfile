FROM  kalilinux/kali-rolling:latest

RUN apt update && apt install dialog apt-utils -y && apt upgrade -y

RUN apt update && apt install p0f python3 python3-pip bruteshark dsniff tcpdump tshark git net-tools libpcap-dev nano iproute2 python3-venv inotify-tools tmux procps systemctl util-linux uuid-runtime jq zeek -y

RUN python3 -m venv /opt/venv

COPY start_monitor.service /lib/systemd/system/start_monitor.service
Run systemctl daemon-reload

COPY NTLMRawUnHide.py /opt/venv/bin/NTLMRawUnHide.py
RUN ln -s /opt/venv/bin/NTLMRawUnHide.py /opt/NTLMRawUnHide.py

RUN mkdir -p /opt/drop_files/scripts/logs
#COPY drop_files/scripts/ /opt/drop_files/scripts/

#COPY drop_files/scripts/init_docker.sh /opt/drop_files/scripts/
#COPY drop_files/scripts/init_docker.sh /opt/drop_files/scripts/
#RUN chmod u+x /opt/drop_files/scripts/init_docker.sh
CMD ["/bin/bash", "-c", "/opt/drop_files/scripts/init_docker.sh"]

RUN apt clean

WORKDIR /opt/
