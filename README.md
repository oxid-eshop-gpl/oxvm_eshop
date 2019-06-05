# Virtual Machine Successor Developer Preview

## Disclaimer

This is a preview utilizing many components under heavy development.

Which means that the content of this branch is prone to **massive** changes and that there is no guarantee about the future availability of any of the used components.

Over time more features will be added and the documentation will be fleshed out.

Any pull requests with improvements are welcome. Honorable mentions will be put into a changelog, or into a separate file, if there will be no changelog.

**Compatibility Challenge:** Get this setup working on Windows 10 and Mac OS X and provide a pull request!

## Quickstart

### Setup + Run

1) `git clone -b docker_developer_preview --recursive https://github.com/OXID-eSales/oxvm_eshop.git oxvm_ddp`
1) `cd oxvm_ddp`
1) `mkdir data/database`
1) `mkdir data/oxideshop`
1) `cp env.tpl .env`
1) Edit the .env file and enter correct HOST_USER_ID, HOST_GROUP_ID, HOST_USER_NAME and HOST_GROUP_NAME
1) `echo "127.0.0.1 webserver" | sudo tee -a /etc/hosts`
1) `docker-compose up -d`

### Access the Demoshop

* Shop: http://webserver/
* Administration: http://webserver/admin/ - User: "admin" / Password: "admin"

### Access the Selenium Desktop

* With any VNC viewer open up "localhost", the password is "secret".

### Run Tests

1) docker exec -it oxvm_ddp_php_1 /bin/bash
1) `./vendor/bin/runtests` for shop integration and unit tests
1) `./vendor/bin/runtests-selenium` for shop acceptance tests

## Compose Services

### db

Based on mysql:5.7 and customized via environment variables.
See troubleshooting ports if your port 3306 is already in use. 

### php

To deal with file ownership issues it is not possible to use oxidesales/oxideshop-docker-ce directly.<br>
Instead a custom build container is created from build/Dockerfile, which is based on oxidesales/oxideshop-docker-ce and will make your host user available within the container.

If oxidesales/oxideshop-docker-ce is not available on dockerhub, but you have access to https://github.com/OXID-eSales/oxideshop-docker-ce you can create the image like this:
1) `git@github.com:OXID-eSales/oxideshop-docker-ce.git`
1) `cd oxideshop-docker-ce/`
1) `./build.sh -t project -s v6.1.3`
1) `./build.sh -t dev -s v6.1.3`

### webserver

Based on httpd:2.4 this is customized via directly editing the config/httpd.conf file.
See troubleshooting ports if your port 80 is already in use.

### mailhog

Based on mailhog/mailhog:latest this provides the sendmail target for the shop.
Mails will not be sent to the real world, but hogged by Mailhog.

### selenium

Based on oxidesales/oxideshop-docker-selenium which provides a defined Selenium Server and Firefox version.
It exposes the port 4444 for running selenium tests and 5900 for VNC, so again see troubleshooting ports if those are already in use.

## The .env file

*Documentation to be done*

## Troubleshooting

### Port conflicts

If any ports are already in use on your host you might need to change the bindings in the "ports:" section of the affected service. <br>
For more details about the syntax see https://docs.docker.com/compose/compose-file/#ports.