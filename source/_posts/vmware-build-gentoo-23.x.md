---
title: VMware虚拟机安装Gentoo-23.x
date: 2024-04-28 22:55:24
categories: ['OS', 'Linux', 'Gentoo']
tags: ['OS', 'Linux', 'Gentoo']
---

# 一、前言

Gentoo Linux是一套通用的、快捷的、完全免费的Linux发行版，它面向开发人员和网络职业人员。与其他发行不同的是，Gentoo Linux拥有一套先进的包管理系统叫作Portage。
在BSD ports的传统中，Portage是一套真正的自动导入系统，然而Gentoo里的Portage是用Python编写的，并且它具有很多先进的特性， 包括文件依赖、精细的包管理、OpenBSD风格的虚拟安装，安全卸载，系统框架文件、虚拟软件包、配置文件管理等等。

Gentoo Linux是一种可以针对任何应用和需要而自动优化和自定义的特殊的Linux发行版。Gentoo拥有优秀的性能、高度的可配置性和一流的用户及开发社区。

# 二、准备工作

> 虚拟机版本：
>
> 产品：VMware® Workstation 17 Pro
>
> 版本：17.5.1 build-23298084

## 1.下载系统包

前往官网下载页面[Downloads Arch Linux](https://archlinux.org/download/)，
也可以使用国内的镜像网站, [清华大学开源软件镜像站](https://mirrors.tuna.tsinghua.edu.cn/gentoo/releases/),下载所需要的版本：
x86_64版本: [install-amd64-minimal-20240526T163557Z.iso](https://mirrors.tuna.tsinghua.edu.cn/gentoo/releases/amd64/autobuilds/20240526T163557Z/install-amd64-minimal-20240526T163557Z.iso)
x86_64桌面版本: [livegui-amd64-20240526T163557Z.iso](https://mirrors.tuna.tsinghua.edu.cn/gentoo/releases/amd64/autobuilds/20240526T163557Z/livegui-amd64-20240526T163557Z.iso)

## 2.新建虚拟机

|  配置名称  |  配置值  |
|  --  |  --  |
|客户机操作系统-版本| Linux - 其他Linux6.x及更高版本内核64位|
|磁盘类型：        |   SATA|
|网络适配器：       |  NAT|

新建虚拟机过程请参考：[VMware虚拟机最小化安装CentOS 6.X系统](/blog/2023/11/16/vmware-build-small-centos-6.x/) 。

# 三、系统安装

```bash
#开启sshd，桌面版本使用sudo提权
/etc/init.d/sshd start
passwd root
```

开机后，进入引导选择界面，直接回车选择默认：

### 1. 硬盘分区、格式化

```bash
# 查看当前的硬盘设备路径
lsblk | grep sd
```

> [parted分区命令使用示例](https://www.cnblogs.com/pipci/p/11372530.html)

#### 1.1. 创建dos分区表
```bash
# 创建两个分区，第1分区为交换分区，第2分区为根分区
fdisk /dev/sda <<EOF
o
n
p
1

+4G
n
p
2


t
1
82
a
2
p
w
EOF

#或者
parted /dev/sda <<EOF
mktable msdos
mkpart primary linux-swap 1 4296M
mkpart primary ext4 4296M 100%
set 2 boot on
p
EOF

#或者
parted /dev/sda mktable msdos
parted /dev/sda mkpart primary linux-swap 1 4296M
parted /dev/sda mkpart primary ext4 4296M 100%
parted /dev/sda set 2 boot on
parted /dev/sda p
```

#### 1.7. 硬盘格式化

1. 格式化交换分区：
```bash
mkswap /dev/sda1
```
回显：
```text
Setting up swapspace version 1, size = 4 GiB (4294963200 bytes)
no label, UUID=4a9c1a02-0440-4bef-982b-f48312a4fbd2
```

2. 格式化主分区：
```bash
mkfs.ext4 /dev/sda2
```
回显：
```text
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 6815488 4k blocks and 1703936 inodes
Filesystem UUID: 5a722b14-2bcf-4c29-b0ac-cf8da2efe607
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
# 挂载根分区
mkdir -p /mnt/gentoo
mount /dev/sda2 /mnt/gentoo

# 启用交换分区
swapon /dev/sda1
```

### 2. 安装系统

#### 2.1. 安装 stage 文件

```bash
cd /mnt/gentoo

wget https://mirrors.tuna.tsinghua.edu.cn/gentoo/releases/amd64/autobuilds/20240602T164858Z/stage3-amd64-systemd-20240602T164858Z.tar.xz
#桌面版本请下载
#wget https://mirrors.tuna.tsinghua.edu.cn/gentoo/releases/amd64/autobuilds/20240602T164858Z/stage3-amd64-desktop-systemd-20240602T164858Z.tar.xz

tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
```

#### 2.2. 配置编译选项

> make.conf 文档参数说明：https://wiki.gentoo.org/wiki//etc/portage/make.conf/zh-cn

原始配置:
```text
# These settings were set by the catalyst build script that automatically
# built this stage.
# Please consult /usr/share/portage/config/make.conf.example for a more
# detailed example.
COMMON_FLAGS="-march=native -O2 -pipe"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
FCFLAGS="${COMMON_FLAGS}"
FFLAGS="${COMMON_FLAGS}"

# NOTE: This stage was built with the bindist Use flag enabled

# This sets the language of build output to English.
# Please keep this setting intact when reporting bugs.
LC_MESSAGES=C.utf8
```

按需调整：
```bash
# COMMON_FLAGS，作为编译时的一般参数，必备的参数有：-march=native（本设备硬件）、-O2（官方指导优化等级）、-pipe（管道代替中间文件）
# -march=native 参数, native意思是让系统自动检测cpu型号进行配置
sed 's|COMMON_FLAGS="|&-march=native |' -i /mnt/gentoo/etc/portage/make.conf

# -fomit-frame-pointer 这一项会导致你编译出来的程序无法debug；不做程序开发或debug的普通用户可以放心开启。
# -finline-functions 允许编译器选择某些简单的函数在其被调用处展开
# -funswitch-loops 将循环体中不改变值的变量移动到循环体之外
sed 's|^COMMON_FLAGS=.*-pipe|& -fomit-frame-pointer -finline-functions -funswitch-loops|' -i /etc/portage/make.conf

echo 'LDFLAGS="${COMMON_FLAGS} -Wl,-O2 -Wl,--as-needed -Wl,--hash-style=gnu -Wl,--sort-common -Wl,--strip-all"' >> /mnt/gentoo/etc/portage/make.conf

# CHOST,可用gcc-config -l查看
echo 'CHOST="x86_64-pc-linux-gnu"' >> /mnt/gentoo/etc/portage/make.conf

# MAKE_OPTS，一般用来设定gcc同时编译的并行数，一般是中央处理器核心数的1/2, 不设置则自动
echo "MAKEOPTS=\"-j$(nproc) -l8\"" >> /mnt/gentoo/etc/portage/make.conf

# 定义了要附加到emerge命令行中的参数
echo 'EMERGE_DEFAULT_OPTS="--with-bdeps=y --verbose=y --load-average --keep-going --deep"' >> /mnt/gentoo/etc/portage/make.conf

# PORTAGE_TMPDIR，包管理器后端存放中间文件的地方
# 建议把编译程序时存放临时中间文件的目录设置为内存的tmpfs(/tmp目录)，以减少编译时对硬盘的大量读写、延长硬盘使用寿命、并加快编译速度；
# 但如果你的内存较小(<=4G)，那么建议你把此项注释掉，否则很多程序会因内存容量不足而导致编译失败
echo 'PORTAGE_TMPDIR="/tmp"' >> /mnt/gentoo/etc/portage/make.conf


echo 'PORTDIR="/var/db/repos/gentoo"' >> /mnt/gentoo/etc/portage/make.conf

# DISTDIR, 变量定义了 Portage 将会把下载的源码存放到哪个路径。新安装完后的默认值是 /var/cache/distfiles。
echo 'DISTDIR=/var/cache/distfiles' >> /mnt/gentoo/etc/portage/make.conf

# PKGDIR 是Portage保存二进制包的位置。默认设置为“/var/cache/binpkgs”
echo 'PKGDIR="/var/cache/binpkgs"' >> /mnt/gentoo/etc/portage/make.conf

# 禁用gnome、kde依赖
echo 'USE="-kde -gnome"' >> /mnt/gentoo/etc/portage/make.conf

# ACCEPT_LICENSE，安装软件接受的许可证类型。此处同意所有licenses
echo 'ACCEPT_LICENSE="*"' >> /mnt/gentoo/etc/portage/make.conf

# ACCEPT_KEYWORDS，选择你安装的软件是使用稳定版本（amd64）还是激进版本（~amd64）。
# "amd64"是使用稳定版的较旧的软件，"~amd64"是使用不稳定版的更新的软件；建议用稳定版的，免得不稳定的软件包出了问题还要折腾；
# 而且gentoo所谓“稳定版”的“旧”软件相比起debian、ubuntu、centos这些已经很新了，除非你是想像archlinux那样追新)
echo 'ACCEPT_KEYWORDS="amd64"' >> /mnt/gentoo/etc/portage/make.conf


# CPU_FLAGS_X86变量可以告知 Portage CPU 拥有的 CPU flags （特性）。此信息专门用于针对目标功能来优化软件包构建。
echo "CPU_FLAGS_X86=\"$(cpuid2cpuflags|awk -F ': ' '{print $2}')\"" >> /mnt/gentoo/etc/portage/make.conf

# 本地化支持
echo 'LINGUAS="en-US zh-CN en zh"' >> /mnt/gentoo/etc/portage/make.conf
echo 'L10N="en-US zh-CN en zh"' >> /mnt/gentoo/etc/portage/make.conf

# 配置显卡
echo 'VIDEO_CARDS="video_cards_vmware"' >> /mnt/gentoo/etc/portage/make.conf

# 配置声卡
#echo 'ALSA_CARDS="hda-intel"' >> /mnt/gentoo/etc/portage/make.conf

#笔记本电脑的触控板
#echo 'INPUT_DEVICES="libinput synaptics"' >> /mnt/gentoo/etc/portage/make.conf

#如果想把CPU的microcode直接编译进内核，则需要设置为“-S”；否则注释掉
echo 'MICROCODE_SIGNATURES="-S"' >> /mnt/gentoo/etc/portage/make.conf

echo 'LLVM_TARGETS="X86"' >> /mnt/gentoo/etc/portage/make.conf

echo 'AUTO_CLEAN="yes"' >> /mnt/gentoo/etc/portage/make.conf
```

最终配置:
```text
# These settings were set by the catalyst build script that automatically
# built this stage.
# Please consult /usr/share/portage/config/make.conf.example for a more
# detailed example.
COMMON_FLAGS="-march=native -O2 -pipe -fomit-frame-pointer -finline-functions -funswitch-loops"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
FCFLAGS="${COMMON_FLAGS}"
FFLAGS="${COMMON_FLAGS}"

# NOTE: This stage was built with the bindist Use flag enabled

# This sets the language of build output to English.
# Please keep this setting intact when reporting bugs.
LC_MESSAGES=C.utf8
LDFLAGS="${COMMON_FLAGS} -Wl,-O2 -Wl,--as-needed -Wl,--hash-style=gnu -Wl,--sort-common -Wl,--strip-all"
CHOST="x86_64-pc-linux-gnu"
MAKEOPTS="-j8 -l8"
EMERGE_DEFAULT_OPTS="--with-bdeps=y --verbose=y --load-average --keep-going --deep"
PORTAGE_TMPDIR="/tmp"
PORTDIR="/var/db/repos/gentoo"
DISTDIR=/var/cache/distfiles
PKGDIR="/var/cache/binpkgs"
USE="-kde -gnome"
ACCEPT_LICENSE="*"
ACCEPT_KEYWORDS="amd64"
CPU_FLAGS_X86="aes avx avx2 f16c fma3 mmx mmxext pclmul popcnt rdrand sse sse2 sse3 sse4_1 sse4_2 ssse3"
LINGUAS="en-US zh-CN en zh"
L10N="en-US zh-CN en zh"
VIDEO_CARDS="video_cards_vmware"
MICROCODE_SIGNATURES="-S"
LLVM_TARGETS="X86"
AUTO_CLEAN="yes"
```

#### 2.3. 替换软件源

```bash
# 替换软件源
echo 'GENTOO_MIRRORS="https://mirrors.tuna.tsinghua.edu.cn/gentoo"' >> /mnt/gentoo/etc/portage/make.conf
mkdir -p /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
sed 's|sync-uri = rsync://rsync.gentoo.org/gentoo-portage|sync-uri = rsync://mirrors.tuna.tsinghua.edu.cn/gentoo-portage|' -i /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

#替换Binhost二进制包镜像源
sed 's|priority = 1|priority = 9999|' -i /mnt/gentoo/etc/portage/binrepos.conf/gentoobinhost.conf
sed 's|https://distfiles.gentoo.org|https://mirrors.tuna.tsinghua.edu.cn/gentoo/|' -i /mnt/gentoo/etc/portage/binrepos.conf/gentoobinhost.conf
#初始化密钥
getuto


#复制DNS信息
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/

echo gentoo > /mnt/gentoo/etc/hostname

cat > /mnt/gentoo/etc/hosts <<EOF
# This defines the current system and must be set
127.0.0.1     gentoo localhost

EOF
```


#### 2.4. 挂载文件系统

```bash
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run
test -L /dev/shm && rm /dev/shm && mkdir /dev/shm
mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm
```

#### 2.5. 进入chroot环境

```bash
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"
```

#### 2.6. 安装Gentoo基础系统

```bash
#从网站安装 Gentoo ebuild 数据库快照
emerge-webrsync

#更新存储库
emerge --sync

#选择正确的配置文件
eselect profile list|grep systemd|grep stable
eselect profile set 22


#更新@world集合
emerge --verbose --update --deep --newuse @world
emerge --pretend --depclean
emerge --depclean


#时区
echo "Asia/Shanghai" > /etc/timezone
emerge --config sys-libs/timezone-data

#生成区域设置
sed 's|#en_US|en_US|' -i /etc/locale.gen
cat >> /etc/locale.gen <<EOF
zh_CN GBK 
zh_CN.UTF-8 UTF-8
EOF

#生成区域设置
locale-gen


#重新加载环境以保存更改
env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
```

#### 2.7. 配置Linux内核

```bash
# 安装无线网卡、视频等固件
emerge sys-kernel/linux-firmware

#开源音频驱动
emerge sys-firmware/sof-firmware

#Intel CPU需要安装微码，AMD CPU在linux-firmware中
emerge sys-firmware/intel-microcode

#内核配置和编译
echo 'sys-kernel/installkernel dracut' > /etc/portage/package.use/installkernel
# 15:10 ~ 15:55, 4G内存  CPU: Intel i7-8700 (8) @ 3.192GHz
# 编译带有Gentoo补丁的内核
emerge sys-kernel/gentoo-kernel

#也可以使用预编译好的Gentoo补丁内核映像，避免在本地编译，代替 `emerge sys-kernel/gentoo-kernel`
#emerge sys-kernel/gentoo-kernel-bin

#更新和清理
emerge --depclean
emerge --prune sys-kernel/gentoo-kernel
#如果使用了预编译好的Gentoo补丁内核映像，则使用这个命令代替 `emerge --prune sys-kernel/gentoo-kernel`
#emerge --prune sys-kernel/gentoo-kernel-bin

# 列出已安装的linux内核
eselect kernel list
# 默认不需要执行，就一个内核
#eselect kernel set 1
```

#### 2.8. 配置系统
```bash
cat > /etc/fstab <<EOF
/dev/sda1  none      swap    sw                  0 0
/dev/sda2  /         ext4    defaults,noatime    0 1
EOF

#或者偷个懒
emerge --ask sys-fs/genfstab
genfstab -U / >> /etc/fstab

#主机名
echo gentoo > /etc/hostname

cat > /etc/hosts <<EOF
# This defines the current system and must be set
127.0.0.1     gentoo localhost
127.0.0.1     lby

EOF

# 安装dhcp
emerge net-misc/dhcpcd
systemctl enable dhcpcd

# 安装 PPPoE 客户端
#emerge net-dialup/ppp

# 安装无线网卡工具
#emerge net-wireless/iw net-wireless/wpa_supplicant

# NetworkManager
emerge --ask net-misc/networkmanager
systemctl enable NetworkManager

passwd root
```

#### 2.9. 初始化、自启动配置
```
#随机生成机器ID
systemd-machine-id-setup

#设置键盘布局
systemd-firstboot --prompt

#开启所有预设服务
systemctl preset-all --preset-mode=enable-only
```

#### 2.10. 安装必要软件包

```bash
#安装文件索引
emerge sys-apps/mlocate
#安装bash支持环境
emerge app-shells/bash-completion
#时间同步
emerge net-misc/chrony


#安装ext4文件系统支持
emerge sys-fs/e2fsprogs
#安装VFAT (FAT32, ...)文件系统支持
emerge sys-fs/dosfstools
#安装XFS文件系统支持
emerge sys-fs/xfsprogs
#安装NTFS文件系统支持
emerge sys-fs/ntfs3g
#确保正确的调度nvme设备:
emerge --ask sys-block/io-scheduler-udev-rules


#任务调度工具
emerge sys-process/cronie
#编辑器
emerge app-editors/vim

#交互式进程查看器
emerge sys-process/htop
#在终端上显示带有发行徽标的系统信息工具，或者 `screenfetch`、`macchina`、`neofetch`
emerge app-misc/fastfetch


#开启sshd服务
systemctl enable sshd
#开启时间同步服务
systemctl enable chronyd.service
#开启crontab任务调度
systemctl enable cronie
```

#### 2.11. 安装系统引导

```bash
#安装grub引导
emerge --verbose sys-boot/grub

grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

#### 2.12. 添加用户

```bash
useradd -m -G users,wheel,audio -s /bin/bash lby
passwd lby

# 安装sudo
emerge --ask app-admin/sudo
# 将普通用户加入sudo组以使用sudo
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

#删除root密码并禁止登录
passwd -dl root
```

#### 2.13. 重启计算机

```bash
# 移除安装工件
rm /stage3-*.tar.*

# 退出子系统
exit

umount -l /mnt/gentoo/dev{/shm,/pts,}
umount -R /mnt/gentoo
reboot
```

# 四、配置新系统

```bash
#查看ip地址
ip addr
```


# 七、参考资料

- [Gentoo安装笔记](https://zhuanlan.zhihu.com/p/659996870)
- [Gentoo Linux实用指北](https://zhuanlan.zhihu.com/p/679224479)
- [Gentoo安装流程分享(step by step)，第一篇之基本系统的安装](https://www.zhihu.com/tardis/bd/art/122222365)
- [最新Gentoo Linux安装教程 – 第1部分](https://zhuanlan.zhihu.com/p/672838696)
- [最新Gentoo Linux安装教程 – 第2部分](https://zhuanlan.zhihu.com/p/673017312)
- [parted分区命令使用示例](https://www.cnblogs.com/pipci/p/11372530.html)
- [Linux各主要发行版的包管理命令对照](https://www.cnblogs.com/huapox/p/3509640.html)

# 八、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->vmware-build-gentoo-23.x](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Fvmware-build-gentoo-23.x)
