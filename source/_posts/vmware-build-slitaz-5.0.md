---
title: VMware虚拟机安装SliTaz-5.0
date: 2024-04-15 22:55:24
categories: ['OS', 'Linux', 'SliTaz']
tags: ['OS', 'Linux', 'SliTaz', 'SliTaz 5.0']
---

# 一、前言

SliTaz是一个超小型的Linux发行版。它在一张不足30MB的LiveCD上，不仅集成了Firefox 3、Mplayer、gFTP、pdf阅读器等众多常用的软件，还包括了Lua解释器、Geany等一些简单的开发工具。

# 二、准备工作

> 虚拟机版本：
>
> 产品：VMware® Workstation 16 Pro
>
> 版本：16.1.2 build-17966106

## 1.下载系统包

前往官网下载页面[Downloads SliTaz Linux](https://www.slitaz.org/en/get/#rolling)，下载所需要的版本：
x86版本: [slitaz-rolling.iso](https://mirror.slitaz.org/iso/rolling/slitaz-rolling.iso)
x86_64位版本: [slitaz-rolling-core64.iso](https://mirror.slitaz.org/iso/rolling/slitaz-rolling-core64.iso)

## 2.新建虚拟机

> 注意，磁盘类型不要选择SCSI模式，否则无法识别硬盘。请选择【IDE】或【SATA】。

|  配置名称  |  配置值  |
|  --  |  --  |
|客户机操作系统-版本| Linux - 其他Linux5.x及更高版本内核64位|
|磁盘类型：        |   SATA|
|网络适配器：       |  NAT|

新建虚拟机过程请参考：[VMware虚拟机最小化安装CentOS 6.X系统](/blog/2023/11/16/vmware-build-small-centos-6.x/) 。

# 三、安装SliTaz

开机后，进入引导选择界面，直接回车选择默认，再选择 SliTaz Live，登录控制台，账号密码root/root：
{% asset_img 1.png %}


### 1. 硬盘分区、格式化

> [parted分区命令使用示例](https://www.cnblogs.com/pipci/p/11372530.html)

#### 1.1. 创建dos分区表
```bash
parted /dev/sda mktable msdos
```

#### 1.2. 创建交换分区
> 分区开始值如果设置为0，可能会报警告：硬盘分区没有对齐以实现性能最优。
> 解决办法参考：https://www.cnblogs.com/oradba/p/16145117.html

交换分区大小设置为512M(根据实际情况自行设定)
```bsh
parted /dev/sda mkpart primary linux-swap 1 513M
```

#### 1.3. 创建ext4分区
```bash
parted /dev/sda mkpart primary ext4 513M 100%
```

#### 1.4. 设置boot标记

设置第2块分区为启动分区标记(按实际分区情况决定)
```bash
parted /dev/sda set 2 boot on
```

#### 1.5. 查询分区详情
```bash
parted /dev/sda p
```
回显:
```text
Model: ATA VMware Virtual S (scsi)
Disk /dev/sda: 32.2GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags: 

Number  Start   End     Size    Type     File system  Flags
 1      1049kB  513MB   512MB   primary
 2      513MB   32.2GB  31.7GB  primary               boot
```

#### 1.6. 硬盘格式化

1. 格式化交换分区：
```bash
mkswap /dev/sda1
```
回显：
```text
Setting up swapspace version 1, size = 511700992 bytes
UUID=f8e1be6c-2de3-448d-abbb-cbd98382ea81
```

2. 格式化主分区：
```bash
mkfs.ext4 /dev/sda2
```
回显：
```text
mke2fs 1.45.5 (07-Jan-2020)
Suggestion: Use Linux kernel >= 3.18 for improved stability of the metadata and journal checksum features.
64-bit filesystem support is not enabled.  The larger fields afforded by this feature enable full-strength checksumming.  Pass -O 64bit to rectify.
Creating filesystem with 7739136 4k blocks and 1937712 inodes
Filesystem UUID: 16a208dc-4437-4177-8132-2bf36b96a369
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
        4096000

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done
```


### 2. 安装系统

#### 2.1. 配置安装参数
```bash
tazinst usage #查看使用帮助
tazinst help  #查看参数说明

tazinst new #创建配置文件
tazinst set mode install ./tazinst.rc         #设置模式为安装，列出支持类型：tazinst list mode
tazinst set media cdrom ./tazinst.rc          #安装来源为cdrom，列出支持类型：tazinst list media
tazinst set root_uuid /dev/sda2 ./tazinst.rc  #安装路径为/dev/sda2分区
tazinst set root_format ext4 ./tazinst.rc     #安装分区文件格式为ext4
tazinst set hostname slitaz ./tazinst.rc      #设置主机名称
tazinst set root_pwd root ./tazinst.rc        #设置root密码
tazinst set user_login tux ./tazinst.rc       #设置普通用户账号
tazinst set user_pwd tux ./tazinst.rc         #设置普通用户密码
tazinst set bootloader auto ./tazinst.rc      #设置系统引导为自动处理，列出支持类型：tazinst list bootloader
```

#### 2.2. 检查配置
```bash
cat ./tazinst.rc #查看安装配置
tazinst check    #检查配置
```

#### 2.3. 安装系统
```bash
tazinst execute  #执行系统安装
```
回显：
```text
1 Installing SliTaz on: /dev/sda2
5 Checking settings...
10 Preparing source media...
Creating mount point: /media/source...
Using files from /dev/sr0.
Checking installation media...
Installation media checked ok
20 Preparing target disk...
Preparing target partition...
Format /dev/sda2 (ext4)
Creating mount point: /mnt/target...
30 Cleaning the root partition if necessary...
40 Extracting the root system...
50 Installing the Kernel...
cp: can't stat '/media/source/boot/rootfs.gz': No such file or directory
install_kernel: vmlinuz-3.16.55-slitaz
60 Preconfiguring the system...
Adding / partition and CHECK_FS to file /etc/rcS.conf...
Configuring host name: slitaz
70 Configuring root and default user account...
80 Configuring /home...
90 Checking bootloader installation...
Installing GRUB on: /dev/sda
Setting the boot flag
Copying splash image                                                      
100 Files installation completed
Process completed. You can now restart (reboot) from your SliTaz GNU/Linux 
system.
Copying log to /var/log/tazinst.log
Unmounting target partition: /dev/sda2
Unmounting: /media/source
```
以上回显说明安装执行完毕.

#### 2.4. 重启系统
```bash
reboot
```

# 四、配置SliTaz

> 用户:密码 => root:root、tux:tux

## 1 修改主机名

```bash
echo 'slitaz' > /etc/hostname
```

## 3. 配置网络

> DNS多少请查询 VMware Workstation 的【编辑】->【虚拟网络编辑器】->【VMnet8】->【NAT设置】, 获取其中的子网掩码，网关IP。
> 本文的DNS也就是网关IP【192.168.168.2】

#### 3.1 静态IP(推荐)

模板如下(一般虚拟机中网关和DNS是同一个地址)：
```text
NETWORK_CONF_VERSION="2"
INTERFACE="eth0"
DHCP="no"
STATIC="yes"
IP="192.168.168.112"
NETMASK="255.255.255.0"
BROADCAST="192.168.168.255"
GATEWAY="192.168.168.2"
DOMAIN=""
DNS_SERVER="192.168.168.2"
```

重启网络
```bash
/etc/init.d/network.sh restart
```

#### 3.2 动态IP

配置动态IP请使用如下模板：
```bash
NETWORK_CONF_VERSION="2"
INTERFACE="eth0"
DHCP="yes"
STATIC="no"
IP=""
NETMASK="255.255.255.0"
BROADCAST="192.168.168.255"
GATEWAY="192.168.168.2"
DOMAIN=""
DNS_SERVER="192.168.168.2"
```

### 3.3 编辑配置

```bash
vi /etc/network.conf
```

重启生效：
```bash
/etc/init.d/network.sh restart
```

## 3. 修改软件源

> echo '软件源' > /var/lib/tazpkg/mirror

打开控制台Terminal程序，修改软件源
```bash
# 阿里云
tazpkg -sm https://mirrors.aliyun.com/slitaz/packages/cooking/

# 官方源
tazpkg -sm http://mirror.slitaz.org/packages/cooking/
tazpkg -sm http://mirror1.slitaz.org/packages/cooking/
```

## 4. 修改密码

```bash
sudo passwd tux
sudo passwd root
```

## 5. 安装openssh
```bash
tazpkg -gi openssh

cd /etc/ssh/sshd_config
sed -i 's|^#PermitRootLogin prohibit-password|PermitRootLogin yes|' /etc/ssh/sshd_config
sed -i 's|^#PubkeyAuthentication|PubkeyAuthentication|' /etc/ssh/sshd_config

/etc/init.d/openssh start
```

加入开机启动配置：
```bash
echo "/etc/init.d/openssh start &" >> /etc/init.d/local.sh
#或
sed -i 's|^RUN_DAEMONS="[A-Za-z0-9 ]*|& openssh|' /etc/rcS.conf
```

查看客户机IP
```bash
ifconfig
```

远程连上客户机

## 6. 设置默认编辑器

> 请修改默认文本编辑器为vi、nano
> tazpkg -gi nano

```bash
sed -i 's|EDITOR="leafpad"|EDITOR="vi"|' /etc/slitaz/applications.conf
source /etc/profile
```

## 7. 开启cron

加入本地启动项：
```bash
echo "/etc/init.d/crond start &" >> /etc/init.d/local.sh
#或
sed -i 's|^RUN_DAEMONS="[A-Za-z0-9 ]*|& crond|' /etc/rcS.conf
```

添加定时任务：
```bash
vi /var/spool/cron/crontabs/root
#或
crontab -e
```

## 8. 修改时区

```bash
echo 'Asia/Shanghai' > /etc/TZ
#或
echo 'Asia/Chongqing' > /etc/TZ
echo 'Asia/Hong_Kong' > /etc/TZ
echo 'Asia/Macau' > /etc/TZ
echo 'Asia/Taipei' > /etc/TZ

reboot
```

修改时间同步服务地址：
```bash
sed -i 's|^NTPD_OPTIONS="-p pool.ntp.org"|NTPD_OPTIONS="-p cn.pool.ntp.org"|' /etc/daemons.conf
```


## 9. 安装辅助软件

```bash
tazpkg -gi htop
tazpkg -gi lrzsz
```

添加别名:
```bash
cat >> /etc/profile <<EOF

alias ll='ls -la'
alias rz='/usr/bin/lrz'
alias sz='/usr/bin/lsz'
EOF

source /etc/profile
```

## 10. 配置控制面板

```bash
cp  /etc/slitaz/httpd.conf /etc/slitaz/httpd.conf.bak

cat > /etc/slitaz/httpd.conf <<EOF
# /etc/slitaz/httpd.conf: Busybox HTTP web server configuration file for TazPanel

# Allow addresses
A:0.0.0.0

# Server root
H:/var/www/tazpanel
# File to open by default
I:index.cgi
# Require user "*", password "*" on URLs starting with "/user"
/:root:*

# CGI interpreter path
*.cgi:/bin/sh
# Additional MIME types
.js:text/javascript
.ttf:application/x-font-ttf
EOF
```

重启控制面板
```bash
/etc/init.d/tazpanel restart

#查看端口监听状态
netstat -tlnp
```


访问 http://192.168.168.112:82/settings.cgi


# 五、系统加固 

> 提示: 你可以使用" tazpkg -s package-name "命令来搜索软件包。

## 1. 安装iptables防火墙

### 1.1. 安装iptables
```bash
tazpkg -gi iptables

sed -i 's|^IPTABLES_RULES="no"|IPTABLES_RULES="yes"|' /etc/slitaz/firewall.conf
```

### 1.2. 启动防火墙

启动防火墙：
```bash
/etc/init.d/firewall start
```

添加规则：
```bash
vi /etc/slitaz/firewall.sh

#开放82端口
#iptables -A INPUT -i $iface -p tcp --destination-port 82 -j ACCEPT
```

查看已添加规则：
```bash
#查看防火墙配置
/etc/init.d/firewall status
#或
iptables -nL
#或
iptables --line-numbers -nv -L
#或
iptables -S
```

参考： [iptables 命令详解和举例](/blog/2023/11/24/iptables-usage-details/)


# 六、参考资料

- [Slitaz入门指南-如何在Virtualbox下安装slitaz5.0及增强功能Additions](https://zhuanlan.zhihu.com/p/64391039?utm_id=0)
- [How to Install SliTaz 4.0 Linux and Review on VMware](https://linux-video-tutorials.blogspot.com/2016/12/install-slitaz-4-0-and-review-on-vmware.html)
- [SliTaz 从入门到精通](https://www.cnblogs.com/meetrice/p/3682509.html)
- [parted分区命令使用示例](https://www.cnblogs.com/pipci/p/11372530.html)
- [Linux各主要发行版的包管理命令对照](https://www.cnblogs.com/huapox/p/3509640.html)

# 七、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->vmware-build-slitaz-5.0](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Fvmware-build-slitaz-5.0)
