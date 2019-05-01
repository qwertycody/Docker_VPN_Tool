FROM debian:latest

USER root

COPY vpnBypass.sh /

RUN chmod 755 vpnBypass.sh &&\
    apt-get update &&\
    apt-get install -y openconnect openssh-server passwd dnsutils iptables iproute2 screen ipcalc &&\
    apt-get clean all &&\
    mkdir /var/run/sshd &&\
    echo "PasswordAuthentication yes" >> /etc/ssh/ssh_config &&\
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config &&\
    echo 'echo "root:password" | chpasswd' >> /startup.sh &&\
    echo "/usr/sbin/sshd -D &" >> /startup.sh &&\
    echo "sh /vpnBypass.sh" >> /startup.sh &&\
    echo "ping localhost" >> /startup.sh &&\
    chmod 755 /startup.sh

EXPOSE 22

CMD sh /startup.sh