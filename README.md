# GreenCube Email Test Setup

## Overview

This project combines the test email server [Greenmail](https://greenmail-mail-test.github.io/greenmail/) with
the [Roundcube](https://roundcube.net/) webmail client into one Docker image that allows quickly starting a
complete setup for email testing. It's main intend is to be deployed as a service in a test environment using
Kubernetes or other container runtimes, but it can also be run standalone.

Note: this essentially just combines the functionality of the [Greenmail Docker image](https://hub.docker.com/r/greenmail/standalone)
and the [Roundcube Docker image](https://hub.docker.com/r/roundcube/roundcubemail/) into one. If you are only
after part of this functionality, you may want to consider either of these as well.

# Features:

* allow sending email to any address using the Greenmail SMTP endpoint - this will automatically create
  necessary inboxes
* allow access to these inboxes from the Roundcube web client
* also allow IMAP4 and POP3 using Greenmail's capabilities, making it possible to view email in other
  mail clients, e.g. to check rendering of HTML email

# Basic Usage

For a basic test setup start Greencube like this:

```shell
docker run --name greencube \
           -p 3025:25 \
           -p 3143:143 \
           -p 8000:80 \
           -p 8080:8080 \
           -d \
           greencube
```

This will allow you to:

* send email to `localhost:3025`. Make sure you do not use SMTPS/TLS, and do not use authentication as that
  will fail. Whenever an email is sent this way, a new user and inbox is created automatically.
* review email at http://localhost:8000 - the Roundcube UI is available there, avoiding the need to set up
  an email client. The user has to be created by sending an email first, any non-empty string will
  be accepted as password.
* receive email at `localhost:3143`. Point any IMAP mail client to this, do not use IMAPS/TLS, and use plain
  password authentication. This is useful if you want to see how email is shown in a particular email client.
* interact with the Greenmail test email server at http://localhost:8080 - this is the OpenAPI endpoint,
  which also hosts a UI with documentation and the ability to issue request. You can e.g. use this to
  purge mail boxes to save on space.

Note that if you use an external email client, some may produce errors as they cannot find certain folders
such as `Sent` or `Trash`. This can be avoided by disabling the related features such as saving a copy on
sending or moving email to trash when deleting.

# Advanced usage

The setup maps a number of ports:

* 8000 is the Roundcube web client
* 8080 is the Greenmail OpenAPI endpoint
* 25 / 465 is SMTP / SMTPS
* 143 / 993 is IMAP / IMAPS
* 110 / 995 is POP3 / POP3S

See the start command in the `build_and_test.sh` script for an example of how to run the image into a
standalone container with all ports enabled.

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
