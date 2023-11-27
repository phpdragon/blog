---
title: VMware虚拟机安装TinyCore-Pure-14.0
date: 2023-11-18 22:55:24
categories: ['OS', 'Linux', 'TinyCore']
tags: ['OS', 'Linux', 'TinyCore', 'TinyCore 14.0']
---

# 一、前言

TinyCore是一款体积极小且高度可扩展性的微型Linux发行版，小得让人叹为观止：终端版本只有11MB，而图形界面版本多了5MB。单单一个常见的镜像文件就要在GB上下徘徊，结果它一出手就惊艳四座，被誉为世界上最小的发行版操作系统，连古董机都可以跑得贼顺畅。

# 二、准备工作

> 虚拟机版本：
>
> 产品：VMware® Workstation 16 Pro
>
> 版本：16.1.2 build-17966106

## 1.下载系统包

前往官网下载页面[Downloads Tiny Core Linux](http://tinycorelinux.net/downloads.html)，下载所需要的版本：
x86版本: [TinyCore-14.0.iso](http://tinycorelinux.net/14.x/x86/release/TinyCore-14.0.iso)
x86_64位版本: [CorePure64-14.0.iso](http://tinycorelinux.net/14.x/x86_64/release/CorePure64-14.0.iso)

## 2.新建虚拟机

> 注意，磁盘类型不要选择SCSI模式，否则无法识别硬盘。请选择【SATA】或其他类型。

|  配置名称  |  配置值  |
|  --  |  --  |
|客户机操作系统-版本| Linux - 其他Linux5.x及更高版本内核64位|
|磁盘类型：        |   SATA|
|网络适配器：       |  NAT|

新建虚拟机过程请参考：[VMware虚拟机最小化安装CentOS 6.X系统](/blog/2023/11/16/vmware-build-small-centos-6.x/) 。

# 三、安装TinyCore

## 1. 虚拟机开机

开机后，进入引导选择界面，直接回车选择 Boot TinyCorePure64，进入桌面：
{% asset_img 1.png %}


## 2. 配置网络

鼠标选择底部菜单【ControlPanel】：
{% asset_img 2.png %}

选择菜单【Network】：
{% asset_img 3.png %}

配置网络选择【DHCP】， 点击【Apply】->【Exit】：
{% asset_img 4.png %}

查看联网情况：
```bash
ping www.qq.com
```

## 3. 系统安装

### 3.1. GUI安装

点击底部菜单栏的【apps】:
{% asset_img 5-0.png %}

弹出提示框【Fist run -would you like the system to pick the fastest mirror？】(第一次运行-你希望系统选择最快的软件源吗?)，选择Yes：
{% asset_img 5-1.png 选择最快的软件源 %}

开始测试哪个是最优软件源：
{% asset_img 5-2.png 最优软件源 %}

结果显示是163的源，点击OK设置软件源，弹窗操作框：
{% asset_img 6.png 设置软件源 %}

#### 3.1.1. 加载安装脚本

选择【Cloud(Remote)】-> 【Browse】，再Search框内输入`tc-install`, 按Enter进行搜索。
选择`tc-install-GUI.tcz`，然后点击左下角的【Go】：
{% asset_img 7.png 加载安装脚本 %}

等待安装一些列软件包，安装完之后，底部菜单栏会发现有一个【tc-install】图标, 点击它

#### 3.1.2. 执行tc-install.sh

点击底部菜单栏中的【tc-install】图标, 开始界面化安装:
{% asset_img 8.png 开始界面化安装 %}

#### 3.1.3. 设置安装参数

勾选【Frugal】，选择【Whole Disk】--【安装系统的盘】，然后下一步：
{% asset_img 9.png 设置安装参数 %}

选择磁盘格式【ext4】，然后下一步：
{% asset_img 10.png 设置安装参数 %}

这里我们选择不配置，选择下一步：
> Enter spaces separated options from examples above。There can be edlted later on vla your bootloader config。
> 
> 从上面的例子中输入空格分隔的选项。稍后可以在vla引导加载程序配置中进行编辑。

{% asset_img 11.png 设置安装参数 %}

扩展安装, 这里选择默认，选择下一步：
{% asset_img 12.png 扩展安装 %}

选择【Proceed】开始安装：
{% asset_img 13.png 开始安装 %}

#### 3.1.4. 重启

底部菜单点击【Exit】->【Reboot】->【OK】：
{% asset_img 14.png 开始安装 %}

参考： [Tiny Core Linux Installation](http://www.tinycorelinux.net/install.html)

### 3.2 Terminal安装系统

点击底部的菜单【Terminal】，打开终端程序。

#### 3.2.1. 设置软件源

设置软件源为南京大学：
```bash
echo 'http://mirrors.nju.edu.cn/tinycorelinux' > /top/tcemirror
```

#### 3.2.2. 加载安装脚本

点击底部菜单栏的`Terminal`:
```bash
tce-load -wi tc-install
```

#### 3.2.3. 执行tc-install.sh

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

设置一些启动选项（输入以空格分隔的启动选项）, 这里先不输入， 直接回车，有以下信息回显：
```text
Last chance to exit before destroying all data on sda
Continue (y/..)? 
```

输入 y 开始安装，有以下信息回显：
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

以上回显说明完毕.

#### 3.2.4. 重启
```bash
sudo reboot
```

# 四、配置TinyCore

> 在TinyCore中的所有修改，都需要持久化处理，否则重启后丢失。


## 1 修改主机名

### 1.1 方式一
TinyCoreLinux的主机名称无法通过编辑`/etc/hostname`文件进行修改。是因为TinyCoreLinux设计成通过引导参数来设置。
所以编辑引导配置文件, `vi /mnt/sda1/tce/boot/extlinux/extlinux.conf`, 在 `APPEND quiet` 的后面添加主机名配置`host=tinycore-14`，这是完整配置示例：
```text
DEFAULT corepure64
LABEL corepure64
KERNEL /tce/boot/vmlinuz64
INITRD /tce/boot/corepure64.gz
APPEND quiet host=tinycore-14 waitusb=5:UUID="3e9b31a9-4cbb-403e-9c9c-27e0beb0f7e3" tce=UUID="3e9b31a9-4cbb-403e-9c9c-27e0beb0f7e3"
```

### 1.2 方式二

编辑`sudo vi /opt/bootsync.sh` 文件, 修改指令为：
```bash
/usr/bin/sethostname tinycore-pure-14
```

保存修改
```bash
echo '/opt/bootsync.sh' >> /opt/.filetool.lst
filetool.sh -b
```

详情请查看官网PDF手册： [corebook.pdf](http://www.tinycorelinux.net/corebook.pdf) 中的第10章节 `Bootcodes explained`。

## 3. 配置网络

> DNS多少请查询宿主机的【控制面板】->【网络和Internet】->【网络连接】, 点击【VMware Network Adapter VMnetX】, 属性中双机击IPv4。
> 其中的局域网地址即是宿主机主IP【192.168.168.1】， 然后IP地址尾段加1即可【192.168.168.2】， 如果可以ping通就是正确的DNS地址。

### 3.1 配置IP

#### 3.1.1 禁止默认启动DHCP
检查系统默认是否启动DHCP
```bash
ps -fU root | grep udhcpc
```

禁止系统默认启动DHCP。
编辑引导配置文件, `vi /mnt/sda1/tce/boot/extlinux/extlinux.conf`, 在 `APPEND quiet` 的末尾添加参数`nodhcp`，示例：
```bash
APPEND quiet nodhcp 其他参数...
```

#### 3.1.2 静态IP

模板如下(一般虚拟机中网关和DNS是同一个地址)：
```text
#!/bin/sh
pkill udhcpc
ifconfig eth0 静态IP netmask 255.255.255.0
route add default gw 网关IP
echo nameserver DNS地址 > /etc/resolv.conf
```

添加网卡配置文件`/opt/eth0.sh`，添加如下内容：
```text
#!/bin/sh
pkill udhcpc
ifconfig eth0 192.168.168.153 netmask 255.255.255.0
route add default gw 192.168.168.2
echo nameserver 192.168.168.2 > /etc/resolv.conf
```

#### 3.1.3 动态IP

配置动态IP请使用如下内容：
```bash
#!/bin/sh
pkill udhcpc
udhcpc -b -i eth0 -x hostname:box -p /var/run/udhcpc.eth0.pid
```

或删除启动参数nodhcp，开启默认启动dhcp。


### 3.2 配置可执行
增加可执行权限，并执行
```bash
sudo chmod 755 /opt/eth0.sh
sudo /opt/eth0.sh
```

### 3.3 开机启动
设置开机启动及永久生效
```bash
sudo echo "/opt/eth0.sh" >> /opt/.filetool.lst
sudo chmod 775 /opt/bootlocal.sh
sudo echo "/opt/eth0.sh &" >> /opt/bootlocal.sh
filetool.sh -b
```

## 3. 修改软件源

打开控制台Terminal程序，修改软件源
```bash
echo "http://mirrors.163.com/tinycorelinux" > /opt/tcemirror
```

## 4. 修改密码

```bash
sudo passwd tc
sudo passwd root
```

## 5. 安装openssh
```bash
tce-load -wi openssh

cd /usr/local/etc/ssh/
sudo cp sshd_config.orig sshd_config

sudo /usr/local/etc/init.d/openssh start
sudo /usr/local/etc/init.d/openssh status
```

加入开机启动配置：
```bash
sudo chown tc:staff /opt/bootlocal.sh
echo "/usr/local/etc/init.d/openssh start &" >> /opt/bootlocal.sh
```

查看客户机IP
```bash
ifconfig
```

远程连上客户机

## 6. 安装open-vm-tools

桌面端请安装`open-vm-tools-desktop`
```bash
tce-load -wi open-vm-tools

sudo /usr/local/etc/init.d/open-vm-tools start
```

查看是否运行:
```bash
sudo /usr/local/etc/init.d/open-vm-tools status
#或
ps -fU root | grep vmtoolsd
```

加入开机启动配置：
```bash
echo "/usr/local/etc/init.d/open-vm-tools start &" >> /opt/bootlocal.sh
```

## 7. 开启cron

编辑引导配置文件, `vi /mnt/sda1/tce/boot/extlinux/extlinux.conf`, 在 `APPEND quiet` 的末尾添加参数`cron`，示例：
```bash
APPEND quiet cron 其他参数...
```

## 8. 配置修改持久化

持久化处理，保存密码、ssh、开机启动配置等：

```bash
sudo echo '/etc/passwd' >> /opt/.filetool.lst
sudo echo '/etc/shadow' >> /opt/.filetool.lst
sudo echo '/usr/local/etc/ssh' >> /opt/.filetool.lst
sudo echo '/opt/bootlocal.sh' >> /opt/.filetool.lst

filetool.sh -b  #或 backup
```

大功告成，这时可以重启检查下，sshd服务是否已自动开启。
```bash
sudo reboot
```

## 9. 关机自动持久化

> /opt/shutdown.sh 脚本的注释如下：
>
> put user shutdown commands here
> this is called from exittc, aka the gui shutdown option
> if you shutdown from cli using shutdown/halt, this will not be called
>
> for custom cli shutdown commands, you should edit /etc/init.d/rc.shutdown
> 
> 翻译：
>
> 将用户关机命令放在这里
> 这是从exittc调用的，也就是GUI关闭选项
> 如果使用shutdown/halt从cli中关闭，则不会调用该函数
>
> 对于自定义的cli关闭命令，你应该编辑/etc/init.d/rc.shutdown

### 9.1 桌面端
如果是安装了桌面，请编辑 /opt/shutdown.sh，在文件末尾添加如下内容：
```text
echo 'Backup in progress.'
/usr/bin/filetool.sh -b
echo 'Backup end!'
```

然后加入持久化：
```bash
echo '/opt/shutdown.sh' >> /opt/.filetool.lst
filetool.sh -b
```

可能桌面端自带自动备份配置，需要关闭请编辑`/home/tc/.profile`文件， 把变量`BACKUP=1`改为`BACKUP=0`

### 9.1 CLI模式(推荐)

cli模式下编辑引导配置文件, `sudo vi /etc/init.d/rc.shutdown`, 在文件的末尾添加如下内容：
```text
echo 'Backup in progress.'  
/usr/bin/filetool.sh -b                   
echo 'Backup end!'  
echo ""
```

然后加入持久化：
```bash
echo '/etc/init.d/rc.shutdown' >> /opt/.filetool.lst
filetool.sh -b
```

# 五、系统加固 

> 提示: 你可以使用" tce-ab "命令来搜索和安装Tiny Core包。

## 1. 安装iptables防火墙

### 1.1. 安装iptables
```bash
tce-load -wi iptables.tcz
```

### 1.2. 添加防火墙规则

```bash
sudo touch /opt/iptables.sh
sudo chmod 777 /opt/iptables.sh
sudo chown tc:staff /opt/iptables.sh
cat > /opt/iptables.sh <<EOF
# 允许所有本机向外的访问
sudo iptables -A OUTPUT -j ACCEPT

# 允许本地回环接口(即允许本机访问本机)
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# 允许内网机器可以访问
# iptables -A INPUT -p all -s X.X.X.0/24 -j ACCEPT 
sudo iptables -A INPUT -p all -s 192.168.168.0/24 -j ACCEPT

# 拒绝被Ping
# 语法：iptables -A INPUT [-i 网卡名] -p icmp --icmp-type 8 -j DROP
#sudo iptables -A INPUT -p icmp --icmp-type 8 -j DROP
#sudo iptables -A INPUT -i eth0 -p icmp --icmp-type 8 -j DROP

# 允许被ping
# 语法：iptables -A INPUT [-i 网卡名] -p icmp --icmp-type 8 -j ACCEPT
sudo iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT
#sudo iptables -A INPUT -i eth0 -p icmp --icmp-type 8 -j ACCEPT

# 允许访问SSH服务的22端口
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
# 允许访问Web服务的80端口
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# 禁止其他未允许的规则访问
sudo iptables -A FORWARD -j REJECT
# 禁止其他未允许的规则访问
sudo iptables -A INPUT -j REJECT
EOF

sudo sh /opt/iptables.sh
```

查看已添加规则：
```bash
sudo iptables --line-numbers -nv -L
#
sudo iptables -S
```

回显如下：
```text
tc@tc-pure-14:~$ sudo iptables -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
-A INPUT -s 192.168.168.0/24 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-port-unreachable
-A FORWARD -j REJECT --reject-with icmp-port-unreachable
-A OUTPUT -j ACCEPT
-A OUTPUT -o lo -j ACCEPT
```

> 注意：因为之前添加了禁止其他未允许的规则访问规则，所以添加新规则之前请删除这个规则再补上。
> 原因：iptables规则是按照规则链的顺序进行匹配的。如果在规则链中的某个位置有一个匹配到的规则，则之后的规则将不会生效。

添加其他端口：
```bash
sudo iptables --line-numbers -nv -L

#删除之前禁止其他未允许的规则访问
sudo iptables -D INPUT 规则序号

#添加你想要的端口
sudo iptables -A INPUT -p tcp --dport 端口号 -j ACCEPT
# 禁止其他未允许的规则访问
sudo iptables -A INPUT -j REJECT
```

### 1.3. 配置加入持久化

```bash
sudo chown tc:staff /opt/.filetool.lst
echo "/opt/iptables.sh" >> /opt/.filetool.lst
filetool.sh -b
```

### 1.4. 添加防火墙自启动服务：

```bash
sudo chown tc:staff /opt/bootlocal.sh
echo "/opt/iptables.sh &" >> /opt/bootlocal.sh
filetool.sh -b
```

参考： [iptables 命令详解和举例_](/blog/2023/11/24/iptables-usage-details/)

# 六、系统目录说明

```text
/bin              二进制可执行命令
/dev              设备特殊文件
/etc              系统管理和配置文件
/etc/rc.d         启动的配置文件和脚本
/home             用户主目录的基点，比如用户user的主目录就是/home/user，可以用~user表示
/lib              标准程序设计库，又叫动态链接共享库，作用类似windows里的.dll文件
/sbin             系统管理命令，这里存放的是系统管理员使用的管理程序
/tmp              公用的临时文件存储点
/root             系统管理员的主目录
/mnt              系统提供这个目录是让用户临时挂载其他的文件系统。
/lost+found       这个目录平时是空的，系统非正常关机而留下“无家可归”的文件(windows下叫什么.chk)就在这里
/proc             虚拟的目录，是系统内存的映射。可直接访问这个目录来获取系统信息。
/var              某些大文件的溢出区，比方说各种服务的日志文件
/usr              最庞大的目录，要用到的应用程序和文件几乎都在这个目录。其中包含：
/usr/x11r6        存放xwindow的目录
/usr/bin          众多的应用程序
/usr/sbin         超级用户的一些管理程序
/usr/doc          linux文档
/usr/include      linux下开发和编译应用程序所需要的头文件
/usr/lib          常用的动态链接库和软件包的配置文件
/usr/man          帮助文档
/usr/src          源代码，linux内核的源代码就放在/usr/src/linux里
/usr/local/bin    本地增加的命令
/usr/local/lib    本地增加的库根文件系统
```

参考： [TinyCore Linux文件结构说明](https://www.kancloud.cn/dlover/linux/1634235)

# 七、参考资料

- [Frugal Install Tiny Core Linux](http://www.tinycorelinux.net/install.html)
- [Tiny Core Linux 安装配置](https://blog.csdn.net/stevenldj/article/details/112852507)
- [TinyCore Linux - Initial steps](https://tiagojsilva.github.io/en/unixlike/meme/2021-10-29_tinycorelinux-install/#installation)
- [将TinyCore安装到硬盘](https://www.jianshu.com/p/3f87fc24e2f6)
- [Tiny Core Linux 安装配置](https://www.cnblogs.com/mq0036/p/13749661.html)
- [Tinycore Linux基本配置及讲解](https://zhuanlan.zhihu.com/p/566463712?utm_id=0)
- [Tiny Core Linux 的安装和使用](https://alenliu.blog.csdn.net/article/details/120319651)
- [configure-microcore-tiny-linux-as-nat-p-nat-router-using-iptables](https://iotbytes.wordpress.com/configure-microcore-tiny-linux-as-nat-p-nat-router-using-iptables/)

# 八、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->vmware-build-tinycore-pure-14.0](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Fvmware-build-tinycore-pure-14.0)
