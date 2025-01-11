# Use Debian 12 as the base image
FROM debian:bookworm-slim

# Set environment variables for MariaDB
ENV MYSQL_ROOT_PASSWORD=my-secret-pw
ENV MYSQL_DATABASE=mydb
ENV MYSQL_USER=myuser
ENV MYSQL_PASSWORD=mypassword

# Install necessary packages
RUN apt-get update && apt-get install -y \
    apache2 \
    openssh-server \
    mariadb-server \
    php \
  php-mysql \
    php-bcmath \
    php-curl \
    php-xml \
    php-mbstring \
    php-json \
    php-zip \
    php-soap \
    php-intl \
    curl \
    vim \
    wget \
    git \
    unzip \
    && apt-get clean

# Configure Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite

# Configure SSH
RUN mkdir /var/run/sshd
RUN mkdir -p /root/.ssh

# Set proper permissions for SSH
RUN chmod 700 /root/.ssh

# Expose necessary ports
EXPOSE 80 443 3306 22

# Create document root for Apache and add a basic PHP file
RUN mkdir -p /var/www/html
WORKDIR /var/www/html
RUN echo "<?php phpinfo(); ?>" > /var/www/html/index.php

# Create the entrypoint.sh script
RUN echo '#!/bin/bash\n\
\n\
# Start services in the background\n\
service apache2 restart &\n\
service ssh restart &\n\
service mariadb restart &\n\
# Keep the container alive\n\
sleep infinity\n' > /root/entrypoint.sh


# Make the script executable
RUN chmod +x /root/entrypoint.sh

# Set the entrypoint to the script
ENTRYPOINT ["/root/entrypoint.sh"]



