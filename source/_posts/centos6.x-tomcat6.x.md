---
title: Centos6.X下安装Tomcat-6.X，JSVC / 端口转发模式
date: 2023-12-04 19:45:29
categories: ['OS', 'Linux', 'CentOS', 'WebServer', 'Tomcat']
tags: ['CentOs','CentOS6.X', 'Linux', 'WebServer', 'Tomcat']
---

# 一、系统版本

> 当前系统基于博文安装：[虚拟机最小化安装CentOS 6.X系统](/blog/2023/11/16/vmware-build-small-centos-6.x/)

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

请参考博文：[CentOS6.x 安装 Oracle JDK](/blog/2023/12/02/centos6-x-install-oracle-jdk/)

本文安装JDK版本1.7.0_71:

```bash
java -version
```
回显如下：
```text
java version "1.7.0_71"
Java(TM) SE Runtime Environment (build 1.7.0_71-b14)
Java HotSpot(TM) 64-Bit Server VM (build 24.71-b01, mixed mode)
```

# 四、安装Tomcat

前往官网下载： [tomcat archive](https://archive.apache.org/dist/tomcat/), 下载链接[apache-tomcat-6.0.53.tar.gz](https://archive.apache.org/dist/tomcat/tomcat-6/v6.0.53/bin/apache-tomcat-6.0.53.tar.gz)

上传下载好的tomcat包，解压并拷贝到你需要安装的目录下，同时新建软链接指向tomcat目录。
```bash
cd /usr/local/src
cp /mnt/hgfs/shared-folder/apache-tomcat-6.0.53.tar.gz ./
tar zxvf apache-tomcat-6.0.53.tar.gz

mv apache-tomcat-6.0.53  /usr/local/apache-tomcat-6.0.53
ln -s  /usr/local/apache-tomcat-6.0.53 /usr/local/tomcat
chown -R tomcat:www /usr/local/apache-tomcat-6.0.53
```

# 五、启动管理

## 1. JSVC模式(推荐)

### 1.1. 编译jsvc文件：
```bash
# 安装编译器
yum -y install gcc

cd /usr/local/tomcat/bin
tar zxvf commons-daemon-native.tar.gz
cd commons-daemon-1.0.15-native-src/unix/

./configure
make

cp jsvc /usr/local/tomcat/bin/jsvc
```

### 1.2. 添加启动项：

添加启动shell：
```bash
cd /usr/local/tomcat/bin

cat > ./tomcatd.sh <<EOF
#!/bin/sh

# Tomcat This shell script takes care of starting and stopping 
# standalone tomcat 
# chkconfig: 345 91 10 
# description: tomcat service 
# processname: tomcat6 
# config file:
# Source function library. 
. /etc/rc.d/init.d/functions
# Source networking configuration. 
. /etc/sysconfig/network
# Check that networking is up. 
if [ "${NETWORKING}" = "no" ]; then
    echo "Network is stoped! Please open the network!";
    exit 0
fi

source /etc/profile

case "\$1" in
    status )
         pid=\$(ps -u tomcat|grep jsvc|awk '{printf \$1}')
         if [ \${pid} -gt 0 ]; then
             echo -e "tomcatd ( pid \${pid} ) is running...\n"
         else
             echo -e "Tomcat is stopped\n"
         fi
         exit 0
        ;;
    *)
        echo "Extended commands："
        echo "  status            show tomcatd status"
        echo ""
        ;;
esac

/usr/local/tomcat/bin/daemon.sh \$1

EOF
```

加入开机自启：
```bash
ln -s /usr/local/tomcat/bin/tomcatd.sh /etc/init.d/tomcatd
chmod a+x /usr/local/tomcat/bin/*.sh
chown -R tomcat:www /usr/local/tomcat/

chkconfig tomcatd on
# 验证配置
chkconfig --list | grep tomcatd
```


脚本用法：
```bash
service tomcatd start
service tomcatd status
service tomcatd restart
service tomcatd stop
```

### 1.3. 修改监听端口为80

```bash
sed -i'.bak' 's|port="8080"|port="80"|g' /usr/local/tomcat/conf/server.xml
```

### 1.4. 开放80端口

```bash
iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
service iptables save
```

### 1.5. 启动tomcat

```bash
service tomcatd start

ss -antu | grep 80 | column -t
```

打开浏览器访问 http://ip， 浏览器显示tomcat欢迎界面。


## 2. 端口转发模式

非root用户其实没有绑定80端口的权限。在Linux下低于1024的端口是root专用，
而Tomcat安装后默认使用用户 tomcat 启动 8080 端口，所以将端口改为80后启动，
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
这样就实现了80端口转发至8080端口，然后我们配置开机自启。

### 2.1. rc.local启动

编辑引导启动脚本 /etc/rc.local , 内容如下：
```bash
[ -e /etc/init.d/tomcatd ] && /etc/init.d/tomcatd stop && unlink /etc/init.d/tomcatd

cat >> /etc/rc.local <<EOF
# tomcat开机自启命令(su 空格 tomcat 空格 -c 空格 '路径')
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

# 开放8080端口
iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
service iptables save
```
使用 http://ip:8080 或 http://ip 访问， 浏览器显示tomcat欢迎界面。

### 2.2. service启动

#### 2.2.1. 添加服务管理脚本

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

#### 2.2.2. 加入开机自启

加入开机自启：
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

# 六、设置运行参数

> 加大tomcat运行内存防止程序报异常[ java.lang.OutOfMemoryError: PermGen space ]

添加tomcat环境变量脚本：
```bash
cat >> /usr/local/tomcat/bin/setenv.sh <<EOF
JAVA_OPTS="-server -Xms2048m -Xmx2048m -Xss1024k -XX:PermSize=256M -XX:MaxNewSize=1024m -XX:MaxPermSize=1024m -Djava.awt.headless=true"
EOF
```
请根据自己服务器的实际配置酌情增大或减小。

# 七、日志定期切割

```bash
cd /usr/local/tomcat/bin/
cat > clean_log.sh <<EOF
#!/bin/bash
PRE_DATE=\$(date +%Y-%m-%d --date="-1 day")
DUE_DATE=\$(date +%Y-%m-%d --date="-8 day")
LOG_DIR="/usr/local/tomcat/logs"

OUT_FILE="\${LOG_DIR}/catalina-daemon.out"
PRE_OUT_FILE="\${LOG_DIR}/catalina-daemon.\${PRE_DATE}.out"
DUE_OUT_FILE="\${LOG_DIR}/catalina-daemon.\${DUE_DATE}.out"

FILE_LINE=\$(wc -l "\${OUT_FILE}"|awk '{print \$1}')

# delete expired file
if [ -f "\${DUE_OUT_FILE}" ];then
   rm -f "\${DUE_OUT_FILE}"
fi

if [ -f \${OUT_FILE} ];then
   head -n \${FILE_LINE} "\${OUT_FILE}" > "\${PRE_OUT_FILE}"
   sed -i "1,\${FILE_LINE}d" "\${OUT_FILE}"
fi

exit 0
EOF
```

加入/etc/cron.d：
```bash
chmod a+x /usr/local/tomcat/bin/clean_log.sh
echo "0 0 * * * root /usr/local/tomcat/bin/clean_log.sh" > /etc/cron.d/clean_tomcat_log
```

# 八、参考资料

- [Iptables 实现端口转发](http://www.linuxidc.com/Linux/2012-09/70481.htm)
- [Linux系统使用ROOT用户启动tomcat报错的问题](http://www.cnblogs.com/ebs-blog/archive/2010/10/14/2167288.html)
- [让tomcat以非root身份运行](http://blog.csdn.net/cnfixit/article/details/7030666)
- [linux 非root用户安装 jdk 和 tomcat](http://blog.csdn.net/wuyigong111/article/details/17410661)

# 九、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->centos6.x-tomcat6.x](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2Fsharelink2076919717-858150382706250%2Ffiles%2Fcentos6.x-tomcat6.x)
