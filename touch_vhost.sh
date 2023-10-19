#!/bin/bash

domain=$1

if [ -z $domain ];then
 echo
 echo "----------------------------------------------"
 echo "Script usage: sudo ./touch_vhost.sh DomainName"
 echo "For example: sudo ./touch_vhost.sh example.com"
 echo "----------------------------------------------"
 echo
 exit
fi

nginx_dir="/etc/nginx"
repo_dir="/home/ubuntu/DevOps_cource"
webdir="/var/www/$domain"

if [ ! -f "$nginx_dir/nginx.conf.org" ]; then
  echo
  echo "make bkp from nginx.conf origin before copy new nginx.conf"
  echo
  mv $nginx_dir/nginx.conf $nginx_dir/nginx.conf.org
  cp $repo_dir/nginx.conf $nginx_dir/
fi

if [ ! -d $nginx_dir/vhosts ];then
  echo
  echo "vhosts does not exist, create ..."
  echo
  sudo mkdir $nginx_dir/vhosts
fi

if [ ! -d $webdir ];then
  echo
  echo "webdir does not exist, create ..."
  echo
  eval mkdir -p "$webdir"/{logs,public_html}
fi

sed "s/__DOMAIN__/$domain/g" $repo_dir/template.host > $nginx_dir/vhosts/$domain.conf

service nginx configtest && service nginx reload && echo "Success"
