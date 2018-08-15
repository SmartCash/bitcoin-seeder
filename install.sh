# Quit on error
set -e

if [ "$(whoami)" != "root" ]; then
  echo "Script must be run as user: root"
  exit -1
fi

# Change working directory to the directory of the script
script_dir=$(dirname $(realpath $0))

cd "$script_dir"

printf "Enter the seed's domain: "
read SEED

printf "Enter the seeder's domain: "
read SEEDER

printf "Enter the email address used for the seeder: "
read EMAIL

# Create the EnvironmentFile
echo "SEED=${SEED}
SEEDER=${SEEDER}
EMAIL=${EMAIL}" > /etc/.dns-seeder-config

# Install the dependencies
apt-get install -y build-essential libboost-all-dev libssl-dev

# Build the seeder
make

# Install init service
ln -sf "$script_dir"/dnsseed /usr/local/bin
systemctl enable "$script_dir"/dns-seeder.service

# Start the seeder
systemctl start dns-seeder
