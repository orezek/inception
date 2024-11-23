# Base image: Debian Bullseye Slim
FROM debian:bullseye-slim

# Metadata
LABEL maintainer="orezek@42.fr" \
      description="Custom WordPress image with PHP-FPM support"

# Update and install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    php \
    php-fpm \
    php-mysqli \
    php-curl \
    php-json \
    php-mbstring \
    php-xml \
    php-zip \
    wget \
    unzip \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create the target directory
RUN mkdir -p /var/www/html \
    mkdir -p /run/php && chown -R www-data:www-data /run/php

# Download WordPress
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress /var/www/html && \
    rm latest.tar.gz

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Copy custom PHP-FPM configuration
COPY conf/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf

# Expose port for PHP-FPM
EXPOSE 9000

# Command to run PHP-FPM in the foreground
ENTRYPOINT ["php-fpm7.4", "-F"]
