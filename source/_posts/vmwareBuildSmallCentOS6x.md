---
title: VMware虚拟机最小化安装CentOS 6.X系统
date: 2023-11-16 19:07:59
tags:
---

# 一、系统信息

> 虚拟机版本：
>
> 产品：VMware® Workstation 16 Pro
>
> 版本：16.1.2 build-17966106

# 二、前期准备

1.下载系统iso镜像包，[CentOS-6.0-x86_64-minimal.iso](https://mirrors.tuna.tsinghua.edu.cn/centos-vault/6.0/isos/x86_64/CentOS-6.0-x86_64-minimal.iso) ，也可以使用6系列的其他版本，按实际需要下载

下载地址: https://mirrors.tuna.tsinghua.edu.cn/centos-vault/6.0/isos/x86_64/

阿里备用地址：https://mirrors.aliyun.com/centos-vault/6.0/isos/x86_64/

网易备用地址：http://mirrors.163.com/centos-vault/6.0/isos/x86_64/


# 三、新建虚拟机

## 1. 新建虚拟机

菜单 -> 文件 -> 新建虚拟机, 选择自定义, 点击下一步：

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4ad93030b2874663a672745030276219~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=497&h=429&s=29537&e=png&b=cce8cf)

## 2. 选择兼容性

选择兼容性， Workstation 16.x, 点击下一步：

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0add9b5e42ec4ffb82fd4d786e368c37~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=497&h=425&s=19739&e=png&b=f0f0f0)

## 3. 如何安装操作系统

选择稍后安装操作系统, 点击下一步：

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2e0b5b5367424993be75ccbf311869ee~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=497&h=427&s=19154&e=png&b=efefef)

## 4. 选择操作系统版本

选择 Linux 版本  CentOS 6 64位, 点击下一步：

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ac433462ccc5480ba436b9e6d499b0d4~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=497&h=426&s=16062&e=png&b=f0f0f0)

## 5. 命名虚拟机

输入虚拟机名称, 点击下一步：

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/454fab4f62754b82832bafc856704b44~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=497&h=428&s=14853&e=png&b=f2f2f2)

## 6. 处理器配置

设置处理器配置，根据物理机实际CPU核心来自由设置, 点击下一步：

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dbc435abe77d4e48992efa1fb71e5e3a~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=497&h=428&s=13485&e=png&b=f1f1f1)

## 7. 虚拟机内存配置

设置虚拟机内存，根据物理机实际内存大小自由设置, 点击下一步：

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2a6d6e75ee75403c89ad52fab6aef830~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=497&h=429&s=20400&e=png&b=f1f1f1)

## 8. 网络类型配置

网络类型设置选择默认（使用网络地址转换NAT类型）, 点击下一步：

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/de8a3abd305f42239db637c6eef08639~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=497&h=429&s=20875&e=png&b=f1f1f1)

## 9. I/O控制器配置

I/O控制器选择默认（LSI LOGIC）, 点击下一步：

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/03005370b60c4ee08fbdc0bdb58d2db7~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=497&h=427&s=17052&e=png&b=f0f0f0)

## 10. 选择磁盘类型

磁盘类型选择默认（SCSI）, 点击下一步：

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/53d80bcb1c634937a7828989bcc7399c~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=497&h=427&s=13610&e=png&b=f0f0f0)

## 11. 如何使用磁盘

选择新建虚拟磁盘, 点击下一步：

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1cf97fbbeb56498b996aaff961500da1~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=497&h=425&s=20399&e=png&b=f1f1f1)

## 12. 磁盘容量配置

磁盘容量选择默认容量20G，单个文件存储(选择其他都行), 点击下一步：

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/fb16a660f8f04ae18101926552d2817c~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=497&h=429&s=22479&e=png&b=f1f1f1)

## 13. 指定磁盘文件

选择磁盘文件（啥也不输入）, 点击下一步：

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6c6ba4392f0942ba833d0f010935d68f~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=497&h=426&s=13657&e=png&b=f0f0f0)

## 14. 自定义硬件配置

点击自定义硬件，弹窗硬件窗口：

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/65f10d3c7a5f4597be19e0d0e9bd9181~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=497&h=427&s=19931&e=png&b=f1f1f1)

## 15. CD/DVD配置

编辑 CD/DVD 配置项，选择你下载好的IOS映像文件, 再点击窗口的关闭：

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b9dabadfb9e5475cadc77ec675166eb3~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=728&h=309&s=21087&e=png&b=f9f9f9)

然后点击完成， 完成虚拟机的创建。

## 16 配置共享文件夹

编辑虚拟机配置，弹出虚拟机配置窗口，再点击添加：

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5bd9dc8f42ba4e1a9ea9b1b38de79956~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=718&h=450&s=31083&e=png&b=fbfbfb)

选择想要共享的文件夹：

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1d8d0ef1b2c3486bbea87a60f3357f24~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=497&h=405&s=12372&e=png&b=f1f1f1)

点击下一步，选择启用此共享，再点击完成。 然后启动客户机


-------------------


# 四、安装操作系统

## 1. 开机

新建好的虚拟机CentOS_6_64_MINI开机

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d06ea9f06e634c21b65c7281dfd9e4d3~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=314&h=368&s=16203&e=png&b=ffffff)

## 2. 选择启动项

进入开机画面，选择第一项安装系统，敲回车确认，开始安装虚拟机:

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ddf0ecb7c3404a79842fc037ac41cf31~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=640&h=480&s=469209&e=png&b=0e1a40)

## 3. 测试硬件媒体

使用Tab键，选中Skip选项，跳过测试步骤:

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b644c29f198f48e0a9ca9df52aa708e9~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=720&h=400&s=20072&e=png&b=0000aa)

显示检测到了本地安装媒体：

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ce499a87bb3843548fb9374eea9a766c~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=720&h=400&s=13329&e=png&b=0000aa)

## 4. 配置安装系统

进入配置安装界面，点击下一步：

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0086d283c3eb4c548350ae114c594140~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=958&h=621&s=210857&e=png&b=edeceb)

## 5. 选择系统语言

语言选择默认（English），点击下一步：

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/fcdcdc0481504d69a628f0c0903b68db~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=398&h=274&s=23391&e=png&b=f9f8f8)

## 6. 选择键盘类型

键盘类型选择默认（U.S.English），点击下一步：

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/722b7202109b4f15836369670ab1ff91~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=329&h=393&s=18463&e=png&b=fafafa)

## 7. 选择安装的设备类型

选择默认第一个选项（Basic Storage Devices 基本存储设备），点击下一步：

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a7c5febfdc7349d2a137af39f80da156~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=643&h=178&s=21045&e=png&b=ecebea)

## 8. 写入存储设备警告

弹出警告，确认是否重新格式化所有硬盘数据，选择丢弃所有数据（Yes，discard any data）：

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4076b6e873444421b398cf6b93e5624a~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=639&h=371&s=48180&e=png&b=ecebea)

## 9. 配置系统名称

输入主机名称：

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/285a37d9c29d4d5c974bbd0bbcc905d0~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=375&h=137&s=9944&e=png&b=eeedec)

## 10. 配置系统网络

右下角点击 Configure Network , 配置网络：

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2a328f94f5f04bf4babd362a7ff0638d~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=456&h=325&s=23721&e=png&b=f4f3f3)

编辑网络，修改为eth0(也可不改)， 勾选自动连接网络，然后点击关闭，再点击下一步：

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5bc74546a3ae4860a5380dcc3de34128~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=433&h=267&s=23889&e=png&b=f1f0ef)

## 11. 配置系统时区

选择时区为上海：

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8a27b3c24a6142c697a7be6261305e4b~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=560&h=358&s=84298&e=png&b=eae8e5)

## 12. 设置Root用户密码

设置Root用户密码，密码过于简单会弹窗再次确认：

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8ed918197f5546f4bb83cc13a4eab10a~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=388&h=152&s=13413&e=png&b=f0efee)

## 13. 选择安装到硬盘的类型

选择使用所有硬盘空间（Use All Space），你也可以进行自定义分区，在右下角勾选【Review and modify partitioning layout】，点击下一步：

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/344ec951fc924ea2822384ab651cd83d~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=726&h=390&s=58039&e=png&b=ecebea)

## 14. 写入配置到硬盘警告

确认将修改写入硬盘（Write changes to disk）

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b9455c55f39d4ac68b00cad013ced27e~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=393&h=182&s=18274&e=png&b=edeceb)认

## 15. 开启系统安装

显示安装进程：

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f8c047149b4a4fda95637605bff535c0~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=426&h=118&s=9052&e=png&b=edeceb)

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/eb4585d796ca49e7a84cee8661d2047c~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=1020&h=360&s=213464&e=png&b=ecebea)

## 16. 系统安装完毕重启

17.显示系统安装完毕， 点击 Reboot 重启系统：

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/befe99b55dff4b398b3642e268080a7c~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=961&h=514&s=50907&e=png&b=edeceb)

# 五、配置虚拟机

## 1. 登录root用户

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/be0983f2f0ba44fbb8a325661d44dd86~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=419&h=111&s=4336&e=png&b=000000)

## 2. 配置SSH

配置ssh可以远程登录root账户, 控制台执行下面命令：

去除：PermitRootLogin 前面的 # 注释 
```shell
sed -i 's|^#PermitRootLogin yes|PermitRootLogin yes|g' /etc/ssh/sshd_config
```

如图所示：

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f90d7b583b654331a47baf2efa9bf13b~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=738&h=400&s=24842&e=png&b=000000)

## 3. 重启sshd服务

```shell
service sshd restart
```

## 4. 查看ip地址

```shell
ip addr
```
然后远程登录到虚拟机

## 5. 修改软件源

> 因为 CentOS 6系列早已停止维护更新， 所以要使用如下CentOS过期软件源进行替换：
> 
> 阿里云：http://mirrors.aliyun.com/centos-vault/
> 
> 腾讯云：http://mirrors.cloud.tencent.com/centos-vault/
> 
> 华为云：http://mirrors.huaweicloud.com/centos-vault/
> 
> 清华： http://mirrors.tuna.tsinghua.edu.cn/centos-vault/
> 
> 网易： http://mirrors.163.com/centos-vault/
> 
> 国外：
> 
> CentOS: http://vault.centos.org
> 
> 备用1：http://archive.kernel.org/centos-vault
> 
> 备用2：http://mirror.nsc.liu.se/centos-store/
> 
> 备用3：linuxsoft：http://linuxsoft.cern.ch/centos-vault/


修改软件源为阿里云软件源：
> 注意，下面只针对CentOS 6.0, 假如是安装6.3版本， 那么请更换掉命令中的 6.0 字眼
> 
> 实际是链接: http://mirror.centos.org/centos/$releasever
> 
> 替换成如下: http://mirrors.aliyun.com/centos-vault/6.0



```shell
# 只针对于 CentOS 6.0 
sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://mirror.centos.org/centos/$releasever|baseurl=http://mirrors.aliyun.com/centos-vault/6.0|g' \
    -i.bak \
    /etc/yum.repos.d/CentOS-*.repo

yum clean all 
yum makecache
```

推荐使用清华软件源的替换脚本：[CentOS Vault 软件仓库使用帮助](https://mirrors.tuna.tsinghua.edu.cn/help/centos-vault/)

南京大学软件源替换脚本：[CentOS Vault 软件仓库镜像使用帮助](https://mirror.nju.edu.cn/centos-vault/)


## 6. 关闭防火墙

```shell
service iptables stop      #关闭防火墙
service ip6tables stop
chkconfig iptables off     #关闭随机启动
chkconfig ip6tables off

service iptables status    #查看防火墙状态
service ip6tables status
```


## 7. 关闭SELinux

设置 SELINUX=disabled 

```shell
sed -i 's|^SELINUX=enforcing|SELINUX=disabled|g' /etc/selinux/config
```

或者编辑 /etc/selinux/config 文件

```shell
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

## 8. 安装VMware-Tools

### 8.1 关闭虚拟机

控制台输入 poweroof, 或者菜单栏选择 关闭客户机


### 8.2 挂载 VMware-Tools ISO 文件

选择客户机，点击右键，菜单栏选择 安装 VMware-Tools 

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c7233351c13c4d7a92767473d793e52a~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=370&h=415&s=20458&e=png&b=f7f7f7)

控制台执行如下命令挂载ISO文件：

```shell
mkdir /mnt/cdrom 
mount /dev/cdrom /mnt/cdrom/ 
```

### 8.3 安装 VMware-Tools

> 安装过程中遇到 yes/no 就 yes; 
> 
> 如果遇到其他提示，比如只有一个yes或者只有一个no，则直接回车即可。

安装命令如下：

```shell 
cp /mnt/cdrom/VMwareTools-*.tar.gz /tmp && cd /tmp
tar zxvf /tmp/VMwareTools-*.tar.gz 

#安装脚本执行器
yum -y install perl

# 执行安装， 然后一路回车使用默认配置 
/tmp/vmware-tools-distrib/vmware-install.pl 

# 删除文件
rm -rf /tmp/VMwareTools-*.tar.gz
rm -rf /tmp/vmware-tools-distrib
```



### 8.4 验证VMware-Tools

> /mnt/hgfs/ 目录下有文件说明安装成功

```shell
reboot
ls /mnt/hgfs/

#或者执行命令，查询刚刚共享的文件夹
vmware-hgfsclient
```


## 9. 安装基础软件包

```shell
#基础包
yum -y groupinstall base

#编译工具
yum -y install gcc gcc-c++ make autoconf cmake patch

#系统工具
yum -y install psmisc net-tools lsof

#类库
yum -y install pcre pcre-devel
yum -y install zlib zlib-devel
yum -y install openssl openssl-devel

#常用工具
yum -y install unzip zip lrzsz vim wget

#升级所有软件包 
yum -y update
```

## 10. 设置系统语言

```shell
echo 'LANG="en_US.UTF-8"' > /etc/locale.conf
```

## 11. 设置时间同步

```shell
yum -y install ntpdate

crontab -e
#加入下文内容

#每分钟同步internet时间
*/1 * * * * /usr/sbin/ntpdate cn.pool.ntp.org && /usr/sbin/hwclock -w
```


## 12. 升级支持TLS1.2协议

### 12.1 背景：

> 为何要升级？
> 
> 时间追溯到2018年，四大Web 浏览器巨头（苹果、谷歌、Mozilla、微软）发表了一项史无前例的联合声明，
> 宣布在2020年初禁用TLS 1.0和TLS 1.1支持的决定。
> 
> 所以意味着还在使用TLS 1.2以下协议的软件无法正常访问HTTPS协议服务了，所以才需要升级。


### 12.2 问题现状：
```
[root@centos-6 ~]# curl https://www.openssl.org/source/old/1.0.1/openssl-1.0.1e.tar.gz
curl: (35) SSL connect error

[root@centos-6 ~]# wget https://www.openssl.org/source/old/1.0.1/openssl-1.0.1e.tar.gz
--2023-11-13 20:07:56--  https://www.openssl.org/source/old/1.0.1/openssl-1.0.1e.tar.gz
Resolving www.openssl.org... 2.17.62.8, 2600:1417:76:788::c1e, 2600:1417:76:796::c1e
Connecting www.openssl.org|2.17.62.8|:443... connected。
OpenSSL: error:1407742E:SSL routines:SSL23_GET_SERVER_HELLO:tlsv1 alert protocol version
Unable to establish SSL connection。
```

### 12.3 问题分析：

诚然，博主已经知道问题是出在哪，所以下面的分析是以结果反推答案。

#### 12.3-1. 分析curl的依赖关系：

```shell
[root@centos-6 ~]# yum deplist curl | grep libssh2
  dependency: libssh2.so.1()(64bit)
   provider: libssh2.x86_64 1.2.2-7.el6

[root@centos-6 ~]# yum deplist libssh2 | grep libssl
  dependency: libssl.so.10
  dependency: libssl.so.10()(64bit)
```
显示有依赖libssh2, libssh2  又依赖 libssl.so.10 这个动态链接库。


#### 12.3-2. 分析依赖wget的关系：

```shell
[root@centos-6 ~]# yum deplist wget | grep libssl
  dependency: libssl.so.10()(64bit)
```

那么通过curl、wget的依赖关系，发现指向一个共同的动态链接库libssl.so.10、libcrypto.so.10，那么这两个动态链接库是谁提供的呢？ 

```shell
[root@centos-6 ~]# rpm -ql openssl | grep libssl.so.10
/usr/lib64/.libssl.so.10.hmac
/usr/lib64/libssl.so.10

[root@centos-6 ~]# rpm -ql openssl | grep libcrypto.so.10
/usr/lib64/.libcrypto.so.10.hmac
/usr/lib64/libcrypto.so.10
```

所以证明结论，需要升级Openssl便可解决。


### 12.4 升级Openssl版本不低于1.0.1

> wget、curl、openssh等依赖OpenSSL的动态链接库, 其依赖版本低于1.0.1的都不支持TLS1.2协议，所以存量老机器需要更新openssl用于支撑TLS1.2协议。

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ef2be1e8f69b49008a45a74972b6c36a~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=756&h=354&s=37776&e=png&b=ffffff)


本文选择升级openssl至1.0.1e，为何不使用更新的版本？

> 主要是CentOS 6.X 系统的yum安装PHP版本默认是php-5.3.3。
>
> 为了支持php支持openssl扩展，目前只测得这个版本可以编译出.so文件。
>
> 其次这个版本也支持TLS1.2版本，访问https服务不会报错。

前往官网[www.openssl.org](https://www.openssl.org/source/old/1.0.1)下载 [openssl-1.0.1e.tar.gz](https://www.openssl.org/source/old/1.0.1/openssl-1.0.1e.tar.gz), 通过共享目录上传至客户机：

备份：
```
#先安装一下
cd /usr/local/src
tar cvf ./openssl.tar /usr/bin/openssl
tar -r -f ./openssl.tar /etc/ssl
tar -r -f ./openssl.tar /etc/pki/CA
tar -r -f ./openssl.tar /etc/pki/tls
tar -r -f ./openssl.tar /usr/lib64/libcrypto.so.1.0.0
tar -r -f ./openssl.tar /usr/lib64/libcrypto.so.10
tar -r -f ./openssl.tar /usr/lib64/libssl.so.1.0.0
tar -r -f ./openssl.tar /usr/lib64/libssl.so.10
tar -r -f ./openssl.tar /usr/lib64/openssl
tar -r -f ./openssl.tar /usr/lib64/libcrypto.so
tar -r -f ./openssl.tar /usr/lib64/libssl.so
tar -r -f ./openssl.tar /usr/lib64/pkgconfig
tar -r -f ./openssl.tar /usr/include/openssl
mv ./openssl.tar ~/
```


编译安装：
```shell
#openssl需要zlib库支持
yum -y install zlib zlib-devel

cd /usr/local/src
tar zxvf openssl-*.tar.gz
cd openssl-1.0.1e

#./config --help 查看其他参数
#--prefix使用 /usr 参数的目的是覆盖原有版本
./config --prefix=/usr --openssldir=/etc/pki/tls shared zlib

make
make install

#查看版本
openssl version -a
```

升级完毕后请不要断开远程登录，继续升级Openssh


### 12.5 升级Openssh-8.5p1

> 如果升级了Openssl不升级Openssh， 断开远程登录后将无法再远程上客户机
> 
> 会报如下错误：

```shell
[root@centos-6 openssl-1.0.1e]# service sshd restart
Stopping sshd:                                             [  OK  ]
Starting sshd: OpenSSL version mismatch. Built against 10000003, you have 1000105f
                                                           [FAILED]
```

前往官网 [www.openssh.com](http://www.openssh.com) 获取下载链接 ，选择版本 [openssh-8.5p1.tar.gz](https://mirrors.aliyun.com/pub/OpenBSD/OpenSSH/portable/openssh-8.5p1.tar.gz)。
请不要选择最新版本，最新版本不兼容openssl-1.0.1e的编译，如果选择最新版本，请尝试升级至其他版本Openssl。

开始安装：
```shell
#安装依赖
yum -y install pam-devel

cd /usr/local/src
tar zxvf openssh-8.5p1.tar.gz
cd openssh-8.5p1

./configure --prefix=/usr --sysconfdir=/etc/ssh --with-pam --with-zlib --with-md5-passwords --with-ssl-dir=/usr

make && make install

#查看版本
ssh -V

#重启
service sshd restart
```

修复重启报不支持参数警告：
```shell
sed -i 's|^GSSAPIAuthentication yes|#GSSAPIAuthentication yes|g' /etc/ssh/sshd_config
sed -i 's|^GSSAPICleanupCredentials yes|#GSSAPICleanupCredentials yes|g' /etc/ssh/sshd_config

#重启
service sshd restart
```


### 12.6 升级curl-8.4.0

前往官网[curl.se](https://curl.se/download) 下载 [curl-8.4.0.tar.gz](https://curl.se/download/curl-8.4.0.tar.gz)：

开始编译安装：
```shell
cd /usr/local/src
tar zxvf curl-8.4.0.tar.gz
cd curl-8.4.0

#./configure --help 查看其他编译参数
./configure --with-openssl=/usr

make && make install

unlink /usr/bin/curl
ln -s /usr/local/bin/curl /usr/bin/curl

#查看版本
curl -V
```

添加别名忽略证书检查：
```shell
vi ~/.bashrc 
    alias curl='curl -k'

#重新加载环境
source ~/.bashrc

#下载测试
curl https://www.openssl.org/source/old/1.0.1/openssl-1.0.1e.tar.gz -o /tmp/test.tar.gz
ll /tmp/test.tar.gz && unlink /tmp/test.tar.gz
```


### 12.7 升级wget-1.20.1

前往下载版本 [wget-1.20.1.tar.gz](https://ftp.gnu.org/gnu/wget/wget-1.20.1.tar.gz) 

编译安装：
```shell
cd /usr/local/src
tar zxvf wget-1.20.1.tar.gz
cd wget-1.20.1

./configure --prefix=/usr --with-ssl=openssl --with-openssl=yes --with-libssl-prefix=/usr

make && make install

#查看版本
wget -V | grep 'GNU Wget'
```


添加别名忽略证书检查：
```shell
vi ~/.bashrc 
    alias wget='wget --no-check-certificate'

#重新加载环境
source ~/.bashrc

#下载测试
wget https://www.openssl.org/source/old/1.0.1/openssl-1.0.1e.tar.gz
ll ./openssl-1.0.1e.tar.gz && unlink ./openssl-1.0.1e.tar.gz
```


# 六、参考：

[离线更新centos系统的openssh，升级到9.3p1](https://blog.csdn.net/qq_43913213/article/details/131510476)


# 七、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->juejin->7300564263345618995](https://pan.baidu.com/s/1PilxMDxpeAbL92M6zJnFtA?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Fjuejin%2F7300564263345618995)