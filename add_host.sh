# Count existing folders and determine the next domain number
HOSTS_FILE='/etc/hosts'
DOMAIN_NUMBER=$(($(grep -oE "pod[0-9]+\.local" $HOSTS_FILE | wc -l) + 1))
DOMAIN_NAME="pod$DOMAIN_NUMBER.local"

# Update /etc/hosts
if ! grep -q "$DOMAIN_NAME" $HOSTS_FILE; then
    echo "127.0.0.1   $DOMAIN_NAME" | sudo tee -a $HOSTS_FILE > /dev/null
    echo "Added $DOMAIN_NAME to $HOSTS_FILE"
else
    echo "$DOMAIN_NAME already exists in $HOSTS_FILE"
fi
