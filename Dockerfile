FROM php:8.1-apache-bullseye

# Installa dipendenze necessarie
RUN apt-get update && apt-get install -y \
    git unzip libpq-dev libxml2-dev \
    libcurl4-openssl-dev libpng-dev libjpeg-dev libfreetype6-dev \
    libicu-dev libzip-dev libonig-dev libxslt1-dev zlib1g-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) intl gd curl zip mbstring soap pdo_pgsql pgsql xml \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Abilita moduli Apache richiesti da Moodle
RUN a2enmod rewrite headers env dir mime

# Copia il codice Moodle
COPY . /var/www/html/

# Crea la directory dati e imposta i permessi
RUN mkdir -p /var/www/moodledata \
    && chown -R www-data:www-data /var/www/moodledata \
    && chmod -R 775 /var/www/moodledata

# Imposta permessi corretti
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

RUN chown -R www-data:www-data /var/www/moodledata \
    && chmod -R 755 /var/www/moodledata

# Imposta directory index
RUN echo "DirectoryIndex index.php index.html" > /etc/apache2/conf-enabled/directoryindex.conf

# Aumenta max_input_vars per Moodle
RUN echo "max_input_vars = 5000\npost_max_size = 64M\nupload_max_filesize = 64M" > /usr/local/etc/php/conf.d/moodle.ini



# Espone la porta
EXPOSE 80

CMD ["apache2-foreground"]
