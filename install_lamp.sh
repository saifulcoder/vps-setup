#!/bin/bash
# Author:  saiful.coder <saiful.coder AT gmail.com>
#
# Notes: Debian 11

set -e

# Function to print error messages
error() {
    echo "Error: $1" >&2
}

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Update system
sudo apt update && sudo apt upgrade -y || error "Failed to update system"


# Install Apache
sudo apt install -y apache2 || error "Failed to install Apache"

# Install MariaDB
sudo apt install -y mariadb-server || error "Failed to install MariaDB"
sudo systemctl start mariadb
sudo systemctl enable mariadb

# # Prompt user for MySQL root password
# read -p "Enter MySQL root password: " mysql_root_password

# # Secure MariaDB installation
# sudo mysql <<EOF
# -- Set root password
# ALTER USER 'root'@'localhost' IDENTIFIED BY '$mysql_root_password';
# -- Remove anonymous users
# DELETE FROM mysql.user WHERE User='';
# -- Disallow root login remotely
# DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost');
# -- Remove test database and access to it
# DROP DATABASE IF EXISTS test;
# DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
# -- Reload privilege tables
# FLUSH PRIVILEGES;
# EOF

# Prompt user for PHP version
echo "Select PHP version to install:"
echo "1) PHP 7.4"
echo "2) PHP 8.3"
read -p "Enter your choice (1 or 2): " php_choice

# Repository Ondřej Surý
sudo apt install -y lsb-release apt-transport-https ca-certificates wget
wget -qO - https://packages.sury.org/php/apt.gpg | sudo tee /etc/apt/trusted.gpg.d/sury-php.gpg >/dev/null
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list
sudo apt update

if [ "$php_choice" -eq 1 ]; then
    # Install PHP 7.4 and required modules
    sudo apt install -y php7.4 libapache2-mod-php7.4 php7.4-mysql || error "Failed to install PHP 7.4"

    # Install PHP 7.4 extensions
    php_extensions=(
        php7.4-curl php7.4-json php7.4-cgi php7.4-xsl 
        php7.4-mbstring php7.4-xml php7.4-zip php7.4-gd php7.4-fileinfo php7.4-ldap
    )
elif [ "$php_choice" -eq 2 ]; then
    # Install PHP 8.3 and required modules
    sudo apt install -y php8.3 libapache2-mod-php8.3 php8.3-mysql || error "Failed to install PHP 8.3"

    # Install PHP 8.3 extensions
    php_extensions=(
        php8.3-curl php8.3-cgi php8.3-xsl 
        php8.3-mbstring php8.3-xml php8.3-zip php8.3-gd php8.3-fileinfo php8.3-ldap
    )
else
    error "Invalid choice. Please run the script again and select either 1 or 2."
    exit 1
fi

for ext in "${php_extensions[@]}"; do
    sudo apt install -y "$ext" || error "Failed to install $ext"
done

# Attempt to install additional PHP extensions
optional_extensions=(
    php${php_choice}.0-imagick php${php_choice}.0-imap php${php_choice}.0-redis php${php_choice}.0-memcached php${php_choice}.0-xdebug
)

for ext in "${optional_extensions[@]}"; do
    sudo apt install -y "$ext" || echo "Optional extension $ext not available"
done

# Install FFmpeg
sudo apt install -y ffmpeg || error "Failed to install FFmpeg"

# Install Node.js version 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - || error "Failed to add Node.js repository"
sudo apt install -y nodejs || error "Failed to install Node.js"

# Install pm2
npm install pm2 -g

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer || error "Failed to install Composer"

# Install Git
sudo apt install git

# Setup default IP page
sudo mkdir -p /var/www/html
sudo tee /var/www/html/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to My Server</title>
</head>
<body>
    <h1>Welcome to My Server</h1>
    <p>This is the default page for this server.</p>
</body>
</html>
EOF

# Configure Apache default virtual host
sudo tee /etc/apache2/sites-available/000-default.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        DirectoryIndex index.html index.php
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Define the source file and destination directory
SOURCE_FILE="x.php"
DESTINATION_DIR="/var/www/html"

# Move the file to the destination directory
mv "$SOURCE_FILE" "$DESTINATION_DIR"
echo "File x-prober '$SOURCE_FILE' has been moved to '$DESTINATION_DIR'."

# Enable Apache modules
sudo a2enmod rewrite

# Restart Apache
sudo systemctl restart apache2 || error "Failed to restart Apache"

# Completion message
echo "LAMP stack installation completed!"
echo "Apache has been installed and started."
echo "MariaDB has been installed and configured."
if [ "$php_choice" -eq 1 ]; then
    echo "PHP 7.4 and core extensions have been installed."
elif [ "$php_choice" -eq 2 ]; then
    echo "PHP 8.3 and core extensions have been installed."
fi
echo "Some optional PHP extensions may not have been installed due to availability."
echo "FFmpeg has been installed."
echo "Node.js version 20 has been installed."
echo "Composer has been installed."
echo "Default IP page has been configured."
echo "Please run 'sudo mysql_secure_installation' to secure your MariaDB installation."

# Verify installations
echo -e "${BLUE}# Verify installations${NC}"
apache2 -v
php -v
mysql --version
node -v
npm -v
composer -v
