#!/bin/bash

read -p "Enter your domain name (e.g., example.com): " DOMAIN

sudo apt-get update
sudo apt-get install -y apache2

sudo apt-get install -y mysql-server

sudo mysql_secure_installation

sudo apt-get install -y php php-mysql phpmyadmin

sudo a2enmod php

sudo phpenmod mcrypt
sudo phpenmod mbstring
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
sudo a2enconf phpmyadmin.conf
sudo systemctl reload apache2

sudo tee /etc/apache2/sites-available/$DOMAIN.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName $DOMAIN
    DocumentRoot /var/www/$DOMAIN

    <Directory /var/www/$DOMAIN>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

sudo a2ensite $DOMAIN.conf
sudo systemctl reload apache2

sudo apt-get install -y certbot python3-certbot-apache

sudo certbot --apache -d $DOMAIN

echo "Installation and configuration completed."
echo "You can access your website at: http://$DOMAIN"