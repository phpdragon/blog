---
title: CentOS 6.X下搭建LAMP服务器
date: 2023-11-16 21:43:49
tags:
---

# 一、系统版本

> 安装LNMP请查看：[CentOS 6.X下搭建LNMP服务器](https://phpdragon.github.io/blog/2023/11/16/centos6-lnmp/)
> 
> 当前系统基于博文安装：[虚拟机最小化安装CentOS 6.X系统](https://phpdragon.github.io/blog/2023/11/16/vmwareBuildSmallCentOS6x/)

查看系统版本
```text
[root@localhost ~]# uname -a
Linux centos-6 2.6.32-71.29.1.el6.x86_64 #1 SMP Mon Jun 27 19:49:27 BST 2011 x86_64 x86_64 x86_64 GNU/Linux
```

当前系统版本基于CentOS 6.0。


# 二、准备工作
1. 修改selinux配置文件(/etc/sysconfig/selinux)关闭selinux

```shell
sed -i 's|^SELINUX=enforcing|SELINUX=disabled|g' /etc/selinux/config
```
2. 修改防火墙开放80、3306端口号，配置文件(/etc/sysconfig/iptables) 

```sehll
echo '' >> /etc/sysconfig/iptables
echo '-A INPUT -p tcp -m state --state NEW -m tcp --dport 3306 -j ACCEPT' >> /etc/sysconfig/iptables
echo '-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT' >> /etc/sysconfig/iptables
```

---------------

# 三、搭建LAMP

## 1、安装MySQL

### 1.1 安装、设置启动项目、启动服务
```shell
yum -y install mysql mysql-devel mysql-server

chkconfig --levels 235 mysqld on   #设置随机启动
chkconfig mysqld off               #关闭随机启动

service mysqld start               #启动
service mysqld restart             #重启
service mysqld status              #查看状态
service mysqld stop                #停止
```
### 1.2 修改mysql密码
```shell
mysql_secure_installation
```
回显如下：
```text
NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MySQL
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!


In order to log into MySQL to secure it, we'll need the current
password for the root user.  If you've just installed MySQL, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

Enter current password for root (enter for none): 
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MySQL
root user without the proper authorisation.

Set root password? [Y/n] y
New password: 
Re-enter new password: 
Password updated successfully!
Reloading privilege tables..
 ... Success!


By default, a MySQL installation has an anonymous user, allowing anyone
to log into MySQL without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] y
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] n
 ... skipping.

By default, MySQL comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] n
 ... skipping.

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] y
 ... Success!

Cleaning up...



All done!  If you've completed all of the above steps, your MySQL
installation should now be secure.

Thanks for using MySQL!
```

### 1.3 登录MySQL

执行如下命令，返回数据库列表则表明安装成功
```shell
mysql -hlocalhost -uroot -p -e 'show databases;'     #输入密码,修改成功则显示数据库列表
```

---------------

## 2、安装Apache

### 2.1 安装、设置随机启动、启动服务

```shell
yum -y install httpd              #yum安装

chkconfig --levels 235 httpd on   #设置随机启动
chkconfig httpd off               #关闭随机启动

service httpd start               #启动
service httpd restart             #重启
service httpd status              #查看状态
service httpd stop                #停止
```

编辑/etc/httpd/conf/httpd.conf：
```
#ServerName www.example.com:80
ServerName localhost:80
```
重启消除如下警告：
```text
[root@centos-6 ~]# service httpd start 
Starting httpd: httpd: apr_sockaddr_info_get() failed for centos-6
httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1 for ServerName
                                                           [  OK  ]
```


### 2.2 访问测试页

访问网页 http://客户机IP ,
{% asset_img 1.png 访问测试页 %}

---------------

## 3、安装PHP5

### 3.1 YUM安装

执行命令

```shell
yum -y install php php-devel

service httpd restart          #重启httpd
```


### 3.2 添加测试代码

写入脚本
```shell
echo '<?php phpinfo();' > /var/www/html/info.php
```
访问网页，http://192.168.168.142/info.php （请使用客户机ip）
{% asset_img 2.png 添加测试代码 %}

### 3.3 添加PHP5扩展模块

查询当前系统版本支持的模块
```shell
yum search php
```
回显：
```text
[root@centos-6-3 html]# yum search php
Loaded plugins: fastestmirror, presto, security
Loading mirror speeds from cached hostfile
============================================================== N/S Matched: php ===============================================================
cups-php.x86_64 : Common Unix Printing System - php module
graphviz-php.x86_64 : PHP extension for graphviz
php.x86_64 : PHP scripting language for creating dynamic web sites
php-bcmath.x86_64 : A module for PHP applications for using the bcmath library
php-cli.x86_64 : Command-line interface for PHP
php-common.x86_64 : Common files for PHP
php-dba.x86_64 : A database abstraction layer module for PHP applications
php-devel.x86_64 : Files needed for building PHP extensions
php-embedded.x86_64 : PHP library for embedding in applications
php-gd.x86_64 : A module for PHP applications for using the gd graphics library
php-imap.x86_64 : A module for PHP applications that use IMAP
php-intl.x86_64 : Internationalization extension for PHP applications
php-ldap.x86_64 : A module for PHP applications that use LDAP
php-mbstring.x86_64 : A module for PHP applications which need multi-byte string handling
php-mysql.x86_64 : A module for PHP applications that use MySQL databases
php-odbc.x86_64 : A module for PHP applications that use ODBC databases
php-pdo.x86_64 : A database access abstraction module for PHP applications
php-pear.noarch : PHP Extension and Application Repository framework
php-pecl-apc.x86_64 : APC caches and optimizes PHP intermediate code
php-pgsql.x86_64 : A PostgreSQL database module for PHP
php-process.x86_64 : Modules for PHP script using system process interfaces
php-pspell.x86_64 : A module for PHP applications for using pspell interfaces
php-recode.x86_64 : A module for PHP applications for using the recode library
php-snmp.x86_64 : A module for PHP applications that query SNMP-managed devices
php-soap.x86_64 : A module for PHP applications that use the SOAP protocol
php-tidy.x86_64 : Standard PHP module provides tidy library support
php-xml.x86_64 : A module for PHP applications which use XML
php-xmlrpc.x86_64 : A module for PHP applications which use the XML-RPC protocol
php-zts.x86_64 : Thread-safe PHP interpreter for use with the Apache HTTP Server
rrdtool-php.x86_64 : PHP RRDtool bindings
uuid-php.x86_64 : PHP support for Universally Unique Identifier library
php-enchant.x86_64 : Human Language and Character Encoding Support
php-pecl-apc-devel.x86_64 : APC developer files (header)
php-pecl-memcache.x86_64 : Extension to work with the Memcached caching daemon

  Name and summary matches only, use "search all" for everything.
```

### 3.4 安装MySQL等模块

执行命令
```shell
yum -y install php-mysql php-gd php-imap php-ldap php-mbstring
yum -y install php-odbc php-pear php-xml php-xmlrpc

service httpd restart    #重启httpd
```


访问测试页 http://192.168.168.142/info.php ，查验是否已正确安装新模块：
{% asset_img 3.png 访问测试页 %}


### 3.5 设置PHP时区

```shell
vi /etc/php.ini

#设置时区为上海
data.timezone = Asia/Shanghai
```


## 4、安装phpMyAdmin

### 4.1 下载安装包

首先前往官方网站下载：[phpMyAdmin-4.0.3-all-languages.zip](https://files.phpmyadmin.net/phpMyAdmin/4.0.3/phpMyAdmin-4.0.3-all-languages.zip)，然后上传解压到/usr/share/目录下
```shell
wget https://files.phpmyadmin.net/phpMyAdmin/4.0.3/phpMyAdmin-4.0.3-all-languages.zip
unzip phpMyAdmin-4.0.3-all-languages.zip
mv phpMyAdmin-4.0.3-all-languages /usr/share/phpmyadmin
```

### 4.2 配置httpd alias

编辑配置文件，vi /etc/httpd/conf.d/phpmyadmin.conf，内容如下：

```text
#
#   Web application to manage llySQL
#
#<Directory "/usr/share/phpmyadmin”
#   Order Deny,Allow
#   Deny from all
#   Allow from 127.0.0.1
#</Directory>

Alias /phpmyadmin /usr/share/phpmyadmin
Alias /phplyAdmin /usr/share/phpmyadmin
Alias /mysqladmin /usr/share/phpmyadmin
```

重启httpd
```shell
service httpd restart
```


### 4.3 配置phpMyAdmin
```shell
cp /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php
vi /usr/share/phpmyadmin/config.inc.php
```


### 4.4 访问phpmyadmin
访问管理地址 http://192.168.168.142/phpmyadmin/ : 
{% asset_img 4.png 访问phpmyadmin %}

## 5、安装php-mcrypt扩展

### 5.1 安装mcrypt类库

#### 5.1.1. 前期准备
下载 [libmcrypt-2.5.8.tar.gz](http://nchc.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz)
并上传至/usr/local/src目录下

前往官网 [www.php.net](https://www.php.net/releases/) 下载PHP源码包 [php-5.3.3.tar.gz](http://museum.php.net/php5/php-5.3.3.tar.gz)


#### 5.1.2. 安装libmcrypt

```sell
cd /usr/local/src
wget http://nchc.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz
tar zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
./configure
make -j64 && make install                  #这里的64对应你的CPU核心倍数，加快编译
```

#### 5.1.3. phpize安装mcrypt

```shell
yum -y install php-devel                   #安装phpize命令

cd /usr/local/src
wget http://museum.php.net/php5/php-5.3.3.tar.gz
tar zxvf php-5.3.3.tar.gz
cd php-5.3.3/ext/mcrypt
phpize
./configure
make -j64 && make install                  #这里的32对应你的CPU核心倍数，加快编译


vi /etc/php.d/mcrypt.ini
    #加入内容
    ; Enable mcrypt extension module
    extension=mcrypt.so

service httpd restart                      #重启服务
```


#### 5.1.4. 查看mcrypt扩展是否安装成功

命令方式
```text
[root@centos-6-3 modules]# php -m | grep mcrypt
mcrypt
```
或访问网页查看: http://192.168.168.142/info.php

------------



## 6、安装php-redis扩展

### 6.1 下载源码包

官网下载链接： https://pecl.php.net/package/redis

下载 [redis-4.3.0.tgz](https://pecl.php.net/get/redis-4.3.0.tgz) (php5.3.3最高支持版本) 到/usr/local/src目录


### 6.2 安装扩展
```shell
cd /usr/local/src                 #进入软件包存放目录
wget https://pecl.php.net/get/redis-4.3.0.tgz
tar xvf redis-4.3.0.tar.gz       #解压
cd redis-4.3.0                    #进入安装目录

phpize
./configure
make -j64 && make install         #这里的8对应你的CPU核心，加快编译
```

安装完成之后，出现下面的安装路径:
```text
[root@centos-6-3 phpredis-2.2.4]# make install
Installing shared extensions:     /usr/lib64/php/modules/
```

### 6.3 配置php支持redis扩展
```shell
vi /etc/php.d/redis.ini               #编辑配置文件，在最后一行添加以下内容

#添加下面内容
; Enable redis extension module
extension=redis.so

#重启
service httpd restart
```



### 6.4 观察效果

```text
[root@centos-6-3 modules]# php -m | grep redis
redis
```
或访问网页查看: http://192.168.168.142/info.php （请使用客户机ip）


## 7、PHP新增拓展通用方法

> Linux下PHP已经编译，如何再为PHP增加新的扩展呢？
> 
> 可以通过PHP自带的phpize命令, 如我的phpize在/usr/bin/phpize


### 7.1 官网下载源码包

到软件的官方或 [pecl.php.net](https://pecl.php.net) 去下载源码包, 上传至/usr/local/src目录

### 7.2 解压并进入到解压后的目录

```shell
tar zxvf *.tar.gz
cd 扩展目录
```

### 7.3 执行 phpize

根据当前php版本动态的创建扩展的configure文件

```shell
phpize
```

### 7.4 执行 ./configure

用生成的configure文件执行
```shell
./configure
```

### 7.5 编译并安装
```shell
make -j64 && make install           #这里的64对应你的CPU核心，加快编译
```


### 7.6 加载 .so 文件


查看扩展安装目录
```shell
php -i | grep extension_dir | grep lib64
```
回显:
```text
[root@centos-6-3 ~]# php -i | grep extension_dir | grep lib64
extension_dir => /usr/lib64/php/modules => /usr/lib64/php/modules
```

添加扩展 vi /etc/php.ini (php.ini路径可以通过命令[ php -i | grep 'Loaded Configuration' ] 获得)
```text
; Enable 扩展名称 extension module
extension=/usr/lib64/php/modules/扩展名称.so
```

如果有 /etc/php.d 目录，则生成 /etc/php.d/扩展名称.ini 文件, 写入如下内容：
```text
; Enable 扩展名称 extension module
extension=扩展.so
```

### 7.7 重启httpd、php-fpm

```shell
service httpd restart
system restatrt httpd
```

-----------


# 四、参考

[linux编译安装时常见错误解决办法](https://blog.csdn.net/m0_38004619/article/details/88598702)

[LSWS PHP/LSAPI Build troubleshooting guide (Archive Only)](https://www.litespeedtech.com/support/wiki/doku.php/archive:php:lsapi-troubleshooting)

[PHP编译安装时常见错误解决办法，PHP编译常见错误](https://www.jianshu.com/p/075e8e035bf5)

[# 源码编译安装php出现的错误汇总](https://www.cnbugs.com/post-1285.html)

[centos 安装 libmcrypt](https://blog.csdn.net/nianyixiaotian/article/details/82706927)

[Linux下php安装mcrypt扩展](https://blog.csdn.net/ichen820/article/details/114693310)

[PHP新增扩展方法](https://www.php.cn/faq/476567.html)


# 五、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->juejin->7300592516759044147](https://pan.baidu.com/s/1PilxMDxpeAbL92M6zJnFtA?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Fjuejin%2F7300592516759044147)