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
