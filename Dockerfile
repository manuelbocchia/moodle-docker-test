FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    git unzip libpq-dev libxml2-dev \
    libcurl4-openssl-dev libpng-dev libicu-dev libzip-dev \
    libonig-dev libxslt1-dev zlib1g-dev \
    && docker-php-ext-install intl gd curl zip mbstring soap xmlrpc pdo_pgsql

# Copia il codice Moodle
COPY . /var/www/html/

# Imposta i permessi
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Directory index
RUN echo "DirectoryIndex index.php index.html" > /etc/apache2/conf-enabled/directoryindex.conf

EXPOSE 80
CMD ["apache2-foreground"]
