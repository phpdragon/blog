---
title: VMware虚拟机安装Salix Linux 15.x
date: 2024-04-16 22:55:24
categories: ['OS', 'Linux', 'Salix']
tags: ['OS', 'Linux', 'Salix', 'Salix Linux 15.x']
---

# 一、前言

Salix是一个基于Slackware的GNU/Linux发行版，它简单快速，易于使用，稳定性是主要目标。Salix也完全向后兼容Slackware，因此Slackware用户可以从Salix存储库中受益，他们可以将其用作他们喜欢的发行版的“额外”质量的软件源。像盆景一样，小而轻，是无限呵护的产物。

# 二、准备工作

> 虚拟机版本：
>
> 产品：VMware® Workstation 17 Pro 
>
> 版本：17.5.1 build-23298084

## 1.下载系统包

> Salix 基于 Slackware Linux

前往官网下载页面[Salix Downloads](http://porteus.org/porteus-mirrors.html)，下载所需要的版本：
x86_64版本: [Salix64 Xfce 15.0](https://download.salixos.org/x86_64/15.0/iso/salix64-xfce-15.0.torrent)


## 2.新建虚拟机

|  配置名称  |  配置值  |
|  --  |  --  |
|客户机操作系统-版本| Linux - 其他Linux5.x及更高版本内核64位|
|磁盘类型：        |   SATA|
|网络适配器：       |  NAT|

新建虚拟机过程请参考：[VMware虚拟机最小化安装CentOS 6.X系统](/blog/2023/11/16/vmware-build-small-centos-6.x/) 。

# 三、安装Salix

开机后，进入引导选择界面，直接回车选择默认：
{% asset_img 1.png %}

在命令中执行系统安装程序（setup）：
{% asset_img 2.png 启动系统安装程序 %}

选择键盘类型，保存当前键盘类型：
{% asset_img 3.png 选择键盘类型 %}

回车开始安装Salix：
{% asset_img 4.png 选择键盘类型 %}

### 1. 硬盘分区、格式化

上下键切换至 /dev/sda 磁盘，敲空格键选择 /dev/sda 磁盘，选中 Go 选项，回车开始磁盘分区：
{% asset_img 5.png 选择sda磁盘开始分区 %}

#### 1.1. 创建dos分区表

上下键切换分区表格式，选择dos，创建dos分区表:
{% asset_img 6.png 创建Dos分区表 %}

#### 1.2. 创建交换分区

选中 New 选项，敲击回车:
{% asset_img 7.png 创建交换分区 %}

交换分区大小设置为4G(根据实际情况自行设定)：
{% asset_img 8.png 创建交换分区 %}

选中为第一分区为: primary：
{% asset_img 9.png 选中为primary分区 %}

选中 Type，敲回车：
{% asset_img 10.png 修改磁盘格式类型 %}

选中 Linux swap，敲回车：
{% asset_img 11.png 修改磁盘格式为Linux swap %}

#### 1.3. 创建ext4分区

> 请根据实际需要进行自定义，当前只是简单演示

选中 New 选项，敲击回车:
{% asset_img 12.png 创建交换ext4分区 %}

分区大小设置为26G(根据实际情况自行设定)：
{% asset_img 13.png 创建交换ext4分区 %}

选中第一分区为 primary：
{% asset_img 14.png 选中为primary分区 %}

选中 Bootable 选项，设置为boot flag，敲回车：
{% asset_img 16.png 设置磁盘boottable flag %}


#### 1.4. 提交分区方案

如不再进行分区，则选中 Write 选项写入分区方案，敲回车：
{% asset_img 18.png 提交分区方案 %}

在确认写入分区方案提示中，输入 yes 回车确认：
{% asset_img 19.png 写入分区方案 %}

硬盘分区操作完毕。

#### 1.5. 启用swap分区

检测到 /dev/sda1 是交换分区，敲击回车启用交换分区：
{% asset_img 20.png 启用交换分区 %}

忽略交换分区磁盘检测，选中 No 选项，敲击回车：
{% asset_img 21.png 忽略交换分区磁盘检测 %}

交互分区启用提醒，意思是已经写入到配置文件 /etc/fstab:
{% asset_img 22.png 交互分区启用提醒 %}

#### 1.6. 选择磁盘分区挂载ROOT根目录

选择 /dev/sda2 分区，挂载系统根目录， 切换至 Select 敲回车提交：
{% asset_img 23.png 选择磁盘分区用于挂载ROOT根目录 %}

#### 1.7. 格式化/dev/sda2分区

选择 Format 选项，格式化并忽略检测磁盘， 切换至 ok 敲回车提交：
{% asset_img 24.png 格式化磁盘/dev/sda2分区 %}

选择 ext4 选项， 切换至 ok 敲回车提交：
{% asset_img 25.png 格式化/dev/sda2分区为ext4 %}

提示已经添加分区信息至配置文件 /etc/fstab ：
{% asset_img 26.png 提示分区信息已写入配置文件 %}

### 2. 安装系统

#### 2.1. 选择系统安装源

选择第2选项，从CD中安装系统：
{% asset_img 27.png 从CD中安装系统 %}

选择 auto 选项，自动扫描CD设备：
{% asset_img 28.png 从CD中安装系统 %}


#### 2.2. 选择安装模式

选择 BASIC 选择，安装一个最小的图形化环境：
{% asset_img 29.png 选择安装一个最小的图形化环境 %}

开始安装系统：
{% asset_img 30.png 开始安装系统 %}


#### 2.3. 安装系统引导

选择 simple 选项，尝试自动化安装 LILO 引导：
{% asset_img 31.png 尝试自动化安装 LILO 引导 %}

选择 standard 选项，使用一个标准的Linux控制台(安全选项)：
{% asset_img 32.png 使用一个标准的Linux控制台 %}

是否需要在引导系统的时候向内核传递参数，这里选择不需要， 直接选择 OK 回车提交：
{% asset_img 33.png 是否需要在引导系统的时候向内核传递参数 %}

选择LILO的安装方式，这里我们选择 MBR 选择：
{% asset_img 34.png 选择LILO引导 Root 方式安装 %}


### 3. 系统配置

#### 3.1. 配置网络

选择 Yes 回车，开始配置网络：
{% asset_img 35.png 开始配置网络 %}

配置主机名称：
{% asset_img 36.png 配置主机名称 %}

配置主机域名：
{% asset_img 37.png 配置主机域名 %}

配置VLAN ID，一些高级网络设置需要VLAN ID才能连接到网络， 这里选择 No：
{% asset_img 38.png 配置VLAN ID %}

配置ip地址， 这里现在配置静态ip：
{% asset_img 39.png 配置静态ip %}

配置ip v4地址：
{% asset_img 40.png 配置ip v4地址 %}

配置网关地址，这里输入192.168.168.2：
> DNS多少请查询 VMware Workstation 的【编辑】->【虚拟网络编辑器】->【VMnet8】->【NAT设置】, 获取其中的子网掩码，网关IP。
> 本文的DNS也就是网关IP【192.168.168.2】
{% asset_img 41.png 配置网关地址 %}

配置ip v6地址，这里不启用：
{% asset_img 42.png 配置ip v6地址 %}

是否需要访问nameserver， 这里选择是：
{% asset_img 43.png 是否需要访问nameserver %}

配置nameserver， 这里输入192.168.168.2：
{% asset_img 44.png 是否需要访问nameserver %}

检查所有的网络配置，选择 Accept 选择提交：
{% asset_img 45.png 检查所有的网络配置 %}

基础网络已配置：
{% asset_img 46.png 基础网络已配置 %}


#### 3.2. 配置时区、语言

选择 Yes 回车，开始配置时区：
{% asset_img 47.png 开始配置时区 %}

键入字母筛选，然后选择 Asia/Shanghai 回车：
{% asset_img 48.png 选择 Asia/Shanghai时区 %}

选择 zh_CN.utf8 回车：
{% asset_img 49.png 选择语言为中文 %}

选择 Yes 回车，开始Numlock：
{% asset_img 50.png 开始Numlock %}

#### 3.3. 配置用户

> 提示第一个创建的用户才可以通过 sudo 命令得到root权限，如果其他用户想获取root选项，需要添加用户到 wheel 组。
> 不创建用户，将会导致系统无法登录，因为root用户默认是被禁用的。

配置用户提醒，敲回车确认：
{% asset_img 51.png 配置用户 %}

选择1选项，创建用户
{% asset_img 52.png 创建用户 %}

输入用户名、密码：
{% asset_img 53.png 用户名 %}
{% asset_img 54.png 用户密码 %}

完成用户添加后，退出用户配置：
{% asset_img 55.png 创建用户 %}

#### 3.4. 配置软件源

选择 US 的软件源：
{% asset_img 56.png 选择美国的软件源 %}

#### 3.5. 重启系统

> 这里可以选择退出并回到命令行模式下， 然后可以执行 netsetup 重新配置网络等

重启系统：
{% asset_img 57.png 重启系统 %}



# 四、配置系统

## 1 修改主机名

```bash
echo 'salix' | sudo tee /etc/HOSTNAME
```

## 3. 配置网络

> DNS多少请查询 VMware Workstation 的【编辑】->【虚拟网络编辑器】->【VMnet8】->【NAT设置】, 获取其中的子网掩码，网关IP。
> 本文的DNS也就是网关IP【192.168.168.2】

```bash
sudo vi /etc/rc.d/rc.inet1.conf

# 或者图形化界面配置
sudo netsetup
```

重启系统生效：
```bash
sudo reboot
```

## 4. 配置openssh
```bash
cd /etc/ssh/sshd_config
sudo sed -i 's|^#PermitRootLogin prohibit-password|PermitRootLogin yes|' /etc/ssh/sshd_config
sudo sed -i 's|^#PubkeyAuthentication|PubkeyAuthentication|' /etc/ssh/sshd_config

sudo chmod +x /etc/rc.d/rc.sshd
sudo /etc/rc.d/rc.sshd start
```

加入开机启动配置：
```bash
#/etc/rc.d/rc.services 里有启动脚本，设置脚本可执行即可
sudo chmod +x /etc/rc.d/rc.sshd
```

查看客户机IP
```bash
ifconfig
```

远程连上客户机


## 5. 开启cron

加入本地启动项：
```bash
sudo chmod +x /etc/rc.d/rc.crond
```

添加定时任务：
```bash
sudo vi /var/spool/cron/crontabs/root
#或
sudo crontab -e
```

## 6. 修改时区

```bash
sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#或者通过命令界面设置
timeconfig
```

校验时间：
```bash
date +'%Y-%m-%d %T'
```

## 7. 修改软件源

> 官方可用源： [Salix Repository mirrors](https://docs.salixos.org/wiki/Repository_mirrors)

```bash
# 替换为美国的源
sudo sed -i 's|http://slackware.uk|http://mirrors.xmission.com|g' /etc/slapt-get/slapt-getrc
```

软件源缓存更新：
```bash
sudo slapt-get --add-keys
sudo slapt-get -u
```

安装软件：
```bash
# 查看使用说明
slapt-get -h

# 查找软件包
slapt-get --search htop

# 安装软件包
sudo slapt-get -i htop
```

## 8. 安装open-vm-tools

> 不推荐使用 slapt-get -i open-vm-tools 安装

选择当前客户机，点击右键，菜单栏选择 安装 VMware-Tools，挂载 VMware-Tools ISO 文件。

然后执行如下命令，进行安装：
```bash
mkdir -p /mnt/cdrom
sudo mount /dev/cdrom /mnt/cdrom
cp /mnt/cdrom/VMwareTools-*.tar.gz /tmp
cd /tmp && tar zxvf /tmp/VMwareTools-*.tar.gz

# 执行安装， 然后一路回车使用默认配置 
sudo /tmp/vmware-tools-distrib/vmware-install.pl

# 删除文件
rm -rf /tmp/VMwareTools-*.tar.gz
rm -rf /tmp/vmware-tools-distrib

#验证VMware-Tools
ls /mnt/hgfs/
#或者执行命令，查询刚刚共享的文件夹
vmware-hgfsclient

# 添加随机启动
sudo chmod +x /etc/rc.d/init.d/vmware-tools

# 查看运行等级
runlevel|awk '{print $2}'

# 根据运行等级，添加响应的软链
sudo ln -s /etc/rc.d/init.d/vmware-tools /etc/rc.d/rc4.d/S03vmware-tools
sudo ln -s /etc/rc.d/init.d/vmware-tools /etc/rc.d/rc4.d/K99vmware-tools
```

# 五、其他

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

# 六、参考资料

- [Salix 官方安装手册](https://guide.salixos.org/)
- [Guide slapt-get](https://guide.salixos.org/321slaptget.html)
- [parted分区命令使用示例](https://www.cnblogs.com/pipci/p/11372530.html)
- [Linux各主要发行版的包管理命令对照](https://www.cnblogs.com/huapox/p/3509640.html)

# 七、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->vmware-build-salix-15.x](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Fvmware-build-salix-15.x)
