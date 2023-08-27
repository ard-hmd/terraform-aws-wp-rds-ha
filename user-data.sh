#!/bin/bash

# Modifiez ces valeurs et conservez-les en lieu sûr
db_username=myrdsuser
db_user_password=myrdspassword
db_name=wpdb
db_host="myrdsinstance.c6wqjjevzbkj.eu-west-3.rds.amazonaws.com:3306"

# installer le serveur LAMP
sudo yum update -y
# installer le serveur apache
sudo yum install -y httpd

# activez d'abord php7.xx depuis amazon-linux-extra et installez-le

amazon-linux-extras enable php7.4
yum clean metadata
yum install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,imap,devel}
# installer l'extension Imagick
yum -y install gcc ImageMagick ImageMagick-devel ImageMagick-perl
pecl install imagick
chmod 755 /usr/lib64/php/modules/imagick.so
cat <<EOF >>/etc/php.d/20-imagick.ini
extension=imagick
EOF
systemctl restart php-fpm.service

usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/

cd /var/www/html
cp wp-config-sample.php wp-config.php

sed -i "s/database_name_here/$db_name/g" wp-config.php
sed -i "s/username_here/$db_username/g" wp-config.php
sed -i "s/password_here/$db_user_password/g" wp-config.php
sed -i "s/localhost/$db_host/g" wp-config.php
cat <<EOF >>/var/www/html/wp-config.php

define( 'FS_METHOD', 'direct' );
define('WP_MEMORY_LIMIT', '256M');
EOF

# Modifier l'autorisation de /var/www/html/
chown -R ec2-user:apache /var/www/html
chmod -R 774 /var/www/html

#  activer les fichiers .htaccess dans la configuration Apache à l'aide de la commande sed
sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/httpd/conf/httpd.conf

# Fait en sorte qu'apache et mariadb démarrent et redémarrent automatiquement apache
systemctl enable  httpd.service

systemctl restart httpd.service
