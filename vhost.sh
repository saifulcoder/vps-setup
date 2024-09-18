#!/bin/bash

# Memeriksa apakah pengguna menjalankan script dengan hak akses root
if [ "$EUID" -ne 0 ]; then
  echo "Silakan jalankan script ini sebagai root."
  exit 1
fi

# Meminta nama domain dari pengguna
read -p "Masukkan nama domain baru (contoh: example.com): " domain

# Meminta pilihan protokol dari pengguna
read -p "Pilih protokol (http/https): " protocol

# Memastikan pilihan protokol valid
if [[ "$protocol" != "http" && "$protocol" != "https" ]]; then
  echo "Pilihan protokol tidak valid. Harap pilih 'http' atau 'https'."
  exit 1
fi

# Membuat direktori untuk domain baru
mkdir -p /var/www/$domain/public_html

# Mengatur izin untuk direktori
chown -R $USER:$USER /var/www/$domain/public_html
chmod -R 755 /var/www

# Membuat file konfigurasi virtual host untuk Apache
cat <<EOL > /etc/apache2/sites-available/$domain.conf
<VirtualHost *:80>
    ServerAdmin webmaster@$domain
    ServerName $domain
    ServerAlias www.$domain
    DocumentRoot /var/www/$domain/public_html

    <Directory /var/www/$domain/public_html>
        AllowOverride All
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL

# Jika protokol HTTPS dipilih, tambahkan konfigurasi SSL
if [ "$protocol" == "https" ]; then
  cat <<EOL >> /etc/apache2/sites-available/$domain.conf
<VirtualHost *:443>
    ServerAdmin webmaster@$domain
    ServerName $domain
    ServerAlias www.$domain
    DocumentRoot /var/www/$domain/public_html

    SSLEngine on
    SSLCertificateFile /path/to/your/certificate.crt
    SSLCertificateKeyFile /path/to/your/private.key
    SSLCertificateChainFile /path/to/your/chainfile.pem

    <Directory /var/www/$domain/public_html>
        AllowOverride All
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL
fi

# Mengaktifkan konfigurasi domain baru
a2ensite $domain.conf

# Memuat ulang Apache untuk menerapkan perubahan
systemctl reload apache2

echo "Domain $domain dengan protokol $protocol telah berhasil ditambahkan!"
