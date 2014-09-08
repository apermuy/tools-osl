#!/bin/bash
clear
echo "------------------------------"
echo "OSL DRUPAL INSTALL SCRIPT"
echo "------------------------------"
echo ""
echo "Comenzar instalación automatizada de Drupal (S)"
echo "Desinstalar tódolos arquivos do script(D)"
echo ""
read -p "Que desexa facer?(S/D)" resposta
if [ $resposta == D ]; then
	echo "--------------------------------------------";
	echo "Imos limpar a casa"
	rm -rf /var/www/drupal
	a2dissite osl.drupal
	rm -rf /etc/apache2/sites-available/osl*
	echo "Password MySQL para eliminar base de datos Drupal"
	mysql -u root -p -e "drop database drupal"
	apt-get -y remove --purge apache2 libapache2-mod-php5 php-pear php5-dev php5-xmlrpc php5-curl php5-intl php5-mysql php5-mcrypt php5-cli php5-gd php5-imagick mysql-server links
	apt-get -y remove --purge mysql-server mysql-client mysql-common
	apt-get -y autoremove
	apt-get -y autoclean
	apt-get -y clean


fi

if [ $resposta == S ]; then
	NOME_SITIO="OSL"
	ESLOGAN_SITIO="CursoDrupalAvanzado"
	echo "Imos actualizar as fontes e instalar uns paquetes"
	sleep 2
	apt-get update && apt-get -y upgrade
	clear
	echo "--------------------------------------------------"
	echo "--------- MOI IMPORTANTE -------------------------"
	echo "Dentro duns segundos deberá inserir un contrasinal de administrador para o servizo MySQL"
	echo "Recomendamos usar un contrasinal xenérico, por exemplo 1234"
	echo "Non esqueza o contrasinal"
	sleep 5
	apt-get -y install apache2 libapache2-mod-php5 php-pear php5-mysql php5-dev php5-xmlrpc php5-curl php5-intl php5-mcrypt php5-cli php5-gd php5-imagick mysql-server links
	service apache2 restart
	clear "Engadir hostname osl.drupal"
	tail -n +2 /etc/hosts > /dev/null 2>&1
	sed -i '1 i\127.0.0.1	localhost osl.drupal' /etc/hosts > /dev/null 2>&1
	ping -c 2 osl.drupal
	clear
	echo "--------------------------------------------------"
	echo "Instalación de Drush : a navalla suiza Drupaleira"
	echo "--------------------------------------------------"
	pear channel-discover pear.drush.org
	pear install drush/drush
	cd /var/www
	drush -y dl drupal --drupal-project-rename=drupal
	clear
	echo "------------------------------------------------"
	echo "Configuración do vhost osl.drupal para Apache2"
	echo "-------------------------------------------------"
        cd /etc/apache2/sites-available
	wget http://www.codery.es/osl/osl.drupal
	a2enmod rewrite && a2ensite osl.drupal && service apache2 restart
	clear
	echo "------------------------------------------------"
	echo "Instalación automatizada de Drupal"
	echo "------------------------------------------------"
	cd /var/www/drupal
	read -p "Necesito o contrasinal de administrador de MySQL" mysqlpass
	drush -y site-install  --account-name=admin --account-pass=admin --db-url=mysql://root:$mysqlpass@localhost/drupal
	drush vset site_slogan $ESLOGAN_SITIO;
	drush vset site_name $NOME_SITIO;
	drush -y dl drush_language
	drush -y dl l10n_update && drush en -y $_
	drush language-add gl && drush language-enable $_
	drush l10n-update-refresh
	drush l10n-update
	drush language-disable en
	drush language-default gl
	drush -y dis overlay
	drush core-cron
	drush cc all
	chown www-data /var/www
	chown -R www-data /var/www
	chmod -R 755 /var/www
	clear
	echo "---------------------------------------------"
	echo "Instalación rematada"
	echo "---------------------------------------------"
	echo "Pode iniciar sesion no seu novo sitio Drupal"
	echo "http://osl.drupal"
	echo "usuario: admin  - contrasinal: admin"
fi
