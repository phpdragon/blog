---
title: mvn命令上传jar包至nexus仓库
date: 2025-03-10 22:55:24
categories: ['SSL', 'Certificate']
tags: ['SSL', 'Certificate']
---

# mvn命令上传jar包至nexus仓库

前提: 
- 需要知道仓库地址、用户名、密码。
- 已安装apache-maven，并mvn命令可执行。

## 一、配置maven的settings.xml文件

在maven的安装目录下， conf/settings.xml 文件中配置2个server，并输入nexus的用户名和密码。

```xml
<servers>
    <server>
        <id>release</id>
        <username>admin</username>
        <password>******</password>
    </server>
    <server>
        <id>snapshots</id>
        <username>admin</username>
        <password>******</password>
    </server>
</servers>
```

## 二、执行deploy命令

在任意目录下

```bat
:: 示例 
:: mvn deploy:deploy-file -Dfile=D:/paas-sdk-3.0.14.jar  -DgroupId=esign-cn -DartifactId=paas-sdk  -Dversion=3.0.14 -Dpackaging=jar -Durl=http://maven.nexus.com:81/repository/maven-releases/ -DrepositoryId=release

mvn deploy:deploy-file -Dfile=D:/file/test-1.0-RELEASES.jar -DpomFile=D:/file/test-1.0-RELEASES.pom -Dpackaging=jar -Durl=http://ip:端口号/仓库地址/ -DrepositoryId=release
```

命令解释：

- mvn deploy:deploy-file  是命令名
- -Dfile=            用于指定 jar 所在的位置，绝对路径、相对路径都是支持的，只要能找到指定文件即可。建议把要上传的jar放到一个简单的目录下。
- -Dpackaging=       要上传的文件类型，jar 或 pom 。上传 jar 包时，-Dfile 和 -DpomFile 都要填写；只上传 pom 文件，只需要填写 -DpomFile。
- -DpomFile=         用于指定 pom 文件所在位置。不使用pom文件，则请传递 -DgroupId 、-DartifactId、-Dversion 3个参数。
- -DgroupId=         用于指定jar对应的gorupId。
- -DartifactId=      用于指定jar对应的artifactId。
- -Dversion=         用于指定jar对应的版本。
- -Durl=             要上传的 nexus 仓库地址，snapshots 的jar要上传到snapshots仓库， releases的jar 要上传到 release仓库。如果类型不匹配会报 status code 400 异常。
- -DrepositoryId=    指定使用哪个仓库id，要与 settings.xml 文件中的 server id 相同。匹配不到 id 的话，也会报 status code 405 异常。

jar包上传成功后，会解析pom文件，自动识别 jar 包的存储路径。

## 三、参考资料

- [mvn deploy命令上传jar包](https://www.cnblogs.com/huanshilang/p/18141329)
