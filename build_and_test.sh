#!/usr/bin/env bash

set -e

docker stop greencube-test 2> /dev/null || true
docker rm greencube-test 2> /dev/null || true

docker build -t greencube .

docker run --name greencube-test \
           -e ROUNDCUBEMAIL_DEFAULT_HOST=localhost \
           -e ROUNDCUBEMAIL_SMTP_SERVER=localhost \
           -p 8000:80 \
           -p 3025:25 \
           -p 3465:465 \
           -p 3143:143 \
           -p 3993:993 \
           -p 3110:110 \
           -p 3995:995 \
           -p 8080:8080 \
           -d \
           greencube

docker exec -it greencube-test bash
