FROM tutum/apache-php:latest

# activate the apache modrewrite
RUN a2enmod rewrite

RUN rm -rf /app
RUN rm -rf /var/www/html
RUN mkdir /var/log/gorazd
RUN chmod ugo+rw /var/log/gorazd

# modified config files
COPY apache.conf /etc/apache2/sites-enabled/000-default.conf
COPY run.sh /run.sh

CMD ["/run.sh"]
