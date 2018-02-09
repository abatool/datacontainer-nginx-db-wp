#/bin/bash
echo "------------------------------------------------------------------------------------------------------"
echo "-----------------------------------------Creation of a new network called wpnet.--------------------------------------"
echo "------------------------------------------------------------------------------------------------------"

docker network create wpnet

echo "------------------------------------------------------------------------------------------------------"
echo "----------Creating a container named datacontainer with the image abatool1/datacontainer-nginx-db-wp which maps volumes /usr/share/nginx/html for nginx and /var/lib/mysql for mariadb.---------------"
echo "------------------------------------------------------------------------------------------------------"

docker create --name datacontainer --network wpnet abatool1/datacontainer-nginx-db-wp

echo "------------------------------------------------------------------------------------------------------"
echo "----------Creating a container of mariadb based image named db with orboan/dcsss-mariadb image and using datacontainer volumes.---------------"
echo "------------------------------------------------------------------------------------------------------"

docker run --name db -d -p 3306:3306 --network wpnet -e MYSQL_ROOT_PASSWORD=wproot -e MYSQL_DATABASE1=wordpress -e MYSQL_USER1=wpuser -e MYSQL_PASSWORD1=wppass --volumes-from datacontainer orboan/dcsss-mariadb

echo "------------------------------------------------------------------------------------------------------"
echo "----------Create a container called nginx with  minhdanh/nginx-php image (it's a nginx based image with php intalles) using datacontainer volumes.---------------"
echo "------------------------------------------------------------------------------------------------------"

docker run --name nginx -d -p 80:80 --network wpnet --volumes-from datacontainer minhdanh/nginx-php

