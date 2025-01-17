#!/bin/bash
# setup mysql 
sudo apt install mariadb-server -y

# only setup mysql if /var/lib/mysql is empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
fi

#
# Start services in the background
service apache2 restart &
service ssh restart &
service mariadb restart &

## Copy WLP to /var/www (unzip + copy)
cd /root
mkdir tmp
unzip /root/zips/wlp-v2.zip -d /root/tmp
mkdir /root/tmp/wlp-v2/wlp-core-plugins
unzip /root/zips/wlp-core-plugin-cms-pack.zip -d /root
mv /root/wlp-core-plugin-cms-pack/ /root/tmp/wlp-v2/wlp-core-plugins/enabled
mv /root/tmp/wlp-v2/* /var/www/html/
chmod 770 /var/www/html -R
chown www-data:www-data /var/www/html -R

# Keep the container alive\n\
# Run the installation script and capture output\n\
FOLDER_PATH='/var/www/html'

# This sets index.php to install ready
URL_WITH_PARAMS=$(bash $FOLDER_PATH/wlp-install/autoinstall-as-root.sh $FOLDER_PATH 'localhost')

cd /var/www/html

# also fix rewrites

# Define the configuration block to be added
CONFIG_BLOCK="<Directory /var/www/html>
    AllowOverride All
</Directory>"

# Define the Apache configuration file path
APACHE_CONF_FILE="/etc/apache2/apache2.conf"

# Append the configuration block to the file
echo "$CONFIG_BLOCK" | sudo tee -a "$APACHE_CONF_FILE" > /dev/null

# Restart Apache to apply the changes
sudo systemctl restart apache2

echo "Configuration added to $APACHE_CONF_FILE and Apache restarted"


sleep infinity

