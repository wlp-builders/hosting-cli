# Define repository URLs and target directories
main_repo="https://github.com/wlp-builders/wlp"
main_repo_dir=`realpath "wlp-v2"`
main_repo_bname="wlp-v2"
core_plugins_repo="https://github.com/wlp-builders/whitelabelpress-wlp"
core_plugins_dir=`realpath "wlp-core-plugin-cms-pack"`
core_plugins_bname="wlp-core-plugin-cms-pack"

# Clone the main WLP repository if it doesn't already exist
if [ ! -d "$main_repo_dir" ]; then
    echo "Cloning main repository..."
    git clone "$main_repo" "$main_repo_dir"
    zip -r zips/wlp-v2.zip "$main_repo_bname"
else
    echo "Main repository already exists, skipping clone."
fi

# Clone the core plugins repository if it doesn't already exist
if [ ! -d "$core_plugins_dir" ]; then
    echo "Cloning core plugins repository..."
    git clone "$core_plugins_repo" "$core_plugins_dir"
    zip -r zips/wlp-core-plugin-cms-pack.zip "$core_plugins_bname"
else
    echo "Core plugins repository already exists, skipping clone."
fi

podman build -t wlp-pod .
