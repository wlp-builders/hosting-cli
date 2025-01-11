# hosting-cli
Early preview hosting-cli for new WLP hosting partners.
You'd need to make the wlp-core and wlp-core-plugins

### 1. Clone this folder with scripts
```
git clone https://github.com/wlp-builders/hosting-cli
cd hosting-cli
```

### 2. Create the latest WLP zips (core + fork)
```
git clone https://github.com/wlp-builders/wlp
git clone https://github.com/wlp-builders/whitelabelpress-wlp
mkdir zips
zip -r zips/wlp.zip wlp/
zip -r zips/whitelabelpress-wlp.zip whitelabelpress-wlp/
```

### 3. Build the Dockerfile
```
cd wlp-pod-image
sh build.sh
cd ../
```

### 4. Create a Pod
```
php create_pod.php # returns pod_*
```

### 5. Enter a Pod
```
sh enter_pod.sh [pod_1]
```

### 6. Unpack WLP inside the Pod
```
unzip /root/zips/wlp.zip /root/wlp
unzip /root/zips/wlp-core-plugins.zip /root/wlp-cms-core-pack
mkdir /var/www/html/wlp-core-plugins
mv /root/wlp/* /var/www/html/
mv /root/wlp-cms-core-pack /var/www/html/wlp-core-plugins/enabled
```

### 7. On your local machine add the reverse proxy
```
<VirtualHost *:80>
    ServerName pod1.local

    # Proxy traffic to another service (change portr)
    ProxyPass / http://pod1.local:8128/
    ProxyPassReverse / http://pod1.local:8128/

    # Optional: Pass headers to preserve the original request information
    RequestHeader set X-Real-IP %{REMOTE_ADDR}s
    RequestHeader set X-Forwarded-For %{REMOTE_ADDR}s
    RequestHeader set X-Forwarded-Proto "http"

    # Optional: Enable logging for this VirtualHost
    CustomLog ${APACHE_LOG_DIR}/access.log combined
    ErrorLog ${APACHE_LOG_DIR}/error.log
</VirtualHost>

```
