#!/bin/bash
if_update="n"
read -t 30 -p "please choose if Update System and Kernel 请选择是否更新系统和内核:y/n    " if_update
if [ "$if_update" = "y" ]
then
     yum -y update
else 
    echo "Without Update 未选择更新"
fi

##########################################################################
echo 'install MariaDB 安装MariaDB'
yum -y install mariadb mariadb-server
###########################################################################
echo 'Compile and install Nginx 1.18.0 stable 编译安装Nginx 1.18.0稳定版本 '
yum -y install wget
mkdir LNMP
cd LNMP
wget http://nginx.org/download/nginx-1.18.0.tar.gz
tar -xvf nginx-1.18.0.tar.gz
cd nginx-1.18.0
echo 'Dowmload and unzip successfully 下载并解压成功'
#---------------------------------------------------------------------------
echo 'Install the compilation environment 安装编译环境'
yum -y install pcre pcre-devel
yum -y install openssl openssl-devel
yum -y install gcc
yum -y install zlib zlib-devel./configure --prefix=/usr/local/nginx1.18 --user=www --group=www --with-http_ssl_module --with-http_flv_module --with-http_stub_status_module --with-http_gzip_static_module --with-pcre
make&&makeinstall
#----------------------------------------------------------------------------
echo 'Install completed,register service and configure environment variables 安装完成,开始注册服务及配置环境变量'
cd /usr/local/nginx1.18
