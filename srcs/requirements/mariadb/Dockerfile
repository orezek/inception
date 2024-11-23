# Base image: Alpine (penultimate stable version)
FROM mariadb:10.6

# Metadata
LABEL maintainer="orezek@42.fr" \
      description="MariaDB container for WordPress"

# Install MariaDB
#RUN apk update && apk add --no-cache \
#    mariadb mariadb-client bash && \
#    mkdir -p /var/lib/mysql /var/run/mysqld /var/log/mysql && \
#    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld /var/log/mysql


# Copy custom MariaDB configuration
COPY ./conf/my.cnf /etc/my.cnf

# Expose port for MySQL
EXPOSE 3306

# Entry point to run MariaDB
#ENTRYPOINT ["mysqld"]
