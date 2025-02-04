#!/bin/bash

# Variables
git_repo="https://github.com/your-repo/your-app.git" # Replace with your repository
app_dir="/var/www/your-app"                            # Replace with your desired directory

# Clone the application
echo "Cloning the application..."
git clone \$git_repo \$app_dir

# Navigate to the app directory
cd \$app_dir || exit

# Build the application
echo "Building the application..."
npm install
npm run build

# Restart the application using PM2 (if using it)
echo "Restarting the application..."
sudo npm install -g pm2
pm2 restart all || pm2 start npm --name "app" -- run start

# Enable PM2 startup
echo "Enabling PM2 to start on boot..."
pm2 startup
pm2 save

echo "Application deployment and restart completed successfully."