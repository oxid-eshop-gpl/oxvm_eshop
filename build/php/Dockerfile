FROM oxidesales/oxideshop-docker-php:7.1

ARG HOST_USER_ID
ARG HOST_USER_NAME
ARG HOST_GROUP_ID
ARG HOST_GROUP_NAME
ARG MSMTP_CONFIG_APPEND
ARG WITH_XDEBUG

USER root
RUN groupadd -f -g $HOST_GROUP_ID $HOST_GROUP_NAME && \
    useradd -m -d /home/$HOST_USER_NAME -s /bin/bash -g $HOST_GROUP_ID -u $HOST_USER_ID $HOST_USER_NAME || true && \
    echo "$HOST_USER_NAME  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    printf "$MSMTP_CONFIG_APPEND" >> /etc/msmtprc && \
    if [ "$WITH_XDEBUG" = "1" ] ; then mv /usr/optional_xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini ; fi

USER $HOST_USER_NAME
WORKDIR /var/www/oxideshop
