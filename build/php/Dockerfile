FROM oxidesales/oxideshop-docker-php:7.1

ARG HOST_USER_ID
ARG HOST_GROUP_ID
ARG MSMTP_CONFIG_APPEND
ARG WITH_XDEBUG

USER root
RUN groupadd -f -g $HOST_GROUP_ID oxid && \
    useradd -m -d /home/oxid -s /bin/bash -g $HOST_GROUP_ID -u $HOST_USER_ID oxid || true && \
    echo "oxid ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    printf "$MSMTP_CONFIG_APPEND" >> /etc/msmtprc && \
    if [ "$WITH_XDEBUG" = "1" ] ; then mv /usr/optional_xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini ; fi

USER oxid
WORKDIR /var/www/oxideshop
