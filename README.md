# Virtual Machine Successor Developer Preview

## Disclaimer

This is a preview utilizing many components under heavy development.

Which means that the content of this branch is prone to **massive** changes and that there is no guarantee about the future availability of any of the used components.

Over time more features will be added and the documentation will be fleshed out.

Any pull requests with improvements are welcome. Honorable mentions will be put into a changelog, or into a separate file, if there will be no changelog.

**Compatibility Challenge:** Get this setup working on Windows 10 and Mac OS X and provide a pull request!

## Quickstart

### Setup + Run

1) `git clone -b docker_developer_preview https://github.com/OXID-eSales/oxvm_eshop.git oxvm_ddp`
1) `cd oxvm_ddp`
1) `mkdir -p data/database data/oxideshop`
1) `cp env.dist .env`
1) Edit the .env file and enter correct HOST_USER_ID, HOST_GROUP_ID, HOST_USER_NAME and HOST_GROUP_NAME
1) `echo "127.0.0.1 oxideshop.local www.oxideshop.local" | sudo tee -a /etc/hosts` (only required once)
1) If you also use the vagrant VM you might need to edit `/etc/hosts` manually and comment out or delete all other occurrences of oxideshop.local, or you choose another naming of your choice
1) `docker-compose build` (To ensure you get up to date images consider adding `--pull`)
1) `docker-compose up -d`

### Access the Demoshop

* Shop: http://webserver/
* Administration: http://webserver/admin/ - User: "admin" / Password: "admin"

### Access the Selenium Desktop

* With any VNC viewer open up "localhost", the password is "secret".

### Run Tests

1) `docker exec -it oxvm_ddp_php_1 ./vendor/bin/runtests` for shop integration and unit tests
1) `docker exec -it oxvm_ddp_php_1 ./vendor/bin/runtests-selenium` for shop acceptance tests

### Execute composer commands

As the code directory is the default working space in the php container you can run any composer commands easily like `docker exec -it oxvm_ddp_php_1 composer -V` or `docker exec -it oxvm_ddp_php_1 composer why oxid-esales/oxideshop-composer-plugin`.

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

## docker-compose.yml

Some of the services described in the chapter "Compose Services" are mapping environment settings into their respective containers.

For those settings which are statically defined feel free to alter them to your needs, but keep in mind that the changes also might affect other places. (a.e. changing the "MYSQL_USER" in the db service is fine, but you will need to also change it in the shop configuration)

Those settings which are being set from existing environment values, have to be changed in the ".env" file.

## The .env file

In this file you can change the different available options.

### CE_CONTAINER_VERSION

You can use any of the available tags from https://hub.docker.com/r/oxidesales/oxideshop-docker-ce/tags.
More info about the build contents is available here https://github.com/OXID-eSales/oxideshop-docker-ce.

### SHOP_DIRECTORY

Mountpoint for the shop code. This has to be an existing directory a.e. the suggested directory `./data/oxideshop` is being created as empty directory in the quickstart scenario.
Only if this directory is empty, the prepared shop code from the container will be deployed into it at the first container-start.
If you use the same directory to switch between a "-dev" and non "-dev" setup, then you should use different directories as suggested in the "env.dist" file.

### DATABASE_DIRECTORY

Mountpoint for the binary db server files. An empty directory has to be available at the first container start.

### SHOP_SETUP_PATH

Is mapped as environment parameter in the php service, so this will overwrite the value provided in the "test_config.yml" file.
Usually will be something like "/var/www/oxideshop/source/Setup"

### SHOP_TESTS_PATH

Is mapped as environment parameter in the php service, so this will overwrite the value provided in the "test_config.yml" file.
Commonly used are "/var/www/oxideshop/tests" for the "-dev" installations directly based on https://github.com/OXID-eSales/oxideshop_ce<br>
or "/var/www/oxideshop/vendor/oxid-esales/oxideshop-ce/tests" for the project installation based on "https://github.com/OXID-eSales/oxideshop_project".

### SSMTP_CONFIG_APPEND

By default this is set to `mailhub=mailhog:8025` and will map the mailhog service with the port 8025 as mailhub target in the php container, meaning that all mails will be send to this service.
If you change the service name or port in the `docker-compose.yml` remember to change this setting accordingly.

**Notice:** Changing this requires a rebuild via `docker-compose build`.

### HOST_*

All of the four HOST_* settings have either all to be set or all to be empty.

If you do not set them, then the root account will be used in the container, meaning you will have to use sudo rights for deleting the contents of the mounted directories for the db and php service.

**Notice:** Changing any of them requires a rebuild via `docker-compose build`. 

#### HOST_USER_ID

The UID for the user, can be retrieved via `id -u`.

#### HOST_GROUP_ID

The GID for the users main group, can be retrieved via `id -g`.

#### HOST_USER_NAME

The name for the user, can be retrieved via `id -un`.

#### HOST_GROUP_NAME

The name for the users main group, can be retrieved via `id -gn`.

### PWD

On Linux and Mac OS X systems this environment variable is automatically available and is not needed.
MS Windows Users  are required to configure this with the project path.

## Troubleshooting

### Port conflicts

If any ports are already in use on your host you might need to change the bindings in the "ports:" section of the affected service. <br>
For more details about the syntax see https://docs.docker.com/compose/compose-file/#ports.