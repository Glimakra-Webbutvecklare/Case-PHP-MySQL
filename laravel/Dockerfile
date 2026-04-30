FROM php:8.4-apache

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libgd-dev \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    gnupg \
    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    calendar \
    gd \
    mysqli \
    pdo \
    pdo_mysql \
    mbstring \
    xml \
    zip \
    fileinfo \
    bcmath \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN a2enmod ssl && a2enmod rewrite
RUN service apache2 restart

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY config/apache.conf /etc/apache2/sites-available/000-default.conf
COPY config/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
