FROM debian:latest

RUN apt-get update 
RUN apt-get install -y openconnect
RUN apt-get install -y openssh-server 
RUN apt-get install -y passwd
RUN apt-get install -y python3
RUN apt-get install -y python3-pip
RUN apt-get install -y dnsutils
RUN apt-get install -y iptables
RUN apt-get install -y iproute2
RUN apt-get install -y screen

RUN pip3 install https://github.com/dlenski/vpn-slice/archive/master.zip

RUN apt-get clean all

RUN mkdir /var/run/sshd

RUN echo "PasswordAuthentication yes" >> /etc/ssh/ssh_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

RUN echo 'echo "root:password" | chpasswd' >> /startup.sh
RUN echo "/usr/sbin/sshd -D &" >> /startup.sh
RUN echo "ping localhost" >> /startup.sh

EXPOSE 22
EXPOSE 3389

CMD sh /startup.sh