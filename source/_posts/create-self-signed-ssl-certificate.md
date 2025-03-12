---
title: 创建自签名SSL证书
date: 2025-01-16 22:55:24
categories: ['SSL', 'Certificate']
tags: ['SSL', 'Certificate']
---

# 创建自签名SSL证书


## 一、自签名ssl证书创建

使用openssl工具进行自签名ssl证书，方便在内网环境中部署使用，为你的网站安全加把锁

自签证书流程：创建 ca 私钥--->用 ca 私钥生成 ca 根证书--->创建 ssl 私钥--->创建 ssl 证书csr--->用 ca 根证书签署生成 ssl 证书

操作方法：

### 1、创建一个文件夹 ca 用来保存 ca 证书文件

```bash
mkdir ca
```

### 2、创建 ca 私钥（建议设置密码）

```bash
openssl genrsa -des3 -out ca/CA.key 4096
```
输出:
```txt
Enter PEM pass phrase:                #输入密码
Verifying - Enter PEM pass phrase:    #输入确认密码
```

### 3、生成 ca 证书，自签20年有效期，把此 ca 证书导入需要访问pc的“受信任的根证书颁发机构”中，后期用此 ca 签署的证书都可以使用

```bash
openssl req -x509 -new -nodes -key ca/CA.key -sha256 -days 7300 -out ca/CA.crt
```
输出：
```text
Enter pass phrase for ca/CA.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:CN								 #国家
State or Province Name (full name) [Some-State]:Guangdong            #省份
Locality Name (eg, city) []:Shenzhen                                 #城市
Organization Name (eg, company) [Internet Widgits Pty Ltd]:ORG       #组织
Organizational Unit Name (eg, section) []:IT Dep                     #部门
Common Name (e.g. server FQDN or YOUR name) []:www.test.org          #域名
Email Address []:it@test.org										 #邮箱
```

#查看证书信息命令 
```bash
openssl x509 -in ca/CA.crt -noout -text
```
输出：
```text
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            37:02:7a:a6:ef:c1:57:f7:74:ad:74:5a:d0:4a:51:b2:27:f4:b6:c7
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=CN, ST=Guangdong, L=Shenzhen, O=ORG, OU=IT Dep, CN=www.test.or
g, emailAddress=it@test.org
        Validity
            Not Before: Jan 16 14:21:22 2025 GMT
            Not After : Jan 11 14:21:22 2045 GMT
        Subject: C=CN, ST=Guangdong, L=Shenzhen, O=ORG, OU=IT Dep, CN=www.test.o
rg, emailAddress=it@test.org
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:bb:95:be:64:d3:ec:0c:f4:83:35:e3:47:86:f9:
                    ce:e8:5e:e2:7d:b2:13:04:c4:1f:a7:87:7a:ac:84:
                    69:f8:95:3b:60:ad:74:84:f4:d2:ce:77:fe:05:e7:
                    b5:d2:40:76:07:d9:f5:0c:4c:2d:45:59:db:85:e7:
                    6f:91:0e:e2:2c:c3:a3:a9:1f:a8:18:ca:8e:5d:58:
                    85:a9:d5:69:a5:e2:26:06:eb:74:b0:7a:18:cc:0a:
                    25:9e:85:4d:d6:9e:55:1a:fb:91:4e:0e:a3:5a:c6:
                    0d:96:71:eb:de:1f:c0:13:53:c1:51:3b:9a:28:d8:
                    b8:be:51:2d:1b:0f:49:9e:b6:8d:b7:ec:c5:31:b8:
                    ce:4c:ae:b3:3a:08:4c:dd:b8:56:d0:17:ed:de:b6:
                    1c:ce:07:8f:8f:65:cd:95:2a:eb:34:4c:d7:57:13:
                    0d:70:26:0b:a7:dc:1a:aa:2a:8a:51:cc:67:15:e8:
                    b1:72:3b:99:6c:e6:c2:0c:a2:37:97:be:09:00:89:
                    8d:06:8e:ed:65:09:e4:77:d2:61:8d:c8:f2:70:03:
                    63:b2:b9:0b:f1:3a:d0:c2:c1:73:6c:c8:98:c7:44:
                    d5:4e:e9:84:d5:e0:51:46:cd:19:38:75:87:ef:84:
                    ed:97:69:e2:9f:eb:c6:fa:0c:08:7f:75:be:29:ac:
                    10:59
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Key Identifier:
                75:93:E6:BD:B5:79:89:54:7B:8F:DB:2C:45:4A:AB:A0:FB:1E:95:12
            X509v3 Authority Key Identifier:
                75:93:E6:BD:B5:79:89:54:7B:8F:DB:2C:45:4A:AB:A0:FB:1E:95:12
            X509v3 Basic Constraints: critical
                CA:TRUE
    Signature Algorithm: sha256WithRSAEncryption
    Signature Value:
        7b:8a:78:20:73:1c:e9:b2:93:a8:09:73:09:cb:8b:84:dc:74:
        56:82:03:bc:bd:72:31:0f:d6:81:c0:0a:96:a7:83:e6:59:3c:
        ae:fb:8b:75:89:60:33:67:3c:a8:5b:d8:d2:05:63:34:80:0f:
        d1:de:fa:80:6e:59:6d:99:e4:8f:34:99:c3:ba:63:53:1b:40:
        24:e8:14:58:f4:1a:93:c5:1f:d4:bb:0e:29:bc:b5:f6:6e:4e:
        10:16:0f:47:f9:7d:7f:6d:96:51:36:ae:cb:47:4c:64:3b:4d:
        fd:47:6e:37:94:2e:29:7c:5e:ec:a4:c3:d6:b4:0a:30:61:1e:
        d4:9f:68:91:af:77:71:a9:90:d7:db:56:10:e6:7c:b4:e1:8e:
        63:04:c8:ba:7f:71:83:b3:04:f3:fb:bd:8a:59:ed:89:58:c4:
        2c:00:3f:54:69:82:96:b1:48:f2:4b:59:4d:95:81:83:48:03:
        aa:92:14:56:db:5e:68:8b:fc:b9:73:b9:b0:bf:c4:35:6e:61:
        9c:31:36:a4:46:e8:e8:ec:ca:ff:ab:92:4b:6c:bc:b4:30:29:
        1f:cb:02:9c:a6:19:01:53:2d:b3:4a:b4:cb:49:61:65:a6:bc:
        3e:d9:eb:29:ab:00:c1:0c:d9:c6:dc:32:da:01:94:36:c4:93:
        02:7a:ef:7f
```

### 4、创建ssl证书私钥

```bash
mkdir certs

#创建ssl私钥
openssl genrsa -out certs/zabbix.key 4096
```

### 5、创建ssl证书csr

```bash
openssl req -new -key certs/zabbix.key -out certs/zabbix.csr
```
输出：
```text
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:CN
State or Province Name (full name) [Some-State]:Guangdong
Locality Name (eg, city) []:Shenzhen
Organization Name (eg, company) [Internet Widgits Pty Ltd]:ORG
Organizational Unit Name (eg, section) []:IT Dep
Common Name (e.g. server FQDN or YOUR name) []:www.test.org
Email Address []:it@test.org

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:				  #与证书一起发送的质询密码，不输入
An optional company name []:              #可选的公司名称     
```


### 6、创建域名附加配置信息

> IP.2 = 192.168.11.100 表示https要访问的ip，IP.3也是ip，ssl证书说明可以自签多个ip，这是自签ip的证书
> DNS.4 = xa.it.com     表示https要访问的域名，DNS.5，DNS.6都一样是域名，ssl证书说明可以自签多个域名，这是自签域名的证书

```bash
cat > certs/cert.ext <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment, dataEncipherment
subjectAltName = @subjectAltName

[subjectAltName]
DNS.1 = localhost
IP.2 = 192.168.11.100
IP.3 = 192.168.10.200
DNS.4 = xa.it.com
DNS.5 = xiykj.com
DNS.6 = *.xa.com
EOF
```

### 7、使用CA根证书签署ssl证书，自签ssl证书有效期20年

```bash
openssl x509 -req -in certs/zabbix.csr -out certs/zabbix.crt -days 7300 -CAcreateserial -CA ca/CA.crt -CAkey ca/CA.key -CAserial certs/serial -extfile certs/cert.ext
```
输出：
```text
Certificate request self-signature ok
subject=C=CN, ST=Guangdong, L=Shenzhen, O=ORG, OU=IT Dep, CN=www.test.org, emailAddress=it@test.org
Enter pass phrase for ca/CA.key:      #输入证书密码
```

### 8、查看文件列表

```bash
ls -l certs
```
输出：
```text
cert.ext          #ssl证书附加配置信息
serial            #证书序列号
zabbix.crt        #ssl证书文件，包含公钥信息
zabbix.csr        #ssl证书签名文件
zabbix.key        #ssl证书私钥
```

### 9、查看签署的证书信息

```bash
openssl x509 -in certs/zabbix.crt -noout -text
```
输出：
```text
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            43:51:dc:1a:64:fa:dc:27:6a:7a:2d:a8:23:f3:75:28:60:8c:fb:b8
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=CN, ST=Guangdong, L=Shenzhen, O=ORG, OU=IT Dep, CN=www.test.org, emailAddress=it@test.org
        Validity
            Not Before: Jan 16 14:38:18 2025 GMT
            Not After : Jan 11 14:38:18 2045 GMT
        Subject: C=CN, ST=Guangdong, L=Shenzhen, O=ORG, OU=IT Dep, CN=www.test.org, emailAddress=it@test.org
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:9e:a2:a7:c5:9b:69:3c:5c:0b:02:5f:83:83:13:
                    57:b7:8f:f7:a5:65:99:f8:7b:ef:6e:96:2b:7b:d2:
                    a6:67:ba:a1:e5:de:ce:ae:08:dd:ce:01:be:0e:b1:
                    3a:c1:62:9f:b0:86:37:db:d5:75:0a:75:85:45:bb:
                    07:79:37:a5:db:cd:bd:58:3a:b6:a1:3d:08:05:5e:
                    9c:ba:dc:be:cd:1e:7f:ad:c4:1a:89:0d:db:52:34:
                    6a:d6:8e:1d:e9:03:c4:85:8c:de:79:71:e5:a4:de:
                    a2:27:64:05:91:af:e6:af:cd:0c:8f:3c:e1:e1:09:
                    25:ff:4f:19:bd:f4:26:f7:e5:bb:42:64:3e:9d:3d:
                    08:58:f4:85:52:d8:ae:e9:09:9d:3d:fa:ff:06:af:
                    08:14:c8:bf:1f:83:6d:f7:42:7d:63:df:0c:2d:13:
                    dd:b7:94:f2:22:12:a8:a7:6a:8d:89:d6:c2:c3:c1:
                    de:76:8d:9d:4a:06:c1:fb:a3:2c:61:9a:f1:34:cd:
                    49:67:bc:13:b1:0e:bc:8d:6c:00:1b:a0:55:eb:fd:
                    21:dd:38:fa:17:b0:ff:c9:93:6f:9a:3c:1d:c3:b4:
                    6e:bb:0c:4e:e4:0e:db:8d:7c:f4:61:d5:27:2d:44:
                    8c:11:87:4f:6d:b2:3f:94:37:6c:60:04:03:f9:14:
                    d4:5f
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Authority Key Identifier:
                75:93:E6:BD:B5:79:89:54:7B:8F:DB:2C:45:4A:AB:A0:FB:1E:95:12
            X509v3 Basic Constraints:
                CA:FALSE
            X509v3 Key Usage:
                Digital Signature, Non Repudiation, Key Encipherment, Data Encipherment
            X509v3 Subject Alternative Name:
                DNS:localhost, IP Address:192.168.11.100, IP Address:192.168.10.200, DNS:xa.it.com, DNS:xiykj.com, DNS:*.xa.com
            X509v3 Subject Key Identifier:
                FD:DC:56:1E:D4:F5:82:E0:C1:49:4B:69:9E:DB:D3:82:FD:14:25:62
    Signature Algorithm: sha256WithRSAEncryption
    Signature Value:
        45:9e:05:83:0e:f1:66:21:cc:65:dc:86:cd:9c:e5:85:eb:7e:
        e8:a2:8b:49:6e:12:fe:6f:ec:83:50:34:36:0b:f8:b3:29:dc:
        80:21:b7:b6:71:07:43:cc:75:69:02:4d:d2:87:5c:b1:e1:7e:
        7e:e7:d7:d8:c9:75:3e:0b:ed:27:9b:7a:5f:0e:fb:34:d6:03:
        c2:fb:10:eb:0e:53:ff:e6:a5:64:fa:fe:55:4d:0c:1a:d8:e0:
        c3:c2:ef:58:25:b5:72:48:d6:63:04:6d:d3:04:c5:3f:86:01:
        bd:67:73:fc:9a:ce:67:78:d1:0b:05:4d:b4:14:19:25:e4:84:
        3d:1c:c0:06:6f:03:ba:0b:43:25:5e:e4:11:13:9a:23:39:fe:
        55:d8:80:b3:8d:17:d7:56:44:4b:e9:dc:1f:60:1a:d0:d2:e4:
        dd:8a:47:87:b1:e2:8e:83:1a:a5:06:03:b0:0c:ca:47:28:da:
        e8:37:bc:81:c0:4e:c2:8d:82:32:3f:2d:76:64:6a:ee:5d:9e:
        b6:1d:cf:46:63:c0:fa:67:52:ef:e8:2f:9c:f0:2d:e4:d1:f7:
        00:72:60:55:d5:b5:37:f8:93:c0:54:df:9e:72:2f:ea:97:42:
        c8:87:36:dc:7e:71:3a:b5:03:05:79:e9:8e:f7:03:dc:88:24:
        b8:ae:6f:a9
```

### 10、使用CA验证ssl证书状态，显示 OK 表示通过验证

```bash
openssl verify -CAfile ca/CA.crt certs/zabbix.crt
```
输出：
```text
certs/zabbix.crt: OK
```

最后将 CA.crt 导入到需要访问的客户端PC`受信任的根证书颁发机构`中，把 `zabbix.crt`、`zabbix.key` 文件部署在服务器上即可。

## 二、生成PEM格式自签根证书示例

生成一个自签的PEM格式根证书，可以用作于nginx的https服务器证书。

```bash
#生成密钥
openssl genrsa -out rootCA.key 4096

#生成证书
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 3650 -out rootCA.crt -subj "/C=CN/ST=Shanghai/L=Shanghai/O=Custom CA Org/CN=Custom Root CA" -config <(cat <<EOF
[ req ]
default_bits       = 4096
default_md         = sha256
distinguished_name = req_distinguished_name
x509_extensions    = v3_ca

[ req_distinguished_name ]


[ v3_ca ]
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment, keyAgreement, keyCertSign
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true
subjectAltName = @alt_names
extendedKeyUsage = serverAuth, clientAuth

[ alt_names ]
IP.1 = 127.0.0.1
IP.2 = 192.168.1.1
DNS.1 = localhost
DNS.2 = *.test.org
DNS.3 = www.test.org
EOF
)

#查看证书信息
openssl x509 -in rootCA.crt -text -noout
```

## 三、参考资料

- [openssl自签名CA根证书、服务端和客户端证书生成并模拟单向/双向证书验证](https://blog.csdn.net/qq_36940806/article/details/136016480)
- [自签名ssl证书](https://www.cnblogs.com/xiykj/p/18099784)
- [openssl自签一个给网站用的证书](https://zhuanlan.zhihu.com/p/630709832)
- [OpenSSL 生成CA证书和自签名证书](https://www.cnblogs.com/hovin/p/18310022)
