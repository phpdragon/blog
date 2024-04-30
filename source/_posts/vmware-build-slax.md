---
title: VMware虚拟机安装Slax Linux
date: 2024-04-19 22:55:24
categories: ['OS', 'Linux', 'Slax']
tags: ['OS', 'Linux', 'Slackware', 'Debian', 'Salix', 'Slax Linux']
---

# 一、前言

Slax是一个紧凑、快速和现代的Linux操作系统，它结合了时尚的设计和模块化的方法。由于可以直接从USB闪存驱动器运行而无需安装，Slax是真正便携的，可以很容易地放在口袋里。尽管它的体积很小，但它提供了视觉上吸引人的图形用户界面和精心挑选的基本预装程序，如文件管理器、文本编辑器、终端等。

基于Slackware或Debian, Slax允许您利用每个平台的庞大生态系统。通过slackpkg(用于Slackware)或apt(用于Debian)命令随时可以获得成千上万的预构建包和应用程序，可能性实际上是无限的。因此，无论您是经验丰富的Linux用户还是刚刚入门，Slax都拥有完成工作所需的一切。

# 二、准备工作

> 虚拟机版本：
>
> 产品：VMware® Workstation 17 Pro 
>
> 版本：17.5.1 build-23298084

## 1.下载系统包

> Slax 基于 Slackware 或 Debian

前往官网下载页面[Slax Linux](https://www.slax.org)，下载所需要的版本：
基于Slackware 32版本: [slax-32bit-15.0.1.iso](https://ftp.sh.cvut.cz/slax/Slax-15.x/slax-32bit-15.0.1.iso)
基于Slackware 64版本: [slax-64bit-15.0.1.iso](https://ftp.sh.cvut.cz/slax/Slax-15.x/slax-64bit-15.0.1.iso)

基于Debian 32版本: [slax-32bit-debian-12.2.0.iso](https://ftp.sh.cvut.cz/slax/Slax-12.x/slax-32bit-debian-12.2.0.iso)
基于Debian 64版本: [slax-64bit-debian-12.2.0.iso](https://ftp.sh.cvut.cz/slax/Slax-12.x/slax-64bit-debian-12.2.0.iso)

## 2.新建虚拟机

|  配置名称  |  配置值  |
|  --  |  --  |
|客户机操作系统-版本| Linux - 其他Linux6.x及更高版本内核64位|
|磁盘类型：        |   SATA|
|网络适配器：       |  NAT|

新建虚拟机过程请参考：[VMware虚拟机最小化安装CentOS 6.X系统](/blog/2023/11/16/vmware-build-small-centos-6.x/) 。


# 三、安装系统

开机后，进入系统，点击左下角打开 Terminal 终端

## 1. 硬盘分区、格式化

> Slackware

```bash
# 创建dos分区表
parted /dev/sda mktable msdos
# 创建交换分区，大小设置为4G(根据实际情况自行设定)
parted /dev/sda mkpart primary linux-swap 1 4296M
# 创建ext分区，使用剩余所有容量
parted /dev/sda mkpart primary ext4 4296M 100%
# 将第2个分区设置为引导分区
parted /dev/sda set 2 boot on
# 查看分区结果
parted /dev/sda p

# 格式化交换分区
mkswap /dev/sda1
# 格式化ext4分区
mkfs.ext4 /dev/sda2
```

> Debian

```bash
# 进入分区命令行
sfdisk /dev/sda

# 建立一个4G的交换分区
,4G,S
# 建立一个linux分区，标记为启动分区
,,L,*
# 写入配置
write

# 打印分区详情
sfdisk /dev/sda -l

mkswap /dev/sda1
mkfs.ext4 /dev/sda2
```

## 2. 安装系统

拷贝系统文件：
```bash
# 或者手动挂载 /dev/sda2 分区
mkdir -p /mnt/sda2 && mount /dev/sda2 /mnt/sda2
# 挂载CD磁盘
mkdir -p /mnt/cdrom && mount /dev/cdrom /mnt/cdrom

# 拷贝系统
cp -R /mnt/cdrom/slax /mnt/sda2
```

开始安装系统：
```
/mnt/sda2/slax/boot/bootinst.sh
```

回显：
```text
Partition /dev/sda2 seems to be located on a physical disk,
which is already bootable. If you continue, your drive /dev/sda
will boot only Slax by default.
Press [Enter] to continue, or [Ctrl+C] to abort...


* attempting to install bootloader to /mnt/sda2/slax/boot...
/mnt/sda2/slax/boot is device /dev/sda2
* setup MBR on /dev/sda
* set bootable flag for /dev/sda2
Boot installation finished.
Press Enter...
```

重启系统
```bash
reboot
```


## 3. 修改主机名

> Slackware

```bash
echo 'slax' > /etc/HOSTNAME
```

> Debian

```bash
echo 'slax' > /etc/hostname
```

## 4. 配置网络

> DNS多少请查询 VMware Workstation 的【编辑】->【虚拟网络编辑器】->【VMnet8】->【NAT设置】, 获取其中的子网掩码，网关IP。
> 本文的DNS也就是网关IP【192.168.168.2】

进入 connman 配置目录
```bash
# 进入connman的配置文件目录
cd /var/lib/connman/ethernet_$(ifconfig|grep ether|awk '{print $2}'|sed 's/://g')_cable
```

### 4.1 静态ip

编辑配置文件 settings ，修改为如下内容：
```bash
cat > ./settings <<EOF
[ethernet_000c29d03977_cable]
Name=Wired
AutoConnect=true
IPv4.method=manual
IPv6.method=off
IPv6.privacy=disabled
Domains=localdomain;
Proxy.Method=direct
Nameservers=192.168.168.2;
IPv4.netmask_prefixlen=24
IPv4.local_address=192.168.168.159
IPv4.gateway=192.168.168.2
EOF

# 重启系统生效
reboot
```

### 4.2 动态ip

编辑配置文件 settings ，修改为如下内容：
```text
cat > ./settings <<EOF
[ethernet_000c29d03977_cable]
Name=Wired
AutoConnect=true
IPv4.method=dhcp
IPv6.method=off
IPv6.privacy=disabled
Domains=localdomain;
Proxy.Method=auto
Nameservers=192.168.168.2;
EOF

# 重启系统生效
reboot
```

## 5. 开启cron

> Slackware

```bash
chmod +x /etc/rc.d/rc.crond
/etc/rc.d/rc.crond start
```

> Debian

```bash
systemctl enable cron
systemctl start cron
```

---

```bash
# 添加定时任务
vi /var/spool/cron/crontabs/root
#或
crontab -e
```

## 6. 配置时区、语言

> 基于 Slackware，也可以通过命令界面设置: timeconfig

```bash
# 设置时区为上海
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 同步时间
ntpdate cn.pool.ntp.org

# 验证时间
date +'%Y-%m-%d %T'
```

添加时间同步任务：
```bash
cat >> /var/spool/cron/crontabs/root <<EOF
#每分钟同步internet时间
*/1 * * * * ntpdate cn.pool.ntp.org >/dev/null && hwclock -w
EOF
```

## 7. 配置openssh

调整ssh配置：
```bash
sed -i 's|^#PermitRootLogin prohibit-password|PermitRootLogin yes|' /etc/ssh/sshd_config
sed -i 's|^#PubkeyAuthentication|PubkeyAuthentication|' /etc/ssh/sshd_config
```

> Slackware

```bash
# 开机自启动
chmod +x /etc/rc.d/rc.sshd

# 启动ssh
/etc/rc.d/rc.sshd start
```

> Debian

```
# 开机自启动
systemctl enable ssh

# 启动ssh
systemctl start ssh
```

---


查看客户机IP
```bash
ifconfig
```

远程连上客户机，root 默认密码：toor


## 8. 修改软件源

> Slackware

参考: [Porteus-desktop修改软件源](/blog/2024/04/18/vmware-build-porteus-desktop-5.x/#7-修改软件源)

> Debian

```bash
sed -i 's|^deb*|#&|g' /etc/apt/sources.list

cat >> /etc/apt/sources.list <<EOF
# 阿里云软件源
deb http://mirrors.aliyun.com/debian/ bullseye main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ bullseye main non-free contrib
EOF

# 更新软件源
apt update
```

## 9. 安装open-vm-tools

> Slackware

参考: [Slax Linux安装open-vm-tools](/blog/2024/04/16/vmware-build-salix-15.x/#8-安装open-vm-tools)

> Debian

```bash
apt install open-vm-tools

# 不使用桌面可以不安装
apt install open-vm-tools-desktop

# 列出共享文件夹名称，说明可以挂载
vmware-hgfsclient

# 手动挂载共享文件夹
vmhgfs-fuse -o allow_other -o auto_unmount .host:/ /mnt/hgfs

# 验证
ls /mnt/hgfs
```

自动挂载方式一：
```bash
# 自动挂载(貌似不支持, 配置文件会复原)
cat >> /etc/fstab <<EOF
.host:/ /mnt/hgfs fuse.vmhgfs-fuse allow_other,auto_unmount 0 0
EOF
```

自动挂载方式二：
```bash
# 添加挂载共享文件夹脚本
cat > /etc/init.d/local_start.sh <<EOF
#!/bin/sh

#挂载共享文件夹
mkdir -p /mnt/hgfs && vmhgfs-fuse -o allow_other -o auto_unmount .host:/ /mnt/hgfs
EOF

# 设置可执行权限
chmod +x /etc/init.d/local_start.sh
# 添加到自启动目录， S：开头表示start(启动)，  99：表示启动顺序
cd "/etc/rc$(runlevel|awk '{print $2}').d" && ln -sf ../init.d/local_start.sh S99local_start
```

## 10. 启用自定义交换分区

> Slackware

```bash
cat >> /etc/rc.d/rc.local <<EOF

# 启用自定义交换分区
[ -b "/dev/sda1" ] && swapoff -a && swapon /dev/sda1
EOF

chmod +x /etc/rc.d/rc.local
```

> Debian

```bash
cat >> /etc/init.d/local_start.sh <<EOF

# 启用自定义交换分区
[ -b "/dev/sda1" ] && swapoff -a && swapon /dev/sda1
EOF

chmod +x /etc/init.d/local_start.sh
cd "/etc/rc$(runlevel|awk '{print $2}').d" && ln -sf ../init.d/local_start.sh S99local_start
```


# 四、参考资料

- [parted分区命令使用示例](https://www.cnblogs.com/pipci/p/11372530.html)
- [Linux各主要发行版的包管理命令对照](https://www.cnblogs.com/huapox/p/3509640.html)

# 五、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->vmware-build-slax](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Fvmware-build-slax)
