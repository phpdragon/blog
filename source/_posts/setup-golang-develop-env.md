---
title: Windows下搭建Golang开发环境
date: 2023-11-12 18:39:43
categories: ['Window', 'Develop', 'Language', 'Golang']
tags: ['Window', 'Develop', 'Language', 'Golang']
---

# Windows下搭建Golang开发环境

## 1.下载Golang

访问[Go官方下载页面](https://golang.org/dl/)。
建议下载Archive类型的文件，直接解压就可以使用，避免了通过Installer安装时会在系统上一些不明确的位置放置文件。
这里以[go1.23.4版本](https://go.dev/dl/go1.23.4.windows-amd64.zip)为例，找到[go1.23.4.windows-amd64.zip](https://go.dev/dl/go1.23.4.windows-amd64.zip)下载即可。

下载完成后，将文件解压缩到指定位置，如我本人解压后的目录为D:\go\go1.23.4，接下来配置系统环境变量。

## 2.配置环境变量

在桌面上，右键点击 此电脑->属性->高级系统设置->高级->环境变量。
在系统变量框中,编辑环境变量中的Path，添加D:\go\go1.23.4\bin，其它不需要任何设置，不要迷信一些比较陈旧的文章里提到的GOROOT和GOPATH两个环境变量的设置，每种编程语言在版本更新时都会改善一些内容。


## 3.验证安装。

打开终端，在命令行输入go version，会看到以下内容，说明环境变量已经配置完成。

```cmd
C:\Users\Administrator>go version
go version go1.23.4 windows/amd64
```

## 4.设置go env

在设置go env之前，首先可以执行go env命令查设置好环境变量后看所有默认的环境变量值。
其中要修改的有GO111MODULE、GOPROXY两项，GO111MODULE作用是开启go的模块管理功能,其中GOPROXY主要方便一些网络不好的地区和用户下载依赖。

```cmd
#开启go的模块管理
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,https://gocenter.io,https://goproxy.io,direct
```

设置完成后，再次查看go env，完整的内容如下

```cmd
C:\Users\Administrator>go env GO111MODULE
on

C:\Users\Administrator>go env GOPROXY
https://goproxy.cn,https://gocenter.io,https://goproxy.io,direct
```

另外可以使用go help env查看更多与env有关的说明

## 5.使用go mod初始化module

在较旧的golang中，所有的项目源码必须存放在GOPATH的src目录下，才能正确地加载依赖，这是非常反人类的设计，好在目前版本中已经使用了go mod来管理依赖。go mod可以理解为Java领域的Maven、Gradle，Python领域的pip。如果golang能够出现类似virtualenv、pipenv这样的虚拟环境管理工具那就更完美了，这样本地环境永远是干净的，各个项目之间也减少了依赖的module版本冲突的可能性。

首先创建了一个test的目录，在命令行进入到此目录下运行go mod init，会出现以下提示，需要在init命令后添加需要初始化的module名称。另外，从提示中我们可以看出，使用mo mod管理的项目，是与GOPATH无关的。

```cmd
E:\test> go mod init
go: cannot determine module path for source directory E:\test (outside GOPATH, module path must be specified)

Example usage:
        'go mod init example.com/m' to initialize a v0 or v1 module
        'go mod init example.com/m/v2' to initialize a v2 module

Run 'go help mod init' for more information.
```

那么根据提示，重新执行go mod

```cmd
E:\test> go mod init test
go: creating new go.mod: module test
```

执行成功后，test目录下会生成一个go.mod的文件，内容如下

```text
module test

go 1.23.4
```

到这里，Golang的安装和配置就已经完成了，并且使用了go mod初始化了一个test的项目（module）。

## 6.安装及配置vscode

上面的过程我们已经准备好了基本的环境，但正式开始golang项目开发，还需要一个IDE，这里推荐vscode。

首先下载并安装vscode，过程省略。

安装完成以后，安装go语言插件，下载第一个就可以了。

{% asset_img vscode-golang.png 安装go语言插件 %}

安装完插件以后，使用快捷键Ctrl + Shift + P打开搜索窗口，输入“go: install/update”找到需要执行的命令

PS: https://www.jianshu.com/p/52062e373086
