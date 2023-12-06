---
title: CentOS7 部署 Hadoop 3.2.X
date: 2023-12-05 19:01:19
tags:
---


# 一、系统版本

> 当前系统基于博文安装：[虚拟机最小化安装CentOS 7.X系统](/blog/2023/11/16/vmware-build-small-centos-7.x/)

查看系统版本
```text
[root@centos-7-64-mini ~]# uname -a
Linux centos-7-64-mini 3.10.0-123.el7.x86_64 #1 SMP Mon Jun 30 12:09:22 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
```

当前系统版本基于CentOS 7.0。


# 二、准备工作

## 1. 开启SELINUX

修改selinux配置文件(/etc/sysconfig/selinux)

```bash
sed -i 's|^SELINUX=disabled|SELINUX=enforcing|g' /etc/selinux/config
reboot

getenforce | grep Enforcing
```

## 2. 开放端口

防火墙开放9870、8088端口号

```bash
systemctl enable firewalld
systemctl start firewalld
systemctl status firewalld

firewall-cmd --permanent --zone=public --add-port=9870/tcp
firewall-cmd --permanent --zone=public --add-port=8088/tcp
firewall-cmd --reload
```

查看firewall规则
```bash
firewall-cmd --zone=public --list-services
firewall-cmd --zone=public --list-ports
```
所有的规则以xml方式存放在 `cat /etc/firewalld/zones/public.xml` 这个目录，也可以直接修改此目录。

参考： [iptables和firewalld的区别](https://www.cnblogs.com/lh438369/p/16313781.html)


---------------

# 三、安装JDK环境

> 请参考博文：[CentOS6.x 搭建 Oracle JDK](/blog/2023/12/02/centos6-x-install-oracle-jdk/)

官方下载链接: [Java SE 8 Archive Downloads](https://www.oracle.com/java/technologies/javase/javase8u211-later-archive-downloads.html)
64位：jdk-8u241-linux-x64.tar.gz
32位：jdk-8u241-linux-i586.tar.gz

本文安装JDK版本1.8.0_241。

```bash
java -version
```
回显如下：
```text
java version "1.8.0_241"
Java(TM) SE Runtime Environment (build 1.8.0_241-b07)
Java HotSpot(TM) 64-Bit Server VM (build 25.241-b07, mixed mode)
```


# 四、安装hadoop

前往官网下载：[hadoop-3.2.1.tar.gz](https://downloads.apache.org/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz)，选择你想要的版本，这里选版本 3.2.1。

## 1. 下载解压
```bash
cd /usr/local/src
#wget https://downloads.apache.org/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz
cp /mnt/hgfs/shared-folder/hadoop-3.2.1.tar.gz ./
tar zxvf hadoop-3.2.1.tar.gz -C /usr/local/

cd /usr/local/
ln -s hadoop-3.2.1 hadoop

# 删除多余的cmd命令文件（可不删除cmd脚本）
find /usr/local/hadoop/ -name *.cmd -exec rm -f {} \;
```

## 2. 目录结构说明

```text
.
├── bin        二进制执行命令文件存储目录
├── etc        配置文件存储目录
├── include    工具脚本存储目录
├── lib        资源库存储目录
├── libexec    资源库存储目录
├── logs       日志文件目录
├── sbin       执行脚本存储目录
└── share      共享资源、开发工具和案例存储目录
```

## 3. 添加环境变量
```bash
cat > /etc/profile.d/hadoop.sh <<EOF 
export HADOOP_HOME="/usr/local/hadoop"
export PATH=\$PATH:\${HADOOP_HOME}/bin:\${HADOOP_HOME}/sbin
EOF

source  /etc/profile
```

安装验证：
```bash
hadoop version
```

回显如下：
```bash
Hadoop 3.2.1
Source code repository https://gitbox.apache.org/repos/asf/hadoop.git -r b3cbbb467e22ea829b3808f4b7b01d07e0bf3842
Compiled by rohithsharmaks on 2019-09-10T15:56Z
Compiled with protoc 2.5.0
From source with checksum 776eaf9eee9c0ffc370bcbc1888737
This command was run using /usr/local/hadoop-3.2.1/share/hadoop/common/hadoop-common-3.2.1.jar
```

## 4. 配置运行参数

```bash
cat >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh <<EOF

source /etc/profile
EOF
```

## 5. 重命名启动脚本

避免和spark服务脚本名称冲突（可不删除cmd脚本）：
```bash
cd ${HADOOP_HOME}/sbin

mv start-all.sh start-hadoop-all.sh
mv stop-all.sh stop-hadoop-all.sh
```

## 6. 启动脚本说明

使用图片重写整理了一下启动脚本的执行先后顺序：
{% asset_img 0.png 启动脚本的执行先后顺序 %}

使用文字再次整理一下：

```text
#一个脚本启动所有线程
start-all.sh         #执行此脚本可以启动所有线程
    1. hadoop-config.sh
        a. hadoop-env.sh    
    2. start-dfs.sh  #执行此脚本可以启动HDFS相关线程
        a.hadoop-config.sh
        b.hadoop-daemons.sh   hdfs  namenode
          hadoop-daemons.sh   hdfs  datanode
          hadoop-daemons.sh   hdfs  secondarynamenode   
    3. start-yarn.sh  #执行此脚本可以启动YARN相关线程

#启动单个线程
#方法1：
hadoop-daemons.sh   --config   [start|stop]  command
    1. hadoop-config.sh
        a. hadoop-env.sh
    2. slaves.sh
        a. hadoop-config.sh
        b. hadoop-env.sh
    3. hadoop-daemon.sh --config  [start|stop]  command
        a.hdfs $command
#方法2：
hadoop-daemon.sh   --config   [start|stop]  command
    1. hadoop-config.sh
        a. hadoop-env.sh
    2. hdfs $command
```

# 五、集群模式配置

通过命令查找默认配置文件路径：
```bash
find ${HADOOP_HOME}/ -name *-default.xml
```

Hadoop的配置4个配置文件：
- core-site.xml
- hdfs-site.xml
- mapred-site.xml
- yarn-site.xml

属性的优先级： 码中的属性 > xxx-site.xml > xxx-default.xml

## 1. 本地模式

本地模式介绍：

1. 特点
- 运行在单台机器上，没有分布式思想，使用的是本地文件系统
2. 用途
- 用于对MapReduce程序的逻辑进行调试，确保程序的正确。由于在本地模式下测试和调试MapReduce程序较为方便，因此，这种模式适宜用在开发阶段。

### 1.1 添加hosts映射

```bash
echo "127.0.0.1   `hostname`" >> /etc/hosts
```

### 1.2 程序案例演示: grep

使用hadoop自带的grep程序查找input目录下的文件是否有符合正则表达式'[a-z.]'的字符串

```bash
cd $HADOOP_HOME
mkdir -p input
cp ./*.txt ./input/

hadoop jar ./share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.1.jar grep input ./output '[a-z.]'

cat ./output/part-r-00000
rm -rf ./input ./output
```


## 2. 伪分布式模式

伪分布式模式介绍：
1. 特点
- 在一台机器上安装，使用的是分布式思想，即分布式文件系统，非本地文件系统。
- hdfs涉及到的相关守护进程(namenode,datanode,secondarynamenode)都运行在一台机器上， 都是独立的java进程。
2. 用途
- 比本地模式多了代码调试功能，允许检查内存使用情况，HDFS输入输出，以及其他的守护进程交互。

### 1.1. 添加host映射

```bash
echo "127.0.0.1   `hostname`" >> /etc/hosts
```

### 1.2. 免密互信

```bash
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
```

### 1.3. 配置root用户启动

```bash
cat >> /etc/profile.d/hadoop.sh <<EOF

export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root
export YARN_RESOURCEMANAGER_USER=root
export YARN_NODEMANAGER_USER=root
EOF
```

### 1.4. 配置core-site.xml

```bash
cat > ${HADOOP_HOME}/etc/hadoop/core-site.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
        <description>指定HDFS Master（namenode）的通信地址，默认端口</description>
    </property>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/usr/local/hadoop/tmp</value>
        <description>指定hadoop运行时产生文件的存储路径</description>
    </property>
</configuration>
EOF
```

### 1.5. 配置hdfs-site.xml

```bash
cat > ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
        <description>设置数据块应该被复制的份数</description>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>/usr/local/hadoop/hdfs/name</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/usr/local/hadoop/hdfs/data</value>
    </property>
</configuration>
EOF
```

### 1.6. 配置mapred-site.xml

```bash
cat > ${HADOOP_HOME}/etc/hadoop/mapred-site.xml <<EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
        <description>yarn模式</description>
    </property>
</configuration>
EOF
```

### 1.7. 配置yarn-site.xml

```bash
cat > ${HADOOP_HOME}/etc/hadoop/yarn-site.xml <<EOF
<?xml version="1.0"?>
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
        <description>NodeManager上运行的附属服务。需配置成mapreduce_shuffle，才可运行MapReduce程序</description>
    </property>
    <property>
        <name>yarn.nodemanager.env-whitelist</name>
        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
    </property>
</configuration>
EOF
```

### 1.8. 启动hadoop
```bash
chown -R hdfs:hadoop /usr/local/hadoop/

# 格式化文件系统
hdfs namenode -format

# 添加开机自启
echo '/usr/local/hadoop/sbin/start-hadoop-all.sh &' >> /etc/rc.local

# 启动hadoop
start-hadoop-all.sh

# 关闭hadoop
#stop-hadoop-all.sh

# 查看端口监听
ss -antu | grep 9000 | column -t
ss -antu | grep 9870 | column -t
ss -antu | grep 8088 | column -t
```

查看启动情况：
```bash
jps | grep -v Jps
```
回显：
```text
11168 NodeManager
11027 ResourceManager
10780 SecondaryNameNode
10414 NameNode
10575 DataNode
```

至此，hadoop启动成功；

### 1.9. 访问WebUI

#### 1.9.1 访问Datanode Info

可以在浏览器上输入：http://192.168.168.102:9870 来查看一下伪分布式集群的文件系统信息
1. 浏览一下页面上提示的ClusterID,BlockPoolID
2. 查看一下活跃节点(Live Nodes)的个数，应该是1个

{% asset_img 1.png %}

#### 1.9.2 访问cluster

再在浏览器上输入：http://192.168.168.102:8088 来查看一下伪分布式集群的指标信息

{% asset_img 2.png %}

### 1.10. 程序案例演示: wordcount
下面运行一次经典的WorkCount程序来检查hadoop工作是否正常：
创建input文件夹：
```bash
hdfs dfs -mkdir /input
```
将测试文件上传的hdfs的/input目录下：
```bash
hdfs dfs -put -f ${HADOOP_HOME}/README.txt /input/test.txt
```
接运行hadoop安装包中自带的workcount程序：
```bash
cd ${HADOOP_HOME}/share/hadoop/mapreduce/
hadoop jar ./hadoop-mapreduce-examples-3.2.1.jar wordcount /input/test.txt /output/
```
查看计算结果：
```bash
hdfs dfs -ls /output/
hdfs dfs -cat /output/part-r-00000

# 删除测试目录
hdfs dfs -rm -r -f /input/ /output/ /tmp/
```


至此，hadoop3.2.1伪分布模式搭建和验证完毕。

参考：[Setting up a Single Node Cluster](https://hadoop.apache.org/docs/r3.2.1/hadoop-project-dist/hadoop-common/SingleCluster.html)

--------------

## 3. 分布式模式搭建

> 生产环境基于上节的伪分布模式搭建

服务器节点布局：
- hadoop-master(192.168.168.200): DataNode，NodeManager，ResourceManager，NameNode
- hadoop-slave1(192.168.168.201): DataNode，NodeManager，SecondaryNameNode
- hadoop-slave2(192.168.168.202): DataNode，NodeManager

配置前先关闭所有服务：
```bash
stop-hadoop-all.sh 
```

### 3.1. 添加hadoop用户

```bash
groupadd hadoop

# NameNode, Secondary NameNode, JournalNode, DataNode
useradd hdfs -g hadoop -s /bin/bash
# 资源管理节点管理服务用户
useradd yarn -g hadoop -s /bin/bash
# MapReduce作业历史服务器用户
useradd mapred -g hadoop -s /bin/bash
```

### 3.2. 免密互信

```bash
# 如果已做过root免密互信则略过
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys

su hdfs -c "ssh-keygen -t rsa -P '' -f /home/hdfs/.ssh/id_rsa"
su hdfs -c "cat /home/hdfs/.ssh/id_rsa.pub > /home/hdfs/.ssh/authorized_keys"
su hdfs -c "chmod 0600 /home/hdfs/.ssh/authorized_keys"

su yarn -c "ssh-keygen -t rsa -P '' -f /home/yarn/.ssh/id_rsa"
su yarn -c "cat /home/yarn/.ssh/id_rsa.pub > /home/yarn/.ssh/authorized_keys"
su yarn -c "chmod 0600 /home/yarn/.ssh/authorized_keys"

su mapred -c "ssh-keygen -t rsa -P '' -f /home/mapred/.ssh/id_rsa"
su mapred -c "cat /home/mapred/.ssh/id_rsa.pub > /home/mapred/.ssh/authorized_keys"
su mapred -c "chmod 0600 /home/mapred/.ssh/authorized_keys"
```

免密登录验证：
```bash
ssh root@localhost
```
回显：
```text
Last login: Mon Dec  5 20:27:45 2023
```


### 3.3. 添加hosts映射

> 尽量清理之前配置的hosts映射。

```bash
cat >> /etc/hosts <<EOF
192.168.168.200 hadoop-master
192.168.168.201 hadoop-slave1
192.168.168.202 hadoop-slave2
EOF
```


### 3.4. 配置环境变量

覆盖之前的配置：
```bash
cat > /etc/profile.d/hadoop.sh <<EOF
export HADOOP_HOME="/usr/local/hadoop"
export PATH=\$PATH:\${HADOOP_HOME}/bin:\${HADOOP_HOME}/sbin

export HDFS_NAMENODE_USER=hdfs
export HDFS_DATANODE_USER=hdfs
export HDFS_SECONDARYNAMENODE_USER=hdfs
export YARN_RESOURCEMANAGER_USER=yarn
export YARN_NODEMANAGER_USER=yarn
EOF
```

### 3.5. 配置core-site.xml

配置core-site.xml配置文件，替换HDFS Master通信地址
```bash
sed -i 's|hdfs://localhost:9000|hdfs://hadoop-master:9000|g' ${HADOOP_HOME}/etc/hadoop/core-site.xml
```

### 3.6. 配置hdfs-site.xml

覆盖core-site.xml配置文件
```bash
cat > ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>3</value>
        <description>设置数据块应该被复制的份数</description>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>/usr/local/hadoop/hdfs/name</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/usr/local/hadoop/hdfs/data</value>
    </property>
    <!-- secondarynamenode守护进程的http地址：主机名和端口号。参考守护进程布局-->
    <property>
        <name>dfs.namenode.secondary.http-address</name>
        <value>hadoop-slave1:9868</value>
    </property>
    <!-- secondarynamenode守护进程的https地址：主机名和端口号。参考守护进程布局-->
    <property>
        <name>dfs.namenode.secondary.https-address</name>
        <value>hadoop-slave1:9869</value>
        <description>
        The secondary namenode HTTPS server address and port.
        </description>
    </property>
</configuration>
EOF
```

### 3.7. 配置mapred-site.xml

如果只是搭建hdfs,只需要配置core-site.xml和hdfs-site.xml文件就可以了，但是我们过两天要学习的MapReduce是需要YARN资源管理器的，因此，在这里，我们提前配置一下相关文件。

```bash
cat > ${HADOOP_HOME}/etc/hadoop/mapred-site.xml <<EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
        <description>yarn模式</description>
    </property>
    <!-- 配置作业历史服务器的地址-->
    <property>
      <name>mapreduce.jobhistory.address</name>
      <value>hadoop-master:10020</value>
      <description>MapReduce JobHistory Server IPC host:port</description>
    </property>
    <!-- 配置作业历史服务器的http地址-->
    <property>
      <name>mapreduce.jobhistory.webapp.address</name>
      <value>hadoop-master:19888</value>
      <description>MapReduce JobHistory Server Web UI host:port</description>
    </property>
    <!-- 配置作业历史服务器的https地址-->
    <property>
      <name>mapreduce.jobhistory.webapp.https.address</name>
      <value>hadoop-master:19890</value>
      <description>
        The https address the MapReduce JobHistory Server WebApp is on.
      </description>
    </property>
    <!-- 配置作业历史服务器的管理地址-->
    <property>
      <name>mapreduce.jobhistory.admin.address</name>
      <value>hadoop-master:10033</value>
      <description>The address of the History server admin interface.</description>
    </property>
</configuration>
EOF
```

### 3.8. 配置yarn-site.xml

```bash
cat > ${HADOOP_HOME}/etc/hadoop/yarn-site.xml <<EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
<!-- Site specific YARN configuration properties -->
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>hadoop-master</value>
        <description>yarn 资源管理服务主机名</description>
    </property>
    <property>
        <name>yarn.nodemanager.env-whitelist</name>
        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_HOME</value>
    </property>
</configuration>
EOF
```

### 3.9. 配置workers

配置workers文件，此文件用于指定datanode守护进程所在的机器节点主机名
```bash
cat > ${HADOOP_HOME}/etc/hadoop/workers <<EOF
hadoop-master
hadoop-slave1
hadoop-slave2
EOF
```

### 3.10. 调整目录权限

```bash
chown -R hdfs:hadoop /usr/local/hadoop/

chmod 775 /usr/local/hadoop/logs/
chmod 777 /usr/local/hadoop/tmp/
chmod 700 /usr/local/hadoop/hdfs/name
```

### 3.11. 克隆主机

> UUID可以通过[在线生成uuid - UUID Online](https://www.uuid.online)

克隆出master、slave1、slave2三台机器，然后编辑虚拟机设置->网络适配器->高级->生成MAC地址，拷贝生成的MAC地址(或手动输入)。
| 主机 | IP | MAC地址 | UUID |
|:-- | :-- | :-- | :-- |
| hadoop-master | 192.168.168.200 | 00:0C:29:18:1F:D3 | f0208bba-45e6-4b85-8104-39c3f9aaa513 |
| hadoop-slave1 | 192.168.168.201 | 00:0C:29:18:1F:D4 | f0208bba-45e6-4b85-8104-39c3f9aaa514 |
| hadoop-slave2 | 192.168.168.202 | 00:0C:29:18:1F:D5 | f0208bba-45e6-4b85-8104-39c3f9aaa515 |

分别登录master、slave1、slave2三台机器

修改网络配置：
编辑 `vi /etc/sysconfig/network-scripts/ifcfg-eno*`, 修改其中的UUID、MAC
```bash
UUID=
HWADDR=00:0C:29:18:1F:D3
IPADDR0=192.168.168.200
```

修改主机名：
```bash
echo 'hadoop-master' > /etc/hostname
```

重启生效。

### 3.12. 启动hadoop集群

> *-site.xml > *-default.xml 

在任何一台主机上执行：
```bash
# 启动hadoop
start-hadoop-all.sh

# 关闭hadoop
#stop-hadoop-all.sh
```

### 3.13. 在master主机上查看端口监听
```bash
ss -antu | grep 9000 | column -t
ss -antu | grep 9870 | column -t
ss -antu | grep 8088 | column -t
```

查看Hadoop集群状态

```bash
hdfs dfsadmin -report
```

访问集群：

http://192.168.168.200:9870/explorer.html#/

