---
title: CentOS7.X 安装 MySQL 5.7.X
date: 2023-12-27 19:01:19
categories: ['OS', 'Linux', 'CentOS', 'MySQL']
tags: ['CentOS', 'CentOS7.X', 'Linux', 'MySQL']
---

# 一、查看系统版本

```bash
[root@centos7-64-mini /]# cat /etc/redhat-release 
CentOS Linux release 7.9.2009 (Core)
```


# 二、卸载Mariadb

CentOS7中默认安装有MariaDB，这个是MySQL的分支。卸载自带 Mariadb 数据库：
```bash
#rpm -qa | grep mysql | xargs rpm -e --nodeps
rpm -qa | grep mariadb | xargs rpm -e --nodeps
unlink /etc/my.cnf
```

# 三、下载rpm包

前往 [MySQL Community Downloads](https://dev.mysql.com/downloads/mysql/) 下载RPM文件 或 执行如下命令：

```bash
cd /usr/local/src/

wget https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-community-common-5.7.44-1.el7.x86_64.rpm
wget https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-community-libs-5.7.44-1.el7.x86_64.rpm
wget https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-community-client-5.7.44-1.el7.x86_64.rpm
wget https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-community-server-5.7.44-1.el7.x86_64.rpm
```

# 四、安装rpm包

```bash
cd /usr/local/src/
rpm -ivh mysql-community-common-5.7.44-1.el7.x86_64.rpm
rpm -ivh mysql-community-libs-5.7.44-1.el7.x86_64.rpm
rpm -ivh mysql-community-client-5.7.44-1.el7.x86_64.rpm
rpm -ivh mysql-community-server-5.7.44-1.el7.x86_64.rpm
```

# 五、查看安装版本
```bash
[root@centos7-64-mini /]# mysqld --verbose --version
mysqld  Ver 5.7.44 for Linux on x86_64 (MySQL Community Server (GPL))
```

# 六、启动MySQL
```bash
systemctl enable mysqld.service
systemctl start mysqld.service
systemctl status mysqld.service
```

# 七、修改root密码

```bash
#查看原始密码
[root@centos7-64-mini /]# grep "password" /var/log/mysqld.log
2023-12-27T08:11:38.478562Z 1 [Note] A temporary password is generated for root@localhost: JGZdu3Juz9;I

#登录MySQL
mysql -uroot -p'原始密码'
```

修改密码：
```sql
set global validate_password_policy=LOW;
ALTER USER 'root'@'localhost' IDENTIFIED BY '你的新密码';
```


# 八、添加可外部连接用户
```sql
set global validate_password_policy=LOW;
CREATE USER 'root'@'%' IDENTIFIED BY 'root1234';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root1234' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

# 九、数据库初始化

## 查看datadir目录:
```bash
[root@centos7-64-mini /]# cat /etc/my.cnf | grep datadir
datadir=/var/lib/mysql
```

## 初始化数据库

```bash
rm -rf /var/lib/mysql/*
mysqld --initialize --console
chown -R mysql:mysql /var/lib/mysql/

service mysqld start

#找出root用户的密码
grep "password" /var/log/mysqld.log

mysql -uroot -p'原始密码'
```

## 修改密码
```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY '你的新密码';
```

# 十、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->centos7.x-mysql5.7.x](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2Fsharelink2076919717-858150382706250%2Ffiles%2Fcentos7.x-mysql5.7.x)
