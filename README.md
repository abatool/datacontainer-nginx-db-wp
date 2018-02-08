# datacontainer-nginx-db-wp
This repository contain a Dockerfile to build a data container image that mount DocumentRoot for nginx, and install **wordpress** in the directory and also mount it on the host machine, to create a niginx container I will use this image **minhdanh/nginx-php** (it’s an image of nginx with php installed).

## Base Docker Image
* centos

### Use of this image

You can use this repository to create data container witch will map on DocumentRoot directory of nginx server /usr/share/nginx/html and /var/lib/mysql for mariadb.

## Build from source

**$ docker build -t="abatool/datacontainer-nginx-db-wp" github.com abatool/datacontainer-nginx-db-wp**

Install image from github.

## Pulling from Docker Hub

**$ docker pull abatool1/datacontainer-nginx-db-wp**

This command pull the image from docker hub.

### Prerequisites 

**$ docker network create wpnet**
 
First we need create a network that we will use while creating containers

**$ docker create --name datacontainer --network wpnet abatool1/datacontainer-nginx-db-wp**

Then we create a container with this image.

## Docker run example:

**$ docker run --name db -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=wproot -e MYSQL_DATABASE1=wordpress -e MYSQL_USER1=wpuser -e MYSQL_PASSWORD1=wppass --volumes-from datacontainer orboan/dcsss-mariadb**

Here I am using **orboan/dcsss-mariadb** image to create a container based on mariadb here we create a     
database for our **wordpress**.

With **--name** you can give a name to you container at container creation time.

With **MYSQL_ROOT_PASSWORD** enviroment variable you can set the mariadb root password at container creation time.

With **MYSQL_DATABASE1**, **MYSQL_USER1**, **MYSQL_PASSWORD1** you can create a mysql db, user with all privileges upon this db, and its password, at container creation time.

You can also create up to 10 triplets (db, user, password) using MYSQL_DATABASEn, MYSQL_USERn, MYSQL_PASSWORDn environment variables, with n=1..10

**3306:3306** maps the mariadb server 

**$ docker run -d --name nginx -p 80:80 --network wpnet --volumes-from datacontainer minhdanh/nginx-php**

With this command we create on nginx based container with image **minhdanh/nginx-php** (it’s an image of nginx with php installed). 

With **--name** you can give a name to you container at container creation time. 

With **-p 80:80** Mapping the port **80** of the host machine to port **80** of the container, it’s the port that nginx server use by default, and mapping volumes from datacontainer with **--volumes-from datacontainer**.

We also use **-d** option for container to run in background and print container ID.

**Then you can hit http://localhost:80 or http://host-ip:80 in your browser**. 

## Docker inspect

**$ docker inspect datacontainer**

This command list all the information about the container to see the mounted volumes we have go to the mount part and there we can see the source and the destination of a mounted volume.

#### For example

  "Mounts": [
   
      {
        "Type": "volume",
       
        "Name": "36b2cff11525619d6b2016807263beca4d5964b1df8014e1da2cfb14f95e70be",
        
        "Source":"/var/lib/docker/volumes/36b2cff11525619d6b201680726
         3beca4d5964b1df8014e1da2cfb14f95e70be/_data",
         
        "Destination":"/usr/share/nginx/html",
         
        "Driver": "local",
        
         "Mode": "",
          
         "RW": true,
          
         "Propagation": ""
           
        },
   ]

You can enter in the source directory and see that there are all the configuration files of **wordpress** now even if you deleted  your nginx (or mariadb)  containers by chance or have problems with them, the **wordpress** configuration files still will be  save in the correspondent source directory and all you need to do is to create deleted or defected container again and you will be able to use the **same wordpress** once again.

## Inculde script
You can run the following script to create a network for the containers and a create datacontainer with this image (abatool1/datacontainer-ngnix-db-wp) which maps the nginx directory /usr/share/nginx/html and mariadb directory /var/lib/mysql and also runs nginx and mariadb containers.

#/bin/bash

#Creation of a new network called wpnet.

**docker network create wpnet**

#Creating a container named datacontainer with the image abatool1/datacontainer-nginx-db-wp which is mapping volumes /usr/share/nginx/html for nginx and /var/lib/mysql (database for wordpress) for mariadb.

**docker create --name datacontainer --network wpnet abatool1/datacontainer-nginx-db-wp**

#Create a mariadb-based container named db with image orboan/dcsss-mariadb using volumes of the datacontainer

**docker run --name db -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=wproot -e MYSQL_DATABASE1=wordpress -e MYSQL_USER1=wpuser -e MYSQL_PASSWORD1=wppass --volumes-from datacontainer orboan/dcsss-mariadb**

#Create a container based on nginx called nginx with image minhdanh/nginx-php using datacontainer volumes.

**docker run -d --name nginx -p 80:80 --network wpnet --volumes-from datacontainer minhdanh/nginx-php**

## Authors
**Author:** Arfa Batool (batoolarfa@gmail.com)

## Acknowledgments
The code was inspired by **orboan/dcsss-httpd-wordpress** image.

### Used images 
**orboan/dcsss-mariadb**
**minhdanh/nginx-php**
**abatool1/datacontainer-nginx-db-wp**

