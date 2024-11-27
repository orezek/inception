#!/bin/sh
set -e

# Function to initialize the database
initialize_database() {
    echo "Initializing database..."

    # Initialize the MariaDB data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start the MariaDB server in the background without networking
    mysqld_safe --skip-networking &
    pid="$!"

    # Wait for the server to start
    sleep 5

    # Read root password from secret or environment variable
    if [ -f /run/secrets/mysql_root_password ]; then
        MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)
        echo "Using MYSQL_ROOT_PASSWORD from Docker secret."
    elif [ -n "$MYSQL_ROOT_PASSWORD" ]; then
        echo "Using MYSQL_ROOT_PASSWORD from environment variable."
    else
        echo "Error: MYSQL_ROOT_PASSWORD not set."
        exit 1
    fi

    # Read user password from secret or environment variable
    if [ -f /run/secrets/mysql_user_password ]; then
        MYSQL_PASSWORD=$(cat /run/secrets/mysql_user_password)
        echo "Using MYSQL_USER_PASSWORD from Docker secret."
    elif [ -n "$MYSQL_PASSWORD" ]; then
        echo "Using MYSQL_PASSWORD from environment variable."
    else
        echo "Error: MYSQL_USER_PASSWORD not set."
        exit 1
    fi

    # Secure the installation
    mysql -u root <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        DELETE FROM mysql.user WHERE User='';
        DROP DATABASE IF EXISTS test;
        FLUSH PRIVILEGES;
EOSQL

    # Create the database if specified
    if [ -n "$MYSQL_DATABASE" ]; then
        mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    fi

    # Create the user and grant privileges
    if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ]; then
        mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
            CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
            GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
            FLUSH PRIVILEGES;
EOSQL
    fi

    # Stop the background server
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
}

# Check if the database has already been initialized
echo "Running Maria DB initalization script"
echo "Checking database existance"
if [ ! -d "/var/lib/mysql/mysql" ]; then
    initialize_database
fi
echo "Database check done"

# Execute the main command
exec "$@"
