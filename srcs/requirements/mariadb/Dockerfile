FROM alpine:3.19

LABEL maintainer="your_email@example.com" \
      description="Custom MariaDB container for WordPress"

# Update package list and install MariaDB with verbose output
RUN set -x && apk update && apk add --no-cache mariadb mariadb-client

# Create necessary directories and set permissions
RUN set -x
RUN mkdir -p /run/mysqld
RUN mkdir -p /var/log/mysql
RUN chown -R mysql:mysql /run/mysqld /var/log/mysql

# Copy custom MariaDB configuration
COPY conf/my.cnf /etc/my.cnf

# Expose port for MariaDB
EXPOSE 3306

# Copy the entrypoint script
COPY conf/mariadb-setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mariadb-setup.sh

# Set entrypoint
ENTRYPOINT ["mariadb-setup.sh"]

# Default command to run
CMD ["mysqld"]
