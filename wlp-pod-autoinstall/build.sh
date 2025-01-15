# Define repository URLs and target directories
main_repo="https://github.com/wlp-builders/wlp"
main_repo_dir=`realpath "wlp-v2"`
main_repo_bname="wlp-v2"
core_plugins_repo="https://github.com/wlp-builders/whitelabelpress-wlp"
core_plugins_dir=`realpath "wlp-core-plugin-cms-pack"`
core_plugins_bname="wlp-core-plugin-cms-pack"
zips_dir=`realpath "zips"`

if [ -d "$zips_dir" ]; then
	rm "$zips_dir" -rf
	mkdir "$zips_dir"
fi
if [ -d "$main_repo_dir" ]; then
	rm "$main_repo_dir" -rf
fi
if [  -d "$core_plugins_dir" ]; then
	rm "$core_plugins_dir" -rf
fi

# Always Clone the latest main WLP repository if it doesn't already exist
    echo "Cloning main repository..."
    git clone "$main_repo" "$main_repo_dir"
    zip -r zips/wlp-v2.zip "$main_repo_bname"

# Clone the core plugins repository if it doesn't already exist
echo "Cloning core plugins repository..."
git clone "$core_plugins_repo" "$core_plugins_dir"
zip -r zips/wlp-core-plugin-cms-pack.zip "$core_plugins_bname"

podman build -t wlp-pod .

