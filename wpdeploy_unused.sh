#! /bin/bash -v

cat << EOF >> /etc/resolv.conf
nameserver 8.8.8.8
search strato
EOF

DBHOST=${db_ip}
DBUSER="admin"
DBPASSWORD="password"
DBNAME="wordpress"


# update image
apt-get update -y
apt-get upgrade -y

# install docker
apt-get install -y docker.io

#fetch public docker wordpress container
docker pull wordpress

# run docker container

docker run --name wpsite -e WORDPRESS_DB_HOST=$DBHOST:3306 -e WORDPRESS_DB_USER=$DBUSER -e WORDPRESS_DB_PASSWORD=$DBPASSWORD -p 8080:80 -d wordpress