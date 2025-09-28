#!/bin/bash
# Update system packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Node.js (v18 LTS) and Git
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs git

# Install PM2 globally to manage the Node.js process
sudo npm install -g pm2

# Switch to ubuntu home directory
cd /home/ubuntu

# Clone your repo
git clone https://github.com/JM-Mushraf/DevSphere.git

# Move into server folder
cd DevSphere/server

# Install dependencies
npm install

# Add environment variables
cat <<EOF > .env
// env data shouldnt be hard coded ,in case of developement itll be okh not preferred in developement 
EOF

# Start your app with PM2
pm2 start server.js --name devsphere-app

# Configure PM2 to auto-start on reboot
pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save
