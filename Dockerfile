FROM roundcube/roundcubemail:1.4.x-apache

ADD https://repo1.maven.org/maven2/com/icegreen/greenmail-standalone/1.6.5/greenmail-standalone-1.6.5.jar /greenmail.jar
ADD /deploy/* /greencube/

RUN \
    apt-get update && \
    apt-get -y upgrade && \
    # openjdk package needs this, but it's missing in the base image
    mkdir /usr/share/man/man1/ && \
    apt-get install -y openjdk-11-jre-headless  && \
    rm -rf /var/lib/apt/lists/* && \
    chmod a+x /greencube/*.sh

ENV ROUNDCUBEMAIL_DEFAULT_HOST=localhost
ENV ROUNDCUBEMAIL_SMTP_SERVER=localhost

EXPOSE 25 465 143 993 110 995 8080

ENTRYPOINT ["/greencube/start.sh"]

CMD ["apache2-foreground"]
