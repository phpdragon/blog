---
title: VMware虚拟机安装FreeBSD12.4系统
date: 2023-11-17 19:30:30
categories: ['OS', 'Unix', 'FreeBSD']
tags: ['OS', 'Unix', 'FreeBSD', 'FreeBSD 12.4']
---

# 一、系统信息

> 虚拟机版本：
>
> 产品：VMware® Workstation 16 Pro
>
> 版本：16.1.2 build-17966106


# 二、前期准备

前往官网 [www.freebsd.org](https://www.freebsd.org/where/) 下载系统iso镜像包 [FreeBSD-12.4-RELEASE-amd64-dvd1.iso](https://download.freebsd.org/releases/amd64/amd64/ISO-IMAGES/12.4/FreeBSD-12.4-RELEASE-amd64-dvd1.iso) ，也可以使用其他版本，按实际需要下载。

国内下载地址：https://mirrors.aliyun.com/freebsd/releases/ISO-IMAGES/

中文社区：www.chinafreebsd.cn


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

选择 其他 版本 FreeBSD 12 64位, 点击下一步：
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

磁盘容量选择默认容量20G，单个文件存储(选择其他都行), 点击下一步：
![](/img/vmware/12.png)

## 13. 指定磁盘文件

选择磁盘文件（使用默认）, 点击下一步：
{% asset_img 13.png 指定磁盘文件 %}

## 14. 自定义硬件配置

点击自定义硬件，弹窗硬件窗口：
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

新建好的虚拟机FreeBSD-12.4-64开机
{% asset_img 19.png 虚拟机开机 %}

出现如下图界面时，直接按Enter键:
{% asset_img 20.png 开机选项界面 %}

## 2. 欢迎界面
直接选择安装（install）
{% asset_img 21.png 欢迎界面 %}

## 3. 选择键盘
选择键盘（Keymap Selection），选择默认的键盘（Continue with default keymap）然后按Enter键。
{% asset_img 22.png 选择键盘 %}

## 4. 设置主机名
设置主机名（Set Hostname），在这里输入 freebsd-12-4 , 然后按Tab键切换到OK，再按Enter键。
{% asset_img 23.png 设置主机名 %}

## 5. 系统组件选装

> lib32 : 兼容库文件， 用于在 64 位版本的 FreeBSD 上运行 32 位程序。
> 
> ports : FreeBSD的软件包管理器。
> 
> src   : 系统源代码

上下键切换选项，空格符选择你想要安装的组件。按Enter键提交。

这里选择只安装软件包管理器ports。
{% asset_img 24.png 系统组件选装 %}

## 6. 硬盘分区

选择磁盘分区方式？(How would you like to partition your disk?) 

磁盘分区方式选择UFS方式，然后按Enter键：
{% asset_img 25.png 硬盘分区 %}

> Would you like to use this entire disk（da0）for FreeBSD or partition it to share it with other operation system? Using the entire disk will erase any data currently stored three.
> 
> 你是想将整个磁盘(da0)用于FreeBSD还是将其分区以与其他操作系统共享?使用整个磁盘将擦除当前存储的所有数据。

选择整个硬盘（Entire Disk），按Enter键：
{% asset_img 26.png 选择整个硬盘 %}

## 7. 选择分区方案

磁盘分区方案选择UFS方式，按Enter键：
{% asset_img 27.png 选择分区方案 %}

## 8. 编辑分区

Partition Editor(编辑分区)，此处因为系统已自动分好，我们就不需要改动了，直接按Enter键就可：
{% asset_img 28.png 编辑分区 %}

> Your changes will now be written to disk. If you have chosen to overwrite existing data, it will be PERMANENTLY ERASED. Are you sure you want to commit your changes ?
> 
> 你的更改现在将被写入磁盘。如果你选择覆盖现有数据，它将被永久擦除。你确定要提交更改吗?

按 Tab 键选择 提交（Commit），按Enter键确认：
{% asset_img 29.png 覆盖现有数据确认 %}

## 9. 提前安装包

获取组件对应的文件：
{% asset_img 30.png 获取组件对应的文件 %}

验证组件文件:
{% asset_img 31.png 验证组件文件 %}

验证过的组件文件会被提取至磁盘:
{% asset_img 32.png 验证过的组件文件会被提取至磁盘 %}

## 10. 设置root密码

设置密码：（根据自己的情况设置密码）
{% asset_img 33.png 设置root密码 %}

## 11. 配置网络

选择默认即可，按Enter键确认：
{% asset_img 34.png 配置网络 %}

网络的设置，可以将IPV4和IPV6都选上，也可只选IPV4，按Enter键确认：
{% asset_img 35.png 选择IPV4? %}

选择DHCP自动分配ip地址，按Enter键确认：
{% asset_img 36.png 选择DHCP自动分配ip地址? %}

配置DNS解析地址，选择默认即可，按Enter键确认：
{% asset_img 37.png 配置DNS解析地址 %}

## 12. 选择地区时区

Time Zone Selector(时区选择)，在此我们选择: Asia -> China -> Bei jing Time ，按Enter键确认：

选择 Asia，按Enter键确认：
{% asset_img 38.png 选择地区 %}

选择 China，按Enter键确认：
{% asset_img 39.png 选择国家 %}

选择 Bei jing Time，按Enter键确认：
{% asset_img 40.png 选择时区 %}

按Enter键确认：
{% asset_img 41.png 确认时区 %}

## 13. 设置日期时间

选择日期，按Enter键确认：
{% asset_img 42.png 选择日期 %}

选择时间，按Enter键确认：
{% asset_img 43.png 选择时间 %}

## 14. 系统服务选装

> local_unbound : 本地缓存验证回收器
> 
> sshd          : ssh远程登录服务
> 
> moused        ：
> ntpdate       ：同步系统网络时间工具
> ntpd          ：同步系统网络时间服务
> powerd        ：动态调整CPU频率，如果硬件支持
> dumpdev       : 开启内核崩溃主动转存支/var/crash



System Configuration(系统配置)，在此我们选择：local_unbound、sshd、ntpdate、dumpdev，按Enter键确认：
{% asset_img 44.png 系统服务选装 %}

## 15. 系统安全加固

System Hardening(系统安全加固)，在此我们不选，按Enter键跳过：
{% asset_img 45.png 系统安全加固 %}


## 16. 添加用户
Add User Accounts(添加新用户)，在此我们添加一个test的用户，密码是****（也可以选择不添加，或者可以添加多个用户）；
{% asset_img 46.png 添加用户 %}

添加用户回显：
{% asset_img 47.png 添加用户回显 %}


## 17. 最终配置

> 所有的安装及配置完成后， 仍有机会对其进行修改。

如果需要重新修改可以重新进行设置。不需要进行其他的配置，请选择直接退出，按Enter键确认：
{% asset_img 48.png 最终配置 %}

我们在此添加一下系统的说明手册，当然前提是已经链接网络了，按Enter键确认：
{% asset_img 49.png 添加说明手册 %}

上下键选择空格键选中 en、zh_cn 两版手册，按Enter键确认：
{% asset_img 50.png 选择说明手册 %}

开始下载手册并安装：
{% asset_img 51.png 开始下载手册并安装 %}

如果其他调整，按Enter键确认提交：

## 18. 打开新系统的shell

> The installation is now finished. Before exiting the installer, would you like to open a shell in the new system to make any final manual modifications ?
> 
> 安装现在已经完成。在退出安装程序之前，您是否希望在新系统中打开shell以进行最后的手动修改?

是否在安装完毕之后选择打开新系统的shell进行其他操作？ 我们选择yes，按Enter键确认：
{% asset_img 52.png 是否在安装完毕之后选择打开新系统的shell进行其他操作 %}

## 19. 优化系统

在 /boot/loader.conf 里加入以下这行设定：
```bash
echo 'kern.hz=100' >> /boot/loader.conf
```
如果没有这项设定，VMware 上的 FreeBSD 客户 OS 空闲时将占用 iMac® 上一个 CPU 大约 15% 的资源。在修改此项设定之后仅为 5%。


## 20. 开启SSH

vi /etc/inet.conf 配置， 去除ssh的两行注释#， 允许root远程登录ssh：

> 注意请使用右侧的 del 键 删除， 按i键进入编辑模式无法删除内容，只可以添加。

{% asset_img 53.png 开启SSH端口放行 %}

vi /etc/ssh/sshd_config 配置， 查找PermitRootLogin关键词，去除前面的注释#，修改为yes， 允许root远程登录ssh：
{% asset_img 54.png 配置SSH %}

参考：[FreeBSD允许root用户通过SSH登陆 ](https://www.cnblogs.com/youbins/p/17662658.html)

## 21. 重启

```bash
reboot
```

查看ip，远程登录ssh, 开始进行其他操作。
```bash
ifconfig
```


# 五、设置软件源

## 1. 修改pkg源
> FreeBSD 中 pkg 源分为系统级和用户级两个源。不建议直接修改/etc/pkg/FreeBSD.conf，因为该文件会随着基本系统的更新而发生改变。

### 1.1 方式1-单源模式
创建一个用户级源配置文件，/usr/local/etc/pkg/repos/FreeBSD.conf
```bash
mkdir -p /usr/local/etc/pkg/repos
vi /usr/local/etc/pkg/repos/FreeBSD.conf
```

> 这个是中科大的源，如果不能用，可以将域名 mirrors.163.com 修改为以下可用源：mirrors.163.com、mirrors.ustc.edu.cn、mirrors.nju.edu.cn

```text
FreeBSD: {
  url: "http://mirrors.163.com/freebsd-pkg/${ABI}/quarterly",
}
```

> 若要获取滚动更新的包，请将 quarterly 修改为 latest。 
> 请注意，CURRENT 版本只有 latest。  
> 
> 若要使用https，请先安装security/ca_root_nss，并将 http 修改为 https。
> 
> 最后使用命令 pkg update -f 刷新缓存即可。


另一个FreeBSD中文社区可用源：
```text
FreeBSD: {
  url: "http://pkg0.nyi.freebsd.org/${ABI}/quarterly",
}
```

更新软件包
```bash
pkg update -f
```


### 1.2 方式2-多源模式

禁用FreeBSD源
```bash
echo "FreeBSD: { enabled: no }" > /usr/local/etc/pkg/repos/FreeBSD.conf
```
添加163源，`vi /usr/local/etc/pkg/repos/163.conf`：
```text
163: {  
    url: "http://mirrors.163.com/freebsd-pkg/${ABI}/quarterly",  
    mirror_type: "srv",  
    signature_type: "none",  
    fingerprints: "/usr/share/keys/pkg",  
    enabled: yes
}
```


添加南京大学源，`vi /usr/local/etc/pkg/repos/nju.conf`：
```text
nju: {
    url: "http://mirrors.nju.edu.cn/freebsd-pkg/${ABI}/quarterly",  
    mirror_type: "srv",  
    signature_type: "none",  
    fingerprints: "/usr/share/keys/pkg",  
    enabled: yes
}
```

添加中国科学技术大学源 `vi /usr/local/etc/pkg/repos/ustc.conf`：
```text
ustc : {
  url: "http://mirrors.ustc.edu.cn/freebsd-pkg/${ABI}/latest",
  mirror_type: "srv",
  signature_type: "none",
  fingerprints: "/usr/share/keys/pkg",
  enabled: yes 
}
```

验证当前生效源

使用 `pkg -vv` 命令可以打印当前 PKG 的配置信息，以及所有生效源配置：

```text
Version                 : 1.20.8
PKG_DBDIR = "/var/db/pkg";
PKG_CACHEDIR = "/var/cache/pkg";
PORTSDIR = "/usr/ports";
INDEXDIR = "";
INDEXFILE = "INDEX-12";
HANDLE_RC_SCRIPTS = false;
DEFAULT_ALWAYS_YES = false;
ASSUME_ALWAYS_YES = false;
REPOS_DIR [
    "/etc/pkg/",
    "/usr/local/etc/pkg/repos/",
]
PLIST_KEYWORDS_DIR = "";
SYSLOG = true;
ABI = "FreeBSD:12:amd64";
ALTABI = "freebsd:12:x86:64";
DEVELOPER_MODE = false;
VULNXML_SITE = "http://vuxml.freebsd.org/freebsd/vuln.xml.xz";
FETCH_RETRY = 3;
PKG_PLUGINS_DIR = "/usr/local/lib/pkg/";
PKG_ENABLE_PLUGINS = true;
PLUGINS [
]
DEBUG_SCRIPTS = false;
PLUGINS_CONF_DIR = "/usr/local/etc/pkg/";
PERMISSIVE = false;
REPO_AUTOUPDATE = true;
NAMESERVER = "";
HTTP_USER_AGENT = "pkg/1.20.8";
EVENT_PIPE = "";
FETCH_TIMEOUT = 30;
UNSET_TIMESTAMP = false;
SSH_RESTRICT_DIR = "";
PKG_ENV {
}
PKG_SSH_ARGS = "";
DEBUG_LEVEL = 0;
ALIAS {
    all-depends = "query %dn-%dv";
    annotations = "info -A";
    build-depends = "info -qd";
    cinfo = "info -Cx";
    comment = "query -i \"%c\"";
    csearch = "search -Cx";
    desc = "query -i \"%e\"";
    download = "fetch";
    iinfo = "info -ix";
    isearch = "search -ix";
    prime-list = "query -e '%a = 0' '%n'";
    prime-origins = "query -e '%a = 0' '%o'";
    leaf = "query -e '%#r == 0' '%n-%v'";
    list = "info -ql";
    noauto = "query -e '%a == 0' '%n-%v'";
    options = "query -i \"%n - %Ok: %Ov\"";
    origin = "info -qo";
    orphans = "version -vRl?";
    provided-depends = "info -qb";
    rall-depends = "rquery %dn-%dv";
    raw = "info -R";
    rcomment = "rquery -i \"%c\"";
    rdesc = "rquery -i \"%e\"";
    required-depends = "info -qr";
    roptions = "rquery -i \"%n - %Ok: %Ov\"";
    shared-depends = "info -qB";
    show = "info -f -k";
    size = "info -sq";
    unmaintained = "query -e '%m = \"ports@FreeBSD.org\"' '%o (%w)'";
    runmaintained = "rquery -e '%m = \"ports@FreeBSD.org\"' '%o (%w)'";
}
CUDF_SOLVER = "";
SAT_SOLVER = "";
RUN_SCRIPTS = true;
CASE_SENSITIVE_MATCH = false;
LOCK_WAIT = 1;
LOCK_RETRIES = 5;
SQLITE_PROFILE = false;
WORKERS_COUNT = 0;
READ_LOCK = false;
IP_VERSION = 0;
AUTOMERGE = true;
VERSION_SOURCE = "";
CONSERVATIVE_UPGRADE = true;
PKG_CREATE_VERBOSE = false;
AUTOCLEAN = false;
DOT_FILE = "";
REPOSITORIES {
}
VALID_URL_SCHEME [
    "pkg+http",
    "pkg+https",
    "https",
    "http",
    "file",
    "ssh",
    "tcp",
]
ALLOW_BASE_SHLIBS = false;
WARN_SIZE_LIMIT = 1048576;
METALOG = "";
OSVERSION = 1204000;
IGNORE_OSVERSION = false;
BACKUP_LIBRARIES = false;
BACKUP_LIBRARY_PATH = "/usr/local/lib/compat/pkg";
PKG_TRIGGERS_DIR = "/usr/local/share/pkg/triggers";
PKG_TRIGGERS_ENABLE = true;
AUDIT_IGNORE_GLOB [
]
AUDIT_IGNORE_REGEX [
]
COMPRESSION_FORMAT = "";
COMPRESSION_LEVEL = -1;
ARCHIVE_SYMLINK = false;
REPO_ACCEPT_LEGACY_PKG = false;
FILES_IGNORE_GLOB [
]
FILES_IGNORE_REGEX [
]


Repositories:
  163: { 
    url             : "http://mirrors.163.com/freebsd-pkg/FreeBSD:12:amd64/quarterly",
    enabled         : yes,
    priority        : 0,
    mirror_type     : "SRV",
    fingerprints    : "/usr/share/keys/pkg"
  }
  nju: { 
    url             : "http://mirrors.nju.edu.cn/freebsd-pkg/FreeBSD:12:amd64/quarterly",
    enabled         : yes,
    priority        : 0,
    mirror_type     : "SRV",
    fingerprints    : "/usr/share/keys/pkg"
  }
  ustc: { 
    url             : "http://mirrors.ustc.edu.cn/freebsd-pkg/FreeBSD:12:amd64/latest",
    enabled         : yes,
    priority        : 0,
    mirror_type     : "SRV",
    fingerprints    : "/usr/share/keys/pkg"
  }
```


更新软件包
```bash
pkg update -f

#更新某个某个想要使用的源, -f 表示强制更新
pkg update -f -r 163
```


测试软件安装：
```bash
pkg install wget
```


## 2. 修改ports源

先安装axel加速工具
```bash
pkg install axel
```

创建或修改文件 `vi /etc/make.conf`
```bash
# content of make.conf
#-n 30 表示使用30个线程下载
FETCH_CMD=axel -n 30 -a 
DISABLE_SIZE=yes
MASTER_SITE_OVERRIDE?=http://mirrors.ustc.edu.cn/freebsd-ports/distfiles/${DIST_SUBDIR}/
```

安装 ports 升级工具 portmaster 试试效果：
```bash
cd /usr/ports/ports-mgmt/portmaster
make install clean
```

portmaster是ports的升级工具，使用基本上就用：
```bash
portmaster -a
```


# 六、安装vm-tools

> 对于台式机系统（带有X11）: pkg install open-vm-tools
>
> 对于服务器系统（非X11）: pkg install open-vm-tools-nox11

```bash
pkg install open-vm-tools-nox11 xf86-video-vmware xf86-input-vmmouse
```

查看是否运行
```bash
ps -fU root | grep vmtoolsd
```
如果没有则：
```bash
/usr/local/etc/rc.d/vmware-guestd start
```


编辑 `vi /etc/rc.conf`
```text
#添加如下内容：
hald_enable="YES" 
moused_enable="YES" 
dbus_enable="YES" 
vmware_guest_vmblock_enable="YES"
vmware_guest_vmhgfs_enable="YES"
vmware_guest_vmmemctl_enable="YES"
vmware_guest_vmxnet_enable="YES"
vmware_guestd_enable="YES"
```

编辑 `vi /boot/loader.conf`
```text
#添加如下内容：
#vmware-shared-folder
fuse_load="YES"
```

编辑 `vi /etc/fstab`
```text
#添加如下内容：
.host:/       /mnt/hgfs     vmhgfs-fuse     failok,rw,allow_other,mountprog=/usr/local/bin/vmhgfs-fuse    0       0
```

创建挂载目录/mnt/hgfs :
```bash
mkdir -p /mnt/hgfs
```

重启虚拟机
```bash
reboot

#查看共享文件夹
vmware-hgfsclient

ls /mnt/hgfs
```
有目录在则表明安装成功。桌面端安装请查看： [freeBSD13 安装vmtools](https://zhuanlan.zhihu.com/p/370823256) 、[How to install vmware tools freebsd ?](https://twiserandom.com/freebsd/how-to-install-vmware-tools-freebsd/index.html) 。

参考： [Freebsd下配置vmware tools](https://www.jianshu.com/p/d4e32dbfe1e6)、[VMware 给 FreeBSD 13 安装 KDE 桌面](https://www.cnblogs.com/Huae/p/16282092.html)


-----------------


# 七、参考资料

- [官方安装手册-安装FreeBSD](https://docs.freebsd.org/zh-cn/books/handbook/bsdinstall/)
- [FreeBSD镜像使用帮助](https://debian.bjtu.edu.cn/help/freebsd/)
- [FreeBSD修改为国内源](https://blog.csdn.net/qu6zhi/article/details/122439153)
- [FreeBSD更换国内源](https://blog.csdn.net/xie__peng/article/details/129280246)
- [FreeBSD 换源方法 2021 非官方镜像站](https://zhuanlan.zhihu.com/p/359251674)
- [FreeBSD系统配置](https://www.chinafreebsd.cn/article/59da60970cb81)


# 八、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->vmware-build-freebsd-12-4](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Fvmware-build-freebsd-12-4)