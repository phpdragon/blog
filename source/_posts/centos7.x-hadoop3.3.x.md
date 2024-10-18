---
title: CentOS7.X 部署 Hadoop 3.3.X
date: 2023-12-05 19:01:19
categories: ['OS', 'Linux', 'CentOS', 'Hadoop']
tags: ['OS', 'Linux', 'CentOS', 'CentOS7.X', 'Hadoop']
---


# 一、系统版本

> 当前系统基于博文安装：[虚拟机最小化安装CentOS 7.X系统](/blog/2023/11/16/vmware-build-small-centos-7.x/)

查看系统版本
```text
[root@hadoop-201 src]# cat /etc/redhat-release 
CentOS Linux release 7.9.2009 (Core)

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

## 2. 开启防火墙

开启防火墙

```bash
systemctl enable firewalld
#systemctl disable firewalld
systemctl start firewalld
#systemctl stop firewalld
systemctl status firewalld

# 允许192.168.168.0~255ip段访问
firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="192.168.168.0/24" accept"
#firewall-cmd --permanent --zone=public --add-port=9870/tcp
#firewall-cmd --permanent --zone=public --add-port=8088/tcp
firewall-cmd --reload
```

查看firewall规则
```bash
firewall-cmd --list-all
firewall-cmd --zone=public --list-all 
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

前往官网下载：[hadoop-3.3.6.tar.gz](https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz)，选择你想要的版本，这里选版本 3.3.6。
归档下载：https://archive.apache.org/dist/hadoop/common/

## 1. 下载解压
```bash
cd /usr/local/src
wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz

mkdir -p /opt/server/
tar zxvf hadoop-3.3.6.tar.gz -C /opt/server/

cd /opt/server/
ln -s hadoop-3.3.6 hadoop

# 删除多余的cmd命令文件（可不删除cmd脚本）
find /opt/server/hadoop/ -name *.cmd -exec rm -f {} \;
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
export HADOOP_HOME="/opt/server/hadoop"
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
Hadoop 3.3.6
Source code repository https://github.com/apache/hadoop.git -r 1be78238728da9266a4f88195058f08fd012bf9c
Compiled by ubuntu on 2023-06-18T08:22Z
Compiled on platform linux-x86_64
Compiled with protoc 3.7.1
From source with checksum 5652179ad55f76cb287d9c633bb53bbd
This command was run using /opt/server/hadoop-3.3.6/share/hadoop/common/hadoop-common-3.3.6.jar
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

# 五、配置文件说明

通过命令查找默认配置文件路径：
```bash
find ${HADOOP_HOME}/ -name *-default.xml
```

Hadoop的配置4个配置文件：
- core-site.xml
- hdfs-site.xml
- mapred-site.xml
- yarn-site.xml

属性的优先级： 代码中的属性 > xxx-site.xml > xxx-default.xml

# 六、本地模式

本地模式介绍：

1. 特点
- 运行在单台机器上，没有分布式思想，使用的是本地文件系统
2. 用途
- 用于对MapReduce程序的逻辑进行调试，确保程序的正确。由于在本地模式下测试和调试MapReduce程序较为方便，因此，这种模式适宜用在开发阶段。

## 1. 添加hosts映射

```bash
echo "127.0.0.1   `hostname`" >> /etc/hosts
```

## 2. 程序案例演示: grep

使用hadoop自带的grep程序查找input目录下的文件是否有符合正则表达式'[a-z.]'的字符串

```bash
cd $HADOOP_HOME
mkdir -p input
cp ./*.txt ./input/

hadoop jar ./share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar grep input ./output '[a-z.]'

cat ./output/part-r-00000
rm -rf ./input ./output
```


# 七、伪分布式模式搭建

伪分布式模式介绍：
1. 特点
- 在一台机器上安装，使用的是分布式思想，即分布式文件系统，非本地文件系统。
- hdfs涉及到的相关守护进程(namenode,datanode,secondarynamenode)都运行在一台机器上， 都是独立的java进程。
2. 用途
- 比本地模式多了代码调试功能，允许检查内存使用情况，HDFS输入输出，以及其他的守护进程交互。

## 1. 添加host映射

```bash
echo "127.0.0.1   `hostname`" >> /etc/hosts
```

## 2. 免密互信

```bash
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
```

## 3. 配置root用户启动

```bash
cat >> /etc/profile.d/hadoop.sh <<EOF

export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root
export YARN_RESOURCEMANAGER_USER=root
export YARN_NODEMANAGER_USER=root
EOF
```

## 4. 配置Hadoop

### 4.1. 配置core-site.xml

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
        <value>/opt/data/hadoop/tmp</value>
        <description>指定hadoop运行时产生文件的存储路径</description>
    </property>
</configuration>
EOF
```

### 4.2. 配置hdfs-site.xml

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
        <value>/opt/data/hadoop/hdfs/name</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/opt/data/hadoop/hdfs/data</value>
    </property>
</configuration>
EOF
```

### 4.3. 配置mapred-site.xml

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
    <property>
        <name>mapreduce.application.classpath</name>
        <value>$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*</value>
    </property>
</configuration>
EOF
```

### 4.4. 配置yarn-site.xml

```bash
cat > ${HADOOP_HOME}/etc/hadoop/yarn-site.xml <<EOF
<?xml version="1.0"?>
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
        <description>NodeManager上运行的附属服务。需配置成mapreduce_shuffle，才可运行MapReduce程序</description>
    </property>
</configuration>
EOF
```

## 5. 启动hadoop
```bash
# 格式化文件系统
hdfs namenode -format

# 添加开机自启
echo '/opt/server/hadoop/sbin/start-hadoop-all.sh &' >> /etc/rc.local

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

## 6. 访问WebUI

### 6.1 访问Datanode Info

可以在浏览器上输入：http://192.168.168.102:9870 来查看一下伪分布式集群的文件系统信息
1. 浏览一下页面上提示的ClusterID,BlockPoolID
2. 查看一下活跃节点(Live Nodes)的个数，应该是1个

{% asset_img 1.png %}

### 6.2 访问cluster

再在浏览器上输入：http://192.168.168.102:8088 来查看一下伪分布式集群的指标信息

{% asset_img 2.png %}

## 7. 案例演示: wordcount
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
hadoop jar ./hadoop-mapreduce-examples-3.3.6.jar wordcount /input/test.txt /output/
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

# 八、完全分布式(单点)模式搭建

> 完全分布式(单点)模式环境基于上节的伪分布模式搭建


## 1. 集群规划：
| 节点名称 | DN | NM | NN | RM |
|:-- | :-- | :-- | :-- | :-- |
| hadoop-201 | DataNode | NodeManager |      NodeName     | ResourceManager |
| hadoop-202 | DataNode | NodeManager | SecondaryNameNode |                 |
| hadoop-203 | DataNode | NodeManager |                   |                 |


配置前先关闭所有服务：
```bash
stop-hadoop-all.sh 
```

## 2. 添加hadoop用户

```bash
groupadd hadoop

# NameNode, Secondary NameNode, JournalNode, DataNode
useradd hdfs -g hadoop -s /bin/bash
# 资源管理节点管理服务用户
useradd yarn -g hadoop -s /bin/bash
# MapReduce作业历史服务器用户
useradd mapred -g hadoop -s /bin/bash
```

## 3. 免密互信

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


## 4. 添加hosts映射

> 尽量清理之前配置的hosts映射。

```bash
cat > /etc/hosts <<EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.168.201 hadoop-201
192.168.168.202 hadoop-202
192.168.168.203 hadoop-203
EOF
```


## 5. 配置环境变量

覆盖之前的环境变量配置， 使用hadoop用户组启动：
```bash
cat > /etc/profile.d/hadoop.sh <<EOF
export HADOOP_HOME="/opt/server/hadoop"
export PATH=\$PATH:\${HADOOP_HOME}/bin:\${HADOOP_HOME}/sbin

export HDFS_NAMENODE_USER=hdfs
export HDFS_DATANODE_USER=hdfs
export HDFS_SECONDARYNAMENODE_USER=hdfs
export YARN_RESOURCEMANAGER_USER=yarn
export YARN_NODEMANAGER_USER=yarn
EOF
```

## 6. 配置Hadoop

### 6.1. 配置core-site.xml

覆盖core-site.xml配置文件：
```bash
cat > ${HADOOP_HOME}/etc/hadoop/core-site.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://hadoop-201:9000</value>
        <description>指定HDFS Master（namenode）的通信地址，默认端口</description>
    </property>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/opt/data/hadoop/tmp</value>
        <description>指定hadoop运行时产生文件的存储路径</description>
    </property>
</configuration>
EOF
```

### 6.2. 配置hdfs-site.xml

覆盖hdfs-site.xml配置文件：
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
        <value>/opt/data/hadoop/hdfs/name</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/opt/data/hadoop/hdfs/data</value>
    </property>
    <!-- secondarynamenode守护进程的http地址：主机名和端口号。参考守护进程布局-->
    <property>
        <name>dfs.namenode.secondary.http-address</name>
        <value>hadoop-202:9868</value>
    </property>
    <!-- secondarynamenode守护进程的https地址：主机名和端口号。参考守护进程布局-->
    <property>
        <name>dfs.namenode.secondary.https-address</name>
        <value>hadoop-202:9869</value>
        <description>
        The secondary namenode HTTPS server address and port.
        </description>
    </property>
</configuration>
EOF
```

### 6.3. 配置mapred-site.xml

覆盖hdfs-site.xml配置文件：
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
    <property>
        <name>mapreduce.application.classpath</name>
        <value>$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*</value>
    </property>
    <!-- 配置作业历史服务器的地址-->
    <property>
      <name>mapreduce.jobhistory.address</name>
      <value>hadoop-201:10020</value>
      <description>MapReduce JobHistory Server IPC host:port</description>
    </property>
    <!-- 配置作业历史服务器的http地址-->
    <property>
      <name>mapreduce.jobhistory.webapp.address</name>
      <value>hadoop-201:19888</value>
      <description>MapReduce JobHistory Server Web UI host:port</description>
    </property>
    <!-- 配置作业历史服务器的https地址-->
    <property>
      <name>mapreduce.jobhistory.webapp.https.address</name>
      <value>hadoop-201:19890</value>
      <description>
        The https address the MapReduce JobHistory Server WebApp is on.
      </description>
    </property>
    <!-- 配置作业历史服务器的管理地址-->
    <property>
      <name>mapreduce.jobhistory.admin.address</name>
      <value>hadoop-201:10033</value>
      <description>The address of the History server admin interface.</description>
    </property>
</configuration>
EOF
```

### 6.4. 配置yarn-site.xml

```bash
cat > ${HADOOP_HOME}/etc/hadoop/yarn-site.xml <<EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>hadoop-201</value>
        <description>yarn 资源管理服务主机名</description>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
</configuration>
EOF
```

## 7. 配置workers

配置workers文件，此文件用于指定datanode守护进程所在的机器节点主机名
```bash
cat > ${HADOOP_HOME}/etc/hadoop/workers <<EOF
hadoop-201
hadoop-202
hadoop-203
EOF
```

## 8. 调整目录权限

```bash
mkdir -p /opt/server/hadoop/logs/
mkdir -p /opt/data/hadoop/tmp/

chown -R hdfs:hadoop /opt/server/hadoop/
chown -R hdfs:hadoop /opt/data/hadoop/

chmod 775 /opt/server/hadoop/logs/
chmod 777 /opt/data/hadoop/tmp/
```

## 9. 克隆主机

> UUID可以通过[在线生成uuid - UUID Online](https://www.uuid.online)

克隆出hadoop-201、hadoop-202、hadoop-203三台机器，然后编辑虚拟机设置->网络适配器->高级->生成MAC地址，拷贝生成的MAC地址(或按下面内容手动输入)。
| 节点名称 | IP | MAC地址 | UUID |
|:-- | :-- | :-- | :-- |
| hadoop-201 | 192.168.168.201 | 00:0C:29:18:1F:D3 | f0208bba-45e6-4b85-8104-39c3f9aaa513 |
| hadoop-202 | 192.168.168.202 | 00:0C:29:18:1F:D4 | f0208bba-45e6-4b85-8104-39c3f9aaa514 |
| hadoop-203 | 192.168.168.203 | 00:0C:29:18:1F:D5 | f0208bba-45e6-4b85-8104-39c3f9aaa515 |

分别登录三台机器，修改网络配置文件：
编辑 `vi /etc/sysconfig/network-scripts/ifcfg-eno*`, 修改其中的UUID、MAC
```bash
UUID=f0208bba-45e6-4b85-8104-39c3f9aaa513
HWADDR=00:0C:29:18:1F:D3
IPADDR0=192.168.168.200
```

修改主机名：
```bash
echo '节点名称' > /etc/hostname
```

重启生效。

## 10. 启动hadoop集群

在master主机上执行：
```bash
rm -rf /opt/data/hadoop/hdfs/
ssh root@hadoop-202 'rm -rf /opt/data/hadoop/hdfs/'
ssh root@hadoop-203 'rm -rf /opt/data/hadoop/hdfs/'

hdfs namenode -format
ssh root@hadoop-202 'hdfs namenode -format'
ssh root@hadoop-203 'hdfs namenode -format'

# 启动hadoop
start-hadoop-all.sh

# 关闭hadoop
#stop-hadoop-all.sh

# 查看端口监听
ss -antu | grep 9000 | column -t
ss -antu | grep 9870 | column -t
ss -antu | grep 8088 | column -t
```

查看Hadoop集群状态:
```bash
su hdfs -c 'hdfs dfsadmin -report'
```

查看node1服务分布：
```bash
jps | grep -v Jps
```
回显如下：
```text
36048 ResourceManager
35457 NameNode
35649 DataNode
36217 NodeManager
```

查看node2服务分布：
```bash
ssh root@hadoop-202 'jps | grep -v Jps'
```
回显如下：
```text
4053 NodeManager
3831 DataNode
3945 SecondaryNameNode
```

查看node3服务分布：
```bash
ssh root@hadoop-203 'jps | grep -v Jps'
```
回显如下：
```text
3520 NodeManager
3387 DataNode
```

和规划的服务布局一致。访问集群：http://192.168.168.201:9870



## 11. 案例演示: wordcount
下面运行一次经典的WorkCount程序来检查hadoop工作是否正常：
创建input文件夹：
```bash
su hdfs -c 'hdfs dfs -mkdir /input'
```
将测试文件上传的hdfs的/input目录下：
```bash
su hdfs -c 'hdfs dfs -put -f ${HADOOP_HOME}/README.txt /input/test.txt'

# 查看目录下文件
su hdfs -c 'hdfs dfs -ls /input'
```
接运行hadoop安装包中自带的workcount程序：
```bash
su hdfs -c 'hadoop jar ${HADOOP_HOME}/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar wordcount /input/test.txt /output/'
```
查看计算结果：
```bash
su hdfs -c 'hdfs dfs -ls /output/'
su hdfs -c 'hdfs dfs -cat /output/part-r-00000'

# 删除测试目录
su hdfs -c 'hdfs dfs -rm -r -f /input/ /output/ /tmp/'
```



# 九、完全分布式(高可用)模式搭建

> 基于上一节的完全分布式(单点)模式内容搭建

## 1. 集群规划

| 节点名称 | NN | JN | DN | RM | NM | ZK | ZKFC |
|:-- | :-- | :-- | :-- |:--| :-- | :-- |:--|
| hadoop-201 | NodeName | JournalNode | DataNode | ResourceManager  | NodeManager | ZooKeeper | ZKFC |
| hadoop-202 | NodeName | JournalNode | DataNode | ResourceManager  | NodeManager | ZooKeeper | ZKFC |
| hadoop-203 | NodeName | JournalNode | DataNode |                  | NodeManager | ZooKeeper | ZKFC |

配置前先关闭所有服务：
```bash
stop-hadoop-all.sh 
```

## 2. 搭建zookeeper集群

### 2.1. 下载和安装

前往 [安装包归档地址](http://archive.apache.org/dist/zookeeper/) 下载 [zookeeper-3.9.1-bin.tar.gz](http://archive.apache.org/dist/zookeeper/zookeeper-3.9.1/apache-zookeeper-3.9.1-bin.tar.gz)

```bash
cd /usr/local/src
wget http://archive.apache.org/dist/zookeeper/zookeeper-3.9.1/apache-zookeeper-3.9.1-bin.tar.gz

tar zxf apache-zookeeper-3.9.1-bin.tar.gz -C /opt/server/

cd /opt/server
ln -s apache-zookeeper-3.9.1-bin/ zookeeper

# 删除多余的cmd命令文件（可不删除cmd脚本）
find /opt/server/zookeeper/ -name *.cmd -exec rm -f {} \;
```

### 2.2. 添加环境变量
```bash
cat > /etc/profile.d/zookeeper.sh <<EOF
export ZOOKEEPER_HOME="/opt/server/zookeeper"
export PATH=\$PATH:\${ZOOKEEPER_HOME}/bin
EOF

source /etc/profile
```

### 2.3. 配置zookeeper

```bash
cd /opt/server/zookeeper/conf
cp zoo_sample.cfg zoo.cfg

sed -i 's|dataDir=/tmp/zookeeper|dataDir=/opt/server/zookeeper/data|g' zoo.cfg

cat >> zoo.cfg <<EOF
dataLogDir=/opt/server/zookeeper/logs

server.1=hadoop-201:2888:3888
server.2=hadoop-202:2888:3888
server.3=hadoop-203:2888:3888
EOF


mkdir -p /opt/server/zookeeper/data
mkdir -p /opt/server/zookeeper/logs

chmod 775 /opt/server/zookeeper/data
chmod 775 /opt/server/zookeeper/logs
```

### 2.4. 添加开机自启

```bash
cat > /usr/lib/systemd/system/zookeeper.service <<EOF
[Unit]
Description=zookeeper
After=syslog.target network.target

[Service]
Type=forking
Environment=ZOO_LOG_DIR=/opt/server/zookeeper/logs
ExecStart=/opt/server/zookeeper/bin/zkServer.sh start
ExecStop=/opt/server/zookeeper/bin/zkServer.sh stop
Restart=always
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF
```

参考：
- [centos7-service文件](https://www.cnblogs.com/chunjeh/p/17817520.html)
- [Centos7以普通用户启动zookeeper并加入开机自启动服务](https://www.tracymc.cn/archives/3670)
- [Centos下Zookeeper设置自启动](https://it.cha138.com/ios/show-384755.html)

### 2.5. 分发zookeeper包至其他机器：
```bash
scp /etc/profile.d/zookeeper.sh root@hadoop-202:/etc/profile.d/
scp /etc/profile.d/zookeeper.sh root@hadoop-203:/etc/profile.d/

rsync -a /opt/server/*zookeeper* root@hadoop-202:/opt/server/
rsync -a /opt/server/*zookeeper* root@hadoop-203:/opt/server/
```

### 2.6. 添加server对应的编号：
```bash
echo "1" > /opt/server/zookeeper/data/myid
ssh root@hadoop-202 'echo "2" > /opt/server/zookeeper/data/myid'
ssh root@hadoop-203 'echo "3" > /opt/server/zookeeper/data/myid'
```

验证：
```bash
echo $ZOOKEEPER_HOME
ssh root@hadoop-202 'echo $ZOOKEEPER_HOME'
ssh root@hadoop-203 'echo $ZOOKEEPER_HOME'

cat /opt/server/zookeeper/data/myid
ssh root@hadoop-202 'cat /opt/server/zookeeper/data/myid'
ssh root@hadoop-203 'cat /opt/server/zookeeper/data/myid'
```

### 2.7. 启动集群
```bash
systemctl enable zookeeper
ssh root@hadoop-202 'systemctl enable zookeeper'
ssh root@hadoop-203 'systemctl enable zookeeper'

#systemctl disable zookeeper

systemctl daemon-reload
ssh root@hadoop-202 'systemctl daemon-reload'
ssh root@hadoop-203 'systemctl daemon-reload'

systemctl start zookeeper
ssh root@hadoop-202 'systemctl start zookeeper'
ssh root@hadoop-203 'systemctl start zookeeper'

# 关闭
#systemctl stop zookeeper
```
验证：
```bash
zkServer.sh status
ssh root@hadoop-202 'zkServer.sh status'
ssh root@hadoop-203 'zkServer.sh status'
```

### 2.8. 测试集群
在hadoop-node2上启动客户端：
```bash
zkCli.sh
```
创建临时节点数据
```bash
create -e /test 1234
```
不要退出客户端。

然后分别登录其他机器：
```bash
zkCli.sh
get /test
```
如果返回有设置的值，说明zookeeper已搭建成功。

## 3. 配置环境变量

覆盖之前的环境变量配置， 使用hadoop用户组启动：
```bash
cat > /etc/profile.d/hadoop.sh <<EOF
export HADOOP_HOME="/opt/server/hadoop"
export PATH=\$PATH:\${HADOOP_HOME}/bin:\${HADOOP_HOME}/sbin

export HDFS_NAMENODE_USER=hdfs
export HDFS_DATANODE_USER=hdfs
export HDFS_SECONDARYNAMENODE_USER=hdfs
export HDFS_JOURNALNODE_USER=hdfs
export HDFS_ZKFC_USER=hdfs
export YARN_RESOURCEMANAGER_USER=yarn
export YARN_NODEMANAGER_USER=yarn
EOF

source /etc/profile
```

分发配置：
```bash
scp /etc/profile.d/hadoop.sh root@hadoop-202:/etc/profile.d/
scp /etc/profile.d/hadoop.sh root@hadoop-203:/etc/profile.d/
```

## 4. 配置Hadoop

### 4.1. 配置core-site.xml

覆盖core-site.xml配置文件：
```bash
cat > ${HADOOP_HOME}/etc/hadoop/core-site.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://mycluster</value>
        <description>把多个NameNode地址组装成一个集群mycluster</description>
    </property>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/opt/data/hadoop/tmp</value>
        <description>指定hadoop运行时产生文件的存储路径</description>
    </property>
    <property>
        <name>ha.zookeeper.quorum</name>
        <value>hadoop-201:2181,hadoop-202:2181,hadoop-203:2181</value>
        <description>指定ZKFC故障自动切换转移</description>
    </property>
</configuration>
EOF
```

### 4.2. 配置hdfs-site.xml

覆盖hdfs-site.xml配置文件：
```bash
cat > ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>2</value>
        <description>设置数据块应该被复制的副本数,默认3份</description>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>/opt/data/hadoop/hdfs/name</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/opt/data/hadoop/hdfs/data</value>
    </property>

    <property>
        <name>dfs.nameservices</name>
        <value>mycluster</value>
        <description>完全分布式集群名称</description>
    </property>
    <property>
        <name>dfs.ha.namenodes.mycluster</name>
        <value>nn1,nn2,nn3</value>
        <description>所有的namenode列表，此处也只是逻辑名称，非namenode所在的主机名称</description>
    </property>
    <property>
        <name>dfs.namenode.rpc-address.mycluster.nn1</name>
        <value>hadoop-201:8020</value>
        <description>namenode之间用于RPC通信的地址。默认端口8020</description>
    </property>
    <property>
        <name>dfs.namenode.rpc-address.mycluster.nn2</name>
        <value>hadoop-202:8020</value>
        <description>namenode之间用于RPC通信的地址。默认端口8020</description>
    </property>
    <property>
        <name>dfs.namenode.rpc-address.mycluster.nn3</name>
        <value>hadoop-203:8020</value>
        <description>namenode之间用于RPC通信的地址。默认端口8020</description>
    </property>
    <property>
        <name>dfs.namenode.http-address.mycluster.nn1</name>
        <value>hadoop-201:9870</value>
        <description>namenode的web访问地址，默认端口9870</description>
    </property>
    <property>
        <name>dfs.namenode.http-address.mycluster.nn2</name>
        <value>hadoop-202:9870</value>
        <description>namenode的web访问地址，默认端口9870</description>
    </property>
    <property>
        <name>dfs.namenode.http-address.mycluster.nn3</name>
        <value>hadoop-203:9870</value>
        <description>namenode的web访问地址，默认端口9870</description>
    </property>

    <!--journalnode主机地址，最少三台，默认端口8485-->
    <!--格式为 qjournal://jn1:port;jn2:port;jn3:port/\${dfs.nameservices}-->
    <property>
        <name>dfs.namenode.shared.edits.dir</name>
        <value>qjournal://hadoop-201:8485;hadoop-202:8485;hadoop-203:8485/mycluster</value>
        <description>指定NameNode的元数据在JournalNode上的存放位置</description>
    </property>
    <property>
        <name>dfs.journalnode.edits.dir</name>
        <value>/opt/data/hadoop/journal-data</value>
        <description>指定journalNode在本地磁盘存放数据的位置</description>
    </property>

    <property>
        <name>dfs.ha.automatic-failover.enabled</name>
        <value>true</value>
        <description>启用自动故障转移</description>
    </property>
    <property>
      <name>dfs.ha.fencing.methods</name>
      <value>sshfence</value>
      <description>配置隔离机制，即同一时刻只能有一台服务器对外响应. 故障时相互操作方式(namenode要切换active和standby)，这里我们选ssh方式</description>
    </property>
    <property>
      <name>dfs.ha.fencing.ssh.private-key-files</name>
      <value>/root/.ssh/id_rsa</value>
      <description>使用隔离机制时需要ssh无秘钥登录</description>
    </property>
    <property>
        <name>dfs.client.failover.proxy.provider.mycluster</name>
        <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
        <description>故障时自动切换的实现类</description>
    </property>

    <property>
        <name>dfs.permissions.enabled</name>
        <value>true</value>
        <description>关闭权限检查，默认为true</description>
    </property>
</configuration>
EOF
```

### 4.3. 配置mapred-site.xml

覆盖hdfs-site.xml配置文件：
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
    <property>
        <name>mapreduce.application.classpath</name>
        <value>$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*</value>
    </property>
    <!-- 配置作业历史服务器的地址-->
    <property>
      <name>mapreduce.jobhistory.address</name>
      <value>hadoop-201:10020</value>
      <description>MapReduce JobHistory Server IPC host:port</description>
    </property>
    <!-- 配置作业历史服务器的http地址-->
    <property>
      <name>mapreduce.jobhistory.webapp.address</name>
      <value>hadoop-201:19888</value>
      <description>MapReduce JobHistory Server Web UI host:port</description>
    </property>
    <!-- 配置作业历史服务器的https地址-->
    <property>
      <name>mapreduce.jobhistory.webapp.https.address</name>
      <value>hadoop-201:19890</value>
      <description>
        The https address the MapReduce JobHistory Server WebApp is on.
      </description>
    </property>
    <!-- 配置作业历史服务器的管理地址-->
    <property>
      <name>mapreduce.jobhistory.admin.address</name>
      <value>hadoop-201:10033</value>
      <description>The address of the History server admin interface.</description>
    </property>
</configuration>
EOF
```

### 4.4. 配置yarn-site.xml

```bash
cat > ${HADOOP_HOME}/etc/hadoop/yarn-site.xml <<EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>yarn.resourcemanager.ha.enabled</name>
        <value>true</value>
        <description>开启RM高可靠</description>
    </property>
    <property>
        <name>yarn.resourcemanager.cluster-id</name>
        <value>yarn-cluster</value>
        <description>指定RM集群名称</description>
    </property>
    <property>
        <name>yarn.resourcemanager.ha.rm-ids</name>
        <value>rm1,rm2</value>
        <description>声明两台RM的地址, 注意这里是逻辑地址</description>
    </property>
    <property>
        <name>yarn.resourcemanager.hostname.rm1</name>
        <value>hadoop-201</value>
        <description>声明一台RM的地址</description>
    </property>
    <property>
        <name>yarn.resourcemanager.hostname.rm2</name>
        <value>hadoop-202</value>
        <description>声明一台RM的地址</description>
    </property>
    <property>
        <name>yarn.resourcemanager.recovery.enabled</name>
        <value>true</value>
        <description>启用自动恢复，默认false</description>
    </property>
    <property>
       <name>yarn.resourcemanager.store.class</name>
       <value>org.apache.hadoop.yarn.server.resourcemanager.recovery.ZKRMStateStore</value>
       <description>指定恢复实现类</description>
    </property>
    <property>
        <name>yarn.resourcemanager.zk-address</name>
        <value>hadoop-201:2181,hadoop-202:2181,hadoop-203:2181</value>
        <description>指定zk集群地址</description>
    </property>

    <property>
        <name>yarn.resourcemanager.webapp.address.rm1</name>
        <value>hadoop-201:8088</value>
        <description>RM对外暴露的web http地址，用户可通过该地址在浏览器中查看集群信息</description>
    </property>
    <property>
        <name>yarn.resourcemanager.webapp.address.rm2</name>
        <value>hadoop-202:8088</value>
        <description>RM对外暴露的web http地址，用户可通过该地址在浏览器中查看集群信息</description>
    </property>

    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.application.classpath</name>
        <value>
            /opt/server/hadoop/etc/hadoop,
            /opt/server/hadoop/share/hadoop/common/*,
            /opt/server/hadoop/share/hadoop/common/lib/*,
            /opt/server/hadoop/share/hadoop/hdfs/*,
            /opt/server/hadoop/share/hadoop/hdfs/lib/*,
            /opt/server/hadoop/share/hadoop/yarn/*,
            /opt/server/hadoop/share/hadoop/yarn/lib/*,
            /opt/server/hadoop/share/hadoop/mapreduce/lib/*,
            /opt/server/hadoop/share/hadoop/mapreduce/*,
        </value>
    </property>
</configuration>
EOF
```

### 4.5. 分发配置

```bash
chmod 700 /opt/data/hadoop/hdfs/name

su hdfs -c "mkdir -p /opt/data/hadoop/journal-data"
ssh root@hadoop-202 'su hdfs -c "mkdir -p /opt/data/hadoop/journal-data"'
ssh root@hadoop-203 'su hdfs -c "mkdir -p /opt/data/hadoop/journal-data"'

scp -r /opt/server/hadoop/etc/* root@hadoop-202:/opt/server/hadoop/etc/
scp -r /opt/server/hadoop/etc/* root@hadoop-203:/opt/server/hadoop/etc/
```

### 4.6. 启动集群

#### 4.6.1. 启动JournalNode

在所有journalnode节点上启动journalnode(本例中是所有机器)：
```bash
hdfs --daemon start journalnode
ssh root@hadoop-202 'hdfs --daemon start journalnode'
ssh root@hadoop-203 'hdfs --daemon start journalnode'
```

#### 4.6.2. 格式化文件系统

> 在namenode(随便哪一个都行)上执行格式化，出现`successfully formated`即为执行成功。

假如我们在hadoop-node2上执行：
```bash
rm -rf /opt/data/hadoop/hdfs/
ssh root@hadoop-201 'rm -rf /opt/data/hadoop/hdfs/'
ssh root@hadoop-203 'rm -rf /opt/data/hadoop/hdfs/'

hdfs namenode -format
```

启动hadoop-node2上的NameNode：
```bash
hdfs --daemon start namenode
```

同步hdfs目录至其他机器：
```text
ssh root@hadoop-201 'hdfs namenode -bootstrapStandby'
ssh root@hadoop-203 'hdfs namenode -bootstrapStandby'
```
出现以下信息即为同步成功。
```text
=====================================================
About to bootstrap Standby ID nn1 from:
           Nameservice ID: mycluster
        Other Namenode ID: nn3
  Other NN's HTTP address: http://hadoop-203:9870
  Other NN's IPC  address: hadoop-203/192.168.168.202:8020
             Namespace ID: 134603182
            Block pool ID: BP-510794777-192.168.168.202-1701941650572
               Cluster ID: CID-c3a1e9a9-0dea-4b26-8310-e9922c92007c
           Layout version: -65
       isUpgradeFinalized: true
=====================================================
```

#### 4.6.3. 格式化zookeeper节点

在任意一台机器上执行格式化，出现`Successfully created /hadoop-ha/mycluster in ZK.`信息即为执行成功。
```bash
hdfs zkfc -formatZK
```
会在zookeeper上产生一个/hadoop-ha的目录。

#### 4.6.4. 启动HDFS集群

在任意一台机器上执行：
```bash
start-hadoop-all.sh
```


任意机器上查看NN服务状态:
```bash
hdfs haadmin -getAllServiceState
# 或者
hdfs haadmin -getServiceState nn1
hdfs haadmin -getServiceState nn2
hdfs haadmin -getServiceState nn3

# 查看管理命令参数说明
hdfs haadmin -help
```

NameNode状态切换命令：
```bash
# 切换为active
su hdfs -c 'hdfs haadmin -transitionToActive --forceactive --forcemanual nn1'

# 切换为standby
su hdfs -c 'hdfs haadmin -transitionToStandby --forcemanual nn3'
```


查看RM服务状态:
```bash
yarn rmadmin -getAllServiceState
# 或者
yarn rmadmin -getServiceState rm1
yarn rmadmin -getServiceState rm2

# 查看管理命令参数说明
yarn rmadmin -help
```

RM状态切换命令：
```bash
# 切换为active
yarn rmadmin -transitionToActive --forceactive --forcemanual rm1

# 切换为standby
yarn rmadmin -transitionToStandby --forcemanual rm2
```


### 4.7 测试故障转移

#### 4.7.1 测试NN故障转移

查看当前NameNode服务主active状态：
```bash
hdfs haadmin -getAllServiceState
# 或者
hdfs haadmin -getServiceState nn1
hdfs haadmin -getServiceState nn2
```

回显如下：
```text
[root@hadoop-202 ~]# hdfs haadmin -getAllServiceState
hadoop-201:8020                                 standby   
hadoop-202:8020                                 active    
hadoop-203:8020                                 standby   
```

杀死hadoop-node2上的NameNode进程：
```bash
ssh root@hadoop-202 "jps|grep NameNode|awk '{print \$1}'|xargs kill -9"
# 重启
ssh root@hadoop-202 "hdfs --daemon start namenode"
```

再次查看NameNode状态：
```bash
hdfs haadmin -getAllServiceState
# 或者
hdfs haadmin -getServiceState nn1
hdfs haadmin -getServiceState nn2
```
回显如下：
```text
[root@hadoop-202 ~]# hdfs haadmin -getAllServiceState
hadoop-201:8020                                 active    
hadoop-202:8020                                 standby   
hadoop-203:8020                                 standby   
```

#### 4.7.2 测试RM故障转移

查看当前RM服务主active状态：
```bash
yarn rmadmin -getAllServiceState
# 或者
yarn rmadmin -getServiceState rm1
yarn rmadmin -getServiceState rm2
```

回显如下：
```text
hadoop-201:8033                                 active    
hadoop-202:8033                                 standby
```

杀死hadoop-node1上的RM进程：
```bash
ssh root@hadoop-201 "jps|grep ResourceManager|awk '{print \$1}'|xargs kill -9"
# 然后启动
ssh root@hadoop-201 'yarn --daemon start resourcemanager'
```

再次查看RM状态：
```bash
yarn rmadmin -getAllServiceState
# 或者
yarn rmadmin -getServiceState rm1
yarn rmadmin -getServiceState rm3
```
回显如下：
```text
[root@hadoop-202 hadoop]# yarn rmadmin -getAllServiceState
hadoop-201:8033                                 standby   
hadoop-202:8033                                 active
```
证明成功实现故障自动转移。


## 4.8. 常用命令

```bash
查看节点状态
hdfs haadmin -getAllServiceState
yarn rmadmin -getAllServiceState

# 启动JournalNode
hdfs --daemon start journalnode
hdfs --daemon status journalnode
hdfs --daemon stop journalnode


# 启动DataNode
hdfs --daemon start datanode
hdfs --daemon status datanode
hdfs --daemon stop datanode

# 启动NameNode
hdfs --daemon start namenode
hdfs --daemon status namenode
hdfs --daemon stop namenode

# 启动ZKFC
hdfs --daemon start zkfc
hdfs --daemon status zkfc
hdfs --daemon stop zkfc
hdfs --help

# 启动NM
yarn --daemon start nodemanager
yarn --daemon status nodemanager
yarn --daemon stop nodemanager

# 启动RM
yarn --daemon start resourcemanager
yarn --daemon status resourcemanager
yarn --daemon stop resourcemanager
yarn --help
```

## 4.9. 一键重启脚本

一键同步配置脚本：
```bash
cat > ${HADOOP_HOME}/sbin/sync-hadoop-configs.sh <<EOF
#!/bin/sh

HADOOP_CONF_DIR="/opt/server/hadoop/etc/hadoop"

# 需要同步的机器列表
HOST_NODES=\$(cat "\${HADOOP_CONF_DIR}/workers")
# 需要同步的文件列表
CONF_FILES="core-site.xml hdfs-site.xml yarn-site.xml mapred-site.xml"

RM_HADOOP_LOGS_CMD="rm -rf /opt/server/hadoop/logs/*"

echo "sync system profiles:"
echo ""

for host in \$HOST_NODES
do
    if [ "\${SELF_HOST}" != \$host ];then
        scp /etc/profile.d/hadoop.sh   root@\${host}:/etc/profile.d/
    fi
done

echo ""
echo "sync hadoop config files:"
echo ""

for file_name in \$CONF_FILES
do
    for host in \$HOST_NODES
    do
        file="\${HADOOP_CONF_DIR}/\${file_name}"
        if [ -f \${file} ];then
            if [ "\${SELF_HOST}" != \$host ];then
                scp "\${file}" "root@\${host}:\${HADOOP_CONF_DIR}/"
            fi
        fi
    done
done

exit 0
EOF

chmod a+x sync-hadoop-configs.sh
```

一键重启脚本：
```bash
cat > restart-hadoop-all.sh <<EOF
#!/bin/sh

HERE="\$(cd \$(dirname \$0);pwd)"

\${HERE}/sync-hadoop-configs.sh

echo ""
echo "stop all hadoop services:"
echo ""
stop-hadoop-all.sh

echo ""
echo "clean all logs:"
echo ""

for host in \$HOST_NODES
do
    if [ "\${SELF_HOST}" != \$host ];then
        ssh "root@\${host}" \${RM_HADOOP_LOGS_CMD}
    else
        eval \${RM_HADOOP_LOGS_CMD}
    fi
done

echo ""
echo "start all hadoop services:"
echo ""
start-hadoop-all.sh
echo ""

exit 0
EOF

chmod a+x restart-hadoop-all.sh
```

# 十、调优

core-site.xml
```text
<property>
     <name>ipc.client.connection.maxidletime</name>
     <value>5000</value>
     <description>客户机中断与服务器连接的最长时间毫秒。默认10秒</description>
</property>
<property>
     <name>ipc.client.connect.timeout</name>
     <value>5000</value>
     <description>客户端等待套接字与服务器建立连接所需的毫秒数，默认20000</description>
</property>
<property>
     <name>ipc.client.connect.max.retries.on.timeouts</name>
     <value>3</value>
     <description>指定客户端在套接字超时时尝试与服务器建立连接的次数，默认45</description>
</property>
```

hdfs-site.xml
```text
<property>
     <name>dfs.namenode.handler.count</name>
     <value>10</value>
     <description>
     NameNode有一个工作线程池，用来处理不同DataNode的并发心跳以及客户端并发的元数据操作。
     对于大集群或者有大量客户端的集群来说，通常需要增大参数dfs.namenode.handler.count的默认值10。
     设置该值的一般原则是将其设置为集群大小的自然对数乘以20，即20 * log(N)，N为集群大小。
     </description>
</property>
<property>
     <name>dfs.hosts</name>
     <value>/opt/server/hadoop/etc/hadoop/workers</value>
     <description>
     命名一个文件，该文件包含允许连接到namenode的主机列表。
     必须指定文件的完整路径名。如果该值为空，则允许所有主机。
     </description>
</property>
```


# 十一、参考资料

- [Hadoop3.2.1版本的环境搭建](https://zhuanlan.zhihu.com/p/91302446)
- [hadoop 3.2.1集群高可用(HA)搭建](https://blog.csdn.net/u012760435/article/details/104401268)
- [Hadoop3.2.1集群搭建](http://blog.itpub.net/29956245/viewspace-2933087/)
- [Hadoop集群搭建](https://blog.csdn.net/qq_41537880/article/details/129426222)
- [Hdfs安装模式之完全分布式集群](https://zhuanlan.zhihu.com/p/113637003)
- [HDFS High Availability Using the Quorum Journal Manager](https://hadoop.apache.org/docs/r3.2.1/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithQJM.html)
- [Hadoop: Setting up a Single Node Cluster](https://hadoop.apache.org/docs/r3.2.1/hadoop-project-dist/hadoop-common/SingleCluster.html)
- [hive配置Kerbros安全认证](https://zhuanlan.zhihu.com/p/137424234)
- [Hadoop集群的启动脚本整理及守护线程源码](https://zhuanlan.zhihu.com/p/113912871)


# 十二、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->centos7.x-hadoop3.3.x](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2Fsharelink2076919717-858150382706250%2Ffiles%2Fcentos7.x-hadoop3.3.x)
