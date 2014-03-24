#!/bin/bash
#Need this for rabbitmq to start
echo  "127.0.0.1 $HOSTNAME" >> /etc/hosts

/sbin/service rabbitmq-server start
rabbitmqctl add_vhost /sensu
rabbitmqctl add_user sensu mypass
rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
rabbitmqctl set_user_tags sensu administrator

/sbin/service redis start
/sbin/service sensu-server start
/sbin/service sensu-api start
/sbin/service sensu-client start
/sbin/service sensu-dashboard start
/usr/sbin/sshd -D -o UseDNS=no -o UsePAM=no
