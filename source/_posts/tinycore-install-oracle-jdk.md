---
title: TinyCore 14.0 搭建 Oracle JDK
date: 2023-11-23 18:39:15
tags:
---

# 一、前言

> 本文的 TinyCore Linux 基于博文安装：[VMware虚拟机安装TinyCore-Pure-14.0](/blog/2023/11/18/vmware-build-tinycore-pure-14.0/)

前往官网下载所需的JDK包： [Java Archive | Oracle](https://www.oracle.com/java/technologies/downloads/archive/#JavaSE)

# 二、安装JAVA

## 1. tcz模式安装(推荐)：

> 本文选择安装版本为 jdk-8u201-linux-x64.tar.gz
>
> 以下脚本已打包在github项目：[tinycore-tcz-repository](https://github.com/phpdragon/tinycore-tcz-repository/tree/main/14.x/x86_64/tcz)

### 1.1. 拷贝文件

```bash
cd /home/tc
cp /mnt/hgfs/shared-folder/jdk-8u201-linux-x64.tar.gz ./

tar zxvf jdk-8u201-linux-x64.tar.gz

mkdir -p jdk8/usr/local
mv jdk1.8.0_201 jdk8/usr/local/java
```

### 1.2. 删除不必要的文件

删除不必要的文件，减少体积：
```bash
cd /home/tc
unlink jdk8/usr/local/java/src.zip 
unlink jdk8/usr/local/java/javafx-src.zip
find jdk8/usr/local/java/ -name '*\.bat' -delete
```

### 1.3. 添加环境变量

添加环境变量文件：
```bash
cd /home/tc
mkdir -p jdk8/etc/profile.d
cat > jdk8/etc/profile.d/jdk8.sh <<EOF
export JAVA_HOME=/usr/local/java
export JRE_HOME=\${JAVA_HOME}/jre
export CLASSPATH=.:\${JAVA_HOME}/lib:\${JRE_HOME}/lib
export PATH=\${JAVA_HOME}/bin:\$PATH
EOF
chmod -R 775 jdk8/etc/profile.d/jdk8.sh
```

### 1.4. 添加tce安装脚本

添加tce 安装脚本：
```bash
cd /home/tc
mkdir -p jdk8/usr/local/tce.installed
cat > jdk8/usr/local/tce.installed/jdk8 <<EOF
#!/bin/sh
. /etc/profile.d/jdk8.sh
[ -e /lib64 ] || [ "\$(uname -m)" != "x86_64" ] || ln -s /lib /lib64
EOF
chmod -R 775 jdk8/usr/local/tce.installed/jdk8
```

### 1.5. 构建tcz文件

构建jdk8.tcz文件：
```bash
tce-load -wi squashfs-tools

chown -R tc:staff jdk8
mksquashfs jdk8 jdk8.tcz
md5sum jdk8.tcz > jdk8.tcz.md5.txt
find jdk8 -not -type d | sed 's|^jdk8/|./|g' > jdk8.tcz.list
mv -f jdk8.tcz* /etc/sysconfig/tcedir/optional
echo "jdk8.tcz" >> /etc/sysconfig/tcedir/onboot.lst
```

### 1.6. 重启系统

清理文件并重启：
```bash
rm -rf /home/tc/jdk8
unlink /home/tc/jdk-*-linux-*.tar.gz

sudo reboot

java -version

df -h | grep jdk
```

## 2. 普通安装

> 本文选择安装版本为 jdk-8u201-linux-x64.tar.gz

### 2.1. 添加环境变量

添加环境变量文件，'sudo vi /etc/profile.d/jdk8.sh', 添加如下内容:
```text
TCEDIR=$(ls -l /etc/sysconfig/|grep tcedir|awk -F '-> ' '{print $2}')
JAVA_HOME_PARENT=$(cd ${TCEDIR};cd ..;pwd)

export JAVA_HOME="${JAVA_HOME_PARENT}/jdk"
export JRE_HOME="${JAVA_HOME}/jre"
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH

#创建动态库软链
[ -e /lib64 ] || [ "$(uname -m)" != "x86_64" ] || sudo ln -s /lib /lib64
```

加入持久化：
```bash
sudo chmod -R 775 /etc/profile.d/jdk8.sh
sudo ln -s /lib /lib64
source /etc/profile

echo '/etc/profile.d/jdk8.sh' >> /opt/.filetool.lst
filetool.sh -b
```

### 2.2. 拷贝文件

```bash
cd ~/
cp /mnt/hgfs/shared-folder/jdk-8u201-linux-x64.tar.gz ./

tar zxvf jdk-*-linux-*.tar.gz
sudo mv -f jdk1* ${JAVA_HOME}
sudo chown -R tc:staff ${JAVA_HOME}

#删除不需要的文件，减少体积
unlink ${JAVA_HOME}/src.zip
unlink ${JAVA_HOME}/javafx-src.zip
find ${JAVA_HOME} -name '*\.bat' -delete
unlink jdk-*-linux-*.tar.gz

#重启
sudo reboot

#查看版本
java -version
```

## 3. 官方软件安装

> 安装了桌面端的可以用这个办法

```bash
tce-load -wi   java-installer
cd ~/
cp /mnt/hgfs/shared-folder/jdk-8u201-linux-x64.tar.gz ./
sudo java-installer
unlink jdk-*-linux-*.tar.gz
```

# 三、参考资料

- [tinycore-jdk-tcz](https://github.com/phpdragon/tinycore-jdk-tcz)
- [tinycore-jdk11-tcz/build-jdk11tcz.sh](https://github.com/hpmtissera/tinycore-jdk11-tcz/blob/master/build-jdk11tcz.sh)
- [TinyCoreLinux 搭建Oracle JDK1.8](https://www.jianshu.com/p/34a045e0bdd5)
- [Topic: Java on TinyCore Plus](http://forum.tinycorelinux.net/index.php/topic,16715.0.html)

# 四、附件
