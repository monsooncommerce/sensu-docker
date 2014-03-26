#!/bin/bash
if [ -n "${GRAPHITE_PORT_2003_TCP_ADDR}" ] ; then
    graphite_host="${GRAPHITE_PORT_2003_TCP_ADDR}"
else
    graphite_host="127.0.0.1"
fi
/sbin/service rabbitmq-server start
rabbitmqctl add_vhost /sensu
rabbitmqctl add_user sensu mypass
rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
rabbitmqctl set_user_tags sensu administrator

# wizardvan setup from Docker link
cat > /etc/sensu/conf.d/config_relay.json <<EOF
{
    "relay": {
        "graphite": {
            "host": "${graphite_host}",
            "port": 2003
        }
    }
}
EOF

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
