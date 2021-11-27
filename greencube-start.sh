#!/usr/bin/env bash

set -e

echo "Starting Greenmail Server"
java -Dgreenmail.setup.all \
     -Dgreenmail.hostname=0.0.0.0 \
     -Dgreenmail.users.login=email \
     -Dgreenmail.auth.disabled \
     -jar /greenmail.jar > /greenmail.out 2> /greenmail.err &

echo "Forwarding to the Roundcube scripts"
. /docker-entrypoint.sh
