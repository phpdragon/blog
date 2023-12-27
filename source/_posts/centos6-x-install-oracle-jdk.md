---
title: CentOS6.x 搭建 Oracle JDK
date: 2023-12-02 19:34:23
categories: ['OS', 'Linux', 'CentOS', 'Oracle', 'JDK']
tags: ['CentOS','CentOS6.X', 'Linux', 'Oracle', 'JDK', 'JAVA']
---


# 一、系统版本

> 当前系统基于博文安装：[虚拟机最小化安装CentOS 6.X系统](/blog/2023/11/16/vmware-build-small-centos-6.x/)

查看系统版本
```text
[root@localhost ~]# uname -a
Linux centos-6 2.6.32-71.el6.x86_64 #1 SMP Fri May 20 03:51:51 BST 2011 x86_64 x86_64 x86_64 GNU/Linux
```

当前系统版本基于CentOS 6.0。

# 三、安装JDK环境

官方下载链接: [Java SE 7 Archive Downloads](https://www.oracle.com/java/technologies/javase/javase7-archive-downloads.html)
64位：jdk-7u71-linux-x64.tar.gz
32位：jdk-7u71-linux-i586.tar.gz

## 方法一、rpm包安装(推荐)

安装rpm包
```bash
cd /usr/local/src
cp /mnt/hgfs/shared-folder/jdk-7u71-linux-x64.rpm ./
rpm -ivh jdk-7u71-linux-x64.rpm
```
在系统环境变量配置文件最后面，添加如下配置：
```bash
cat > /etc/profile.d/java.sh <<EOF 
export JAVA_HOME="/usr/java/default"
export JRE_HOME="\${JAVA_HOME}/jre"
export CLASSPATH=.:\${JAVA_HOME}/lib:\${JRE_HOME}/lib
export PATH=\${JAVA_HOME}/bin:\$PATH
EOF

source  /etc/profile
```


## 方法二、tar.gz包安装

```bash
cd /usr/local/src
cp /mnt/hgfs/shared-folder/jdk-7u71-linux-x64.tar.gz ./

tar zxvf jdk-7u71-linux-x64.tar.gz
mv jdk1.7.0_71 /usr/local/oracle-jdk

cd /usr/local/
ln -s jdk1.7.0_71 oracle-jdk
```
在系统环境变量配置文件最后面，添加如下配置：
```bash
cat > /etc/profile.d/java.sh <<EOF 
export JAVA_HOME="/usr/local/oracle-jdk/"
export JRE_HOME="\${JAVA_HOME}/jre"
export CLASSPATH=.:\${JAVA_HOME}/lib:\${JRE_HOME}/lib
export PATH=\${JAVA_HOME}/bin:\$PATH
EOF

source  /etc/profile
```

## 安装验证：
```bash
java -version
```
回显如下：
```text
java version "1.7.0_71"
Java(TM) SE Runtime Environment (build 1.7.0_71-b14)
Java HotSpot(TM) 64-Bit Server VM (build 24.71-b01, mixed mode)
```
配置生效，JDK已经安装完毕。

