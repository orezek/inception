# Base image: Debian Bullseye Slim
FROM debian:bullseye-slim

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
	mariadb-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create the target directories and assign rights - each line is a separate layer in the docker image, howerver, I prefer readability.
RUN mkdir -p /var/www/html && mkdir -p /run/php && \
chown -R www-data:www-data var/run/php && \
chown -R www-data:www-data /var/www/html

# # Download WordPress
# RUN wget https://wordpress.org/latest.tar.gz -O /tmp/latest.tar.gz && \
#     tar -xzf /tmp/latest.tar.gz -C /var/www/html --strip-components=1 && \
#     rm /tmp/latest.tar.gz

# Install WordPress CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp

# Copy the custom PHP-FPM configuration
COPY conf/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf

# Add WordPress setup script
COPY conf/setup-wordpress.sh /usr/local/bin/setup-wordpress.sh
RUN chmod +x /usr/local/bin/setup-wordpress.sh

# Expose port for PHP-FPM
EXPOSE 9000

# Command to run the setup script before starting PHP-FPM
ENTRYPOINT ["/usr/local/bin/setup-wordpress.sh"]
CMD ["php-fpm7.4", "-F"]
