FROM php:8.1-apache-bullseye

# Installa dipendenze di sistema e librerie necessarie
RUN apt-get update && apt-get install -y \
    git unzip libpq-dev libxml2-dev \
    libcurl4-openssl-dev libpng-dev libicu-dev libzip-dev \
    libonig-dev libxslt1-dev zlib1g-dev \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install intl gd curl zip mbstring soap pdo_pgsql xml \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copia i file di Moodle
COPY . /var/www/html/

# Permessi corretti
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Imposta directory index per Apache
RUN echo "DirectoryIndex index.php index.html" > /etc/apache2/conf-enabled/directoryindex.conf

EXPOSE 80
CMD ["apache2-foreground"]
