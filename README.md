# GreenCube Email Test Setup

## Status

This is work in progress and only partially working. At the moment sending mail via telnet works but doesn't
show the sender, Thunderbird and Rouncube throw errors. Roundcube, Grenmail API and IMAP seem to work fine.

## Overview

This project combines the test email server [Greenmail](https://greenmail-mail-test.github.io/greenmail/) with
the [Roundcube](https://roundcube.net/) webmail client into one Docker image that allows quickly starting a
complete setup for email testing. It's main intend is to be deployed as a service in a test environment using
Kubernetes or other container runtimes, but it can also be run standalone.

Features:

* allow sending email to any address using the Greenmail SMTP endpoint - this will automatically create
  necessary inboxes
* allow access to these inboxes from the Roundcube web client
* also allow IMAP4 and POP3 using Greenmail's capabilities, making it possible to view email in other
  mail clients, e.g. to check rendering of HTML email

The setup maps a number of ports:

* 8000 is the Roundcube web client
* 8080 is the Greenmail OpenAPI endpoint
* 25 / 465 is SMTP / SMTPS
* 143 / 993 is IMAP / IMAPS
* 110 / 995 is POP3 / POP3S

See the start command in the `build_and_test.sh` script for an example of how to run the image into a
standalone container.

## Development Setup

When working on this Docker configuration, the script `build_and_test.sh` can be used to speed things up.
It will stop any existing docker containers, build a new image, then start that as a detached container
with all ports mapped. The HTTP port (Roundcube on 8000, Greenmail on 8080) are mapped as is, all email
related ports are mapped to a port 3000 higher, e.g. SMTP is on 3025 instead of 25. This is the equivalent
of Greenmail's test configuration and avoids clashing with other services that may already run on the host.

Once everything is started it opens a bash on the container for testing. This allows for a workflow of:

* run `build_and_test.sh`
* check whatever you need to in the container
* exit
* repeat
