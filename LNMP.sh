#!/bin/bash
if_update="n"
read -t 20 -p "please choose if Update System and Kernel,after 20s will choose not update 请选择是否更新系统和内核,20秒后选择不更新(y/n):    " if_update
if [ "$if_update" = "y" ]
then
     yum -y update
else 
    echo "Without Update 未选择更新"
fi
useradd www
##########################################################################
echo 'install MariaDB 安装MariaDB'
yum -y install mariadb mariadb-server
###########################################################################
echo 'Compile and install Nginx 1.18.0 stable 编译安装Nginx 1.18.0稳定版本 '
yum -y install wget
cd /root
mkdir LNMP
cd LNMP
if  [ ! -f "/root/LNMP/nginx-1.18.0.tar.gz" ];then
wget http://mirrors.sohu.com/nginx/nginx-1.18.0.tar.gz
fi
tar -xvf nginx-1.18.0.tar.gz
cd nginx-1.18.0
echo 'Dowmload and unzip successfully 下载并解压成功'
#---------------------------------------------------------------------------
echo 'Install the compilation environment 安装编译环境'
yum -y install pcre pcre-devel
yum -y install openssl openssl-devel
yum -y install gcc
yum -y install zlib zlib-devel
./configure --prefix=/usr/local/nginx1.18 --user=www --group=www --with-http_ssl_module --with-http_flv_module --with-http_stub_status_module --with-http_gzip_static_module --with-pcre
make&&make install

#----------------------------------------------------------------------------
echo 'Install completed,register service and configure environment variables 安装完成,开始注册服务及配置环境变量'
cd /lib/systemd/system
wget https://raw.githubusercontent.com/LHB6540/CentOS7-LNMP-ShellScript/master/nginx
rm -f nginx.service
mv nginx nginx.service
systemctl daemon-reload
systemctl start nginx.service
#----------------------------------------------------------------------------
if_enable_nginx=y
read -t 20 -p "if set nginx enable,after 20s it will be setted enable 是否设置nginx自启动,20秒后默认设置自启动(y/n): " if_enable_nginx
if [ "$if_enable_nginx" = "y" ]
then
systemctl enable nginx.service
fi
#----------------------------------------------------------------------------
echo 'export PATH=$PATH:/usr/local/nginx1.18/sbin' >> /etc/profile
source /etc/profile
echo 'Nginx completed nginx安装已完成'
###############################################################################
echo 'Start install php-fpm 开始安装php-fpm'
cd /root/LNMP
if  [ ! -f "/root/LNMP/php-7.4.7.tar.gz" ];then
wget http://mirrors.sohu.com/php/php-7.4.7.tar.gz
fi
tar -xvf php-7.4.7.tar.gz
yum -y install libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel libcurl libcurl-devel libxslt-devel sqlite-devel
yum install epel-release -y
yum clean all&& yum makecache
yum install oniguruma oniguruma-devel -y
cd /root/LNMP/php-7.4.7
./configure --prefix=/usr/local/php7.4.7 --with-curl --with-freetype-dir --with-gd --with-gettext --with-iconv-dir --with-jpeg-dir --with-kerberos --with-libdir=lib64 --with-libxml-dir --with-mysql --with-mysqli --with-openssl --with-pcre-regex --with-pdo-mysql --with-pdo-sqlite --with-pear --with-png-dir --with-xmlrpc --with-xsl --with-zlib --enable-fpm --enable-bcmath --enable-libxml --enable-inline-optimization --enable-gd-native-ttf --enable-mbregex --enable-mbstring --enable-opcache --enable-pcntl --enable-shmop --enable-soap --enable-sockets --enable-sysvsem --enable-xml  --enable-zip
make && make install
#-------------------------------------------------------------------------------
cd /usr/local/php7.4.7/etc
cp php-fpm.conf.default php-fpm.conf
cd /usr/local/php7.4.7/etc/php-fpm.d
cp www.conf.default www.conf
cp /root/LNMP/php-7.4.7/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod o+x /etc/init.d/php-fpm
service php-fpm start
#-------------------------------------------------------------------------------
echo 'export PATH=$PATH:/usr/local/php7.4.7/bin' >> /etc/profile
source /etc/profile
###############################################################################
echo '环境配置完毕，您可以访问主机地址，将看到nginx欢迎页面'
echo '请确保已关闭防火墙或者放行80端口，请关闭selinux，云主机请在安全组规则中放行80端口'
echo 'Nginx 支持使用Systemctl [start/stop/restart/status] nginx.service管理'
echo 'PHP支持使用Service php-fpm [start/stop/restart]管理'
read -p 'LNMP组件已经安装完毕，是否允许修改Nginx配置文件和主页以测试php解析是否正常(y/n): ' if_test_php
if [ "$if_test_php" = "y" ]
then
cp /usr/local/nginx1.18/conf/nginx.conf /usr/local/nginx1.18/conf/nginx.conf.back
rm -f /usr/local/nginx1.18/conf/nginx.conf
cd /usr/local/nginx1.18/conf
wget https://raw.githubusercontent.com/LHB6540/CentOS7-LNMP-ShellScript/master/configOfnginx
mv configOfnginx nginx.conf
cd /usr/local/nginx1.18/html
wget https://raw.githubusercontent.com/LHB6540/CentOS7-LNMP-ShellScript/master/index.php
/usr/local/nginx1.18/sbin/nginx -s reload
echo '请重新访问页面，您将看到php信息'
fi
 

















