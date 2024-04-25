---
title: VMware虚拟机安装Porteus Desktop 5.x
date: 2024-04-18 22:55:24
categories: ['OS', 'Linux', 'Porteus']
tags: ['OS', 'Linux', 'Porteus', 'Porteus Desktop 5.x']
---

# 一、前言

Porteus 是一个轻量级但完整的 Linux 发行版，经过优化，可以从CD、USB闪存驱动器、CD、DVD、硬盘驱动器或其他可启动存储介质上运行。它基于Slackware Linux，它很小(不到300Mb)且启动速度非常快，让你在其他操作系统还在启动的时候就完成它的启动并开始上网了。

Porteus 可在任何 Intel、AMD 或 VIA x86/64 处理器上运行，只需要 512MB 的磁盘空间和 256MB 的内存。 硬盘不是必须的，因为它可以从可移动存储介质上运行。如果你在可移动存储媒体设备上使用Porteus，你可以利用其“持久”的模式，将数据直接保存在存储设备上。

你还可以选择下载Porteus的Cinnamon、Gnome、KDE、LXDE、LXQT、MATE、Openbox或Xfce版本。


# 二、准备工作

> 虚拟机版本：
>
> 产品：VMware® Workstation 16 Pro 
>
> 版本：16.1.2 build-17966106

## 1.下载系统包

> Porteus 基于 salix Linux

前往官网下载页面[Porteus Mirrors](http://porteus.org/porteus-mirrors.html)，下载所需要的版本：
x86_64版本: [Porteus-MATE-v5.01-x86_64.iso](https://www.mirrorservice.org/sites/dl.porteus.org/x86_64/Porteus-v5.01/Porteus-MATE-v5.01-x86_64.iso)

## 2.新建虚拟机

|  配置名称  |  配置值  |
|  --  |  --  |
|客户机操作系统-版本| Linux - 其他Linux5.x及更高版本内核64位|
|磁盘类型：        |   SATA|
|网络适配器：       |  NAT|

新建虚拟机过程请参考：[VMware虚拟机最小化安装CentOS 6.X系统](/blog/2023/11/16/vmware-build-small-centos-6.x/) 。

# 三、安装Porteus

> 密码显示在启动界面：root/toor、 guest/guest 
> 文档: http://www.porteus.org/faq.html#twenty6

开机后，进入引导选择界面，直接回车选择默认：
{% asset_img 1.png %}

启动系统安装程序器（Porteus Installer）：
{% asset_img 2.png 启动系统安装程序器 %}

### 1. 硬盘分区、格式化

点击菜单Partition manager，打开磁盘分区应用(GParted)：
{% asset_img 3.png 打开磁盘分区应用 %}

#### 1.1. 创建dos分区表

点击菜单 Device -> Create Partition Table ，创建分区表:
{% asset_img 4.png 创建分区表 %}

再确认弹窗中选择分区表格式为msdos，点击 Apply 提交：
{% asset_img 5.png 创建Dos分区表 %}

#### 1.2. 创建交换分区

选中未分配(unallocated)的分区，右键点击New菜单:
{% asset_img 6.png 创建交换分区 %}

创建交换分区，交换分区大小设置为1024M(根据实际情况自行设定)，格式未 linux-swap：
{% asset_img 7.png 创建交换分区 %}

#### 1.3. 创建ext4分区

> 请根据实际需要进行自定义，当前只是简单演示

选中未分配(unallocated)的分区，右键点击New菜单:
{% asset_img 8.png 创建交换ext4分区 %}

直接点击 Add 按钮，使用默认参数进行分区：
{% asset_img 9.png 创建交换ext4分区 %}

#### 1.4. 提交分区方案

如不再进行分区，点击菜单栏的 √ 按钮提交：
{% asset_img 10.png 提交分区方案 %}

警告弹窗点击 Apply 按钮提交：
{% asset_img 11.png 确认分区方案 %}

开始进行分区应用操作：
{% asset_img 12.png 执行分区方案 %}

分区操作明细：
{% asset_img 13.png 分区操作明细 %}

#### 1.5. 设置boot标记

选中第2分区(按实际分区情况决定)，右键点击 Manage Flags：
{% asset_img 14.png 设置boot标记 %}

标记第2分区为boot：
{% asset_img 15.png 标记第2分区为boot %}

查看硬盘分区详情：
{% asset_img 16.png 硬盘分区详情 %}

硬盘分区操作完毕，关闭GParted应用。

#### 1.6. 命令行模式分区

硬盘分区：

```bash
# /dev/sda设置为msdos格式分区表
parted /dev/sda mktable msdos

# 创建一个1024M大小的交换分区
parted /dev/sda mkpart primary linux-swap 1 1025M

# 创建剩余容量为ext4分区
parted /dev/sda mkpart primary ext4 1025M 100%

# 标记第2分区为boot
parted /dev/sda set 2 boot on

# 格式化第1分区为交换分区格式
mkswap /dev/sda1

# 格式化第2分区为ext4文件格式
mkfs.ext4 /dev/sda2
```

分区详情：
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
 1      1049kB  1075MB  1074MB  primary  linux-swap
 2      1075MB  32.2GB  31.1GB  primary  ext4         boot
```

### 2. 安装系统

挂载boot分区，本文的boot分区是第2分区，点击按钮 Mount a partition(挂载分区)：
{% asset_img 17.png 挂载分区 %}

在弹窗显示的可挂载分区中选择第2分区，点击按钮 Mount now 执行挂载：
{% asset_img 18.png 挂载第2分区 %}

显示挂载分区成功：
{% asset_img 19.png 挂载第2分区成功 %}

#### 2.4. 安装系统

点击Next，开始安装系统：
{% asset_img 20.png 开始安装系统 %}

同意明白并接受上述警告提示，同意安装系统引导，然后点击Next：
{% asset_img 21.png 同意警告提示和安装系统引导 %}

在弹窗窗口输入 ok， 然后回车：
{% asset_img 22.png 确认设置的是正确分区 %}

再次弹窗，告知当前安装程序已处理完毕请重启系统，输入任意键退出：
{% asset_img 23.png 系统安装完毕请重启系统 %}

# 四、配置系统

## 1 修改主机名

> 请切换到root用户进行操作

```bash
echo 'porteus' > /etc/HOSTNAME
```

## 3. 配置网络

> DNS多少请查询 VMware Workstation 的【编辑】->【虚拟网络编辑器】->【VMnet8】->【NAT设置】, 获取其中的子网掩码，网关IP。
> 本文的DNS也就是网关IP【192.168.168.2】

```bash
vi /etc/NetworkManager/system-connections/eth0.nmconnection
```

#### 3.1 静态IP(推荐)

模板如下(一般虚拟机中网关和DNS是同一个地址)：
```text
[ipv4]
address1=192.168.168.155/24,192.168.168.2
dns=192.168.168.2;
dns-search=192.168.168.2;
may-fail=false
method=manual
```

重启系统生效：
```bash
reboot
```

#### 3.2 动态IP

配置动态IP请使用如下模板：
```text
[ipv4]
dsn-search=
method=auto
```

重启系统生效：
```bash
reboot
```

## 4. 配置openssh
```bash
cd /etc/ssh/sshd_config
sed -i 's|^#PermitRootLogin prohibit-password|PermitRootLogin yes|' /etc/ssh/sshd_config
sed -i 's|^#PubkeyAuthentication|PubkeyAuthentication|' /etc/ssh/sshd_config

/etc/rc.d/rc.sshd start
```

加入开机启动配置：
```bash
#/etc/rc.d/rc.services 里有启动脚本，设置脚本可执行即可
chmod +x /etc/rc.d/rc.sshd
```

查看客户机IP
```bash
ifconfig
```

远程连上客户机


## 5. 开启cron

加入本地启动项：
```bash
chmod +x /etc/rc.d/rc.crond
```

添加定时任务：
```bash
vi /var/spool/cron/crontabs/root
#或
crontab -e
```

## 6. 修改时区

编辑 vi $PORTCFG (/mnt/sda2/porteus/porteus-v5.0-x86_64.cfg)， 添加 timezone=Asia/Shanghai
> 说明文档：/usr/doc/porteus/cheatcodes.txt

```bash
# 或者
echo 'timezone=Asia/Shanghai' >> /etc/bootcmd.cfg
# 或者
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#或者通过命令界面设置
timeconfig
```

修改时间同步服务地址：
```bash
cat >> /var/spool/cron/crontabs/root <<EOF
#每分钟同步internet时间
*/1 * * * * ntpdate cn.pool.ntp.org >/dev/null && hwclock -w
EOF
```

校验时间：
```bash
date +'%Y-%m-%d %T'
```

## 7. 修改软件源

> 软件源:
> 阿里云: https://mirrors.aliyun.com/slackware/slackware64-15.0/
> 官方源: https://mirrors.slackware.com/slackware/slackware64-15.0/

### 7.1 修改slackpkg软件源
打开控制台Terminal程序，修改软件源:
```bash

# 屏蔽官方软件源
sed -i 's|^https://mirrors.slackware.com*|#&|' /etc/slackpkg/mirrors

# 设置软件源为阿里云
cat >> /etc/slackpkg/mirrors <<EOF
# 阿里云
https://mirrors.aliyun.com/slackware/slackware64-15.0/
EOF

# 或者打开编辑器编辑
pluma /etc/slackpkg/mirrors
```

软件源缓存更新：
```bash
slackpkg update gpg
slackpkg update
```

安装软件：
```bash
# 查看使用说明
slackpkg -h

# 查找软件包
slackpkg search htop

# 安装软件包
slackpkg install htop
```

tgz软件包安装方法：
```bash
# 安装软件包
installpkg bmp.tgz
# 升级软件包
upgradepkg bmp
# 卸载软件包
removepkg bmp
```

### 7.2 修改slapt-get软件源

```bash
vi /etc/slapt-get/slapt-getrc
```

软件源缓存更新：
```bash
slapt-get --add-keys
slapt-get -u
```

安装软件：
```bash
# 查看使用说明
slapt-get -h

# 查找软件包
slapt-get --search htop

# 安装软件包
slapt-get -i htop
```

修复slapt-get无法安装软件问题:
```bash
wget https://download.salixos.org/x86_64/15.0/salix/a/spkg-1.7-x86_64-2gv.tgz
installpkg spkg-1.7-x86_64-2gv.tgz
rm spkg-1.7-x86_64-2gv.tgz
```

## 8. 安装open-vm-tools

> 不推荐使用 slapt-get -i open-vm-tools 安装

选择当前客户机，点击右键，菜单栏选择 安装 VMware-Tools，挂载 VMware-Tools ISO 文件。

然后执行如下命令，进行安装：
```bash
mkdir -p /mnt/cdrom
mount /dev/cdrom /mnt/cdrom
cp /mnt/cdrom/VMwareTools-*.tar.gz /tmp && cd /tmp
tar zxvf /tmp/VMwareTools-*.tar.gz 

slackpkg install perl

# 执行安装， 然后一路回车使用默认配置 
/tmp/vmware-tools-distrib/vmware-install.pl 

# 删除文件
rm -rf /tmp/VMwareTools-*.tar.gz
rm -rf /tmp/vmware-tools-distrib

#验证VMware-Tools
ls /mnt/hgfs/
#或者执行命令，查询刚刚共享的文件夹
vmware-hgfsclient

# 添加随机启动
chmod +x /etc/rc.d/init.d/vmware-tools
echo '/etc/rc.d/init.d/vmware-tools start &' >> /etc/rc.d/rc.local
```

## 9. 汉化

```bash
# 安装字体
slackpkg search wqy-zenhei-font-ttf
slackpkg install wqy-zenhei-font-ttf

# 下载官方语言包
cd $MODDIR
wget https://www.mirrorservice.org/sites/dl.porteus.org/x86_64/Porteus-v5.01/language/zh-mate_locales.xzm

sed -i 's|^export LANG=en_US.UTF-8|export LANG=zh_CN.UTF-8|' /etc/profile.d/lang.sh

# 生效
source /etc/profile

# 验证
locale

# 重启系统查看
reboot
```

或者在桌面环境下执行脚本：
```bash
wget https://www.mirrorservice.org/sites/dl.porteus.org/i486/testing/packages/Language-Selection-Tool/gtk-language-selection-tool
bash ./gtk-language-selection-tool
```


# 五、系统加固 

## 1. 启动防火墙

> /etc/rc.d/rc.FireWall 脚本是有问题的，需要手动修复

```bash
chmod +x /etc/rc.d/rc.FireWall
/etc/rc.d/rc.FireWall start

/etc/rc.d/rc.FireWall status
```

开放端口：
```bash
vi /etc/rc.d/rc.FireWall
```

查看已添加规则：
```bash
#查看防火墙配置
/etc/rc.d/rc.FireWall status
#或
iptables -nL
#或
iptables --line-numbers -nv -L
#或
iptables -S
```

## 2. 自定义防火墙脚本
```bash
###########################################################################
##           防火墙脚本
##  1.建立INPUT、FORWARD、OUTPUT 三个链， 默认丢弃
##  2.建立LOG_DROP链用于记录所有丢弃的数据包
##  3.设置需要的防火墙规则
##  4.将INPUT、FORWARD、OUTPUT 三个链未匹配的数据包转发至LOG_DROP链, 最终丢弃
###########################################################################

# 删除所有规则
iptables -F
# 删除所有用户自定义链
iptables -X

# 丢弃所有输入、输出、转发数据包
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# 放行回环网卡数据包
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# 允许发送ping信号
iptables -A OUTPUT -p icmp --icmp-type 8 -j ACCEPT

# 允许DNS请求
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --sport 53 -j ACCEPT

# 允许已建立的链接通行
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# 允许外部访问本机80端口
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
# 允许本机80端口的数据包输出
iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
# 允许本机访问外部机器的80端口
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT

# 创建一个链，用于记录所有丢弃的数据包
iptables -N LOG_DROP
iptables -A LOG_DROP -j DROP

# 所有未匹配的输入数据包跳转至LOG_DROP规则链处理，也就是丢弃
iptables -A INPUT -j LOG_DROP
# 所有未匹配的转发数据包跳转至LOG_DROP规则链处理，也就是丢弃
iptables -A FORWARD -j LOG_DROP


#################################################
##           关闭防火墙
#################################################
# 删除所有规则
iptables -F
# 删除所有用户自定义链
iptables -X
# 放行流入数据包
iptables -P INPUT ACCEPT
# 放行转发数据包
iptables -P FORWARD ACCEPT
# 放行流出数据包
iptables -P OUTPUT ACCEPT
```

参考： [iptables 命令详解和举例](/blog/2023/11/24/iptables-usage-details/)


# 六、其他

启动执行路径：
```text
/etc/inittab
    ⬇
/etc/rc.d/rc.S -> /etc/rc.d/rc.sysvinit -> /etc/rc.d/rc${runlevel}.d/S*
    ⬇
/etc/rc.d/rc.K -> /etc/rc.d/rc.sysvinit -> /etc/rc.d/rc${runlevel}.d/S*
    ⬇
/etc/rc.d/rc.M -> /etc/rc.d/rc.services -> /etc/rc.d/rc.* -> /etc/rc.d/rc.local
    ⬇
/etc/rc.d/rc.4
```
所以我们添加自启服务可以在 /etc/rc.d/ 目录下 添加 rc. 前缀的启动脚本即可。
并且需要满足一个通用启动命令 /etc/rc.d/rc.* start|stop|restart

需要随机启动的脚本可以添加在 /etc/rc.d/rc.local 文件中。

# 七、参考资料

- [官方porteus安装指南](http://www.porteus.org/tutorials/37-installing/114-official-porteus-installation-guide-v-10.html)
- [How to Install Porteus 3.2 to Hard Drive + Review + VMware Tools on VMware Workstation Tutorial [HD]](https://www.youtube.com/watch?v=9d5tr4Jm4f0)
- [Guide slapt-get](https://guide.salixos.org/321slaptget.html)
- [parted分区命令使用示例](https://www.cnblogs.com/pipci/p/11372530.html)
- [Linux各主要发行版的包管理命令对照](https://www.cnblogs.com/huapox/p/3509640.html)

# 八、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->vmware-build-porteus-desktop-5.x](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Fvmware-build-porteus-desktop-5.x)
