# NextCloud docker-compose

[Using NextCloud Docker Image](https://github.com/nextcloud/docker)

## Installation

Create the `.env` file from [.env.dist](.env.dist) example with the
environment variables from [docker let's encrypt nginx proxy](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion/wiki/Basic-usage)

```bash
docker-compose up -d
```

## Update docker images

```bash
./updateDockerImages.sh
```

## Increase file size

In order to increase file size uploading :

You have to update the php.ini in the nextcloud app and update theses lines :

```ini
post_max_size = 1000M

upload_max_filesize = 1000M
```

You have to update the nginx.conf in the nginx-proxy and add this line :

```
http {
    ...
    client_max_body_size 1000M;
}
```
