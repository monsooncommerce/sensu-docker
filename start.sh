#!/bin/bash
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

# sshd setup
ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N ''
ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_dsa_key -C '' -N ''
ssh-keygen -q -t rsa1 -f /etc/ssh/ssh_host_key -C '' -N ''
/usr/sbin/sshd -D -o UseDNS=no -o UsePAM=no
