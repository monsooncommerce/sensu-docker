FROM centos:latest
MAINTAINER Stephen Price <steeef@gmail.com>

RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum -y install sudo openssh-server redis gcc glibc-devel make ncurses-devel openssl-devel autoconf libxslt-devel

RUN curl -o /tmp/otp_src_R14B.tar.gz http://erlang.org/download/otp_src_R14B.tar.gz
RUN tar -zxf /tmp/otp_src_R14B.tar.gz -C /tmp
RUN cd /tmp/otp_src_R14B && ./configure PREFIX=/ && make && make install
RUN cd $HOME; rm -rf /tmp/otp_src_R14B*

RUN rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
RUN rpm -Uvh --nodeps http://www.rabbitmq.com/releases/rabbitmq-server/v3.1.4/rabbitmq-server-3.1.4-1.noarch.rpm
RUN rabbitmq-plugins enable rabbitmq_management

RUN mkdir -p /var/run/sshd
RUN chmod -rx /var/run/sshd

RUN useradd -d /home/sensu -m -s /bin/bash sensu
RUN echo sensu:sensu | chpasswd
RUN echo 'sensu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/sensu
RUN chmod 0440 /etc/sudoers.d/sensu

ADD sensu.repo /etc/yum.repos.d/sensu.repo
RUN yum -y install sensu

ADD config.json /etc/sensu/
ADD client.json /etc/sensu/conf.d/client.json

RUN chown -R sensu. /etc/sensu
RUN chown -R rabbitmq. /etc/rabbitmq

EXPOSE 15672
EXPOSE 8080
ADD start.sh /tmp/start.sh
CMD ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N ''
CMD ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_dsa_key -C '' -N ''
CMD ssh-keygen -q -t rsa1 -f /etc/ssh/ssh_host_key -C '' -N ''
CMD /bin/bash /tmp/start.sh
