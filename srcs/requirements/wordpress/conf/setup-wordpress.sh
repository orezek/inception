#!/bin/bash

# Ensure the script stops on error
set -e

# Define variables from environment variables
DB_HOST=${WORDPRESS_HOST}
DB_NAME=${WORDPRESS_DB_NAME}
DB_USER=${WORDPRESS_USER}
DB_PASSWORD=${WORDPRESS_PASSWORD}
ADMIN_USER=${WORDPRESS_ADMIN_USER}
ADMIN_PASSWORD=${WORDPRESS_ADMIN_PASSWORD}
ADMIN_EMAIL=${WORDPRESS_ADMIN_EMAIL}

echo "Printing credentials"
echo "${ADMIN_USER}"
echo "${ADMIN_PASSWORD}"
echo "${ADMIN_EMAIL}"

# Wait for the database to be ready
echo "Waiting for the database to be ready..."
until mysql -h"${DB_HOST}" -u"${DB_USER}" -p"${DB_PASSWORD}" -e "SHOW DATABASES;" &> /dev/null; do
    echo "Waiting for MySQL at ${DB_HOST}..."
    sleep 3
done

echo "Database is ready."

# Check if wp-cli is installed
if ! command -v wp &> /dev/null; then
    echo "Error: wp-cli is not installed. Please install it in the container."
    exit 1
fi

# Verify WordPress files exist
echo "Verifying WordPress data existance"
if [ ! -f /var/www/html/wp-config-sample.php ]; then
    echo "Error: WordPress files are missing in /var/www/html."
    echo "Attempting to re-download WordPress..."
    wget https://wordpress.org/latest.tar.gz -O /tmp/latest.tar.gz && \
    tar -xzf /tmp/latest.tar.gz -C /var/www/html --strip-components=1 && \
    rm /tmp/latest.tar.gz

    # Re-check after downloading
    if [ ! -f /var/www/html/wp-config-sample.php ]; then
        echo "Error: WordPress download failed or files are still missing."
        exit 1
    fi
fi
echo "WordPress files verified."


# Generate wp-config.php
echo "Verifying wp-config existance"
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Setting up wp-config.php..."
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    sed -i "s/database_name_here/${DB_NAME}/" /var/www/html/wp-config.php
    sed -i "s/username_here/${DB_USER}/" /var/www/html/wp-config.php
    sed -i "s/password_here/${DB_PASSWORD}/" /var/www/html/wp-config.php
    sed -i "s/localhost/${DB_HOST}/" /var/www/html/wp-config.php
fi
echo "WP files verified."

# Run WordPress installation
echo "Installing basic Wordpress blog"
if ! wp core is-installed --path=/var/www/html --allow-root; then
    echo "Installing WordPress..."
    wp core install --url="http://localhost" \
        --title="${WORDPRESS_SITE_TITLE}" \
        --admin_user="${ADMIN_USER}" \
        --admin_password="${ADMIN_PASSWORD}" \
        --admin_email="${ADMIN_EMAIL}" \
        --path=/var/www/html \
        --allow-root
fi
echo "Wordpress installation installed"

# Ensure permissions
echo "Setting permissions for /var/www/html..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
echo "Setting permissions completed"

# Execute the CMD
echo "Executing CMD command"
exec "$@"
