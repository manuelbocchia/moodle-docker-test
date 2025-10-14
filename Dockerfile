FROM php:8.1-apache

# Installazione dei pacchetti necessari per Moodle
RUN apt-get update && \
    apt-get install -y git unzip libpq-dev libxml2-dev \
    libcurl4-openssl-dev libpng-dev libicu-dev libzip-dev \
    libonig-dev libxslt1-dev zlib1g-dev && \
    docker-php-ext-install intl gd zip mbstring soap pdo_pgsql xml && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Abilita mod_rewrite (necessario per Moodle)
RUN a2enmod rewrite

# Clona Moodle (puoi cambiare la versione con MOODLE_405_STABLE o simile)
RUN git clone -b MOODLE_404_STABLE https://github.com/moodle/moodle.git /var/www/html/moodle

# Crea la directory dati e imposta i permessi corretti
RUN mkdir /var/moodledata && chown -R www-data:www-data /var/moodledata /var/www/html/moodle

# Espone la porta 80
EXPOSE 80

# Avvia Apache in foreground
CMD ["apache2-foreground"]
