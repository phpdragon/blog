---
title: vmware-build-tinycore-pure-14.0
date: 2023-11-18 22:55:24
tags:
---

# 前言

# 准备工作

硬盘请选择STAT模式

# 安装TinyCore

## 1. 虚拟机开机
开机后，进入引导选择界面，直接回车选择 Boot TinyCorePure64
{% asset_img 1.png %}

进入桌面以后

## 2. 开始安装

### 2.1. 加载安装脚本
```bash
tce-load -wi tc-install
```

### 2.2. 执行tc-install.sh
```bash
sudo /usr/local/bin/tc-install.sh
``` 
回显如下：
```text
Core Installation.

Install from [R]unning OS, from booted [C]drom, from [I]so file, or from [N]et. (r/c/i/n): c
```

选择 c 从光盘安装，有以下信息回显：
```text
Using: /mnt/sr0/boot/core.gz

Select install type for /mnt/sr0/boot/core.gz

Frugal
* Use for frugal hard drive installations.
Note: You will be prompted for disk/partion and formatting options.

HDD
* Use for pendrives. Your BIOS must support USB-HDD booting.
* A single FAT partition will be made.
Note: Requires dosfstools extension.
Warning: This is a whole drive installation!

Zip
* Use for pendrives. Drive will be formatted into two FAT partitions.
* One small one for USB_ZIP boot compatibility, and used to hold Tiny Core.
* The remaining partition will be used for backup & extensions.
Note: Requires dosfstools and perl extensions.
Warning: This is a whole drive installation!

Select Install type [F]rugal, [H]DD, [Z]ip. (f/h/z): f
```
选择 f 安装到本地硬盘，有以下信息回显：

```text
Select Target for Installation of core
         1. Whole Disk
         2. Partition
Enter selection ( 1 - 2 ) or (q)uit: 1
```
选择 1 使用整个硬盘安装，有以下信息回显：

```text
Would you like to install a bootloader?
Most people should answer yes unless they are trying to embed Core
into a different Linux distribution with an existing bootloader.

Enter selection ( y, n ) or (q)uit: y
```
选择 y 安装启动引导，有以下信息回显：

```text
Install Extensions from this TCE/CDE Directory:
```

输入扩展路径，这里先不输入， 直接回车，有以下信息回显：


```text
Select Formatting Option for sda
         1. ext2
         2. ext3
         3. ext4
         4. vfat
Enter selection ( 1 - 4 ) or (q)uit: 3
```
选择 3 使用分区格式 ext4，有以下信息回显：
```text
Enter space separated boot options: 
Example: vga=normal syslog showapps waitusb=5
```

设置一些启动选项, 这里先不输入， 直接回车，有以下信息回显：
```text
Last chance to exit before destroying all data on sda
Continue (y/..)? 
```

选择 y 开始安装，有以下信息回显：
```text
Writing zero's to beginning of /dev/sda
Partitioning /dev/sda
Formatting /dev/sda1
mke2fs 1.46.5 (30-Dec-2021)
1+0 records in
1+0 records out
440 bytes (440B) copied, 0.000595 seconds, 722.2KB/s
UUID="d05650de-ed23-415a-955a-4296f59db67b"
Applying extlinux.
/mnt/drive/tce/boot/extlinux is device /dev/sda1
Setting up core image on /mnt/sda1
Installation has completed
Press Enter key to continue.
```

安装完毕后有以下信息回显, 安装完毕.

### 2.1.重启
```bash
sudo reboot
```

## 3. 修改软件源

打开控制台Terminal程序，修改软件源
```bash
echo "http://mirrors.163.com/tinycorelinux" > /opt/tcemirror
```

## 4. 修改密码

```bash
sudo passwd tc
```

## 5. 安装openssh
```bash
tce-load -wi openssh

cd /usr/local/etc/ssh/
sudo cp sshd_config.orig sshd_config
/usr/local/etc/init.d/openssh start
```

查看客户机IP
```bash
ifconfig
```

远程连上客户机


## 持久化

持久化处理，保存密码、ssh、开机启动配置：

```bash
sudo echo '/etc/passwd' >> /opt/.filetool.lst
sudo echo '/etc/shadow' >> /opt/.filetool.lst
sudo echo '/usr/local/etc/ssh' >> /opt/.filetool.lst
sudo echo '/opt/bootlocal.sh' >> /opt/.filetool.lst

sudo touch /opt/bootlocal.sh
sudo echo '/usr/local/etc/init.d/openssh start &' >> /opt/bootlocal.sh
filetool.sh -b
```

如果 /opt/bootlocal.sh 没有权限，则手动进行编辑

大功告成，这时可以重启检查下，sshd服务是否已自动开启。

