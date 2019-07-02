ARG CE_CONTAINER_VERSION

FROM oxidesales/oxideshop-docker-ce:$CE_CONTAINER_VERSION

ARG HOST_USER_ID
ARG HOST_USER_NAME
ARG HOST_GROUP_ID
ARG HOST_GROUP_NAME
ARG SSMTP_CONFIG_APPEND
ARG WITH_XDEBUG

USER root
RUN groupadd -f -g $HOST_GROUP_ID $HOST_GROUP_NAME && \
    useradd -m -d /home/$HOST_USER_NAME -s /bin/bash -g $HOST_GROUP_ID -u $HOST_USER_ID $HOST_USER_NAME || true && \
    echo "$HOST_USER_NAME  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo "$SSMTP_CONFIG_APPEND" >> /etc/ssmtp/ssmtp.conf && \
    chown -R $HOST_USER_NAME.$HOST_GROUP_NAME /var/www/oxideshop_template && \
    if [ "$WITH_XDEBUG" = "1" ] ; then mv /usr/optional_xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini ; fi

USER $HOST_USER_NAME