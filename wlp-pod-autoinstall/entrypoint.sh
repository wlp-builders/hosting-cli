#!/bin/bash
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
sleep infinity

