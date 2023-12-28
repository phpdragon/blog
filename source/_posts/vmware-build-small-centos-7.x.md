---
title: VMware虚拟机最小化安装CentOS 7.X系统
date: 2023-11-16 19:55:54
categories: ['OS', 'Linux', 'CentOS']
tags: ['OS', 'Linux', 'CentOS', 'CentOS7.X']
---

# 一、系统信息

> 虚拟机版本：
>
> 产品：VMware® Workstation 16 Pro
>
> 版本：16.1.2 build-17966106

# 二、前期准备

下载系统iso镜像包，[CentOS-7.0-1406-x86_64-Minimal.iso](https://mirrors.tuna.tsinghua.edu.cn/centos-vault/7.0.1406/isos/x86_64/CentOS-7.0-1406-x86_64-Minimal.iso) ，也可以使用6系列的其他版本，按实际需要下载

下载地址: https://mirrors.tuna.tsinghua.edu.cn/centos-vault/7.0.1406/isos/x86_64/

阿里云备用地址: https://mirrors.aliyun.com/centos-vault/7.0.1406/isos/x86_64/

网易备用地址: http://mirrors.163.com/centos-vault/7.0.1406/isos/x86_64/


# 三、新建虚拟机

## 1. 新建虚拟机

菜单 -> 文件 -> 新建虚拟机, 选择自定义, 点击下一步：
![](/img/vmware/1.png)


## 2. 选择兼容性

选择兼容性， Workstation 16.x, 点击下一步：
![](/img/vmware/2.png)

## 3. 如何安装操作系统

选择稍后安装操作系统, 点击下一步：
![](/img/vmware/3.png)

## 4. 选择操作系统版本

选择 Linux 版本  CentOS 7 64位, 点击下一步：
{% asset_img 4.png 选择操作系统版本 %}

## 5. 命名虚拟机

输入虚拟机名称, 点击下一步：
{% asset_img 5.png 命名虚拟机 %}

## 6. 处理器配置

设置处理器配置，根据物理机实际CPU核心来自由设置, 点击下一步：
![](/img/vmware/6.png)

## 7. 虚拟机内存配置

设置虚拟机内存，根据物理机实际内存大小自由设置, 点击下一步：
![](/img/vmware/7.png)

## 8. 网络类型配置

网络类型设置选择默认（使用网络地址转换NAT类型）, 点击下一步：
![](/img/vmware/8.png)

## 9. I/O控制器配置

I/O控制器选择默认（LSI LOGIC）, 点击下一步：
![](/img/vmware/9.png)

## 10. 选择磁盘类型

磁盘类型选择默认（SCSI）, 点击下一步：
![](/img/vmware/10.png)

## 11. 如何使用磁盘

选择新建虚拟磁盘, 点击下一步：
![](/img/vmware/11.png)

## 12. 磁盘容量配置

磁盘容量选择默认容量20G，本文设置40G，单个文件存储(选择其他都行), 点击下一步：
![](/img/vmware/12.png)

## 13. 指定磁盘文件

选择磁盘文件（使用默认）, 点击下一步：
{% asset_img 13.png 选择操作系统版本 %}

## 14. 自定义硬件配置

点击自定义硬件，弹出硬件窗口：
{% asset_img 14.png 自定义硬件配置 %}

## 15. CD/DVD配置

编辑 CD/DVD 配置项，选择你下载好的IOS映像文件, 再点击窗口的关闭：
![](/img/vmware/15.png)

然后点击完成， 完成虚拟机的创建。


## 16. 配置共享文件夹

编辑虚拟机配置，弹出虚拟机配置窗口，再点击添加：
{% asset_img 16.png 配置共享文件夹 %}

选择想要共享的文件夹：
![](/img/vmware/17.png)

点击下一步，选择启用此共享，再点击完成。 

-------------------


# 四、安装操作系统

## 1. 虚拟机开机

新建好的虚拟机CentOS-7-64开机
{% asset_img 18.png 虚拟机开机 %}

## 2. 选择启动项

进入开机画面，选择第一项安装系统，敲回车确认，开始安装虚拟机:
{% asset_img 19.png 选择启动项 %}

## 3. 选择系统语言

语言选择默认（English），点击下一步：
{% asset_img 20.png 选择启动项 %}

## 4. 配置系统时区
{% asset_img 21.png 配置系统时区 %}

用鼠标点击地图，选择时区为上海，点击右上角按钮Done提交：

{% asset_img 22.png 选择时区为上海 %}

## 5. 选择键盘类型

键盘类型选择默认（U.S.English），无需操作：
{% asset_img 23.png 选择键盘类型 %}

## 6. 选择安装源

无需操作，默认设置即可：
{% asset_img 24.png 选择安装源 %}

如需网络安装请自己设置安装服务器地址：
{% asset_img 25.png 网络安装 %}


## 7. 软件包选择

默认就是最小化包，这里无需进入选项操作。
{% asset_img 26.png 软件包选装 %}

因为我们下载的就是最小化系统镜像包，所以没有其他可选选项：
{% asset_img 27.png 最小化系统镜像包 %}

## 8. 安装位置

点击进入设置安装目的地选项：
{% asset_img 28.png 设置安装目的地 %}

默认已选择自动分区，如果不想手动分区，直接点击左上角按钮Done提交：
{% asset_img 29.png 默认已选择自动分区 %}

本文选择手动分区, 勾选我要配置分区(I will configure partitioning)，再点击左上角按钮Done提交：
{% asset_img 43.png 选择手动分区 %}

点击自动创建分区分区(Click here to create them automatically)：
{% asset_img 44.png 点击自动创建分区分区 %}

自动生成如下分区配置：
{% asset_img 45.png 自动分区配置 %}

缩减根分区的磁盘大小，调整大小，点击更新设置(Update Settings)：
{% asset_img 46.png 自动分区配置 %}

添加新分区，挂载点为 /opt, 大小设置为15G：
{% asset_img 47.png 添加新分区 %}

最终分区配置如下图，点击左上角按钮Done确认：
{% asset_img 48.png 最终分区配置 %}

确认分区更变，点击接受更改(Accept Changes)：
{% asset_img 49.png 接受更改 %}


## 9. 网络和主机名

{% asset_img 30.png 配置网络 %}

网络连接点击打开：
{% asset_img 31.png 网络连接点击打开 %}

然后点击右下角按钮 Configure， 弹出网络配置弹窗：
{% asset_img 32.png 弹出网络配置弹窗 %}

修改 “链接名称”（Connection name）为 eth0 ， 勾选 “当网络可用自动连接网络”（Automatically connect to this network when it is available）。
{% asset_img 33.png 当网络可用自动连接网络 %}

点击 IPv6 Settings 选项卡，方式（Method）选择 “忽略”（Ignore），不启用IPV6，再点击 Save 保存配置。

{% asset_img 34.png 设置客户机主机名称 %}

设置客户机主机名称为 centos-7-64-mini ， 点击左上角按钮 Done 提交。

## 10. 开始安装

点击右下角按钮 Begin Installation， 开始安装系统：
{% asset_img 35.png 开始安装 %}

## 11. 设置root密码

点击进入设置root密码选项：
{% asset_img 36.png 设置root密码 %}

输入root用户密码， 点击左上角按钮Done提交：
{% asset_img 37.png 设置root密码 %}


## 12. 系统安装完毕

{% asset_img 38.png 系统安装完毕 %}

点击右下角按钮 Reboot， 重启客户机。


# 五、配置虚拟机

## 1. 登录root用户

{% asset_img 39.png 登录root用户 %}

## 2. 配置SSH

### 2.1. 开启root远程

配置ssh可以远程登录root账户, 控制台执行下面命令：

去除：PermitRootLogin 前面的 # 注释 
```bash
sed -i 's|^#PermitRootLogin yes|PermitRootLogin yes|g' /etc/ssh/sshd_config
cat /etc/ssh/sshd_config | grep PermitRootLogin | grep yes
```

如图所示：
![](/img/sshd/38.png)

### 2.2. 重启sshd服务

```bash
systemctl restart  sshd.service
```

### 2.3. 查看ip地址

```bash
ip addr
```
然后远程登录到虚拟机


## 3. 修改软件源

> 因为 CentOS 7系列将在2024年停止维护更新， 所以到时也可以参考 [CentOS 6系列更换软件源](https://juejin.cn/post/7300564263345618995#heading-41)

### 5.1 替换软件源

设置为南京大学的软件源：

```bash
sed -e 's|^mirrorlist=|#mirrorlist=|g' \
-e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirror.nju.edu.cn/centos|g' \
-i.bak \
/etc/yum.repos.d/CentOS-Base.repo
```

或者设置为阿里云的软件源：

```bash
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```

或者设置为中科大的软件源：

```bash
sudo sed -e 's|^mirrorlist=|#mirrorlist=|g' \
-e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.ustc.edu.cn/centos|g' \
-i.bak \
/etc/yum.repos.d/CentOS-Base.repo
```

### 5.2 更新YUM缓存

重置yum缓存:
```base
yum clean all 
yum makecache
```

如果报如下错误：
```
[Errno 14] curl#35 - "Peer reports incompatible or unsupported protocol version."
```
原因是curl版本过低，导致curl命令无法识别https最新的TSL协议，解决办法就是把软件源的https改为http协议。

```bash
sed -i 's|^baseurl=https|baseurl=http|g' /etc/yum.repos.d/CentOS-Base.repo
yum clean all 
yum makecache
#升级curl、openssl版本解决问题
yum -y update curl openssl
sed -i 's|^baseurl=http|baseurl=https|g' /etc/yum.repos.d/CentOS-Base.repo
yum clean all 
yum makecache
```

## 4. 网络配置

### 4.1 配置iP

#### 4.1.1 动态IP

修改配置文件，`vi /etc/sysconfig/network-scripts/ifcfg-eno*`, 修改后的内容如下：
```text
TYPE=Ethernet
BOOTPROTO=dhcp
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=no
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
NAME=eth0
UUID=212f2866-8aca-45a9-8303-f42788eb79c5
ONBOOT=yes
HWADDR=00:0C:29:5B:E3:F8
PEERDNS=yes
PEERROUTES=yes
```

#### 4.1.2 静态IP(推荐)

> MAC地址(选中虚拟机->设置->网络适配器->高级->MAC地址->生成)和UUID请自己生成。
> 网关IP请查询 VMware Workstation 的【编辑】->【虚拟网络编辑器】->【VMnet8】->【NAT设置】, 获取其中的子网掩码，网关IP。

修改配置文件，`vi /etc/sysconfig/network-scripts/ifcfg-eno*`, 修改后的内容如下：
```text
TYPE=Ethernet
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
NAME=eth0
UUID=f0208bba-45e6-4b85-8104-39c3f9aaa512
ONBOOT=yes
HWADDR=00:0C:29:18:1F:D2
IPADDR0=192.168.168.102
PREFIX0=24
GATEWAY0=192.168.168.2
DNS1=192.168.168.2
DOMAIN=localhost
```

### 4.2 配置DNS

> DNS多少请查询 VMware Workstation 的【编辑】->【虚拟网络编辑器】->【VMnet8】->【NAT设置】, 获取其中的子网掩码，网关IP。
> 本文的DNS也就是网关IP【192.168.168.2】

本文添加如下DNS配置内容：

```bash
cat > /etc/resolv.conf <<EOF
# Generated by NetworkManager
domain localdomain
search localdomain
nameserver 114.114.114.114
nameserver 192.168.168.2
EOF
```

### 4.3 重启网络服务

```bash
systemctl restart network
```

测试网络是否正常：
```text
ping www.baidu.com
```

```bash
ip addr
```
然后远程登录到虚拟机


## 5. 关闭防火墙

```bash
#查看防火墙状态
systemctl status firewalld.service
#关闭防火墙
systemctl stop firewalld.service

#关闭开机自启
systemctl disable firewalld.service
#开启开机自启
systemctl enable firewalld.service

#检查启动项开启状态
systemctl list-unit-files | grep firewalld
```


## 6. 关闭SELinux

设置 SELINUX=disabled 

```bash
sed -i 's|^SELINUX=enforcing|SELINUX=disabled|g' /etc/selinux/config
cat /etc/selinux/config | grep  SELINUX=disabled
```

或者编辑 /etc/selinux/config 文件

```bash
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of these two values:
#     targeted - Targeted processes are protected,
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
```
重启系统生效


## 7. 安装VMware-Tools

### 7.1 方式一

[安装VMware-Tools](/blog/2023/11/16/vmware-build-small-centos-6.x/#8-安装VMware-Tools)

### 7.2 方式二（推荐）
安装命令如下：

```bash 
yum -y install open-vm-tools

systemctl enable vmtoolsd
systemctl start vmtoolsd
```

验证VMware-Tools
```bash
#查询之前设置的共享文件夹
vmware-hgfsclient
```

挂载共享文件, 简版 vmhgfs-fuse .host:/ /mnt/hgfs
```bash
vmhgfs-fuse .host:/ /mnt/hgfs -o subtype=vmhgfs-fuse,allow_other,uid=1000,gid=1000
echo 'vmhgfs-fuse .host:/ /mnt/hgfs -o subtype=vmhgfs-fuse,allow_other,uid=1000,gid=1000' >> /etc/rc.local
chmod +x /etc/rc.local
```

> /mnt/hgfs/ 目录下有文件说明安装成功
```
ls /mnt/hgfs
```

参考：

[Centos7安装open-vm-tools和设置共享文件夹](https://zhuanlan.zhihu.com/p/151666020)

[CentOS 7 VMware-Tools Mount Shared Folder](https://simukti.net/blog/2016/09/10/centos-7-vmware-tools-mount-shared-folder/ "CentOS 7 VMware-Tools Mount Shared Folder")

## 8. 设置时间同步

```bash
yum -y install ntpdate
echo '#每分钟同步internet时间
*/1 * * * * /usr/sbin/ntpdate cn.pool.ntp.org >/dev/null && /usr/sbin/hwclock -w' >> /var/spool/cron/root

cat /var/spool/cron/root
```

或手动编辑，加入下文内容：

```bash
crontab -e

#每分钟同步internet时间
*/1 * * * * /usr/sbin/ntpdate cn.pool.ntp.org && /usr/sbin/hwclock -w
```

## 9. 安装基础软件包

```bash
#基础包
yum -y groupinstall base

#编译工具
yum -y install gcc gcc-c++ autoconf automake cmake make patch

#系统工具
yum -y install psmisc net-tools lsof yum-utils

#类库
yum -y install pcre pcre-devel
yum -y install zlib zlib-devel
yum -y install openssl openssl-devel

#常用工具
yum -y install unzip zip lrzsz vim wget
```

安装中如果出现如下提示：
```text
There are unfinished transactions remaining. You might consider running yum-complete-transaction, 
or "yum-complete-transaction --cleanup-only" and "yum history redo last", first to finish them. 
If those don't work you'll have to try removing/installing packages by hand (maybe package-cleanup can help).
```

解决方法：使用yum-complete-transaction命令清理未完成事务，使用该命令是需要先安装 yum-utils 工具包
```bash
# 安装工具包
yum install yum-utils
 
#清空缓存
yum clean all
 
# 清楚未完成事务
yum-complete-transaction --cleanup-only
```

如果还是无法安装，可能是有损坏包存在，可以尝试在安装命令后面添加 --skip-broken 参数
```bash
# 安装工具包
yum -y groupinstall base --skip-broken
```


# 六、参考资料

- [Centos7安装open-vm-tools和设置共享文件夹](https://zhuanlan.zhihu.com/p/151666020)
- [CentOS 7 VMware-Tools Mount Shared Folder](https://simukti.net/blog/2016/09/10/centos-7-vmware-tools-mount-shared-folder/ "CentOS 7 VMware-Tools Mount Shared Folder")


# 七、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->vmware-build-small-centos-7.x](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Fvmware-build-small-centos-7.x)
