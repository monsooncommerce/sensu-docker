FROM steeef/sensu-centos:latest
MAINTAINER Stephen Price <steeef@gmail.com>

RUN yum -y install git

RUN git clone https://github.com/opower/sensu-metrics-relay.git /tmp/wizardvan
RUN cp -R /tmp/wizardvan/lib/sensu/extensions/* /etc/sensu/extensions/
RUN cp /tmp/wizardvan/config_relay.json /etc/sensu/conf.d/
RUN rm -rf /tmp/wizardvan

EXPOSE 15672
EXPOSE 8080

ADD start.sh /tmp/start.sh
RUN chmod +x /tmp/start.sh
ENTRYPOINT /tmp/start.sh
