sensu-docker
============

Dockerfile to Create a CentOS 6.x Sensu Server with WizardVan (for exporting to
Graphite).
Initially forked from https://github.com/petecheslock/sensu-docker

Docker Index:  https://index.docker.io/u/steeef/sensu-wizardvan-centos
Docker Index of non-WizardVan build:  https://index.docker.io/u/steeef/sensu-centos

This is for testing only - SSL is not setup/configured for the server and clients.
Installs Erlang from source since EPEL-provided RPM includes dependencies for
X11 libs.

You will need to edit `/etc/sensu/conf.d/config_relay.json` to point to your
Graphite server.

Run detached with pseudo-tty, publish ports:
```
sudo docker run -P -t -d steeef/sensu-wizardvan-centos
```

Port `15672` is where the rabbitmq management dashboard is running on
(`un: sensu pw: mypass`)
When you run container you can see which port the Sensu dashboard is listening
on by running `docker ps` (`un: admin pw: secret`)

By default - when starting the container, docker will start all the necessary
services and start sshd.

Run `sudo docker ps` to get the container ID

Then run `sudo docker inspect ${container ID}` to get the IP address of the
container to connect to.

From there you can SSH to the container to inspect the running sensu processes.
(`un: sensu pw: sensu`)
