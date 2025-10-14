FROM php:8.1-apache

RUN apt-get update && \
    apt-get install -y git unzip libpq-dev php-pgsql php-xml php-curl php-gd php-intl php-zip php-mbstring php-soap php-xmlrpc && \
    docker-php-ext-install pdo_pgsql

# Clona Moodle nella cartella web
RUN git clone -b MOODLE_404_STABLE https://github.com/moodle/moodle.git /var/www/html/moodle

# Crea la cartella dati e imposta permessi
RUN mkdir /var/moodledata && chown -R www-data:www-data /var/moodledata /var/www/html/moodle

EXPOSE 80
CMD ["apache2-foreground"]
