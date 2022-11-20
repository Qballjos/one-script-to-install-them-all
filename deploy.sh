#!/bin/bash
#
# Perform initial setup and configuration of Docker environment for 
# full media server goodness.

## FUNCTIONS
info() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@"
}

err() {
  RED='\033[0;31m'
  NC='\033[0m' # No Color
  echo -e "${RED}[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@${NC}" >&2
}

success() {
  GREEN='\033[0;32m'
  NC='\033[0m' # No Color
  echo -e "${GREEN}[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@${NC}"
}

get_env_var() {
  VAR=$(grep $1 $2 | xargs)
  IFS="=" read -ra VAR <<< "$VAR"
  echo ${VAR[1]} | tr -d "\r"
}

apt_update() {
  sudo apt-get update &> /dev/null
  if [[ "$?" -ne "$SUCCESS" ]]
  then
    err "Error occurred updating apt packages."
    exit 1
  fi
  success "apt packages up-to-date."
}

apt_install() {
  apt_update

  sudo apt-get install -y $1 $2 $3 $4 $5 $6 &> /dev/null
  if [[ "$?" -ne "$SUCCESS" && "$?" -ne 9 ]]
    then
    err "Error installing packages."
  fi
  success "Successfully installed requested packages."
}

## VARIABLES
ROOT_UID=0
username=$(get_env_var USER_NAME .env)
password=$(get_env_var PASSWORD .env)
timezone=$(get_env_var TIMEZONE .env)
base_dir=$(get_env_var BASE_DIR .env)
VPN_ENABLED=$(get_env_var VPN_ENABLED .env)
VPN_USER=$(get_env_var VPN_USER .env)
VPN_PASS=$(get_env_var VPN_PASS .env)
ENABLE_PRIVOXY=$(get_env_var ENABLE_PRIVOXY .env)
VPN_ENABLED=$(get_env_var VPN_ENABLED .env)
LAN_NETWORK=$(get_env_var LAN_NETWORK .env)
NAME_SERVERS=$(get_env_var NAME_SERVERS .env)
DOMAIN=$(get_env_var DOMAIN .env)
SUBDOMAINS=$(get_env_var SUBDOMAINS .env)
ONLY_SUBDOMAINS=$(get_env_var ONLY_SUBDOMAINS .env)
EXTRA_DOMAINS=$(get_env_var EXTRA_DOMAINS .env)

## EXECUTION
# Must be root
if [[ "${UID}" -ne "${ROOT_UID}" ]]
then
  err "Must be root to perform this operation."
  exit 1
fi

# Must have apt
command -v apt-get &> /dev/null
if [[ "$?" -ne "$SUCCESS" ]]
then
  err "Process requires apt but doesn't appear to be installed."
  exit 1
fi

# System Configuration
info "Performing system pre-configuration."
# Create user
sudo useradd -p "${password}" -d /home/"${username}" -m -g users -s /bin/bash "${username}" &> /dev/null
if [[ "$?" -ne "$SUCCESS" && "$?" -ne 9 ]]
then
  err "Could not create user: ${username}."
fi
success "Created user: ${username}."

sudo usermod -aG sudo ${username} &> /dev/null
if [[ "$?" -ne "$SUCCESS" ]]
then
  err "Error setting user as sudo-er."
  exit 1
fi
success "Set user as sudo-er."

# Set timezone
sudo timedatectl set-timezone "${timezone}"
if [[ "$?" -ne "$SUCCESS" ]]
then
  err "Error setting timezone."
  exit 1
fi
success "Timezone set to ${timezone}."

sudo apt-get remove docker docker-engine docker.io &> /dev/null
if [[ "$?" -ne "$SUCCESS" ]]
then
  err "Error occurred removing legacy Docker packages."
  exit 1
fi
success "Ensured legacy Docker packages are gone."

# curl install
info "Ensuring curl is installed."
apt_install -y "curl"

# docker packages & pre-configure
info "Installing Docker CE."
sudo curl -sSL https://get.docker.com | sh &> /dev/null
if [[ "$?" -ne "$SUCCESS" ]]
then
  err "Error occurred installing legacy Docker ."
  exit 1
fi
success "Docker is installed."

# pip for docker-compose
info "Ensuring packages for pip and docker-compose are installed."
apt_install -y "libffi-dev" "libssl-dev" "python" "python-pip"
sudo apt-get remove -y "python-configparser"

info "Installing Docker Compose."
info "Downloading Compose from GitHub."
sudo pip -q install docker-compose
  &> /dev/null
if [[ "$?" -ne "$SUCCESS" ]]
then
  err "Error downloading Docker Compose."
  exit 1
fi
success "Docker Compose installed."

# cockpit install
info "Installing Cockpit."
apt_install "cockpit"
sudo systemctl enable cockpit.socket > /dev/null
if [[ "$?" -ne "$SUCCESS" ]]
then
  err "Cockpit auto-start failed."
  exit 1
fi
success "Cockpit set to auto-start."

# container installation

info "Building the Docker containers."
sudo docker-compose up --force-recreate -d
if [[ "$?" -ne "$SUCCESS" ]]
then
  err "Docker build failed."
  exit 1
fi
# All done!
success "Successfully built media server Docker environment!"
exit 0