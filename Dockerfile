FROM centos:latest
MAINTAINER Stephen Price <sprice@monsooncommerce.com>

RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum -y install openssh-server curl redis
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl
RUN mkdir -p /var/run/sshd
RUN echo '127.0.0.1 localhost.localdomain localhost' >> /etc/hosts
RUN useradd -d /home/sensu -m -s /bin/bash sensu
RUN echo sensu:sensu | chpasswd
RUN echo 'sensu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/sensu
RUN chmod 0440 /etc/sudoers.d/sensu

ADD policy-rc.d /usr/sbin/policy-rc.d

ADD install-sensu.sh /tmp/
RUN /tmp/install-sensu.sh
ADD config.json /etc/sensu/
ADD client.json /etc/sensu/conf.d/client.json

EXPOSE 15672:15672
EXPOSE 8080
ADD start.sh /tmp/start.sh
CMD /tmp/start.sh
