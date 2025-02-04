#!/bin/bash

# Update the package list
sudo apt update -y

# Install Node.js and NPM
echo "Installing Node.js and NPM..."
sudo apt install -y nodejs npm

# Verify Node.js and NPM installation
node -v
npm -v

# Install Nginx
echo "Installing Nginx..."
sudo apt install -y nginx

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Create Nginx configuration files

echo "Configuring Nginx for web.example.com and api.example.com..."

# Web App Configuration
sudo tee /etc/nginx/sites-available/web.example.com > /dev/null <<EOL
server {
    listen 80;
    server_name web.example.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOL

# API Configuration
sudo tee /etc/nginx/sites-available/api.example.com > /dev/null <<EOL
server {
    listen 80;
    server_name api.example.com;

    location / {
        proxy_pass http://localhost:4000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOL

# Enable the configuration files
sudo ln -s /etc/nginx/sites-available/web.example.com /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/api.example.com /etc/nginx/sites-enabled/

# Test Nginx configuration and reload
sudo nginx -t
sudo systemctl reload nginx

# Install Certbot and provision SSL certificates
echo "Installing Certbot and obtaining SSL certificates..."
sudo apt install -y certbot python3-certbot-nginx

# Obtain SSL Certificates (replace emails accordingly)
sudo certbot --nginx -d web.example.com -d api.example.com --non-interactive --agree-tos -m your-email@example.com

# Enable auto-renewal for SSL certificates
sudo systemctl enable certbot.timer

echo "Environment setup completed successfully."