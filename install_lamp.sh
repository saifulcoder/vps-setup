#!/bin/bash
# Author:  saiful.coder <saiful.coder AT gmail.com>
#
# Notes: Debian 11

set -e

# Function to print error messages
error() {
    echo "Error: $1" >&2
}

# Update system
sudo apt update && sudo apt upgrade -y || error "Failed to update system"

# Install Apache
sudo apt install -y apache2 || error "Failed to install Apache"

# Install MariaDB
sudo apt install -y mariadb-server || error "Failed to install MariaDB"
sudo systemctl start mariadb
sudo systemctl enable mariadb
echo "Please run 'sudo mysql_secure_installation' manually after the script finishes."

# Install PHP 7.4 and required modules
sudo apt install -y php7.4 libapache2-mod-php7.4 php7.4-mysql || error "Failed to install PHP"

# Install PHP extensions
php_extensions=(
    php7.4-curl php7.4-json php7.4-cgi php7.4-xsl 
    php7.4-mbstring php7.4-xml php7.4-zip php7.4-gd php7.4-fileinfo php7.4-ldap
)

for ext in "${php_extensions[@]}"; do
    sudo apt install -y "$ext" || error "Failed to install $ext"
done

# Attempt to install additional PHP extensions
optional_extensions=(
    php7.4-imagick php7.4-imap php7.4-redis php7.4-memcached php7.4-xdebug
)

for ext in "${optional_extensions[@]}"; do
    sudo apt install -y "$ext" || echo "Optional extension $ext not available"
done

# Install FFmpeg
sudo apt install -y ffmpeg || error "Failed to install FFmpeg"

# Install Node.js version 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - || error "Failed to add Node.js repository"
sudo apt install -y nodejs || error "Failed to install Node.js"

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
# php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
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
echo "PHP 7.4 and core extensions have been installed."
echo "Some optional PHP extensions may not have been installed due to availability."
echo "FFmpeg has been installed."
echo "Node.js version 20 has been installed."
echo "Composer has been installed."
echo "Default IP page has been configured."
echo "Please run 'sudo mysql_secure_installation' to secure your MariaDB installation."

# Verify installations
apache2 -v
mysql --version
php -v
node -v
npm -v
composer -V
