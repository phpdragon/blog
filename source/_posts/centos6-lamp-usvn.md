---
title: CentOS 6.X + Subversion + Usvn 搭建版本管理服务器
date: 2023-11-17 18:41:39
tags:
---

# 一． Subversion 简介   

Subversion是一个自由，开源的版本控制系统。在Subversion管理下，文件和目录可以超越时空。Subversion将文件存放在中心版本库里。这个版本库很像一个普通的文件服务器，不同的是，它可以记录每一次文件和目录的修改情况。这样就可以借此将数借此复到以前的版本，并可以查看数据的更改细节。正因为如此，许多人将版本控制系统当作一种神奇的“时间机器”。 

# 二、系统版本

当前系统基于博文安装：[CentOS 6.X下搭建LAMP服务器](/blog/2023/11/16/centos6-lamp/)

# 三．安装USVN环境

## 1. 安装所需软件
```bash
yum -y install subversion mod_dav_svn mod_auth_mysql
```

查看 subversion 是否安装成功：
```text
[root@centos-6 ~]# svnserve --version | grep 1.6
svnserve，版本 1.6.11 (r934486)
```

## 2. 下载USVN源码包

```shell
cd /usr/local/src
wget https://github.com/usvn/usvn/archive/refs/tags/1.0.7.tar.gz
tar zxvf usvn-1.0.7.tar.gz
mv usvn-1.0.7 /var/www/usvn

chown -R apache:apache /var/www/usvn/
```

## 3. 配置Httpd Alias
```shell
vi /etc/httpd/conf.d/subversion.conf

#在文件最末尾添加内容如下
Alias /usvn "/var/www/usvn/public"
<Directory "/var/www/usvn/public">
        Options +SymLinksIfOwnerMatch
        AllowOverride All
        Order allow,deny
        Allow from all
</Directory>
```

## 4. 开启PHP的短标签
```shell
sed -i 's|^short_open_tag = Off|short_open_tag = On|g' /etc/php.ini
```

## 5. 配置完后重启Httpd
```shell
service httpd restart
```

# 五．安装USVN

## 1. 访问安装页

访问 http://客户机IP/usvn/install.php 就可以按步骤一步步完成搭建。

> 如果打不开，请检查你的iptables、selinux是否有限制。
>
{% asset_img 12.png 访问安装页异常 %}

出现上面的提示，请尝试关闭SElinux看能否解决。

```shell
setenforce 0
```

访问正常将会出现下面安装界面:

{% asset_img 1.png 访问安装页 %}

## 2. 系统环境检查：

{% asset_img 2.png 系统环境检查 %}

## 3. 设置语言和时区

我们选择 “中文 - Asia/Shanghai”， 点击下一步：

{% asset_img 3.png 设置语言和时区 %}

直接同意第三步的证书协议。

{% asset_img 4.png 证书协议 %}

## 4. 配置参数

如果使用默认值不行，请做调整：

{% asset_img 5.png 配置参数 %}

### 4.1. 新建Subversion仓库目录

请根据你的实际情况创建仓库目录, 本文使用默认路径：

```shell
mkdir -p /var/www/usvn/files/
chown -R apache:apache /var/www/usvn/files/
```

## 5. 安装数据库

填入之前创建的MySQL用户名和密码，勾选 “创建数据库”：
{% asset_img 6.png 安装数据库 %}

## 6. 管理员创建

创建一个账号用于登录管理usvn：
{% asset_img 7.png 管理员创建 %}

## 7.检查新版本:

{% asset_img 8.png 检查新版本 %}

我们点击左下角 “检查更新并发送统计信息” 按钮：

{% asset_img 9.png 检查新版本 %}

复制“Apache设置”下的代码到配置文件 `vi /etc/httpd/conf.d/subversion.conf` 的末尾
```text
<Location /usvn/svn/>
	ErrorDocument 404 default
	DAV svn
	Require valid-user
	SVNParentPath /var/www/usvn/files/svn
	SVNListParentPath off
	AuthType Basic
	AuthName "USVN"
	AuthUserFile /var/www/usvn/files/htpasswd
	AuthzSVNAccessFile /var/www/usvn/files/authz
</Location>
```
重启httpd服务
```shell
service httpd restart
```

## 8. 链接到USVN

点击 “链接到USVN”，跳转到USVN的登录页，也可直接访问登录 http://客户机IP/usvn/login/：
{% asset_img 10.png 登录到USVN %}

至此整个subversion 及 USVN 搭建完成。需要用USVN测试创建用户、用户组、项目是否正常！！！

{% asset_img 11.png 管理功能 %}

# 六、参考

[GitHub - USVN Installation ](https://github.com/usvn/usvn/wiki/Installation)


# 七、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->juejin->7301574373789007907](https://pan.baidu.com/s/1PilxMDxpeAbL92M6zJnFtA?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Fjuejin%2F7301574373789007907)

