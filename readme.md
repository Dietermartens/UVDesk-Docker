# UVDesk dockerized

Php config and settings are based on [thecodingmachine/docker-images-php](https://github.com/thecodingmachine/docker-images-php).

Community version of UVDesk is included in image.

When you setup the container, you should run the application in dev mode until after the installation process. If you run the installation in prod, it will run forever.

If you want to run it using docker-compose view the example below:

```
version: "3"

volumes:
  app:

services:
  uvdesk:
    image: dietermartens/uvdesk
    environment:
      # installation in dev, change it after installation to prod
      - APP_ENV=production
      - APP_SECRET=
      - TZ=Europe/Brussels
      - APP_TIMEZONE=Europe/Brussels
      - APP_CURRENCY=EUR
      - CRON_USER1=root
      - CRON_SCHEDULE1=*/5 * * * *
      - CRON_COMMAND1=cd /var/www/html && php bin/console uvdesk:refresh-mailbox info@domain.tld support@domain.tld
    restart: always
    extra_hosts:
      - "{uvdesk.domain.tld}:127.0.0.1"
    networks:
      - public
    volumes:
      - app:/var/www/html
```

To run this container with traefik (reverse proxy):

```
version: "3"

networks:
  public:
    external:
      name: proxy

volumes:
  app:

services:
  uvdesk:
    image: dietermartens/uvdesk
    environment:
      # installation in dev, change it after installation to prod
      - APP_ENV=dev
      - APP_SECRET=
      - TZ=Europe/Brussels
      - APP_TIMEZONE=Europe/Brussels
      - APP_CURRENCY=EUR
      - CRON_USER1=root
      - CRON_SCHEDULE1=*/5 * * * *
      - CRON_COMMAND1=cd /var/www/html && php bin/console uvdesk:refresh-mailbox info@domain.tld support@domain.tld
    # if using traefik proxy
    labels:
      - traefik.enable=true
      - traefik.docker.network=proxy
      - traefik.http.routers.uvdesk.rule=Host(`{uvdesk.domain.tld}`)
      - traefik.http.services.uvdesk.loadbalancer.server.port=80
      - traefik.http.routers.uvdesk.tls.certresolver=le
      - traefik.http.routers.uvdesk.tls=true
    restart: always
    extra_hosts:
      - "{uvdesk.domain.tld}:127.0.0.1"
    networks:
      - public
    volumes:
      - app:/var/www/html
```

## Problems

### Mailbox does not create tickets from email sync

Check the config/packages/uvdesk.yaml site_url if its not setup corectly, change it to the correct url without 'https://' or 'http://'.

### Build

- docker buildx build --platform linux/amd64 -t dietermartens/uvdesk --push .