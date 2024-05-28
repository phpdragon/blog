---
title: VMware虚拟机安装ArchLinux
date: 2024-04-28 22:55:24
categories: ['OS', 'Linux', 'ArchLinux']
tags: ['OS', 'Linux', 'ArchLinux', 'ArchLinux 5.0']
---

# 一、前言

Arch Linux 是一个独立开发的x86-64架构通用GNU/Linux发行版，它致力于通过滚动更新来提供大多数软件的最新稳定版本。默认安装是一个最小的基本系统，由用户自行添加需要的软件，因此Arch Linux是高度可自定义的。Arch Linux使用pacman作为包管理器。并且Arch Linux还有AUR（Arch User Repository），AUR是为用户而建、由用户主导的 Arch 软件仓库。AUR 中的软件包以软件包生成脚本（PKGBUILD）的形式提供，用户自己通过 makepkg 生成包，再由 pacman 安装。其存在为Arch Linux提供了非常丰富的软件资源。

Arch Linux采用滚动更新。Arch Linux努力维护其软件的最新稳定版本，除非需要合理地避免系统包损坏。


# 二、准备工作

> 虚拟机版本：
>
> 产品：VMware® Workstation 17 Pro
>
> 版本：17.5.1 build-23298084

## 1.下载系统包

前往官网下载页面[Downloads Arch Linux](https://archlinux.org/download/)，
也可以使用国内的镜像网站, [清华大学开源软件镜像站](https://mirrors.tuna.tsinghua.edu.cn/archlinux/iso/latest/),下载所需要的版本：
x86_64版本: [latest/archlinux-x86_64.iso](https://mirrors.tuna.tsinghua.edu.cn/archlinux/iso/latest/archlinux-x86_64.iso)

## 2.新建虚拟机

|  配置名称  |  配置值  |
|  --  |  --  |
|客户机操作系统-版本| Linux - 其他Linux5.x及更高版本内核64位|
|磁盘类型：        |   SATA|
|网络适配器：       |  NAT|

新建虚拟机过程请参考：[VMware虚拟机最小化安装CentOS 6.X系统](/blog/2023/11/16/vmware-build-small-centos-6.x/) 。

# 三、系统安装

开机后，进入引导选择界面，直接回车选择默认：

### 1. 硬盘分区、格式化

> [parted分区命令使用示例](https://www.cnblogs.com/pipci/p/11372530.html)

#### 1.1. 创建dos分区表
```bash
parted /dev/sda mktable msdos
```

#### 1.2. 创建交换分区
> 分区开始值如果设置为0，可能会报警告：硬盘分区没有对齐以实现性能最优。
> 解决办法参考：https://www.cnblogs.com/oradba/p/16145117.html

交换分区大小设置为4G(根据实际情况自行设定)
```bsh
parted /dev/sda mkpart primary linux-swap 1 4097M
```

#### 1.3. 创建ext4分区
```bash
parted /dev/sda mkpart primary ext4 4097M 100%
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

#### 1.7. 挂载硬盘

```bash
mount /dev/sda2 /mnt

# 启用交换分区
swapon /dev/sda1
```

### 2. 安装系统

#### 2.1. 设置软件源

> 编辑软件源配置文件， /etc/pacman.d/mirrorlist 。
> 在列表中，越靠前的镜像站在下载软件包时，就会有越高的优先级。
> 看看列出的镜像站的顺序是否合适。
> 如果不合适，可以手动修改，将离您所处地理位置最近的镜像挪到文件的头部，同时也应该考虑一些其他标准。

编辑 /etc/pacman.d/mirrorlist ，先注释掉里面的所有行，然后在文件的最顶端添加

```bash
sed -i 's|Server*|#&|g' /etc/pacman.d/mirrorlist

cat >> /etc/pacman.d/mirrorlist <<EOF

# 阿里云软件源
Server = http://mirrors.aliyun.com/archlinux/\$repo/os/\$arch
EOF

# 更新软件源
pacman -Sy pacman-mirrorlist
```


#### 2.4. 安装必要软件包

> 虚拟机中只需要最小化安装 base 和 linux 组件，不需要安装 linux-firmware，将 vim 安装进去便于编辑文件。

```bash
pacstrap -K /mnt base linux vim
```

#### 2.5. 生成 fstab 文件

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```


# 四、配置系统

chroot到新安装的系统:
```
arch-chroot /mnt
```


## 1 修改主机名

```bash
echo 'arch' > /etc/hostname
```

## 2. 修改时区

```bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc

# 验证
date +'%Y-%m-%d %X'
```

## 3. 修改语言

```bash
sed -i 's|#en_US.UTF-8|en_US.UTF-8|' /etc/locale.gen
sed -i 's|#zh_CN.UTF-8|zh_CN.UTF-8|' /etc/locale.gen

# 生成 locale 信息
locale-gen

echo 'LANG=zh_CN.UTF-8' >> /etc/locale.conf
```

## 4. 修改root密码

```bash
passwd
```

## 5. 安装openssh

```bash
pacman -S openssh

# 运行root登录
sed -i 's|^#PermitRootLogin prohibit-password|PermitRootLogin yes|' /etc/ssh/sshd_config
sed -i 's|^#PubkeyAuthentication|PubkeyAuthentication|' /etc/ssh/sshd_config

systemctl enable sshd
```


## 6. 安装 CPU microcode：
```bash
# AMD CPU
pacman -S amd-ucode

# Intel CPU
pacman -S intel-ucode
```

## 7. 安装open-vm-tools

> 当前方案下自启动脚本无法挂载共享文件夹，手动挂载可以

```bash
pacman -S open-vm-tools

systemctl enable vmtoolsd
systemctl enable vmware-vmblock-fuse

# 添加 systemd 脚本
cat > /usr/lib/systemd/system/rc-local.service <<EOF
[Unit]
Description="/etc/rc.local Compatibility"

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardInput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target
EOF


# 添加自启动执行脚本
cat > /etc/rc.local <<EOF
#!/bin/sh
#
# 基于 /usr/lib/systemd/system/rc-local.service 启动

# 挂载共享文件
mkdir -p /mnt/hgfs && vmhgfs-fuse -o allow_other -o auto_unmount .host:/ /mnt/hgfs
EOF

# 设置可执行权限
chmod +x /etc/rc.local

systemctl daemon-reload
systemctl enable rc-local
```


## 8. 配置网络

> DNS多少请查询 VMware Workstation 的【编辑】->【虚拟网络编辑器】->【VMnet8】->【NAT设置】, 获取其中的子网掩码，网关IP。
> 本文的DNS也就是网关IP【192.168.168.2】

```bash
networkctl list

systemctl enable systemd-networkd systemd-resolved
```

> 官方网络配置：https://wiki.archlinuxcn.org/wiki/Systemd-networkd


配置静态ip:
```bash
cat > /etc/systemd/network/20-wired.network <<EOF
[Match]
Name=ens33

[Network]
Address=192.168.168.150/24
Gateway=192.168.168.2
DNS=192.168.168.2
EOF
```

配置动态ip:
```bash
cat > /etc/systemd/network/20-wired.network <<EOF
[Match]
Name=ens33

[Network]
DHCP=ipv4
EOF
```

---

或者安装NetworkManager

```bash
pacman -S networkmanager
systemctl enable NetworkManager

#启动图形化工具配置网络
nmtui
```


## 9. 开启cron

```bash
pacman -S cronie
systemctl enable cronie
```

---

```bash
# 添加定时任务
vim /var/spool/cron/root
#或
crontab -e
```


添加时间同步任务：
```bash
pacman -S ntp

cat >> /var/spool/cron/root <<EOF
#每分钟同步internet时间
*/1 * * * * ntpdate cn.pool.ntp.org >/dev/null && hwclock -w
EOF
```

## 10. 安装系统引导

```bash
# 安装grub
pacman -S grub

# 安装引导到磁盘sda
grub-install --target=i386-pc /dev/sda

# 生成 grub.cfg 文件
grub-mkconfig -o /boot/grub/grub.cfg
```

## 11. 安装辅助软件

```bash
pacman -S htop
pacman -S lrzsz

# 安装文泉驿字体
pacman -S wqy-zenhei
```

添加别名:
```bash
cat >> /etc/profile.d/alias.sh <<EOF
alias vi='vim'
alias ll='ls -la'
alias rz=' /usr/bin/lrzsz-rz'
alias sz='/usr/bin/lrzsz-sz'
EOF
```

## 12. 重启计算机

```bash
# 退出子系统
exit

reboot
```


参考： [iptables 命令详解和举例](/blog/2023/11/24/iptables-usage-details/)


# 七、参考资料

- [Arch Linux安装指南](https://wiki.archlinuxcn.org/wiki/%E5%AE%89%E8%A3%85%E6%8C%87%E5%8D%97)
- [Arch Linux使用向导安装/告别命令行archfi](https://www.jianshu.com/p/0de367008fe0)
- [最新ArchLinux安装教程【建议收藏】](https://www.cnblogs.com/immengxin/p/17400744.html)
- [安装Arch Linux，手把手组装操作系统](http://www.360doc.com/content/23/1029/15/170868_1102055514.shtml)
- [Arch Linux 详细安装教程，萌新再也不怕了！「2023.10」](https://zhuanlan.zhihu.com/p/596227524)
- [虚拟机安装Arch Linux](https://zhuanlan.zhihu.com/p/586336041)
- [Arch Linux安装教程](https://blog.csdn.net/qq_31672775/article/details/136707003)
- [Arch Linux桌面环境（Xfce4）安装教程](https://www.jianshu.com/p/f2197f0b064b)
- [arch linux安装与基础配置](https://www.cnblogs.com/hacker-dvd/p/17929318.html)
- [parted分区命令使用示例](https://www.cnblogs.com/pipci/p/11372530.html)
- [Linux各主要发行版的包管理命令对照](https://www.cnblogs.com/huapox/p/3509640.html)

# 八、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->vmware-build-slitaz-5.0](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Fvmware-build-slitaz-5.0)
