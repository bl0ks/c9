#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Set default values
C9_PORT=8080
C9_USERNAME="root"
C9_PASSWORD="Password@2025"
WORKSPACE_DIR="$HOME/project"

echo -e "${YELLOW}======= Installing Cloud9 IDE =======${NC}"

# Function to check if a command succeeds
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ $1${NC}"
    else
        echo -e "${RED}✗ $1${NC}"
        exit 1
    fi
}

# Update system and install dependencies
echo -e "${YELLOW}Installing system dependencies...${NC}"
sudo apt-get update && sudo apt-get upgrade -y
check_status "System update"
sudo apt-get install -y curl git build-essential software-properties-common
check_status "Core utilities"
sudo apt-get install -y libx11-dev libxtst-dev libxt-dev libxkbfile-dev
check_status "Development libraries"

# Install Node.js and downgrade to v6.17.1
echo -e "${YELLOW}Setting up Node.js v6.17.1...${NC}"
sudo apt install -y nodejs npm
check_status "Node.js and npm"
sudo npm install -g n
check_status "Node version manager (n)"
sudo n 6.17.1
check_status "Node.js v6.17.1"
hash -r
node -v

# Setup Python 2.7
echo -e "${YELLOW}Setting up Python 2.7...${NC}"
sudo apt-get install -y python2.7
check_status "Python 2.7"
sudo ln -sf /usr/bin/python2.7 /usr/bin/python
check_status "Python symlink"
python --version

# Clone and set up Cloud9
echo -e "${YELLOW}Cloning Cloud9 repository...${NC}"
git clone https://github.com/c9/core.git ~/prof
check_status "Cloud9 repository"
cd ~/prof

# Download custom install-sdk.sh
echo -e "${YELLOW}Setting up custom installer...${NC}"
curl -o scripts/install-sdk.sh https://raw.githubusercontent.com/bl0ks/c9/refs/heads/main/recode/install-sdk.sh
check_status "Custom install script"
chmod +x scripts/install-sdk.sh
check_status "Script permissions"

# Run installation
echo -e "${YELLOW}Running Cloud9 installation...${NC}"
./scripts/install-sdk.sh
check_status "Cloud9 SDK installation"

# Install pty.js with Python 2.7
echo -e "${YELLOW}Installing pty.js...${NC}"
npm install pty.js@0.3.1 --build-from-source --python=/usr/bin/python2.7
check_status "pty.js installation"

# Create workspace directory
mkdir -p $WORKSPACE_DIR
check_status "Workspace directory"

# Create systemd service
echo -e "${YELLOW}Creating systemd service...${NC}"
cat > /tmp/cloud9.service << EOF
[Unit]
Description=Cloud9 IDE
After=network.target

[Service]
ExecStart=/usr/local/bin/node $HOME/prof/server.js --listen 0.0.0.0 --port $C9_PORT -w $WORKSPACE_DIR -a $C9_USERNAME:$C9_PASSWORD
Restart=always
User=$USER
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOF

sudo mv /tmp/cloud9.service /etc/systemd/system/cloud9.service
check_status "Service file creation"

# Start service
echo -e "${YELLOW}Starting Cloud9 service...${NC}"
sudo systemctl daemon-reload
check_status "Systemd reload"
sudo systemctl enable cloud9.service
check_status "Service enabled"
sudo systemctl start cloud9.service
check_status "Service started"

# Show service status
sudo systemctl status cloud9.service

# Display success message
echo -e "${GREEN}======= Cloud9 IDE installed successfully! =======${NC}"
echo -e "Access your Cloud9 IDE at: http://$(hostname -I | awk '{print $1}'):$C9_PORT"
echo -e "Username: $C9_USERNAME"
echo -e "Password: $C9_PASSWORD"
echo -e "${YELLOW}Workspace directory: $WORKSPACE_DIR${NC}"
