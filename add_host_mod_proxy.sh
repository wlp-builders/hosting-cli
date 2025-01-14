# Check if exactly one argument is passed (the port) or show usage
if [ -z "$1" ]; then
    echo "Usage: $0 [pod_n] [port] [optional:domain.tld]"
    echo "  port: The port to proxy traffic to (e.g., 8128)"
    exit 1
fi
if [ -z "$2" ]; then
    echo "Usage: $0 [pod_n] [port] [optional:domain.tld]"
    echo "  port: The port to proxy traffic to (e.g., 8128)"
    exit 1
fi

# Assign the port argument
PORT="$2"

POD="$1"
# Replace underscores with nothing
POD=$(echo "$POD" | tr -d '_')

# Count existing folders and determine the next domain number
HOSTS_FILE='/etc/hosts'
DOMAIN_NAME="$POD.local"
if [ -n "$3" ]; then
	DOMAIN_NAME=$3 #override podn.local domain if specified
fi



APACHE_CONF="/etc/apache2/apache2.conf"
# Update /etc/hosts
echo "127.0.0.1   $DOMAIN_NAME" | sudo tee -a $HOSTS_FILE > /dev/null
echo "Added $DOMAIN_NAME to $HOSTS_FILE"

# Update apache2 with reverse proxy
sudo tee -a $APACHE_CONF > /dev/null <<EOF
<VirtualHost *:80>
    ServerName $DOMAIN_NAME

    # Proxy traffic to another service (or another Apache container)
    ProxyPass / http://$DOMAIN_NAME:$PORT/
    ProxyPassReverse / http://$DOMAIN_NAME:$PORT/

    # Optional: Pass headers to preserve the original request information
    RequestHeader set X-Real-IP %{REMOTE_ADDR}s
    RequestHeader set X-Forwarded-For %{REMOTE_ADDR}s
    RequestHeader set X-Forwarded-Proto \"http\"

    # Optional: Enable logging for this VirtualHost
    CustomLog \${APACHE_LOG_DIR}/access.log combined
    ErrorLog \${APACHE_LOG_DIR}/error.log
</VirtualHost>
EOF

echo "Added reverse proxy path"

echo "Restarting apache2"
sudo service apache2 restart
echo "Apache2 Restarted"
