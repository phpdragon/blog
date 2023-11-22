---
title: TinyCore 14.0 搭建 LNAMP
date: 2023-11-21 16:50:10
categories: ['OS', 'Linux', 'TinyCore', 'LNAMP']
tags: ['Linux', 'TinyCore', 'TinyCore 14.0', 'Nginx', 'Apache', 'PHP', 'MySQL']
---

# 一、前言

> 本文的 TinyCore Linux 基于博文安装：[VMware虚拟机安装TinyCore-Pure-14.0](/blog/2023/11/18/vmware-build-tinycore-pure-14.0/)

LNAMP(Linux+Nginx+Apache+Mysql+PHP)架构受到很多IT企业的青睐，取代了原来认为很好的LNMP(Linux+Nginx+Mysql+PHP)架构。

那我们说LNAMP到底有什么优点呢,还得从Nginx和apache的优缺点说起。

- Nginx处理静态文件能力很强。同样起web 服务，比apache占用更少的内存及资源，Nginx 静态处理性能比 Apache 高3倍以上。nginx 处理请求是异步非阻塞的，而apache则是阻塞型的，在高并发下nginx 能保持低资源低消耗高性能。
- Apache处理动态文件很强而且很稳定。如果PHP处理慢或者前端压力很大的情况下，很容易出现Apache进程数飙升，从而拒绝服务的现象。把二者综合在一块,性能能提升很多倍。

# 二、安装Nginx

## 1. 安装nginx

```bash
tce-load -wi nginx
```

## 2. 配置nginx

> Tiny Core Linux是加载到内存运行的，如果我们不做持久化配置，当你重启系统后，所有修改都会丢失。

```bash
cd /usr/local/etc/nginx
#sudo cp original/nginx.conf.default nginx.conf
sudo cp original/fastcgi_params.default fastcgi_params
sudo cp original/mime.types.default mime.types
sudo mkdir -p /usr/local/etc/nginx/conf.d

sudo mkdir -p /usr/local/html
sudo cp /usr/local/lib/nginx/html/index.html /usr/local/html
```

添加nginx配置文件，`sudo vi /usr/local/etc/nginx/nginx.conf`，添加如下内容：
```text
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    
    access_log  /var/log/nginx/access.log;
    
    sendfile        on;
    keepalive_timeout  65;
    gzip  on;

    include conf.d/*.conf;
}
```

添加vhost配置文件，`sudo vi /usr/local/etc/nginx/conf.d/default.conf`，添加如下内容：
```text
server {
    listen          80;
    server_name     localhost;

    location / {
       root   html;
       index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }

}
```

启动Nginx：
```bash
sudo /usr/local/etc/init.d/nginx start
sudo /usr/local/etc/init.d/nginx reload
sudo /usr/local/etc/init.d/nginx status
```

查看客户机ip：
```bash
ifconfig eth0 | grep "inet addr" 
```
打开浏览器，使用 IP 地址浏览，可以看到nginx的欢迎网页，说明nginx已经正常工作了。

## 3. 开机自动启动

`sudo vi /opt/bootlocal.sh`，加入启动命令：
```text
/usr/local/etc/init.d/nginx start &
```

## 4. 持久化Nginx的配置与网页

```bash
echo '/opt/bootlocal.sh' >> /opt/.filetool.lst
echo '/usr/local/etc/nginx' >> /opt/.filetool.lst
echo '/usr/local/html' >> /opt/.filetool.lst

filetool.sh -b
```

# 三、安装Apache2.4 

## 1. 安装httpd
```bash
tce-load -wi apache2.4  #请打开http://tinycorelinux.net/14.x/x86/tcz/搜索apache具体版本
```

## 2. 配置httpd

> Tiny Core Linux是加载到内存运行的，如果我们不做持久化配置，当你重启系统后，所有修改都会丢失。

```bash
cd /usr/local/etc/httpd
sudo cp original/httpd.conf-sample httpd.conf

sudo mkdir -p /usr/local/etc/httpd/conf.d/
sudo mkdir -p /usr/local/html
```

修改配置：
```bash
cd /usr/local/etc/httpd

sudo sed -i 's|^User daemon|User nobody|g' httpd.conf
sudo sed -i 's|^Group daemon|Group nogroup|g' httpd.conf
sudo sed -i 's|^#ServerName www.example.com:80|ServerName localhost:8080|g' httpd.conf
sudo sed -i 's|^Listen 80|Listen 8080|g' httpd.conf
```

启动httpd：
```bash
sudo /usr/local/etc/init.d/httpd start
```

打开浏览器，使用 IP:8080 地址浏览，可以看到Apache的工作网页，说明Apache已经正常工作了。

## 3. 开机自动启动

`sudo vi /opt/bootlocal.sh`，加入启动命令：
```text
/usr/local/etc/init.d/httpd start &
```

## 4. 持久化httpd的配置与网页

```bash
echo '/usr/local/etc/httpd' >> /opt/.filetool.lst

filetool.sh -b
```

# 四、安装MariaDB(MySQL)

## 1. 安装数据库

```bash
tce-load -wi mariadb-10.4-client.tcz mariadb-10.4-dev.tcz mariadb-10.4.tcz
```

## 2. 初始化数据库

初始化数据库：我们将默认的数据库存放在 /home/tc/mysql/data 文件夹中，所以先创建相应的文件夹，再使用mysql_install_db来生成初始化的数据库信息。
```bash
cd  /usr/local/mysql/scripts/
mkdir -p /home/tc/mysql/data
sudo chown -R tc:staff /home/tc/mysql

sudo mkdir /auth_pam_tool_dir
sudo ./mysql_install_db --user=root --basedir=/usr/local/mysql --datadir=/home/tc/mysql/data
sudo rm -rf /auth_pam_tool_dir
```

## 3. 配置my.cnf

编写 my.cnf 文件，设置好数据库的配置参数：
先删除原来的 my.cnf 文件
```bash
cd /usr/local/etc/mysql/
sudo unlink my.cnf
sudo touch my.cnf
```

`sudo vi /usr/local/etc/mysql/my.cnf`，添加如下内容：
```text
[mysqld]
bind-address=0.0.0.0
port=3306
user=root
basedir=/usr/local/mysql
datadir=/home/tc/mysql/data
socket=/var/run/mysql.sock
log-error=/home/tc/mysql/data/mysql_error.log
pid-file=/var/run/mysql.pid
character_set_server=utf8mb4
symbolic-links=0
innodb_log_file_size = 5M
```

## 4. 启动mysql服务

```bash
sudo /usr/local/etc/init.d/mysql start
```

## 5. 修改root密码

### 5.1 方式一

```bash
sudo /usr/local/mysql/bin/mysqladmin -u root password 你的密码
```

### 5.1 方式二(推荐)

```bash
sudo /usr/local/mysql/bin/mysql_secure_installation
```
选择操作和回显如下：
```text
NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user. If you've just installed MariaDB, and
haven't set the root password yet, you should just press enter here.

Enter current password for root (enter for none): 
OK, successfully used password, moving on...

Setting the root password or using the unix_socket ensures that nobody
can log into the MariaDB root user without the proper authorisation.

You already have your root account protected, so you can safely answer 'n'.

Switch to unix_socket authentication [Y/n] y
Enabled successfully!
Reloading privilege tables..
 ... Success!


You already have your root account protected, so you can safely answer 'n'.

Change the root password? [Y/n] y
New password: 
Re-enter new password: 
Password updated successfully!
Reloading privilege tables..
 ... Success!


By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] y
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] n
 ... skipping.

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] n
 ... skipping.

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
```

### 5.3 验证root密码
```text
sudo /usr/local/mysql/bin/mysql -uroot -p -e 'show databases;'
或
sudo /usr/local/mysql/bin/mysql -uroot -p -e 'select version();'
```

## 6. 开机自动启动

`sudo vi /opt/bootlocal.sh`，加入启动命令：
```bash
/usr/local/etc/init.d/mysql start &
```

## 7. my.cnf加入持久化

```bash
echo "/usr/local/etc/mysql" >> /opt/.filetool.lst

filetool.sh -b
```

# 五、安装PHP

## 1. 安装PHP
```bash
tce-load -wi php-7.4-cli php-7.4-cgi php-7.4-dev.tcz php-7.4-ext.tcz php-7.4-mod.tcz php-7.4-fpm.tcz
tce-load -wi libxml2 readline liblzma bzip2 libffi pcre2 curl libgd gdbm sqlite3
```

## 2. 安装其他扩展
```bash
tce-load -wi openssl-*              #支持openssl、ftp扩展，请打开http://tinycorelinux.net/14.x/x86/tcz/搜索具体版本
tce-load -wi bzip2                  #支持bz2扩展，请打开http://tinycorelinux.net/14.x/x86/tcz/搜索bzip2具体版本
tce-load -wi curl                   #支持curl扩展
tce-load -wi gdbm                   #支持dba扩展
tce-load -wi libxml2                #支持libxml、xml、dom、simplexml、soap、xmlreader、xmlrpc、xmlwriter、扩展
tce-load -wi enchant2               #支持enchant扩展
tce-load -wi libgd                  #支持gd扩展
tce-load -wi gmp                    #支持gmp扩展
tce-load -wi openldap cyrus-sasl    #支持ldap扩展
tce-load -wi libonig                #支持mbstring扩展
tce-load -wi unixODBC               #支持odbc、pdo_odbc扩展
tce-load -wi postgresql-9.5-client  #支持pgsql、pdo_pgsql扩展
tce-load -wi sqlite3                #支持sqlite3、pdo_sqlite扩展
tce-load -wi aspell                 #支持pspell扩展
tce-load -wi readline               #支持readline扩展
tce-load -wi net-snmp               #支持snmp扩展
tce-load -wi libsodium              #支持sodium扩展
tce-load -wi libtidy                #支持tidy扩展
tce-load -wi libxml2 libxslt        #支持xsl扩展
tce-load -wi libzip                 #支持zip扩展
```

## 3. 配置php.ini

### 3.1. 开启扩展

添加php.ini配置文件, 请按需开启扩展：
```bash
cd /usr/local/etc/php7/
sudo cp php.ini-sample-7.4 php.ini

#配置时区
sudo sed -i 's|^;date.timezone =|date.timezone = Asia/Shanghai|g' php.ini

#开启扩展
sudo sed -i 's|^;extension=openssl|extension=openssl|g' php.ini
sudo sed -i 's|^;extension=bcmath|extension=bcmath|g' php.ini
sudo sed -i 's|^;extension=bz2|extension=bz2|g' php.ini
sudo sed -i 's|^;extension=curl|extension=curl|g' php.ini
sudo sed -i 's|^;extension=dba|extension=dba|g' php.ini
sudo sed -i 's|^;extension=enchant|extension=enchant|g' php.ini
sudo sed -i 's|^;extension=ftp|extension=ftp|g' php.ini
sudo sed -i 's|^;extension=gd|extension=gd|g' php.ini
sudo sed -i 's|^;extension=gettext|extension=gettext|g' php.ini
sudo sed -i 's|^;extension=gmp|extension=gmp|g' php.ini
sudo sed -i 's|^;extension=iconv|extension=iconv|g' php.ini
sudo sed -i 's|^;extension=ldap|extension=ldap|g' php.ini
sudo sed -i 's|^;extension=mbstring|extension=mbstring|g' php.ini
sudo sed -i 's|^;extension=exif|extension=exif|g' php.ini
sudo sed -i 's|^;extension=mysqlnd|extension=mysqlnd|g' php.ini
sudo sed -i 's|^;extension=mysqli|extension=mysqli|g' php.ini
sudo sed -i 's|^;extension=pdo_mysql|extension=pdo_mysql|g' php.ini
sudo sed -i 's|^;extension=odbc|extension=odbc|g' php.ini
sudo sed -i 's|^;extension=pdo_odbc|extension=pdo_odbc|g' php.ini
sudo sed -i 's|^;extension=pgsql|extension=pgsql|g' php.ini
sudo sed -i 's|^;extension=pdo_pgsql|extension=pdo_pgsql|g' php.ini
sudo sed -i 's|^;extension=sqlite3|extension=sqlite3|g' php.ini
sudo sed -i 's|^;extension=pdo_sqlite|extension=pdo_sqlite|g' php.ini
sudo sed -i 's|^;extension=pcntl|extension=pcntl|g' php.ini
sudo sed -i 's|^;extension=phar|extension=phar|g' php.ini
sudo sed -i 's|^;extension=phpdbg_webhelper|extension=phpdbg_webhelper|g' php.ini
sudo sed -i 's|^;extension=pspell|extension=pspell|g' php.ini
sudo sed -i 's|^;extension=readline|extension=readline|g' php.ini
sudo sed -i 's|^;extension=session|extension=session|g' php.ini
sudo sed -i 's|^;extension=shmop|extension=shmop|g' php.ini
sudo sed -i 's|^;extension=simplexml|extension=simplexml|g' php.ini
sudo sed -i 's|^;extension=snmp|extension=snmp|g' php.ini
sudo sed -i 's|^;extension=soap|extension=soap|g' php.ini
sudo sed -i 's|^;extension=sockets|extension=sockets|g' php.ini
sudo sed -i 's|^;extension=sodium|extension=sodium|g' php.ini
sudo sed -i 's|^;extension=sysvmsg|extension=sysvmsg|g' php.ini
sudo sed -i 's|^;extension=sysvsem|extension=sysvsem|g' php.ini
sudo sed -i 's|^;extension=sysvshm|extension=sysvshm|g' php.ini
sudo sed -i 's|^;extension=tidy|extension=tidy|g' php.ini
sudo sed -i 's|^;extension=tokenizer|extension=tokenizer|g' php.ini
sudo sed -i 's|^;extension=xsl|extension=xsl|g' php.ini
sudo sed -i 's|^;extension=zip|extension=zip|g' php.ini
sudo sed -i 's|^;extension=zlib|extension=zlib|g' php.ini

#复核已开启模块
cat php.ini | grep 'extension='

php -m
```

修复动态库报错, 原因是从 PHP 5.1.2 开始，hash扩展是内置的，不需要外部库，并且默认是启用的。 ：
```text
PHP Warning:  PHP Startup: Unable to load dynamic library 'hash' (tried: /usr/local/lib/php/extensions/hash (/usr/local/lib/php/extensions/hash: cannot open shared object file: No such file or directory), /usr/local/lib/php/extensions/hash.so (/usr/local/lib/php/extensions/hash.so: cannot open shared object file: No such file or directory)) in Unknown on line 0
```

注释掉无效配置
```bash
sudo sed -i 's|^extension=hash|;extension=hash|g' php.ini
```

验证
```bash
php -m | grep 'Warning'
php -r "echo hash('md5','1234');"
```

### 3.2. 重启服务

```bash
sudo /usr/local/etc/init.d/httpd restart
```

重启Nginx，需要的话：
```bash
sudo /usr/local/etc/init.d/nginx stop
sudo /usr/local/etc/init.d/nginx start
```

### 3.3. php.ini加入持久化

```bash
echo '/usr/local/etc/php7' >> /opt/.filetool.lst

filetool.sh -b
```

## 4. 安装扩展mcrypt

```bash
tce-load -wi libmcrypt.tcz mhash.tcz
```

## 5. 安装oci8、pdo_oci扩展

### 5.1 下载安装包
前往Oracle官网[Instant Client for Linux x86-64 (64-bit)](https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html)
下载instantclient以支持 oci8、pdo_oci扩展：
```bash
cd /home/tc/

#查看glibc的版本
ldd --version

#选择合适的版本下载
wget https://download.oracle.com/otn_software/linux/instantclient/2112000/instantclient-basic-linux.x64-21.12.0.0.0dbru.zip
unzip instantclient*.zip

mkdir /home/tc/oracle
cp instantclient_21_12/libclntsh.so.21.1 /home/tc/oracle/
cp instantclient_21_12/libclntshcore.so.21.1 /home/tc/oracle/
cp instantclient_21_12/libnnz21.so /home/tc/oracle/
cp instantclient_21_12/libocci.so.21.1 /home/tc/oracle/
cd /home/tc/oracle && ln -s libclntsh.so.21.1 libclntsh.so.12.1 && cd /home/tc

sudo mv /home/tc/oracle/ /usr/local/

rm -rf instantclient_21_12
unlink instantclient*.zip
```

### 5.2 配置安装脚本
`sudo vi /usr/local/tce.installed/oracle`，添加如下内容：
```text
#!/bin/sh
[ $(grep oracle /etc/ld.so.conf) ] || echo /usr/local/oracle >> /etc/ld.so.conf
ldconfig -q
```

### 5.3 打包oracle动态库包

```bash
cd /home/tc

tce-load -wi squashfs-tools

sudo chmod 777 /usr/local/tce.installed/oracle
sudo chown tc:staff /usr/local/tce.installed/oracle
sudo chmod -R 777 /usr/local/oracle
sudo chown root:root /usr/local/oracle
mksquashfs /usr/local/oracle /usr/local/tce.installed/oracle oracle.tcz -no-strip

cp oracle.tcz /mnt/sda1/tce/optional
echo 'oracle.tcz' >> /mnt/sda1/tce/onboot.lst
#sudo sh /usr/local/tce.installed/oracle

unlink oracle.tcz
sudo reboot
``` 

验证是否加载oracle动态库
```bash
cat /etc/ld.so.conf | grep oracle
```

### 5.4 开启oci8、pdo_oci扩展
```bash
tce-load -wi libaio

sudo sed -i 's|^;extension=oci8|extension=oci8|g' /usr/local/etc/php7/php.ini
sudo sed -i 's|^;extension=pdo_oci|extension=pdo_oci|g' /usr/local/etc/php7/php.ini

php -m | grep oci8
php -m | grep PDO_OCI
```


参考 [linux下安装php扩展pdo_oci和oci8](https://www.cnblogs.com/tanghu/p/10396154.html)


## 6. 配置httpd支持php

`sudo vi /usr/local/etc/httpd/httpd.conf`，在文件的末尾追加：
```text
LoadModule php7_module modules/mod_php7.so
AddType application/x-httpd-php .php
```

重启httpd服务：
```bash
sudo /usr/local/etc/init.d/httpd stop
sudo /usr/local/etc/init.d/httpd start
```

添加测试脚本，`sudo vi /usr/local/apache2/htdocs/index.php`，添加内容：
```php
<?php phpinfo();
```

访问页面index.php， 打开浏览器，使用 http://IP:8080/index.php 地址浏览，可以看到经典的PHP info详情，说明已经配置完毕。


# 五、安装phpMyAdmin

## 1.下载安装包

```bash
cd /home/tc
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.tar.gz
tar zxvf phpMyAdmin-5.2.1-all-languages.tar.gz
sudo mv phpMyAdmin-5.2.1-all-languages /usr/local/html/phpmyadmin
sudo chown -R tc:staff /usr/local/html/phpmyadmin

cd /usr/local/html/phpmyadmin/
sudo mkdir -p tmp
sudo chmod 777 tmp
sudo cp config.sample.inc.php config.inc.php
unlink /home/tc/phpMyAdmin-*.tar.gz
```

## 2. 添加httpd配置

修改httpd配置，`sudo vi /usr/local/etc/httpd/httpd.conf`，末尾添加如下内容：
```text
Include /usr/local/etc/httpd/conf.d/*.conf
```

添加httpd配置文件，`sudo vi /usr/local/etc/httpd/conf.d/phpmyadmin.conf`
```text
<Directory "/usr/local/html/phpmyadmin">
     DirectoryIndex index.php index.html
     #Options Indexes FollowSymLinks
     AllowOverride None
     Require all granted
</Directory>

<VirtualHost *:8080>
    ServerAdmin webmaster@dummy-host.example.com
    DocumentRoot "/usr/local/html/phpmyadmin"
    ServerName test.phpmydmin.com
    ServerAlias test.phpmydmin.com
</VirtualHost>
```

重启服务：
```bash
sudo /usr/local/etc/init.d/httpd restart
```

打开浏览器，使用 http://IP:8080/index.php 地址浏览，刷新页面，可以看到进入了phpMyAdmin登录页。


## 3. 配置nginx代理转发至httpd

添加nginx配置文件，`sudo vi /usr/local/etc/nginx/conf.d/phpmyadmin.conf`，添加如下内容：
```text
upstream app-lamp{
    server 127.0.0.1:8080 weight=1 max_fails=2 fail_timeout=30s;
}

server {
    listen          80;
    server_name     test.phpmyadmin.com;

    location / {
        root /usr/local/html/phpmyadmin;
        index index.php index.html index.htm;
    }

    #放开前端接口
    location ~ .*\.(php|jsp|cgi)?$ {
        proxy_redirect off;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;

        proxy_pass http://app-lamp;
    }

    location ~.*\.(html|htm|gif|jpg|jpeg|bmp|png|ico|txt|js|css)$ {
        root    /usr/local/html/phpmyadmin;
        expires 3d;
    }

}
```

重载Nginx配置
```bash
sudo /usr/local/etc/init.d/nginx reload
```

修改宿主机hosts文件： C:\Windows\System32\drivers\etc\hosts，添加如下映射：
```text
你的虚拟机IP test.phpmyadmin.com
```

打开浏览器，使用 http://test.phpmyadmin.com 地址浏览，强制刷新页面，可以看到进入了phpMyAdmin登录页，说明Nginx已实现代理转发。

## 4. 验证Nginx转发httpd

监听 httpd 日志：
```bash
tail -f /var/log/access_log
```
打开浏览器，使用 http://test.phpmyadmin.com:8080/index.php 地址浏览， 查看到日志会打印js、css、jpg等资源文件请求。

再使用 http://test.phpmyadmin.com 地址浏览， 查看到日志会打印php的请求路径, 说明Nginx已经实现了静态资源文件的处理。


## 5. 持久化phpMyAdmin

```bash
filetool.sh -b
```

# 六、数据持久化问题

> Tiny Core Linux是加载到内存运行的，所以当文件过多的时候，需要持久化的东西会很多，特别是网站文件与数据库文件容量增大后，就会大量占用内存，会造成内存不足而出现不同的问题。

我们需要考虑将网站与数据库直接存放在硬盘而不是内存中。在Tiny Core Linux中，第一个硬盘会挂载到 /mnt/sda1 ，我们可以直接将网站与数据库的文件夹存放在这个下面，这样就不会占用内存空间了。
如果是全新安装的话，可以在上面安装过程中，网页与数据库直接使用新的 /mnt/sda1/ 中的路径，这样就可以直接将数据放在硬盘，同时网站持久化中 echo “usr/local/html” >> /opt/.filetool.lst 的这一条命令也不再需要执行。

## 1. 网站文件夹迁移：

```bash
sudo mkdir -p /mnt/sda1/www
sudo mv /usr/local/html/phpmyadmin /mnt/sda1/www/phpmyadmin
sudo chown -R tc:staff /mnt/sda1/www/

sudo sed -i 's|/usr/local/html|/mnt/sda1/www|g' /usr/local/etc/nginx/conf.d/phpmyadmin.conf
sudo sed -i 's|/usr/local/html|/mnt/sda1/www|g' /usr/local/etc/httpd/conf.d/phpmyadmin.conf

sudo /usr/local/etc/init.d/nginx reload
sudo /usr/local/etc/init.d/httpd restart

#删除备份目录
sudo sed -i 's|/usr/local/html||g' /opt/.filetool.lst
filetool.sh -b
```

## 2. 数据库迁移
```bash
sudo /usr/local/etc/init.d/mysql stop

sudo mv /home/tc/mysql /mnt/sda1/mysql
sudo chown -R tc:staff /mnt/sda1/mysql/

sudo sed -i 's|home/tc|mnt/sda1|g' /usr/local/etc/mysql/my.cnf
sudo /usr/local/etc/init.d/mysql start
```


# 七、参考资料

- [轻量化Tiny Core Linux硬盘安装nginx+php+mysql](https://www.ssdlsoft.com/other/144)
- [LNAMP(Linux+Nginx+Apache+Mysql+PHP)高性能架构配置实战版](https://blog.51cto.com/hao360/1652709)

# 八、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->tinycore-14.0-lnamp](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Ftinycore-14.0-lnamp)
