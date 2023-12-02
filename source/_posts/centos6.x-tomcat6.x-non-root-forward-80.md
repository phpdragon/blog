---
title: Centos6.X 下使用 Tomcat-6.X 非root用户 部署 生产环境 端口转发方式
date: 2023-12-02 17:18:29
categories: ['OS', 'Linux', 'CentOS', 'WebServer', 'Tomcat']
tags: ['CentOs','CentOS6.X', 'Linux', 'WebServer', 'Tomcat']
---

# 一、系统版本

> 当前系统基于博文安装：[虚拟机最小化安装CentOS 6.X系统](/blog/2023/11/16/vmware-build-small-centos-6x/)

查看系统版本
```text
[root@localhost ~]# uname -a
Linux centos-6 2.6.32-71.el6.x86_64 #1 SMP Fri May 20 03:51:51 BST 2011 x86_64 x86_64 x86_64 GNU/Linux
```

当前系统版本基于CentOS 6.0。


# 二、准备工作

## 1. 开启SELinux

修改SELinux配置文件(/etc/sysconfig/selinux) 

```bash
sed -i 's|^SELINUX=disabled|SELINUX=enforcing|g' /etc/selinux/config
setenforce 1
```

验证：
```bash
# 查看配置结果
cat /etc/sysconfig/selinux | grep 'SELINUX='

# 查看开启状态
getenforce
```
回显结果是 Enforcing 或者 1 ，表示已经开启SELinux

## 2. 开启防火墙

```bash
service iptables restart
chkconfig --add iptables 
```

验证：
```bash
service iptables status

chkconfig --list | grep iptables
```

## 3. 添加用户tomcat

```bash
groupadd www
useradd tomcat -g www -s /bin/bash
usermod -L tomcat
```
---------------

# 三、安装JDK环境

官方下载链接:
https://www.oracle.com/java/technologies/javase/javase7-archive-downloads.html

64位：jdk-7u71-linux-x64.tar.gz
32位：jdk-7u71-linux-i586.tar.gz

## 方法一、rpm包安装（推荐）

安装rpm包
```bash
cd /usr/local/src
cp /mnt/hgfs/shared-folder/jdk-7u71-linux-x64.rpm ./
rpm -ivh jdk-7u71-linux-x64.rpm
```

## 方法二、tar.gz包安装

```bash
cd /usr/local/src
cp /mnt/hgfs/shared-folder/jdk-7u71-linux-x64.tar.gz ./

tar zxvf jdk-7u71-linux-x64.tar.gz
mv jdk1.7.0_71 /usr/local/oracle-jdk7
```
在系统环境变量配置文件最后面，添加如下配置：
```bash
cat >> /etc/profile <<EOF 

export JAVA_HOME="/usr/local/oracle-jdk7"
export JRE_HOME="\${JAVA_HOME}/jre"
export CLASSPATH=.:\${JAVA_HOME}/lib:\${JRE_HOME}/lib
export PATH=\${JAVA_HOME}/bin:$PATH
EOF

source  /etc/profile
```

验证：
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


# 四、安装Tomcat

前往官网下载： [tomcat archive](https://archive.apache.org/dist/tomcat/), 下载链接[apache-tomcat-6.0.53.tar.gz](https://archive.apache.org/dist/tomcat/tomcat-6/v6.0.53/bin/apache-tomcat-6.0.53.tar.gz)

## 1. 解压tar包安装

上传下载好的tomcat包，解压并拷贝到你需要安装的目录下，同时新建软链接指向tomcat目录。
```bash
cd /usr/local/src
cp /mnt/hgfs/shared-folder/apache-tomcat-6.0.53.tar.gz ./
tar zxvf apache-tomcat-6.0.53.tar.gz

mv apache-tomcat-6.0.53  /usr/local/apache-tomcat-6.0.53
ln -s  /usr/local/apache-tomcat-6.0.53 /usr/local/tomcat
chown -R tomcat:www /usr/local/apache-tomcat-6.0.53
```

## 2. 设置启动项

### 2.1 rc.local启动

编辑引导启动脚本 /etc/rc.local , 内容如下：
```bash
cat >> /etc/rc.local <<EOF
# tomcat随机启动命令(su 空格 tomcat 空格 -c 空格 '路径')
su - tomcat -c '/usr/local/tomcat/bin/startup.sh'
# 或者
# su - tomcat -c '/usr/local/tomcat/bin/catalina.sh start'
EOF

chmod a+x /etc/rc.d/rc.local
reboot
```

验证安装：
```bash
# 查看ip
ip addr | grep inet | grep eth

# 查看端口监听
ss -antu | grep 8080 | column -t

# 开发8080端口
iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
service iptables save
```
使用 http://ip:8080 访问， 浏览器显示tomcat欢迎界面。


### 2.2 服务化启动（推荐）

#### 2.2.1 添加服务管理脚本

添加tomcat服务管理shell脚本 `vi /usr/local/tomcat/bin/tomcatd`，添加如下内容：
```text
#!/bin/bash 
# 
# tomcatd This shell script takes care of starting and stopping 
# standalone tomcat 
# chkconfig: 345 91 10 
# description: tomcat service 
# processname: tomcatd 
# config file: 

# Source profile configuration. 
. /etc/profile

# Source function library. 
. /etc/rc.d/init.d/functions

# Source networking configuration. 
. /etc/sysconfig/network

# Check that networking is up. 
if [ "${NETWORKING}" = "no" ]; then
    echo "Network is stoped! Please open the network!";
    exit 0
fi 

# Executive user
executor=tomcat
prog=tomcatd

export CATALINA_HOME=/usr/local/tomcat/

STARTUP="${CATALINA_HOME}/bin/catalina.sh start" 
SHUTDOWN="${CATALINA_HOME}/bin/catalina.sh stop"

if [ ! -f ${CATALINA_HOME}/bin/startup.sh ]; then 
    echo "CATALINA_HOME for tomcatd not available" 
    exit 0
fi

start() {
    # Start daemons.
    echo -e $"Startting tomcat service: " 
    su - $executor -c "$STARTUP" 
    status
    RETVAL=$? 
    return $RETVAL 
}

status() {
     tomcat_pid=$(ps -u tomcat|grep java|awk '{printf $1}')
     if [ ${tomcat_pid} -gt 0 ]; then
         echo -e "tomcatd ( pid ${tomcat_pid} ) is running...\n"
     else
         echo -e "Tomcat is stopped\n"
     fi
}

stop() { 
    # Stop daemons. 
    echo -e $"Stoping tomcat service:" 
    su - $executor -c "$SHUTDOWN" 
    RETVAL=$? 
    return $RETVAL 
}

# See how we were called. 
case "$1" in 
start) 
    start 
    ;; 
stop) 
    stop 
    ;; 
restart|reload)    
    stop 
    sleep 10
    start 
    RETVAL=$? 
    ;; 
status) 
    status
    RETVAL=$? 
    ;; 
*) 
    echo $"Usage: tomcatd {start|stop|restart|status}" 
    exit 1 
esac
exit $RETVAL
```

#### 2.2.2 加入随机启动

加入随机启动：
```bash
chmod a+x /usr/local/tomcat/bin/tomcatd
ln -s /usr/local/tomcat/bin/tomcatd /etc/init.d/tomcatd
chkconfig tomcatd on

# 查看启动设置
chkconfig --list | grep tomcat
```

删除上文设置的自启配置：
```bash
sed -i "s|su - tomcat -c '/usr/local/tomcat/bin/startup.sh'||g" /etc/rc.local

service tomcatd restart
```

浏览器再次访问 http://ip:8080

脚本用法：
```bash
service tomcatd start
service tomcatd status
service tomcatd restart
service tomcatd stop
```


# 六、设置tomcat环境变量

> 加大tomcat运行内存防止程序报异常[ java.lang.OutOfMemoryError: PermGen space ]

添加tomcat环境变量脚本：
```bash
cat >> /usr/local/tomcat/bin/setenv.sh <<EOF
JAVA_OPTS="-server -Xms2048m -Xmx2048m -Xss1024k -XX:PermSize=256M -XX:MaxNewSize=1024m -XX:MaxPermSize=1024m -Djava.awt.headless=true"
EOF
```
请根据自己服务器的实际配置酌情增大或减小。


# 七、端口转发

非root用户其实没有绑定80端口的权限。在Linux下低于1024的端口是root专用，
而Tomcat安装后默认使用用户 tomcat 启动的，所以将端口改为80后启动，
会产生错误：java.net.BindException: Permission denied:80。

解决方法有两种：
- 1.利用Nginx代理转发, 这个办法网上很多资料，本文不赘述。
- 2.利用Iptables端口转发功能：

设置防火墙转发80端口至8080端口，配置文件(/etc/sysconfig/iptables)
```bash
sysctl -w net.ipv4.ip_forward=1

iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -t nat -A POSTROUTING -j MASQUERADE

service iptables save
```
这样就实现了80端口转发至8080端口


# 八、参考资料

- [Iptables 实现端口转发](http://www.linuxidc.com/Linux/2012-09/70481.htm)
- [Linux系统使用ROOT用户启动tomcat报错的问题](http://www.cnblogs.com/ebs-blog/archive/2010/10/14/2167288.html)
- [让tomcat以非root身份运行](http://blog.csdn.net/cnfixit/article/details/7030666)
- [linux 非root用户安装 jdk 和 tomcat](http://blog.csdn.net/wuyigong111/article/details/17410661)
