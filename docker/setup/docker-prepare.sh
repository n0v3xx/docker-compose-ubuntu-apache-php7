#!/bin/bash

# this file is excecutet on docker-setup.sh

# include config
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/../config/docker-config.sh

USER_ID=$(id -u)
GROUP_ID=$(id -g)
GROUP_NAME=$(id -gn)

# Start
sudo docker-compose up -d

#############################################
########    System User and Group    ########
#############################################
echo "==> Add group '$GROUP_NAME'"
sudo docker exec -it ${CONTAINER_WEB} groupadd -f -g "$GROUP_ID" "$GROUP_NAME"
echo "==> Add new user '$USER' with group '$GROUP_NAME'"
sudo docker exec -it ${CONTAINER_WEB} /bin/bash -c "id -u $USER &>/dev/null || useradd -m -u $USER_ID -g $GROUP_NAME -d $HOME $USER"

#############################################
######## Change Apache Conf and Vars ########
#############################################
echo "==> Set APACHE_RUN_USER to '$USER'"
sudo docker exec -it ${CONTAINER_WEB} sed -i -r "s/APACHE_RUN_USER=www-data\b/APACHE_RUN_USER=$USER"/ /etc/apache2/envvars
echo "==> Set APACHE_RUN_GROUP to '$GROUP_NAME'"
sudo docker exec -it ${CONTAINER_WEB} sed -i -r "s/APACHE_RUN_GROUP=www-data\b/APACHE_RUN_GROUP=$GROUP_NAME"/ /etc/apache2/envvars
echo "==> Set apache2.conf User to '$USER'"
sudo docker exec -it ${CONTAINER_WEB} sed -i -r "s/User www-data\b/User $USER"/ /etc/apache2/apache2.conf
echo "==> Set apache2.conf Group '$GROUP_NAME'"
sudo docker exec -it ${CONTAINER_WEB} sed -i -r "s/Group www-data\b/Group $GROUP_NAME"/ /etc/apache2/apache2.conf

#############################################
########           XDEBUG            ########
#############################################
echo "==> Replace xdebug remote host with ipadress of docker host"
REMOTE_HOST=$(hostname -I | awk '{print $1}')
echo "Your remote host ip address is $REMOTE_HOST"
sudo docker exec -it ${CONTAINER_WEB} sed -i -r "s/xdebug\.remote_host=(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b/xdebug.remote_host=$REMOTE_HOST"/ /etc/php/7.0/mods-available/xdebug.ini

#############################################
########           PHP.INI            #######
#############################################
echo "PHP.ini - Set memory_limit to -1"
sudo docker exec -it ${CONTAINER_WEB} sed -i -r "s/memory_limit = 128M\b/memory_limit = -1"/ /etc/php/7.0/apache2/php.ini

# Restart
sudo docker-compose restart ${CONTAINER_WEB}