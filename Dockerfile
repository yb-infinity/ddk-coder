# syntax=docker/dockerfile:1.4
FROM alpine:3.22.1

ARG BUILD_VER
ARG BUILD_DATE
ARG PHP_VER=84
ARG COMPOSER_VER=2.8.11
ARG CODER_VER=8.3.30

LABEL org.opencontainers.image.authors="DrakeMazzy <i.am@mazzy.rv.ua>" \
    org.opencontainers.image.title="Drupal Coding Standards Tools" \
    org.opencontainers.image.description="Docker image with PHP 8, Composer, and Code Quality Tools" \
    org.opencontainers.image.url="https://github.com/yb-infinity/ddk-coder" \
    org.opencontainers.image.licenses="GPL-2.0-or-later" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.version="${BUILD_VER}"

ENV COMPOSER_ALLOW_SUPERUSER=1
USER root
RUN set -e && apk --update add --no-cache tini wget \
    php${PHP_VER} \
    php${PHP_VER}-phar \
    php${PHP_VER}-json \
    php${PHP_VER}-curl \
    php${PHP_VER}-mbstring \
    php${PHP_VER}-openssl \
    php${PHP_VER}-tokenizer \
    php${PHP_VER}-xmlwriter \
    php${PHP_VER}-simplexml \
    # fix for arm64
    && rm -f /usr/bin/php /usr/bin/php-config /usr/bin/phpize && \
    if [ ! -e /usr/bin/php ]; then ln -s /usr/bin/php${PHP_VER} /usr/bin/php; fi && \
    if [ ! -e /usr/bin/php-config ]; then ln -s /usr/bin/php${PHP_VER}-config /usr/bin/php-config; fi && \
    if [ ! -e /usr/bin/phpize ]; then ln -s /usr/bin/php${PHP_VER}-ize /usr/bin/phpize; fi && \
    # install composer
    wget -q https://getcomposer.org/download/${COMPOSER_VER}/composer.phar -O /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer && \
    # install drupal/coder
    composer global config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true && \
    composer global require drupal/coder:${CODER_VER} && \
    cd /root/.composer && \
    composer audit --no-interaction --locked && \
    ln -s /root/.composer/vendor/bin/yaml-lint /usr/local/bin/yaml-lint && \
    ln -s /root/.composer/vendor/bin/phpcbf /usr/local/bin/phpcbf && \
    ln -s /root/.composer/vendor/bin/phpcs /usr/local/bin/phpcs && \
    # configure
    echo -e "\nmemory_limit = -1" >> /etc/php${PHP_VER}/php.ini && \
    phpcs --config-set show_progress 1 && \
    phpcs --config-set colors 1 && \
    phpcs --config-set report_width 80 && \
    phpcs --config-set encoding utf-8 && \
    # cleanup
    apk del wget && \
    rm -rf /etc/apk /lib/apk /usr/share/apk /var/cache/apk/* && \
    composer clear-cache && \
    rm -f /usr/local/bin/composer && \
    find /root -type d -name ".git" -o -name ".github" -o -name "tests" | xargs rm -rf

VOLUME /tmp
WORKDIR /tmp

ENTRYPOINT ["/sbin/tini", "--"]
