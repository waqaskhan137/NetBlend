#!/bin/bash

# Check if OpenConnect is already installed
if ! command -v openconnect &>/dev/null; then
  echo "OpenConnect is not installed. Installing..."
  if [[ $(command -v apt-get) ]]; then
    sudo apt-get update
    sudo apt-get install -y openconnect
  elif [[ $(command -v yum) ]]; then
    sudo yum update
    sudo yum install -y openconnect
  elif [[ $(command -v dnf) ]]; then
    sudo dnf update
    sudo dnf install -y openconnect
  else
    echo "Failed to install OpenConnect. Please install it manually."
    exit 1
  fi
fi

# Check if Python is installed
if ! command -v python3 &>/dev/null; then
  echo "Python is not installed. Installing..."
  if [[ $(command -v apt-get) ]]; then
    sudo apt-get update
    sudo apt-get install -y python3
  elif [[ $(command -v yum) ]]; then
    sudo yum update
    sudo yum install -y python3
  elif [[ $(command -v dnf) ]]; then
    sudo dnf update
    sudo dnf install -y python3
  else
    echo "Failed to install Python. Please install it manually."
    exit 1
  fi
fi

# Check if vpn-slice is installed
if ! command -v vpn-slice &>/dev/null; then
  echo "vpn-slice is not installed. Installing..."
  if [[ $(command -v pip) ]]; then
    sudo pip install vpn-slice
  elif [[ $(command -v pip3) ]]; then
    sudo pip3 install vpn-slice
  else
    echo "Failed to install vpn-slice. Please install it manually."
    exit 1
  fi
fi

# Get the current user's username
CURRENT_USER=$(id -un)

# Prompt the user to enter the company name
read -p "Enter your company name: " COMPANY_NAME

# Prompt the user to enter their main password
read -s -p "Enter your main password: " MAIN_PASSWORD
echo

# Prompt the user to enter their company password
read -s -p "Enter your $COMPANY_NAME password: " COMPANY_PASSWORD
echo

# Prompt the user to enter their main user
read -p "Enter your main user: " MAIN_USER

# Prompt the user to enter their OTP secret
read -s -p "Enter your OTP secret: " OTP_SECRET
echo

# Prompt the user to enter their initial company IPs
read -p "Enter your initial $COMPANY_NAME IPs (space-separated): " COMPANY_IPS

# Generate the VPN script content
VPN_SCRIPT_CONTENT="#!/bin/bash

export MAIN_PASSWORD=\"$MAIN_PASSWORD\"
export COMPANY_PASSWORD=\"$COMPANY_PASSWORD\"
export MAIN_USER=\"$MAIN_USER\"
export OTP_SECRET=\"$OTP_SECRET\"
export COMPANY_IPS=\"$COMPANY_IPS\"

openconnect -v --authgroup=$COMPANY_NAME_VPN --user=\$MAIN_USER --passwd-on-stdin --token-mode=totp --no-dtls --token-secret=base32:\$OTP_SECRET vpn.$COMPANY_NAME.com -s \"vpn-slice \$COMPANY_IPS\""

# Create the VPN script file
echo "$VPN_SCRIPT_CONTENT" > "/home/$CURRENT_USER/vpn-script.sh"
chmod +x "/home/$CURRENT_USER/vpn-script.sh"

# Create the VPN service file
VPN_SERVICE_CONTENT="[Unit]
Description=$COMPANY_NAME VPN service

[Service]
ExecStart=/bin/bash /home/$CURRENT_USER/vpn-script.sh

[Install]
WantedBy=default.target"

echo "$VPN_SERVICE_CONTENT" > "/etc/systemd/system/netblend.service"

# Reload systemd daemon
sudo systemctl daemon-reload

# Enable and start the VPN service
sudo systemctl enable netblend.service
sudo systemctl start netblend.service"

# Create the alias for managing company IPs
ALIAS_CONTENT="alias vpn-ips='read -p \"Enter the IP to add or remove: \" IP; sed -i \"s/\\\$COMPANY_IPS/\\\$COMPANY_IPS \$IP/\" \"/home/\$USER/vpn-script.sh\"; sudo systemctl restart netblend.service'"

# Append the alias to the user's .bashrc file
echo "$ALIAS_CONTENT" >> "/home/$CURRENT_USER/.bashrc"

# Source the .bashrc file
source "/home/$CURRENT_USER/.bashrc"

echo "$COMPANY_NAME VPN service installation completed."
