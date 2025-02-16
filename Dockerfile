FROM roundcube/roundcubemail:1.6.10-apache

ADD https://repo1.maven.org/maven2/com/icegreen/greenmail-standalone/2.1.3/greenmail-standalone-2.1.3.jar /greenmail.jar
ADD /deploy/* /greencube/

RUN \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y openjdk-17-jre-headless  && \
    rm -rf /var/lib/apt/lists/* && \
    chmod a+x /greencube/*.sh

ENV ROUNDCUBEMAIL_DEFAULT_HOST=localhost
ENV ROUNDCUBEMAIL_SMTP_SERVER=localhost

EXPOSE 25 465 143 993 110 995 8080

ENTRYPOINT ["/greencube/start.sh"]

CMD ["apache2-foreground"]
