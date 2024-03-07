---
title: CentOS7 部署 Hadoop 3.2.X hive
date: 2023-12-27 19:11:19
tags:
---

一、前言

Presto简介

Presto是一个开源的分布式SQL查询引擎，适用于交互式分析查询，数据量支持GB到PB字节。Presto的设计和编写完全是为了解决像Facebook这样规模的商业数据仓库的交互式分析和处理速度的问题。Presto支持在线数据查询，包括Hive, Cassandra, 关系数据库以及专有数据存储。 一条Presto查询可以将多个数据源的数据进行合并，可以跨越整个组织进行分析。


## 安装PRESTO


前往官网：[Presto Release Notes](https://repo1.maven.org/maven2/com/facebook/presto/presto-spark-package/) 下载：[presto-server-0.284.tar.gz](https://repo1.maven.org/maven2/com/facebook/presto/presto-server/0.284/presto-server-0.284.tar.gz)

```bash
cd /usr/local/src
wget https://repo1.maven.org/maven2/com/facebook/presto/presto-server/0.284/presto-server-0.284.tar.gz
tar zxvf presto-server-0.284.tar.gz -C /opt/server/

cd /opt/server/
ln -s presto-server-0.284 presto
```

安装客户端：
```bash
cd /opt/server/presto/bin/
wget https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/0.284/presto-cli-0.284-executable.jar
mv presto-cli-0.284-executable.jar presto
chmod a+x presto
```

添加环境变量：
```bash
cat > /etc/profile.d/presto.sh <<EOF
export PRESTO_HOME=/opt/server/presto
export PATH=\$PATH:\${PRESTO_HOME}/bin
EOF

source /etc/profile
```



搭建
```bash
mkdir -p /opt/server/presto/etc/catalog

cd /opt/server/presto/etc

cat > node.properties <<EOF
node.environment=production
#每个节点需要不同
node.id=ffffffff-ffff-ffff-ffff-ffffffffffff01
node.data-dir=/usr/local/presto-server/data
EOF

cat > jvm.config <<EOF
-server
-Xmx2G
-XX:+UseG1GC
-XX:G1HeapRegionSize=32M
-XX:+UseGCOverheadLimit
-XX:+ExplicitGCInvokesConcurrent
-XX:+HeapDumpOnOutOfMemoryError
-XX:+ExitOnOutOfMemoryError
EOF

cat > config.properties <<EOF
#work节点需要填写false
coordinator=true
#是否允许在coordinator上调度节点只负责调度时node-scheduler.include-coordinator设置为false，调度节点也作为worker时node-scheduler.include-coordinator设置为true
node-scheduler.include-coordinator=true
http-server.http.port=8089
query.max-memory=1GB
query.max-memory-per-node=512MB
query.max-total-memory-per-node=512MB
#Presto 通过Discovery 服务来找到集群中所有的节点,每一个Presto实例都会在启动的时候将自己注册到discovery服务；  注意：worker 节点不需要配 discovery-server.enabled
discovery-server.enabled=true
#Discovery server的URI。由于启用了Presto coordinator内嵌的Discovery 服务，因此这个uri就是Presto coordinator的uri
discovery.uri=http://localhost:8089
EOF

cat > log.properties <<EOF
com.facebook.presto=INFO
EOF


cat > ${PRESTO_HOME}/etc/catalog/mysql.properties <<EOF
connector.name=mysql
connection-url=jdbc:mysql://localhost:3306
connection-user=hive
connection-password=hive1234
EOF


cat > $PRESTO_HOME/etc/catalog/hive.properties <<EOF
connector.name=hive-hadoop2
hive.metastore.uri=thrift://localhost:9083
hive.config.resources=/opt/server/hadoop/etc/hadoop/core-site.xml,/opt/server/hadoop/etc/hadoop/hdfs-site.xml
EOF
```

## 测试

启动presto服务
```bash
launcher run
```


链接客户端:
```bash
presto --server localhost:8089 --catalog mysql
```

进入presto控制台：
```text
[root@hadoop-201 bin]# presto --server localhost:8089 --catalog mysql
presto> show catalogs;
 Catalog 
---------
 hive    
 mysql   
 system  
(3 rows)

Query 20231228_133949_00000_nupd4, FINISHED, 1 node
Splits: 19 total, 19 done (100.00%)
[Latency: client-side: 0:02, server-side: 0:01] [0 rows, 0B] [0 rows/s, 0B/s]

presto> use hive;
USE
presto:hive> select * from default.test;
 id |  name  | gender 
----+--------+--------
  1 | 王力宏 | 男     
  2 | 阴丽华 | 女     
  3 | 周杰伦 | 男     
(3 rows)

Query 20231228_140510_00004_qs4c9, FINISHED, 1 node
Splits: 17 total, 17 done (100.00%)
[Latency: client-side: 314ms, server-side: 293ms] [3 rows, 48B] [10 rows/s, 163B/s]
```

http://192.168.168.201:8089/ui/




HADOOP启动脚本
```
#!/bin/sh
#
# hadoop        This shell script takes care of starting and stopping
#
# chkconfig: 345 64 36
# description:  Hadoop server.
# processname: hadoop

source /etc/profile

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

start(){
 sh ${HADOOP_HOME}/sbin/start-all.sh
}

stop(){
 sh ${HADOOP_HOME}/sbin/stop-all.sh
} 

restart(){
    stop
    start
}

status(){
  HADOOP_PROC_NUM=$(netstat -tulnp | grep 50070 | wc -l)
  if [ "${HIVE_PROC_NUM}" = "1" ]; then
    echo -e "hadoop服务已启动, web端口[50070]监听中"
  else
    echo -e "hadoop服务未启动"
  fi
}


# See how we were called.
case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  status)
    status
    ;;
  restart)
    restart
    ;;
  *)
    echo $"Usage: $0 {start|stop|status|restart}"
    exit 2
esac

exit $?
```


Presto-server脚本
```
#! /bin/bash
#
# Presto This shell script takes care of starting and stopping
#
# chkconfig: 345 64 36
# description:  Presto server.
# processname: presto
#
### BEGIN INIT INFO
# Should-Start: hive
# Short-Description: Presto This shell script takes care of starting and stopping
# Description: Presto This shell script takes care of starting and stopping
### END INIT INFO

source /etc/profile

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

##
HIVE_PROC_NUM="netstat -tulnp | grep 10000 | wc -l"
PRESTO_PID="ps aux | grep -v grep | grep HiveServer2 | awk '{print \$2}'"
##


checkHiveServer(){
    while (($(eval "${HIVE_PROC_NUM}")<=0))
    do
      sleep 1s
    done
}

start(){
    checkHiveServer
    ${PRESTO_HOME}/bin/launcher start
}

stop(){
    ${PRESTO_HOME}/bin/launcher stop
}

restart(){
    ${PRESTO_HOME}/bin/launcher restart
}

status(){
  ${PRESTO_HOME}/bin/launcher status
}

# See how we were called.
case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  status)
    status
    ;;
  restart)
    restart
    ;;
  *)
    echo $"Usage: $0 {start|stop|status|restart}"
    exit 2
esac

exit $?
```