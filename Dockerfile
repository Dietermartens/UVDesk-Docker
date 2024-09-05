FROM thecodingmachine/php:8.3-v4-apache

ENV PHP_EXTENSION_MAILPARSE=1 \
    PHP_EXTENSION_IMAP=1 \
    APACHE_DOCUMENT_ROOT=/var/www/html/public \
    PHP_INI_MEMORY_LIMIT=1g

RUN composer create-project uvdesk/community-skeleton /var/www/html

RUN a2enmod rewrite \
    && cd /var/www/html/ \
    && chmod 777 .env var config \
    && php bin/console c:c
