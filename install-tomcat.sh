#!/bin/bash

sudo yum update -y
sudo yum install -y httpd tomcat7

echo "\
<VirtualHost *:80>
  ProxyPass / http://localhost:8080/
  ProxyPassReverse / http://localhost:8080/
</VirtualHost>" | sudo tee /etc/httpd/conf.d/tomcat.conf

sudo service httpd start
sudo service tomcat7 start

sudo wget -O /usr/share/tomcat7/webapps/petclinic.war https://s3-us-west-2.amazonaws.com/codepipeline-blog/petclinic.war
sudo service tomcat7 restart
