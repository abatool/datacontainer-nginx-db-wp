# Pull base image.
FROM centos 

#Create documentroot directory for apache.
RUN mkdir -p /usr/share/nginx/html 

#Create documentroot directory for mariadb.
RUN mkdir -p /var/lib/myqsl

#Creating user and group nginx with uid and guid.
RUN groupadd -g 115 nginx
RUN useradd -u 115 -g 115 nginx
 
#Declare the work directory
WORKDIR ["/usr/share/nginx/html"]

# Install wget
RUN yum install wget -y 

#Enter in the directory /usr/share/nginx/html
RUN cd /usr/share/nginx/html 

#Installation of latest version of wordpress.
RUN wget https://wordpress.org/latest.tar.gz 

RUN\
#Extract the wordpress directory.
tar -xvf latest.tar.gz && \

# As we already extract the wordpress directory we delete the latest.tar.gz file.
rm -f latest.tar.gz && \

#Copy all the files from the directory /usr/share/nginx/wordpress to /usr/share/nginx//html.
mv  /usr/share/nginx/wordpress/* /usr/share/nginx/html && \

#Delete wordpress directory.
rm -rf wordpress/ && \

#Recursively change the owner of /usr/share/nginx/html to nginx.
chown -R nginx:nginx /usr/share/nginx//html && \

#Recursively change the permission of directory /usr/share/nginx/html to 755.
chmod -R 755 /usr/share/nginx/html

#Difine mountable directories.
VOLUME ["/usr/share/nginx/html" , "/var/lib/msql"]

