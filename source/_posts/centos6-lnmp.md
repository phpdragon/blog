---
title: CentOS 6.X下搭建LNMP服务器
date: 2023-11-16 21:55:58
categories: ['OS', 'Linux', 'CentOS', 'LNMP']
tags: ['CentOs', 'CentOS6.X', 'Linux', 'Nginx', 'PHP', 'MySQL']
---

# 一、系统版本

> 安装LAMP请查看：[CentOS 6.X下搭建LAMP服务器](/blog/2023/11/16/centos6-lamp/)
> 
> 当前系统基于博文安装：[虚拟机最小化安装CentOS 6.X系统](/blog/2023/11/16/vmware-build-small-centos-6x/)

查看系统版本
```text
[root@localhost ~]# uname -a
Linux centos-6 2.6.32-71.29.1.el6.x86_64 #1 SMP Mon Jun 27 19:49:27 BST 2011 x86_64 x86_64 x86_64 GNU/Linux
```

当前系统版本基于CentOS 6.0。



# 二、准备工作

## 1. 关闭SELINUX
修改selinux配置文件(/etc/sysconfig/selinux) 关闭防火墙

```bash
sed -i 's|^SELINUX=enforcing|SELINUX=disabled|g' /etc/selinux/config
```
## 2. 开放80、3306端口
修改防火墙开放80、3306端口号，配置文件(/etc/sysconfig/iptables) 

```sehll
echo '' >> /etc/sysconfig/iptables
echo '-A INPUT -p tcp -m state --state NEW -m tcp --dport 3306 -j ACCEPT' >> /etc/sysconfig/iptables
echo '-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT' >> /etc/sysconfig/iptables
```

## 3. 添加用户mysql、nginx、php
```bash
groupadd www
useradd mysql -g www -s /sbin/nologin -M
useradd nginx -g www -s /sbin/nologin -M
useradd php -g www -s /sbin/nologin -M
```

---------------


# 三、搭建LAMP

## 1、安装MySQL-5.5.60

> 为何不使用yum安装？
> 
> CentOS 6系列已经不维护了，很多软件没法升级。yum安装的版本是5.1.52，有些配件如phpMyAdmin需要更高的版本。
> 
> 手动编译mysql的最后安装路径也是可以和yum安装的路径一致的。
> 主要根据编译参数 -DCMAKE_INSTALL_PREFIX=/usr 来覆盖，同时可以根据当前系统软件环境选择合适兼容的版本。

### 1.1 下载源码包

请往官网下载：[dev.mysql.com](https://dev.mysql.com/downloads/mysql/), 选择版本，选择操作系统类型:Linux -Generic，选择系统版本：Linux - Generic(glibc 2.12)(x86,64-bit)

{% asset_img 1.png 下载MySQL源码包 %}

或者前往国内阿里云软件源镜像下载：[mysql-5.5.60.tar.gz](https://mirrors.aliyun.com/mysql/MySQL-5.5/mysql-5.5.60.tar.gz)

```bash
cd /usr/local/src
curl -O https://mirrors.aliyun.com/mysql/MySQL-5.5/mysql-5.5.60.tar.gz
```

### 1.2 安装依赖库
```bash
yum -y install ncurses-devel
```

### 1.3 编译参数说明

请查看 [官方说明文档](https://dev.mysql.com/doc/refman/5.7/en/source-configuration-options.html#cmake-installation-layout-options)

```text
#指定mysql的安装路径, 默认/usr/local/mysql
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql
#指向mysql配置文件目录（/etc），文件my.cnf的所在目录
-DSYSCONFDIR=/etc
#指向mysql数据文件目录
-DMYSQL_DATADIR=/var/mysql/data
#指定mysql进程监听套接字文件（数据库连接文件）的存储路径，默认/tmp/mysql.sock
-DMYSQL_UNIX_ADDR=/tmp/mysql.sock
#mysql-test目录的安装位置。若要禁止安装该目录，请显式将该选项设置为空值(-DINSTALL_MYSQLTESTDIR=)
-DINSTALL_MYSQLTESTDIR=
#指定默认使用的字符集编码，如utf8, 默认latin1
-DDEFAULT_CHARSET=utf8
#设定默认排序规则（utf8_general_ci快速/utf8_unicode_ci准确），默认latin1_swedish_ci
-DDEFAULT_COLLATION=utf8_general_ci
#启用额外的字符集类型（默认为all）
-DWITH_EXTRA_CHARSETS=all
#安装Archive存储引擎
-DWITH_ARCHIVE_STORAGE_ENGINE=1
#安装BLACKHOLE存储引擎
-DWITH_BLACKHOLE_STORAGE_ENGINE=1
#安装EXAMPLE存储引擎
-DWITH_EXAMPLE_STORAGE_ENGINE=1
#安装FEDERATED存储引擎
-DWITH_FEDERATED_STORAGE_ENGINE=1
#安装PARTITION存储引擎
-DWITH_PARTITION_STORAGE_ENGINE=1
#安装HEAP存储引擎
-DWITH_HEAP_STORAGE_ENGINE=1 \
#安装MRG_MYISAM存储引擎
-DWITH_MRG_MYISAM_STORAGE_ENGINE=1 \
#安装PERFORMANCE_SCHEMA存储引擎
-DWITH_PERFSCHEMA_STORAGE_ENGINE=1 \
#启用本地数据导入支持
-DENABLED_LOCAL_INFILE=1
#启用readline库支持（提供可编辑的命令行）
-DWITH_READLINE=1
#启用ssl库支持（安全套接层）,默认system, 
#yes：使用系统OpenSSL库(如果有的话)，否则使用与发行版捆绑的库。
#system: 使用系统OpenSSL库。这是MySQL 5.7.28的默认设置。
-DWITH_SSL=yes
#生成便于systemctl管理的文件，如果启用会安装systemd支持文件，不安装mysqld_safe和System V初始化脚本等脚本，默认禁用。 Centos6系列不支持
-DWITH_SYSTEMD=1
#指定进程文件的存储路径, 默认/var/run/mysqld，Centos7系列支持
-DSYSTEMD_PID_DIR=/var/run/mysqld
#使用mysql用户
-DMYSQL_USER=mysql
#使用3306端口
-DMYSQL_TCP_PORT=3306
#关于编译环境的描述性注释
-DWITH_COMMENT='Use CentOS 6.0 86_64 build'
```

参考：

[# mysql源码编译常见参数解释](https://www.python100.com/html/16823.html#MySQL%20cmake%E7%BC%96%E8%AF%91%E6%97%B6%E8%BF%99%E4%BA%9B%E5%8F%82%E6%95%B0%E6%98%AF%E4%BB%80%E4%B9%88%E6%84%8F%E6%80%9D)


### 1.4 编译MySQL
```bash
cd /usr/local/src
curl -O https://mirrors.aliyun.com/mysql/MySQL-5.5/mysql-5.5.60.tar.gz
tar zxvf mysql-5.5.60.tar.gz
cd mysql-5.5.60

cmake \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DSYSCONFDIR=/etc \
-DMYSQL_DATADIR=/var/mysql/data \
-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
-DINSTALL_MYSQLTESTDIR= \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EXTRA_CHARSETS=all \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_EXAMPLE_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITH_HEAP_STORAGE_ENGINE=1 \
-DWITH_MRG_MYISAM_STORAGE_ENGINE=1 \
-DWITH_PERFSCHEMA_STORAGE_ENGINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_READLINE=1 \
-DWITH_SSL=yes \
-DMYSQL_USER=mysql \
-DMYSQL_TCP_PORT=3306 \
-DWITH_COMMENT='Use CentOS 6.0 86_64 build'

make
make install
```

### 1.5 设置启动项
```bash
#数据库设置初始化
unlink /etc/my.cnf
cp /usr/local/mysql/support-files/my-small.cnf /etc/my.cnf
chown mysql:www /etc/my.cnf

#数据库文件初始化
cd /usr/local/mysql/scripts/
chmod +x ./mysql_install_db
./mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/var/mysql/data

cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod 755 /etc/init.d/mysqld
#设置随机启动
chkconfig --levels 235 mysqld on
#关闭随机启动
chkconfig mysqld off
```


### 1.6 创建数据目录、环境变量
```bash
mkdir -p /var/mysql/data
chown -R mysql:www /var/mysql/data

echo '' >> /etc/profile
echo 'export PATH=/usr/local/mysql/bin:$PATH' >> /etc/profile
source /etc/profile
```


### 1.7 启动服务、修改密码
```bash
service mysqld start               #启动
service mysqld restart             #重启
service mysqld status              #查看状态
service mysqld stop                #停止

# 修改密码
mysqladmin -u root password 你的密码
# 或者
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

### 1.8 登录MySQL

执行如下命令，返回数据库列表则表明安装成功
```bash
mysql -hlocalhost -uroot -p -e 'show databases;'     #输入密码,修改成功则显示数据库列表

#查询版本
mysql -hlocalhost -uroot -p -sN -e 'select version();'
#或
mysql -V
```

文章参考：

- [Centos7下源码编译安装mysql](https://www.cnblogs.com/aaron911/p/8370575.html)
- [CentOS5.5下编译安装Mysql5.5](https://www.cnblogs.com/huake/p/3469986.html)
- [Centos7下源码编译安装mysql](https://blog.csdn.net/huz1Vn/article/details/130976885)


---------------


## 2、安装Nginx-1.25.0
> 为何不用yum安装？
> 
> CentOS 6系列已经不维护了，很多软件没法升级。
> 
> yum安装的nginx依赖openssl版本要么当前系统版本低，要么手动安装的openssl版本过高不兼容。
> 
> 手动编译nginx的最后安装路径也是可以和yum安装的路径一致的。
> 
> 主要根据编译参数 --prefix=/usr 来覆盖，同时可以根据当前系统软件环境选择合适兼容的版本。

### 2.1 下载源码包

下载地址[nginx.org](http://nginx.org/en/download.html), 下载 [nginx-1.25.0.tar.gz](https://nginx.org/download/nginx-1.25.0.tar.gz)：

```bash
cd /usr/local/src
wget https://nginx.org/download/nginx-1.25.0.tar.gz
```

### 2.2 安装依赖库
```bash
yum -y install gcc gcc-c++ autoconf automake make
yum -y install pcre pcre-devel
yum -y install zlib zlib-devel make libtool
yum -y install openssl openssl-devel

yum -y install libxml2-devel libxslt-devel gd gd-devel perl-devel perl-ExtUtils-Embed
```

### 2.3 编译Nginx

```bash
cd /usr/local/src
tar zxvf nginx-1.25.0.tar.gz
cd nginx-1.25.0

./configure \
--prefix=/usr/local/nginx \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--http-client-body-temp-path=/var/tmp/nginx/client_body \
--http-proxy-temp-path=/var/tmp/nginx/proxy \
--http-fastcgi-temp-path=/var/tmp/nginx/fastcgi \
--http-uwsgi-temp-path=/var/tmp/nginx/uwsgi \
--http-scgi-temp-path=/var/tmp/nginx/scgi \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/lock/subsys/nginx.lock \
--with-compat \
--with-debug \
--with-file-aio \
--with-http_addition_module \
--with-http_auth_request_module \
--with-http_dav_module \
--with-http_degradation_module \
--with-http_flv_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_image_filter_module=dynamic \
--with-http_mp4_module \
--with-http_perl_module=dynamic \
--with-http_random_index_module \
--with-http_realip_module \
--with-http_secure_link_module \
--with-http_slice_module \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_sub_module \
--with-http_v2_module \
--with-http_xslt_module=dynamic \
--with-mail=dynamic \
--with-mail_ssl_module \
--with-pcre \
--with-pcre-jit \
--with-stream=dynamic \
--with-stream_ssl_module \
--with-stream_ssl_preread_module \
--with-threads \
--user=nginx \
--group=www

make -j64 && make install
```


### 2.4 设置启动项

编写引导启动脚本 `vi /etc/init.d/nginx` , 内容如下：
```text
#!/bin/bash
### BEGIN INIT INFO
# Provides:          nginx
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts nginx
# Description:       starts the nginx Process Manager daemon
### END INIT INFO

source /etc/profile

ngxc="nginx"
pidf="/var/run/nginx.pid"

case "$1" in
    start)
        if [ ! -f "${pidf}" ]; then
            $ngxc -t &> /dev/null
            if [ $? -eq 0 ];then
                $ngxc
                echo "nginx service start success!"
                $0 status
            else
                echo "nginx configuration file test fail!"
            fi
        else
            nginx_pid=$(cat $pidf)
            if [ ""x != "${nginx_pid}"x ]; then
                $0 status
            else
                $ngxc
                echo "nginx service start success!"
                $0 status
            fi
        fi
    ;;
    stop)
        if [ -f "${pidf}" ]; then
            nginx_pid=$(cat $pidf)
            if [ ""x != "${nginx_pid}"x ]; then
                kill -INT $(cat $pidf)
                echo "nginx service stop success!"
            else
                echo "nginx service is stop"
            fi
        else
            echo "nginx service is stop"
        fi
    ;;
    restart)
        $0 stop
        $0 start
    ;;
    status)
        if [ -f "${pidf}" ]; then
            nginx_pid=$(cat $pidf)
            if [ ""x != "${nginx_pid}"x ]; then
                echo "nginx (pid ${nginx_pid}) is running..."
            else
                echo "nginx service is stop"
            fi
        else
            echo "nginx service is stop"
        fi
    ;;
    reload)
        $ngxc -t &> /dev/null
        if [ $? -eq 0 ];then
            nginx_pid=$(cat $pidf)
            if [ ""x != "${nginx_pid}"x ]; then
                $ngxc -s reload
                echo "reload nginx config success!"
            else
                echo "nginx service is stop, reload fail!"
            fi
        else
            $ngxc -t
        fi
    ;;
    *)
    echo "please input stop|start|restart|reload|status."
    exit 1
esac
```

添加随机启动
```bash
chmod +x /etc/init.d/nginx

chkconfig --add nginx           #添加启动项
chkconfig --del nginx           #删除启动项
chkconfig --list | grep nginx   #查看启动项
```

### 2.5 创建运行目录、环境变量：
```bash
mkdir -p /etc/nginx/conf.d /var/log/nginx/ /var/tmp/nginx/
chown -R nginx:www /etc/nginx /var/log/nginx/ /var/tmp/nginx/

echo '' >> /etc/profile
echo 'export PATH=/usr/local/nginx/sbin:$PATH' >> /etc/profile
source /etc/profile
```

### 2.6 配置Nginx

```bash
#备份配置文件
cp /etc/nginx/nginx.conf{,.bak}

vim /etc/nginx/nginx.conf
```
在 http{ } 结构内的最末尾追加一行配置
```text
    include conf.d/*.conf;
```

如下图：
{% asset_img 2.png 编辑nginx.conf %}

### 2.7 启动Nginx

```bash
#查看配置是否正确
nginx -t

#启动nginx
service nginx start

service nginx status            #查看进程状态
service nginx reload            #重置配置
service nginx restart           #重启
service nginx stop              #停止

#查看端口监听
ss -antu | grep 80 | column -t
```
访问 http://客户机IP/index.html
{% asset_img 3.png Welcome to nginx！ %}


### 2.8 参考博文

- [一文搞定nginx 从安装到高可用](https://zhuanlan.zhihu.com/p/620406883)
- [在 Linux 下源码编译安装 nginx](https://www.cnblogs.com/inslog/p/17584550.html)
- [CentOS 6/7 下使用yum安装nginx](http://blog.sway.com.cn/?p=412)


------------------

## 3、安装PHP-5.3.3

> 为何不使用yum安装？
> 
> 从5.3.3版本才开始支持php-fpm功能，Nginx只支持端口模式或套接字文件模式(推荐)。
> 
> 同时CentOS 6.0版本yum安装版是5.3.2, 也不再支持升级到其他版本了。

### 3.1 下载源码包

到官方 [php.net](https://www.php.net/releases/) 去下载源码包, 上传至/usr/local/src目录
```bash
cd /usr/local/src
wget http://museum.php.net/php5/php-5.3.3.tar.gz
```

### 3.2 安装依赖库
```bash
yum -y install libevent-devel libxml2-devel bzip2-devel libxslt-devel
yum -y install libpng-devel libjpeg-devel gd gd-devel
```

> 因为当前php-5.3.3版本查找动态链接库的路径是PREFIX/lib, PREFIX指的是依赖库的安装根目录,由依赖库的编译参数--prefix设置)， lib 是写死的。
> 
> 所以如果编译时要使用--with-openssl=/usr参数增加openssl扩展，
>
> 那么请添加 libssl.so 动态库文件的软链接至 /usr/lib 目录下，只限定当前PHP版本，可能高版本会修复吧。
>
> 同理: --with-jpeg=/usr、--with-png=/usr、--with-gd=/usr 

```bash
ln -s /usr/lib64/libssl.so /usr/lib/


#修复jpeg、png 找不到动态链接库问题
ln -s /usr/lib64/libjpeg.so /usr/lib/
ln -s /usr/lib64/libpng.so /usr/lib/
ln -s /usr/lib64/libgd.so /usr/lib/
```


### 3.3 编译PHP

> PHP不能同时支持httpd模式和PHP-FPM模式，只能二者选一

```text
--enable-fpm                     #以fpm模式安装，两者只能取其一
--with-apxs2=/usr/sbin/apxs      #生成libphp5.so来支持httpd解码php，两者只能取其一
```

设置编译参数
```bash
cd /usr/local/src
tar zxvf php-5.3.3.tar.gz
cd php-5.3.3

./configure \
--prefix=/usr/local/php \
--with-config-file-scan-dir=/usr/local/php/etc/php.d \
--with-config-file-path=/usr/local/php/etc/ \
--enable-mbstring \
--enable-xml \
--enable-sockets \
--with-mysql=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-freetype-dir \
--with-jpeg-dir=/usr \
--with-png-dir=/usr \
--with-gd=/usr \
--enable-gd-native-ttf \
--with-zlib \
--with-libxml-dir=/usr \
--with-bz2 \
--disable-rpath \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization \
--with-curl \
--enable-mbregex \
--with-mhash \
--enable-pcntl \
--with-xmlrpc \
--enable-soap \
--enable-short-tags \
--enable-static \
--with-xsl \
--enable-ftp \
--enable-fpm \
--with-fpm-user=php \
--with-fpm-group=www \
--with-openssl=/usr

make -j64 && make install
```


### 3.4 设置启动项

编写引导启动脚本 `vi /etc/init.d/php-fpm` , 内容如下：
```bash
#!/bin/bash
### BEGIN INIT INFO
# Provides:          php-fpm
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts php-fpm
# Description:       starts the PHP FastCGI Process Manager daemon
### END INIT INFO

source /etc/profile

ngxc_fpm="php-fpm"
pidf_fpm="ps aux|grep 'php-fpm'|grep -v grep|grep root|grep Ss|awk '{print \$2}'"

case "$1" in
    start)
        fpm_pid=$(eval "$pidf_fpm")
        if [ ""x != "${fpm_pid}"x ]; then
            echo "php-fpm (pid ${fpm_pid}) is running..."
        else
            $ngxc_fpm
            echo "php-fpm service start success!"
            $0 status
        fi
    ;;
    stop)
        fpm_pid=$(eval "$pidf_fpm")
        if [ ""x != "${fpm_pid}"x ]; then
            kill -INT $(eval $pidf_fpm)
            echo "php-fpm service stop success!"
        else
            echo "php-fpm service stop success!"
        fi
    ;;
    restart)
        $0 stop
        $0 start
    ;;
    status)
        fpm_pid=$(eval "$pidf_fpm")
        if [ ""x != "${fpm_pid}"x ]; then
            echo "php-fpm (pid ${fpm_pid}) is running..."
        else
            echo "php-fpm service is stop"
        fi
    ;;
    reload)
        fpm_pid=$(eval "$pidf_fpm")
        if [ ""x != "${fpm_pid}"x ]; then
            kill -USR2 $(eval "$pidf_fpm")
            echo "reload php-fpm config success!"
            sleep 1
            $0 status
        else
            echo "php-fpm service is stop, reload fail!"
        fi
    ;;
    *)
    echo "please input stop|start|restart|reload|status."
    exit 1
esac
```

添加随机启动
```bash
chmod +x /etc/init.d/php-fpm

chkconfig --add php-fpm           #添加启动项
chkconfig --del php-fpm           #删除启动项
chkconfig --list | grep php-fpm   #查看启动项
```


### 3.5 设置环境变量：
```bash
echo '' >> /etc/profile
echo 'export PATH=/usr/local/php/bin:$PATH' >> /etc/profile
echo 'export PATH=/usr/local/php/sbin:$PATH' >> /etc/profile
source /etc/profile
```


### 3.6 配置PHP-FPM

#### 3.6.1. php-fpm.conf

修改配置文件php-fpm.conf
```text
cd /usr/local/php/etc/
cp php-fpm.conf.default php-fpm.conf

#vi /usr/local/php/etc/php-fpm.conf

    pm.start_servers = 2
    pm.min_spare_servers = 1
    pm.max_spare_servers = 5

:wq
```
即去掉这三行前面的;号也行


#### 3.6.2. php.ini
复制源码包内的配置文件到安装目录下，并改名即可
```bash
cp /usr/local/src/php-5.3.3/php.ini-production /usr/local/php/etc/php.ini
mkdir -p /usr/local/php/etc/php.d
chown -R php:www /usr/local/php
```

#### 3.6.3. 设置时区
```bash
#设置时区为上海
sudo sed -i 's|^;date.timezone =|date.timezone = Asia/Shanghai|g' /usr/local/php/etc/php.ini
```

### 3.7 启动PHP-FPM

```bash
service php-fpm start             #启动
service php-fpm status            #查看进程状态
service php-fpm reload            #重置配置
service php-fpm restart           #重启
service php-fpm stop              #停止

ss -antu | grep 9000 | column -t
```


### 3.8 编写网页并验证

添加测试配置文件 `vi /etc/nginx/conf.d/test.conf` ，内容如下：

```text
server {
    listen          8080;

    location / {
        #根目录
        root /var/www/html;
        #history添加, hash不添加
        try_files $uri $uri/ @router;
        #指向23行的@router
        index index.html;
    }

    #以支持php脚本
    location ~ \.php$ {
        root /var/www/html;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        include        fastcgi.conf;
    }

    #对应11行的@router，主要原因是路由的路径资源并不是一个真实的路径，所以无法找到具体的文件
    #因此需要rewrite到index.html中，然后交给路由在处理请求资源
    location @router {
        rewrite ^.*$ /index.html last;
    }
    
}
```


写入测试脚本
```bash
service nginx reload

mkdir -p /var/www/html
echo '<?php phpinfo();' > /var/www/html/info.php
```
访问网页 http://客户机IP:8080/info.php

测试链接MySQL，

写入如下文件到 `vi /var/www/html/mysql.php`
```text
<?php
$servername = '127.0.0.1';
$username = 'root';
$password = 'root1234';
$dbname = 'mysql';

// 创建连接
$conn = new mysqli($servername, $username, $password, $dbname);

// 检测连接
if ($conn->connect_error) {
  die('fail: ' . $conn->connect_error);
}
echo 'success';
```

访问网页 http://客户机IP:8080/mysql.php


## 4、安装phpMyAdmin

### 4.1 下载安装包

首先前往官方网站下载：[phpMyAdmin-4.0.3-all-languages.zip](https://files.phpmyadmin.net/phpMyAdmin/4.0.3/phpMyAdmin-4.0.3-all-languages.zip)，然后上传解压到/usr/share/目录下
```bash
cd /usr/local/src
wget https://files.phpmyadmin.net/phpMyAdmin/4.0.3/phpMyAdmin-4.0.3-all-languages.zip
unzip phpMyAdmin-4.0.3-all-languages.zip
mv phpMyAdmin-4.0.3-all-languages /usr/share/phpmyadmin
```

### 4.2 配置Nginx

编辑配置文件 `vi /etc/nginx/conf.d/phpmyadmin.conf` ，内容如下：

```text
server {
    listen          8081;

    location / {
        #根目录
        root /usr/share/phpmyadmin;
        #history添加, hash不添加
        try_files $uri $uri/ @router;
        #指向23行的@router
        index index.php;
    }

    #以支持php脚本
    location ~ \.php$ {
        root /usr/share/phpmyadmin;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        include        fastcgi.conf;
    }

    #对应11行的@router，主要原因是路由的路径资源并不是一个真实的路径，所以无法找到具体的文件
    #因此需要rewrite到index.html中，然后交给路由在处理请求资源
    location @router {
        rewrite ^.*$ /index.html last;
    }
}
```

重置nginx配置
```bash
service nginx reload
```


### 4.3 配置phpMyAdmin: 
```bash
cp /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php
vi /usr/share/phpmyadmin/config.inc.php +31    #把localhost改为127.0.0.1
```


### 4.4 访问phpmyadmin

访问管理地址 http://客户机IP:8081 :
{% asset_img 4.png Welcome to 访问phpmyadmin！ %}


## 5、安装php-mcrypt扩展

> 请参考：[安装php-mcrypt扩展](/blog/2023/11/16/centos6-lamp/#5%E3%80%81%E5%AE%89%E8%A3%85php-mcrypt%E6%89%A9%E5%B1%95) 、[PHP新增拓展通用方法](/blog/2023/11/16/centos6-lamp/#7%E3%80%81PHP%E6%96%B0%E5%A2%9E%E6%8B%93%E5%B1%95%E9%80%9A%E7%94%A8%E6%96%B9%E6%B3%95)

### 5.1. 安装libmcrypt库

```bash
cd /usr/local/src
tar zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
./configure
make -j64 && make install
```

### 5.2. 安装mcrypt扩展

```bash
cd /usr/local/src
tar zxvf php-5.3.3.tar.gz
cd php-5.3.3/ext/mcrypt
phpize
./configure
make -j64 && make install
```

### 5.3. 配置mcrypt扩展

```bash
cat > /usr/local/php/etc/php.d/mcrypt.ini <<EOF
; Enable mcrypt extension module
extension=mcrypt.so
EOF
```

验证:
```bash
php -m | grep mcrypt
```

### 5.4. 重载php-fpm
```bash
service php-fpm reload
```


------------


# 四、参考资料

- [LNMP平台搭建-Centos6.x](https://blog.csdn.net/Liang_GaRy/article/details/128410909)
- [CentOS 6, 编译安装lamp (php-fpm)](https://blog.csdn.net/weixin_30727835/article/details/98349275)


# 五、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->centos6-lnmp](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Fcentos6-lnmp)
