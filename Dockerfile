FROM centos:latest
MAINTAINER Stephen Price <steeef@gmail.com>

RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum -y install sudo openssh-server redis erlang

RUN rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
RUN rpm -Uvh http://www.rabbitmq.com/releases/rabbitmq-server/v3.1.4/rabbitmq-server-3.1.4-1.noarch.rpm
RUN rabbitmq-plugins enable rabbitmq_management

RUN mkdir -p /var/run/sshd
RUN chmod -rx /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key

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
CMD /bin/bash /tmp/start.sh
