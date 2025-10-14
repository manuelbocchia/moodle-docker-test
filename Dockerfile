FROM php:8.1-apache

# Installazione pacchetti richiesti da Moodle
RUN apt-get update && \
    apt-get install -y git unzip libpq-dev libxml2-dev \
    libcurl4-openssl-dev libpng-dev libicu-dev libzip-dev \
    libonig-dev libxslt1-dev zlib1g-dev && \
    docker-php-ext-install intl gd curl zip mbstring soap xmlrpc pdo_pgsql

# Abilita i moduli Apache richiesti
RUN a2enmod rewrite

# Clona Moodle (puoi cambiare branch se vuoi un’altra versione)
RUN git clone -b MOODLE_404_STABLE https://github.com/moodle/moodle.git /var/www/html/moodle

# Crea la directory dati e imposta permessi
RUN mkdir /var/moodledata && chown -R www-data:www-data /var/moodledata /var/www/html/moodle

EXPOSE 80
CMD ["apache2-foreground"]
