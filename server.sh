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
EMAIL=himpreetak@gmail.com
PASSWORD=Himanshu


PORT=3000
CONNECTION_STRING=mongodb+srv://mushraf1786:Mushraf@webdevmongodb1.tgpz9v3.mongodb.net/devchat
JWT_SECRET=cnmsjkenfkljnsjklgnsdljkfjsdkcnmsa4rw4jljsdfl
NODE_ENV=development

CLODUINARY_CLOUD_NAME=dqlcy9wmd
CLODUINARY_API_KEY=513937327371915
CLODUINARY_API_SECRET=9XnoWAmjQOP-XhuRbT1cIEm-99c

TEAM_EMAIL=devchatapplication@gmail.com
PASSWORD=lrlp wbvm lhlx rmxc
FRONTEND_URL=http://localhost:5173

SESSION_SECRET=fjrm3nrjfks03me3j
EOF

# Start your app with PM2
pm2 start server.js --name devsphere-app

# Configure PM2 to auto-start on reboot
pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save
