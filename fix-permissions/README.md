###Script para fijar permisos de directorios en Drupal
Este script es un clon del referenciado en https://www.drupal.org/node/244924.
Antes de ejecutar el script, recomiendo encarecidamente leer y comprender el link anterior.

####Uso
El nombre del grupo del servidor web se asume como "www-data", si difiere debes usar el parámetro: --httpd_group=GRUPO



git clone https://github.com/apermuy/tools-osl.git

cd tools-osl/fix-permissions

chmod +x fix-permissions

./fix-permissions.sh  --drupal_path=/var/www/drupal --drupal_user=nombredeusuario
