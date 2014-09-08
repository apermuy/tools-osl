#!/bin/bash

## Directorios
##
httpDir="/storage/codery/wwwroot/CODERY/pub"
rootDir=$1
 
## Datos do sitio
##
siteName="Drupal OSL"
siteSlogan="Curso Drupal OSL"
siteLocale="es"
 
## Base de datos
##
dbHost="localhost"
dbName="demo"
dbUser="demo"
dbPassword="demo"
dbPrefix="osl_$1_"
 
## Configuracion conta administrador
##
adminUsername="admin"
adminPassword="admin"
adminEmail="admin@example.com"
 
## Core
##
drush dl -y --destination=$httpDir --drupal-project-rename=$rootDir;
 
cd $httpDir/$rootDir;
 
## Instalacion do core
##
drush site-install -y standard --account-mail=$adminEmail --account-name=$adminUsername --account-pass=$adminPassword --site-name=$siteName --site-mail=$adminEmail --locale=$siteLocale --db-prefix=$dbPrefix --db-url=mysql://$dbUser:$dbPassword@$dbHost/$dbName;

## Deshabilitamos algúns módulos do core que non precisamos
##
drush -y dis color overlay

## Módulos básicos
## 
drush -y dl token pathauto

## Módulos contribuidos devel-toolkit
##
drush -y dl devel views ctools drupalforfirebug smtp backup_migrate features
drush -y en devel devel_generate views views_ui ctools drupalforfirebug smtp backup_migrate features

## Temas
drush -y dl bootstrap
drush -y en bootstrap

## Configuracion módulo smtp
##
drush vset smtp_on 1
drush vset smtp_host 127.0.0.1
drush vset smtp_hostbackup smtp-01.osl.cixug.es


## Deshabilitamos o rexistro de usuarios
##
drush vset -y user_register 0;

## Configuracion o slogan do sitio
##
drush vset -y site_slogan $siteSlogan; 

## Configuración do tema predeterminado
drush vset theme_default bootstrap

## Configuración do tema predeterminado para rol Administrador
drush vset admin_theme bootstrap
