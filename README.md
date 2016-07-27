# docker-compose-ubuntu-apache-php7

Run 2 docker container with: 
* Ubuntu 16.10
* Apache2 (2.4.18)
* PHP 7 (7.0.8)
* XDebug (2.4.0)
* Memcache (Hostname: memcached, Port: 11211)

Base Container: https://github.com/n0v3xx/docker-ubuntu-apache-php7

Start container (without modification):

    sudo docker-compose up -d
    
Start container with user rights and co (only working on linux systems):

    ./docker/setup/docker-setup.sh
    
Open in browser to see phpinfo():

    http://localhost:8880/info.php