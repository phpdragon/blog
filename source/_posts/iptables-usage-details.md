---
title: iptables 命令详解和举例
date: 2023-11-24 12:51:31
tags:
---

# 一、iptables 入门介绍

## 1. 介绍

防火墙，其实说白了讲，就是用于实现Linux下访问控制的功能的，它分为硬件的或者软件的防火墙两种。
无论是在哪个网络中，防火墙工作的地方一定是在网络的边缘。
而我们的任务就是需要去定义到底防火墙如何工作，这就是防火墙的策略，规则，以达到让它对出入网络的IP、数据进行检测。

目前市面上比较常见的有3、4层的防火墙，叫网络层的防火墙，还有7层的防火墙，其实是代理层的网关。

对于TCP/IP的七层模型来讲，我们知道第三层是网络层，三层的防火墙会在这层对源地址和目标地址进行检测。但是对于七层的防火墙，不管你源端口或者目标端口，源地址或者目标地址是什么，都将对你所有的东西进行检查。
所以，对于设计原理来讲，七层防火墙更加安全，但是这却带来了效率更低。所以市面上通常的防火墙方案，都是两者结合的。
而又由于我们都需要从防火墙所控制的这个口来访问，所以防火墙的工作效率就成了用户能够访问数据多少的一个最重要的控制，配置的不好甚至有可能成为流量的瓶颈。

## 2. iptables工作机制

{% asset_img 1.png iptables工作结构图 %}

作者一共在内核空间中选择了5个位置：
- 1.内核空间中：从一个网络接口进来，到另一个网络接口去的
- 2.数据包从内核流入用户空间的
- 3.数据包从用户空间流出的
- 4.进入/离开本机的外网接口
- 5.进入/离开本机的内网接口

这五个位置也被称为五个钩子函数（hook functions）,也叫五个规则链：
- 1.PREROUTING (路由前)
- 2.INPUT (数据包流入口)，此链用于控制传入连接的行为
- 3.FORWARD (转发管卡)，这条链用于传入的连接，这些连接实际上不是在本地传递的，比如路由和 NATing
- 4.OUTPUT(数据包出口)，此链用于传出连接
- 5.POSTROUTING（路由后）

这是NetFilter规定的五个规则链，任何一个数据包，只要经过本机，必将经过这五个链中的其中一个链：
- 对于 raw表，只能做在2个链上：PREROUTING、OUTPUT。
- 对于 filter表，只能做在3个链上：INPUT ，FORWARD ，OUTPUT。
- 对于 nat表，只能做在3个链上：PREROUTING ，OUTPUT ，POSTROUTING。
- 而 mangle表，则是5个链都可以做：PREROUTING，INPUT，FORWARD，OUTPUT，POSTROUTING。


## 3. 命令参数说明

```text
$ iptables -h
iptables v1.8.2

用法:
    iptables -[AD] 链名 规则规范 [参数]
    iptables -I 链名 [序号] 规则规范 [参数]
    iptables -R 链名 序号 规则规范 [参数]
    iptables -D 链名 序号 [参数]
    iptables -[LS] [链名 [rulenum]] [参数]
    iptables -[FZ] [链名] [参数]
    iptables -[NX] 链名
    iptables -E 旧链名 新链名
    iptables -P 链名 目标 [参数]
    iptables -h (打印帮助信息)

命令:  允许使用长或短参数
    --append        -A  链名                   在[链名]规则链的最后新增一个规则
    --delete        -D  链名                   删除[链名]规则链中的所有规则
    --delete        -D  链名    序号           明确指定删除[链名]规则链中序号是[序号]的规则(第一个序号是1)
    --insert        -I  链名    [序号]         在规则链的头部加入新规则 (默认规则序号从1开始)
    --replace       -R  链名    序号           替换/修改[链名]规则链中序号是[序号]的规则(第一个序号是1)
    --list          -L  [链名   [序号]]        列出[链名]规则链中的所有规则 或者 序号是[序号]的规则
    --list-rules    -S  [链名   [序号]]        打印出[链名]规则链中的所有规则 或者 序号是[序号]的规则
    --flush         -F  [链名]                 清空所有链的规则 或者 明确指定清空[链名]的所有规则
    --zero          -Z  [链名  [序号]]         清空所有链的计数器 或者 明确指定清空[链名]的计数器
    --new           -N  链名                   创建一个新的用户定义链
    --delete-chain  -X  [链名]                 删除用户自定义链
    --policy        -P  链名    目标           将[链名]规则链的策略更改为目标策略
    --rename-chain  -E  旧链名  新链名          更改链名(移动任何引用)，主要是用来给用户自定义的链重命名

参数: (加一个“!”表示除了哪个IP之外)
    --ipv4          -4                         Nothing (line is ignored by ip6tables-restore)
    --ipv6          -6                         Error (line is ignored by iptables-restore)
[!] --protocol      -p  协议名                 协议名:通过编号或名称，例如：“tcp”，这里的协议通常有3种，TCP/UDP/ICMP
                    -p  tcp(TCP协议的扩展)：
                    --dport XX-XX              指定目标端口,不能指定多个非连续端口,只能指定单个端口，比如：--dport 21，指定目标端口；或 --dport 21-23，此时表示21,22,23
                    --sport                    指定源端口
                    --tcp-fiags                TCP的标志位（SYN,ACK，FIN,PSH，RST,URG）
                    -p  udp(UDP协议的扩展)：
                    --dport
                    --sport
                    -p icmp(ICMP协议的扩展)：
                    --icmp-type                echo-request(ping回显)，一般用 8 来表示； echo-reply(响应的数据包)，一般用0来表示。  

[!] --source        -s  IP[/mask][...]         匹配来源地址 IP/MASK，例如：IP | IP/MASK | 0.0.0.0/0.0.0.0
[!] --destination   -d  IP[/mask][...]         匹配目标地址 IP/MASK，例如：IP | IP/MASK | 0.0.0.0/0.0.0.0
[!] --in-interface  -i  网卡名[+]              网卡名称,匹配从这块网卡流入的数据([+]表示通配符)
    --jump          -j  动作                   目标规则(可以加载目标扩展): DROP(悄悄丢弃)、REJECT(明示拒绝)、ACCEPT(接受)、RETURN(返回)、REDIRECT(重定向)等
    --goto          -g  链名                   跳转到规则链上，没有返回
    --match         -m  match                  扩展匹配(可加载扩展)，例如：-m multiport 表示启用多端口扩展，之后可以跟参比如： -m multiport --dports 21,23,80
    --numeric       -n                         IP地址和端口的数字输出，如果不加-n，则会将ip反向解析成主机名。
[!] --out-interface -o  网卡名[+]              网卡名称,匹配从这块网卡流出的数据([+]表示通配符)
    --table         -t  表名                   要操作的表(默认:' filter')
    --verbose       -v                         详细模式，例如： -vv | -vvv ，越多越详细
    --wait          -w  [秒数]                 在放弃之前等待获取xtables锁的最大时间
    --wait-interval -W  [秒数]                 尝试获取xtables锁的等待时间，默认为1秒
    --line-numbers                             列出时打印行号
    --exact         -x                         展开数字(显示精确值)
[!] --fragment      -f                         只匹配第二个或更多的片段
    --modprobe=<command>                       尝试使用此命令插入模块
    --set-counters PKTS BYTES                  在插入/追加期间设置计数器
[!] --version       -V                         打印版本。


iptables -t 表名 <-A/I/D/R> 规则链名 [序号] <-i/o 网卡名> -p 协议名 <-s 源IP/源子网> --sport 源端口 <-d 目标IP/目标子网> --dport 目标端口 -j 动作
```

# 二、iptables 安装

## 1. CentOS

CentOS 6
```bash
yum install -y iptables
```

CentOS 7 上默认安装了 firewalld 作为防火墙，使用 iptables 建议关闭并禁用 firewalld。
```bash
systemctl stop firewalld
systemctl disable firewalld

yum install -y iptables-services
```

## 2. Ubuntu

```bash
apt-get install iptables
```

## 3. TinyCore Linux

```bash
tce-load -wi iptables.tcz
```

# 三、管理 iptables 服务

CentOS 6
```bash
service iptables status  #查看服务状态
service iptables start   #启动服务
service iptables restart #重启服务
service iptables stop    #关闭服务

chkconfig iptables on    #启用服务
chkconfig iptables off   #禁用服务
```

CentOS 7、Ubuntu
```bash
systemctl status iptables  # 查看服务状态
systemctl enable iptables  # 启用服务
systemctl disable iptables # 禁用服务
systemctl start iptables   # 启动服务
systemctl restart iptables # 重启服务
systemctl stop iptables    # 关闭服务
```

# 四、防火墙规则

iptables 使用三个不同的链来允许或阻止流量：输入(INPUT)、输出(OUTPUT)和转发(FORWARD)

- 输入(INPUT) —— 此链用于控制传入连接的行为
- 输出(OUTPUT) —— 此链用于传出连接
- 转发(FORWARD) —— 这条链用于传入的连接，这些连接实际上不是在本地传递的，比如路由和 NATing

## 1.1. 配置白名单

```bash
# 允许本地回环接口(即允许本机访问本机)
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# 允许所有本机向外的访问
sudo iptables -A OUTPUT -j ACCEPT

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

# 允许已建立的链接通行
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# 禁止其他未允许的规则访问
sudo iptables -A INPUT -j REJECT
# 禁止其他未允许的规则访问
sudo iptables -A FORWARD -j REJECT
```

## 1.2. 连接管理

```bash
# 允许环回连接
sudo iptables -A INPUT -i lo -j ACCEPT 
sudo iptables -A OUTPUT -o lo -j ACCEPT

# 允许已建立和相关的传入连接
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 允许已建立的传出连接
sudo iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT

# 网卡eth1转发到网卡eth0
sudo iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT

# 丢弃无效数据包
sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
```

## 1.3. 开放指定的端口

```bash
# 允许访问SSH服务的22端口
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
# 允许访问FTP服务的21端口
sudo iptables -A INPUT -p tcp --dport 21 -j ACCEPT
# 允许访问Web服务的80端口
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
```

## 1.4. 屏蔽 IP/IP段

```bash
# 屏蔽单个IP
# iptables -I INPUT [-i 网卡名] -s xxxx.xxxx.xxxx.xxxx -j DROP
sudo iptables -I INPUT -s 123.45.6.7 -j DROP

# 屏蔽整个IP段，即从 123.0.0.1 到 123.255.255.254
sudo iptables -I INPUT -s 123.0.0.0/8 -j DROP

# 屏蔽IP区段，即从 123.45.0.1 到 123.45.255.254
$ iptables -I INPUT -s 124.45.0.0/16 -j DROP

# 屏蔽IP子区段，即从 123.45.6.1 到 123.45.6.254
$ iptables -I INPUT -s 123.45.6.0/24 -j DROP
```

## 1.5. 端口映射

转发本机的 2222 端口 到 内网机器 192.168.168.154 的 22 端口
```bash
# 语法：iptables -t nat -A PREROUTING [-d 本机IP] -p tcp --dport [本机端口] -j DNAT --to-dest [目标IP]:[目标端口]
sudo iptables -t nat -A PREROUTING -d 192.168.168.153 -p tcp --dport 2222 -j DNAT --to-dest 192.168.168.154:22
```

## 1.6. 启动网络转发规则

公网 210.14.67.7 让内网 192.168.188.0/24 上网
```bash
sudo iptables -t nat -A POSTROUTING -s 192.168.188.0/24 -j SNAT --to-source 210.14.67.127
```

## 1.7. 字符串匹配

比如，我们要过滤所有 TCP 连接中的字符串test，一旦出现它我们就终止这个连接，我们可以这么做：
```bash
sudo iptables -A INPUT -p tcp -m string --algo kmp --string "test" -j REJECT --reject-with tcp-reset
sudo iptables -L
```

回显如下：
```text
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
REJECT     tcp  --  anywhere             anywhere             STRING match  "test" ALGO name kmp TO 65535 reject-with tcp-reset

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination   
```

## 1.8. 防止攻击

```bash
# 阻止 Windows 蠕虫的攻击
sudo iptables -I INPUT -j DROP -p tcp -s 0.0.0.0/0 -m string --algo kmp --string "cmd.exe"

# 防止 SYN 洪水攻击
sudo iptables -A INPUT -p tcp --syn -m limit --limit 5/second -j ACCEPT

# 防止端口扫描
sudo iptables -N port-scanningiptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURNiptables -A port-scanning -j DROP

# SSH 暴力破解保护
sudo iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --setiptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP

# 同步泛洪保护
sudo iptables -N syn_floodiptables -A INPUT -p tcp --syn -j syn_floodiptables -A syn_flood -m limit --limit 1/s --limit-burst 3 -j RETURN
sudo iptables -A syn_flood -j DROPiptables -A INPUT -p icmp -m limit --limit  1/s --limit-burst 1 -j ACCEPT
sudo iptables -A INPUT -p icmp -m limit --limit 1/s --limit-burst 1 -j LOG --log-prefix PING-DROP:
sudo iptables -A INPUT -p icmp -j DROPiptables -A OUTPUT -p icmp -j ACCEPT

# 使用 SYNPROXY 缓解 SYN 泛洪
sudo iptables -t raw -A PREROUTING -p tcp -m tcp --syn -j CT --notrack
sudo iptables -A INPUT -p tcp -m tcp -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

# 阻止非 SYN 的新数据包
sudo iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# 阻止带有虚假 TCP 标志的数据包
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
```

## 1.9. 删除已添加的规则

> iptables说明：
> 四个表名: raw，nat，filter，mangle
> 五个规则链名: PREROUTING、INPUT、FORWARD、OUTPUT、POSTROUTING
>
> raw 表包含 PREROUTING、OUTPUT 两个规则链
> nat 表包含 PREROUTING、INPUT、OUTPUT、POSTROUTING 四个规则链
> filter 表包含 INPUT、FORWARD、OUTPUT 三个规则链
> mangle 表包含 PREROUTING、INPUT、FORWARD、OUTPUT、POSTROUTING 五个规则链

```bash
# 查看现有规则(带序号)
# 语法：iptables --line-numbers [-t 表名] -L [链名]
sudo iptables --line-numbers -t filter -L
sudo iptables --line-numbers -L

# 删除规则
# 语法：iptables [-t 表名] -D [链名 [序号]]
# 比如要删除 PREROUTING 里序号为 2 的规则，执行：
sudo iptables -t nat -D PREROUTING 2

# 比如要删除 INPUT 里序号为 8 的规则，执行：
sudo iptables -D INPUT 8
```

## 1.10. 其他管理命令

```bash
# 详细查看已添加的规则-INPUT
sudo iptables -nv --line-numbers -L INPUT

# 清空所有的防火墙规则
sudo iptables -F

# 清空所有INPUT的防火墙规则
sudo iptables -F INPUT

# 清空计数
sudo iptables -Z

# 删除用户自定义链
sudo iptables -X
```

# 五、参考资料

- [iptables命令详解和举例（完整版）](https://blog.csdn.net/wangquan1992/article/details/100534543) 
- [iptables 常用使用命令](https://blog.csdn.net/hietech/article/details/132550445)
