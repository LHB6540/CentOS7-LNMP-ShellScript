# CentOS7-LNMP-ShellScript
### 简述：
CentOS7一键部署LNMP环境shell脚本
### 版本信息
基于CentOS7_1908版本，最小安装模式,理论支持CnetOS7所有版本   
Nginx版本：1.18      
PHP-fpm版本7.4.7
### 注意事项
Nginx、PHP均使用官方源，国内下载速度较慢，为防止意外中断，建议在screen中执行脚本    
Nginx 用户、组为www   
Nginx 支持使用Systemctl [] nginx.service管理  
PHP支持使用Service php-fpm []管理

