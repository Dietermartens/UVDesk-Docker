# UVDesk dockerized

Php config and settings are based on [thecodingmachine/docker-images-php](https://github.com/thecodingmachine/docker-images-php).

Community version of UVDesk is included in image

```
version: "3"

services:
  uvdesk:
    image: dietermartens/uvdesk
    ports:
      - 80:80
    volumes:
      - ./uvdesk:/var/www/html:rw
    environment:
      - APP_ENV=PROD
      - APP_SECRET=${SECRET}
      - TZ=Europe/Brussels
      - CRON_USER=root
      - CRON_SCHEDULE=*/5 * * * *
      - CRON_COMMAND=cd /var/www/html && php bin/console uvdesk:refresh-mailbox info@domain.tld
```
