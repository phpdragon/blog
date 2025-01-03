---
title: TortoiseGit设置密钥
date: 2024-12-28 22:55:24
categories: ['OS', 'Windows', 'Git', 'TortoiseGit']
tags: ['OS', 'Windows', 'Git', 'TortoiseGit', 'Settings']
---

# 一、TortoiseGit

TortoiseGit‌是一个开源的Git版本控制系统的图形界面工具，特别适用于Windows系统。它提供了一个人性化的图形化界面，使得用户可以更轻松地使用Git命令，无需输入长串的命令，只需通过鼠标操作即可完成代码的提交和上传‌。

# 二、生成SSH公钥

> Windows 用户建议使用 Windows PowerShell 或者 Git Bash，在 命令提示符 下无 cat 和 ls 命令。

### 1.通过命令 ssh-keygen 生成 SSH Key：

```bash
ssh-keygen -t ed25519 -C "Gitee SSH Key"
```
- t key类型
- C 注释

输出，如：
```text
Generating public/private ed25519 key pair.
Enter file in which to save the key (/c/Users/Administrator/.ssh/id_ed25519):
Enter passphrase for "/c/Users/Administrator/.ssh/id_ed25519" (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /c/Users/Administrator/.ssh/id_ed25519
Your public key has been saved in /c/Users/Administrator/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:ohDd0OK5WG2dx4gST/j35HjvlJlGHvihyY+Msl6IC8I Gitee SSH Key
The key's randomart image is:
+--[ED25519 256]--+
|    .o           |
|   .+oo          |
|  ...O.o +       |
|   .= * = +.     |
|  .o +..S*. +    |
|. ...o o..+* *   |
|.E. o . ..+.O    |
| . . ... o =.    |
|    ..oo. o.o    |
+----[SHA256]-----+
```

- 中间通过三次回车键确定

### 2.查看生成的 SSH 公钥和私钥：
```bash
ls ~/.ssh/
```

输出：
```text
id_ed25519  id_ed25519.pub
```

- 私钥文件 id_ed25519
- 公钥文件 id_ed25519.pub

### 3.读取公钥文件 ~/.ssh/id_ed25519.pub：

```bash
cat ~/.ssh/id_ed25519.pub
```

输出，如：

```text
ssh-ed25519 AAAA***5B Gitee SSH Key
```

复制终端输出的公钥。

# 三、Github、Gitee设置公钥

- [Gitee设置账户SSH公钥](https://help.gitee.com/base/account/SSH%E5%85%AC%E9%92%A5%E8%AE%BE%E7%BD%AE#%E8%AE%BE%E7%BD%AE%E8%B4%A6%E6%88%B7-ssh-%E5%85%AC%E9%92%A5)
- [Github配置ssh详细步骤](https://blog.csdn.net/lianqi2003/article/details/143156434)
- [向你的帐户添加新的SSH密钥](https://docs.github.com/zh/enterprise-server@3.15/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account#adding-a-new-ssh-key-to-your-account)

# 四、设置TortoiseGit秘钥

### 1.找到TortoiseGit安装目录下的PuTTYgen, 并双击打开。

> 或者按 Windows 键，输入 PuTTYgen 也可以调出该程序。

{% asset_img PuTTYgen.png PuTTYgen配置界面 %}

### 2.点击 Load 按钮，加载上文生成的 id_ed25519 文件。
> 根据key类型不同，可能是私钥文件是 ~/.ssh/id_rsa

{% asset_img select-key.png 选择私钥文件 %}

加载私钥文件成功：
{% asset_img load-key-success.png 选择私钥文件 %}

### 3.然后生成putty私钥 putty_private.ppk 和公钥 putty_public.pem。

> 名字可以随便起，私钥文件后缀用ppk，公钥后缀随意。

{% asset_img gen-pub-ppk.png 生成公钥私钥 %}

### 4.在项目文件夹空白处点击右键，选择🐢TortoiseGit->设置->Git->远端，设置Putty密钥。

{% asset_img settings.png 配置TortoiseGit %}

加载私钥：
{% asset_img load-key.png 加载putty私钥 %}

### 5.拉取代码测试

测试秘钥有效性:
```bash
# 显示明细请使用：ssh -vT git@github.com 
ssh -T git@github.com
```
返回：
```text
Hi XXX! You've successfully authenticated, but GitHub does not provide shell access.
```

最后拉取代码：
{% asset_img git-push.png 推送代码到远端 %}


# 五、其他问题

- Git正常拉取Tortoisegit无法拉取

原因：出现这种问题的原因是因为TortoiseGit的默认网络SSH client是内置的TortoiseGitPlink.exe。

办法：操作 TortoiseGit设置 -> Network -> SSH -> SSH client , 将 [TortoiseGit安装目录]\bin\TortoiseGitPlink.exe 改为 [Git安装目录]\usr\bin\ssh.exe 即可解决。

如果还不行，则在 %HOMEPATH%/.ssh/ (直接在文件资源管理器地址栏输入进入)目录下增加如下配置文件：
```txt
# 请求转发到ssh.github.com
Host github.com
	port 22  #也可以是443端口
	HostName ssh.github.com
```


# 六、参考资料

- [TortoiseGit设置密钥](https://blog.csdn.net/lwb725/article/details/139381732)
- [Gitee SSH公钥设置](https://help.gitee.com/base/account/SSH%E5%85%AC%E9%92%A5%E8%AE%BE%E7%BD%AE)
- [Git正常拉取Tortoisegit无法拉取](https://blog.csdn.net/Blackrosetian/article/details/130244896)
- [解决 Git：ssh: connect to host github.com port 22: Connection timed out 问题的三种方案](https://blog.csdn.net/weixin_43405300/article/details/135814505)