---
title: SpringBoot项目同时使用http和https
date: 2025-03-12 18:55:43
categories: ['Window', 'Develop', 'Language', 'Golang']
tags: ['Window', 'Develop', 'Language', 'Golang']
---

# SpringBoot项目同时使用http和https

从 Spring Boot 2.7.x 版本开始，已经增加了对 PEM 格式证书的支持，不需要再做额外的转换，这样的好处是能实现所有平台和软件的证书在格式上都保持一致。

具体文档可以查看这里 => [Spring Boot / How-to Guides / Embedded Web Servers / Using PEM-encoded files](https://docs.spring.io/spring-boot/how-to/webserver.html#howto.webserver.configure-ssl.pem-files)


## 一、生成PEM格式SSL证书

> 这里图省事，直接用根证书来做服务器证书。
> 合理的方式应该是用根证书生成一个二级服务器证书。
> 办法请查询下文参考资料！！！

生成一个自签的PEM格式根证书，可以用作于nginx的https服务器证书。

```bash
#生成密钥
openssl genrsa -out my-server.key 4096

#生成自签证书
openssl req -x509 -new -nodes -key my-server.key -sha256 -days 3650 -out my-server.crt -subj "/C=cn/ST=gd/L=sz/O=hw/OU=hc/CN=192.168.3.3" -config <(cat <<EOF
[ req ]
default_bits       = 4096
default_md         = sha256
distinguished_name = req_distinguished_name
x509_extensions    = v3_ca

[ req_distinguished_name ]
countryName = CN

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
openssl x509 -in jetbrains.crt -text -noout
```

然后将上一步生成的 my-server.key、my-server.crt 放到项目的resources下。

## 二、配置SpringBoot的yaml配置

添加启用https的配置：

```yaml
server:
  port: 443
  ssl:
    enabled: true
    certificate: classpath:my-server.crt
    certificate-private-key: classpath:my-server.key
    trust-certificate: classpath:root-ca.crt
```

## 三、增加http额外的连接器

```java
import org.apache.catalina.connector.Connector;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.stereotype.Component;

/**
 * 自定义tomcat http 80连接器
 *
 * @author cloudgyb
 * @since 2022/3/12 15:28
 */
@Component
public class CustomTomcatServer implements WebServerFactoryCustomizer<TomcatServletWebServerFactory> {

    @Override
    public void customize(TomcatServletWebServerFactory factory) {
        final Connector httpConn = new Connector();
        httpConn.setPort(80);
        factory.addAdditionalTomcatConnectors(httpConn);
    }
}
```

重启项目，此时已经同时支持https:443和http:80了！

## 四、参考资料

- [openssl自签名CA根证书、服务端和客户端证书生成并模拟单向/双向证书验证](https://blog.csdn.net/qq_36940806/article/details/136016480)
- [自签名ssl证书](https://www.cnblogs.com/xiykj/p/18099784)
- [openssl自签一个给网站用的证书](https://zhuanlan.zhihu.com/p/630709832)
- [OpenSSL 生成CA证书和自签名证书](https://www.cnblogs.com/hovin/p/18310022)
- [SpringBoot配置使用PEM格式SSL/TLS证书和私钥](https://blog.csdn.net/zhang197093/article/details/139097603)
- [SpringBoot项目同时使用http和https](https://blog.csdn.net/gybshen/article/details/123444990)
- [springboot启动使用https(支持证书生成和同时支持http和https,使用keytool生成证书)](https://blog.csdn.net/weixin_38941757/article/details/139258716)
- [SpringBoot配置HTTPS安全证书的两种方案](https://blog.csdn.net/liliangpin/article/details/127033325)
