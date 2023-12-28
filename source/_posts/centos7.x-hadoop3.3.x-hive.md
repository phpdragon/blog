---
title: CentOS7.X 部署 Hadoop3.3.X + Hive3.X
date: 2023-12-27 19:11:19
categories: ['OS', 'Linux', 'CentOS', 'Hadoop']
tags: ['OS', 'Linux', 'CentOS', 'CentOS7.X', 'Hadoop', 'Hive']
---

# 一、前言


Hive 是一个基于 Hadoop的开源数据仓库工具，用于存储和处理海量结构化数据。    它把海量数据存储于 hadoop 文件系统，而不是数据库，但提供了一套类数据库的数据存储和处理机制，并采用 HQL （类 SQL ）语言对这些数据进行自动化管理和处理。我们可以把 Hive 中海量结构化数据看成一个个的表，而实际上这些数据是分布式存储在 HDFS 中的。 Hive 经过对语句进行解析和转换，最终生成一系列基于 hadoop 的 map/reduce 任务，通过执行这些任务完成数据处理。


# 二、环境准备

> 当前系统基于博文安装：[虚拟机最小化安装CentOS 7.X系统](/blog/2023/11/16/vmware-build-small-centos-7.x/)

## 安装MySQL

请参考博文：[CentOS7.X 安装 MySQL 5.7.X](/blog/2023/12/27/centos7.x-mysql5.7.x/)


# 三、Hive安装

## 1. 安装Hive

前往官网：[Hive Release Notes](https://www.apache.org/dyn/closer.cgi/hive/) 下载：[apache-hive-3.1.3-bin.tar.gz](https://dlcdn.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz)

```bash
cd /usr/local/src
wget https://dlcdn.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz --no-check-certificate
tar zxvf apache-hive-3.1.3-bin.tar.gz -C /opt/server/

cd /opt/server/
ln -s apache-hive-3.1.3-bin hive
```

## 2.添加配置文件

```bash
cat > /opt/server/hive/conf/hive-site.xml <<EOF
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>hive.exec.scratchdir</name>
        <value>/opt/server/hive/tmp</value>
    </property>
    <property>
        <name>hive.metastore.warehouse.dir</name>
        <value>/opt/server/hive/warehouse</value>
    </property>
    <property>
        <name>hive.querylog.location</name>
        <value>/opt/server/hive/log</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:mysql://localhost:3306/db_hive?createDatabaseIfNotExist=true&amp;characterEncoding=UTF-8&amp;useSSL=false</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>com.mysql.jdbc.Driver</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionUserName</name>
        <value>hive</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionPassword</name>
        <value>hive1234</value>
    </property>
    <property>
        <name>hive.metastore.uris</name>
        <value>thrift://hadoop-201:9083</value>
    </property>
    <property>
        <name>hive.server2.thrift.bind.host</name>
        <value>hadoop-201</value>
        <description>Bind host on which to run the HiveServer2 Thrift service.</description>
    </property>
    <property>
        <name>hive.metastore.event.db.notification.api.auth</name>
        <value>false</value>
    </property>
</configuration>
EOF
```

## 3.添加环境变量

```bash
cat > /etc/profile.d/hive-server.sh <<EOF
export HIVE_HOME=/opt/server/hive
export PATH=\${HIVE_HOME}/bin:\$PATH
EOF

source /etc/profile
```

## 4.下载MySQL驱动

前往 https://downloads.mysql.com/archives/c-j/ 下载 [mysql-connector-java-5.1.49.tar.gz](https://cdn.mysql.com/archives/mysql-connector-java-5.1/mysql-connector-java-5.1.49.tar.gz) ，解压文件并把MySQL驱动包放至 hive/lib 目录下

```bash
cd /usr/local/src
wget https://cdn.mysql.com/archives/mysql-connector-java-5.1/mysql-connector-java-5.1.49.tar.gz
tar zxf mysql-connector-java-5.1.49.tar.gz

mv mysql-connector-java-5.1.49/mysql-connector-java-5.1.49-bin.jar /opt/server/hive/lib/
rm -rf mysql-connector-java-5.1.49
```

## 5.初始化元数据库

```bash
mysql -h hadoop-201 -uroot -proot1234
```

添加用户hive
```sql
CREATE DATABASE db_hive;
set global validate_password_policy=LOW;
CREATE USER 'hive'@'%' IDENTIFIED BY 'hive1234';
GRANT ALL ON db_hive.* TO 'hive'@'%';
FLUSH PRIVILEGES;
```

初始化数据结构：
```bash
schematool -dbType mysql -initSchema -verbose

mysql -h hadoop-201 -uroot -proot1234 -e 'show databases';
```


## 6.启动服务
```bash
mv /opt/server/hive/lib/guava-19.0.jar  /opt/server/hive/lib/guava-19.0.jar_bak
cp /opt/server/hadoop/share/hadoop/hdfs/lib/guava-27.0-jre.jar /opt/server/hive/lib/

cd /opt/server/hive
mkdir -p logs
nohup hive --service metastore > logs/hive_metastore.log 2>&1 &
nohup hive --service hiveserver2  > logs/hive_server2.log 2>&1 &
```

## 7.进入hive控制台

```bash
su hdfs -c 'beeline -u jdbc:hive2://localhost:10000/dm -n hadoop'
# 或者
su hdfs -c 'hive'
```

hive简单操作
```sql
show databases;

create table test(id INT,name string, gender string);
insert into test values(1,'王力宏','男'),(2,'阴丽华','女'),(3,'周杰伦','男');
select gender,count(*) as total from test group by gender;
select * from test;
```

## 8.添加启动脚本

vi /opt/server/hive/bin/hiveServer.sh，添加如下内容：
```shell
#! /bin/bash

source /etc/profile

##
HADOOP_PROC_NUM="hdfs haadmin -getAllServiceState|grep active|wc -l"
HIVE_META_STORE_PID="ps aux|grep -v grep|grep HiveMetaStore|awk '{print \$2}'"
HIVE_SERVER2_PID="ps aux|grep -v grep|grep HiveServer2|awk '{print \$2}'"

LOG_METASTORE="${HIVE_HOME}/logs/hive_metastore.log"
LOG_SERVER2="${HIVE_HOME}/logs/hive_server2.log"
##


checkHadoopDfsServer(){
    while (($(eval "${HADOOP_PROC_NUM}")<=0))
    do
      sleep 1s
    done
}

start(){
    checkHadoopDfsServer

    nohup hive --service metastore > ${LOG_METASTORE} 2>&1 &
    
    while [ $(eval "${HIVE_META_STORE_PID}") ]
    do
        sleep 1s
    done

    nohup hive --service hiveserver2 > ${LOG_SERVER2} 2>&1 &
}

stop(){
    if [ $(eval "${HIVE_META_STORE_PID}") ]; then
        ps aux | grep -v grep | grep HiveMetaStore | awk '{print $2}' | xargs kill -9
    fi
    if [ $(eval "${HIVE_SERVER2_PID}") ]; then
        ps aux | grep -v grep | grep HiveServer2 | awk '{print $2}' | xargs kill -9
    fi
}

restart(){
    stop
    start
}

status(){
  pid=$(ps axu|grep java|grep HiveServer2|awk '{print $2}')
  if [ "${pid}"x != "x" ]; then
    echo -e "hive pid: ${pid}, web端口[10000]监听中"
  else
    echo -e "hive服务未启动"
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

添加开机启动脚本：
```bash
cat > /usr/lib/systemd/system/hive.service <<EOF
[Unit]
Description=hive
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/server/hive/bin/hiveServer.sh start
ExecStop=/opt/server/hive/bin/hiveServer.sh stop
Restart=always
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF


systemctl enable hive
systemctl daemon-reload
```

