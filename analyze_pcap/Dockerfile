FROM  kalilinux/kali-rolling

# Noninteractive mode to avoid prompts during installs
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y

RUN apt update && apt install curl gpg p0f python3 python3-pip bruteshark dsniff tcpdump tshark git net-tools libpcap-dev nano iproute2 python3-venv inotify-tools tmux procps systemctl util-linux uuid-runtime jq -y

# Apparently zeek is broken due to libc6 dependency issue.
# Best course of action is just installing directly from source.
# Kali is based off of Debian so this should work just fine.
RUN echo 'deb http://download.opensuse.org/repositories/security:/zeek/Debian_Testing/ /' | tee /etc/apt/sources.list.d/security:zeek.list
RUN curl -fsSL https://download.opensuse.org/repositories/security:zeek/Debian_Testing/Release.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/zeek.gpg
RUN apt update
RUN apt install -y zeek

RUN python3 -m venv /opt/venv

COPY start_monitor.service /lib/systemd/system/start_monitor.service
RUN systemctl daemon-reload

COPY NTLMRawUnHide.py /opt/venv/bin/NTLMRawUnHide.py
RUN ln -s /opt/venv/bin/NTLMRawUnHide.py /opt/NTLMRawUnHide.py

RUN mkdir -p /opt/drop_files/scripts/logs

CMD ["/bin/bash", "-c", "/opt/drop_files/scripts/init_docker.sh"]

RUN apt clean

WORKDIR /opt/
