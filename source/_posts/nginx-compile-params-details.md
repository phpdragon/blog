---
title: Nginx编译参数详解
date: 2023-11-16 22:05:41
tags:
---

# 前言

- Nginx (engine x) 是一个高性能的HTTP和反向代理web服务器，同时也提供了IMAP/POP3/SMTP服务。
Nginx是由伊戈尔·赛索耶夫为俄罗斯访问量第二的Rambler.ru站点（俄文：Рамблер）开发的，公开版本1.19.6发布于2020年12月15日。
- 其将源代码以类BSD许可证的形式发布，因它的稳定性、丰富的功能集、简单的配置文件和低系统资源的消耗而闻名。2022年01月25日，nginx 1.21.6发布。
- Nginx是一款轻量级的Web 服务器/反向代理服务器及电子邮件（IMAP/POP3）代理服务器，在BSD-like 协议下发行。
其特点是占有内存少，并发能力强，事实上nginx的并发能力在同类型的网页服务器中表现较好。

# 查看支持的构建参数

> 官方链接：[从源代码构建nginx-编译配置参数说明](http://nginx.org/en/docs/configure.html)

使用configure命令配置构建。它定义了系统的各个方面，包括nginx允许用于连接处理的方法。最后，它创建一个Makefile。

查看构建参数:
```shell
./configure --help
```

> 参数 : 默认值 : 作用 : 备注

| ./config编译参数  | 默认值  |  作用  |  备注  |
| --- | --- | --- | --- |
|  --prefix=PATH                                |  /usr/local/nginx  |  指定安装目录。  |  这个目录也将被用于所有由configure设置的相对路径(库源路径除外)和nginx.conf配置文件中。  |
|  --sbin-path=PATH                             |  <prefix>/sbin/nginx  |  指定可执行程序文件  |
|  --modules-path=PATH                          |  <prefix>/modules  |  定义安装nginx动态模块的目录。  |
|                                               |
|  --conf-path=PATH                             |  <prefix>/conf/nginx.conf  |  指定nginx.conf配置文件  |  运行时可以通过在命令行参数-c file来自定义  |
|  --error-log-path=PATH                        |  <prefix>/logs/error.log  |  指定错误日志目录  |  安装后，可在nginx.conf中使用error_log=xxx.log修改  |
|  --pid-path=PATH                              |  <prefix>/logs/nginx.pid  |  指定nginx.pid文件  |  安装后，可在nginx.conf中使用pid=xxx.pid修改  |
|  --lock-path=PATH                             |  <prefix>/logs/nginx.lock  |  指定nginx.lock文件  |  安装后，可在nginx.conf中使用lock_file=xxx.lock修改  |
|                                               |
|  --user=USER                                  |  nobody  |  指定程序运行时的非特权用户，  |  安装后，可在nginx.conf中使用user=nginx修改  |
|  --group=GROUP                                |    |  指定程序运行时的非特权用户组，  |  缺省下组名为非特权用户名。安装后，可在nginx.conf中使用user=user group修改  |
|                                               |
|  --build=NAME                                 |    |  指向编译构建名称  |
|  --builddir=DIR                               |    |  指向编译目录  |
|                                               |
|  --with-select_module                         |    |  启用select模块支持  |  一种轮询模式，不推荐在高载环境下使用  |
|  --without-select_module                      |    |  禁用select模块支持  |
|  --with-poll_module                           |    |  启用poll模块支持  |  功能与select相同，与select特性相同，为一种轮询模式,不推荐在高载环境下使用  |
|  --without-poll_module                        |    |  禁用poll模块支持  |
|                                               |    |    |
|  --with-threads                               |    |  启用线程池支持  |
|                                               |
|  --with-file-aio                              |    |  启用file aio支持  |  一种APL文件传输格式  |
|                                               |
|  --without-quic_bpf_module                    |    |  disable ngx_quic_bpf_module  |
|                                               |
|  --with-http_ssl_module                       |    |  启用ngx_http_ssl_module支持  |  支持https请求，需安装openssl库  |
|  --with-http_v2_module                        |  关闭  |  启用http v2协议  |
|  --with-http_v3_module                        |  关闭  |  启用http v3协议  |  建议构建时使用如BoringSSL、LibreSSL或QuicTLS支持SSL的库。使用OpenSSL库将不支持QUIC早期数据  |
|  --with-http_realip_module                    |  关闭  |  启用ngx_http_realip_module  |  这个模块允许从请求标头更改客户端的IP地址值  |
|  --with-http_addition_module                  |  关闭  |  启用ngx_http_addition_module  |  作为一个输出过滤器，支持不完全缓冲，分部分响应请求  |
|  --with-http_xslt_module                      |  关闭  |  启用ngx_http_xslt_module  |  过滤转换XML请求
|  --with-http_xslt_module=dynamic              |    |  同上  |
|  --with-http_image_filter_module              |  关闭  |  启用ngx_http_image_filter_module  |  传输JPEG/GIF/PNG 图片的一个过滤器，要用到gd库  |
|  --with-http_image_filter_module=dynamic      |  关闭  |  同上  |
|  --with-http_geoip_module                     |  关闭  |  启用ngx_http_geoip_module  |  该模块通过客户端IP地址和MaxMind的GeoIP库，来创建客户端所在的国家，城市等变量  |
|  --with-http_geoip_module=dynamic             |  关闭  |  同上  |  [如何给NGINX安装ngx_http_geoip2_module模块](https://www.azio.me/how-to-install-ngx_http_geoip2_module/)  |
|  --with-http_sub_module                       |  关闭  |  启用ngx_http_sub_module  |  允许通过将一个指定字符串替换为另一个字符串来修改响应  |
|  --with-http_dav_module                       |  关闭  |  启用ngx_http_dav_module  |  通过WebDAV协议提供文件管理自动化，需编译开启  |
|  --with-http_flv_module                       |  关闭  |  启用ngx_http_flv_module  |  为Flash Video (FLV)文件提供伪流服务器端支持  |
|  --with-http_mp4_module                       |  关闭  |  启用ngx_http_mp4_module  |  为MP4文件提供伪流服务器端支持  |
|  --with-http_gunzip_module                    |  关闭  |  启用ngx_http_gunzip_module  |  为不支持“gzip”编码方法的客户端自动解压具有“Content-Encoding: gzip”报头的响应  |
|  --with-http_gzip_static_module               |  关闭  |  启用ngx_http_gzip_static_module  |  负责搜索和发送经过Gzip功能预压缩的数据（在线实时压缩输出数据流）  |
|  --with-http_auth_request_module              |  关闭  |  启用ngx_http_auth_request_module  |  基于子请求结果的客户端认证，如果子请求返回2xx状态码，访问将被允许。  |
|  --with-http_random_index_module              |  关闭  |  启用ngx_http_random_index_module  |  处理以斜杠字符('/')结尾的请求，并在目录中随机选择一个文件作为索引文件  |
|  --with-http_secure_link_module               |  关闭  |  启用ngx_http_secure_link_module  |  可以对请求的链接进行真伪校验,并限制链接的有效时间  |
|  --with-http_degradation_module               |  关闭  |  启用ngx_http_degradation_module  |  允许在内存不足的情况下返回204或444码  |
|  --with-http_slice_module                     |  关闭  |  启用ngx_http_slice_module  |  它将请求拆分为子请求,每个子请求都返回一定范围的响应。实现如：分片上传功能  |
|  --with-http_stub_status_module               |  关闭  |  启用ngx_http_stub_status_module  |  获取nginx自上次启动以来的工作状态  |
|                                               |
|  --without-http_charset_module                |  启用  |  禁用ngx_http_charset_module  |  将指定的charset添加到“Content-Type”响应报头(Response Headers)字段中，从而用将响应内容转换为另一种charset  |
|  --without-http_gzip_module                   |  启用  |  禁用ngx_http_gzip_module  |  该模块同-with-http_gzip_static_module功能一样  |
|  --without-http_ssi_module                    |  启用  |  禁用ngx_http_ssi_module  |  该模块提供了一个在输入端处理处理服务器包含文件（SSI）的过滤器，目前支持SSI命令的列表是不完整的  |
|  --without-http_userid_module                 |  启用  |  禁用ngx_http_userid_module  |  设置适用于客户端标识的 cookie  |
|  --without-http_access_module                 |  启用  |  禁用ngx_http_access_module  |  提供了基于主机ip地址，允许限制对某些客户端地址的访问  |
|  --without-http_auth_basic_module             |  启用  |  禁用ngx_http_auth_basic_module  |  可以使用用户名和密码认证的方式来对站点或部分内容进行认证  |
|  --without-http_mirror_module                 |  启用  |  禁用ngx_http_mirror_module  |  可以复制原始请求发送到一个特定的环境，同时Nginx会忽略这个复制的请求的返回值。如生产环境的流量拷贝到预上线环境或测试环境  |
|  --without-http_autoindex_module              |  启用  |  禁用disable ngx_http_autoindex_module  |  处理以斜杠字符(' / ')结尾的请求，并在ngx_http_index_module模块找不到索引文件时生成目录列表。  |
|  --without-http_geo_module                    |  启用  |  禁用ngx_http_geo_module  |  该模块会根据客户端IP地址创建带有值的变量。  |
|  --without-http_map_module                    |  启用  |  禁用ngx_http_map_module  |  使用任意的键/值对设置配置变量  |
|  --without-http_split_clients_module          |  启用  |  禁用ngx_http_split_clients_module  |  适用于A / B测试的变量，也称为分割测试。  |
|  --without-http_referer_module                |  启用  |  禁用disable ngx_http_referer_module  |  该模块用来过滤请求，拒绝报头中Referer值不正确的请求  |
|  --without-http_rewrite_module                |  启用  |  禁用ngx_http_rewrite_module  |  该模块允许使用正则表达式改变URI，并且根据变量来转向以及选择配置。此模块需要PCRE库  |
|  --without-http_proxy_module                  |  启用  |  禁用ngx_http_proxy_module  |  http代理功能  |
|  --without-http_fastcgi_module                |  启用  |  禁用ngx_http_fastcgi_module  |  允许Nginx 与FastCGI 进程交互，并通过传递参数来控制FastCGI 进程工作。 FastCGI一个常驻型的公共网关接口。  |
|  --without-http_uwsgi_module                  |  启用  |  禁用ngx_http_uwsgi_module  |  启用uwsgi协议，uwsgi服务器相关  |
|  --without-http_scgi_module                   |  启用  |  禁用ngx_http_scgi_module  |  启用SCGI协议支持，SCGI协议是CGI协议的替代。它是一种应用程序与HTTP服务接口标准。它有些像FastCGI但他的设计 更容易实现。  |
|  --without-http_grpc_module                   |  启用  |  禁用ngx_http_grpc_module  |  允许将请求传递给 gRPC 服务器  |
|  --without-http_memcached_module              |  启用  |  禁用ngx_http_memcached_module  |  启用对memcached的支持，用来提供简单的缓存，以提高系统效率  |
|  --without-http_limit_conn_module             |  启用  |  禁用ngx_http_limit_zone_module  |  用来限制每个键的连接数，例如，来自单个IP地址的连接数。  |
|  --without-http_limit_req_module              |  启用  |  禁用ngx_http_limit_req_module  |  用来限制每个键的请求处理速率，例如，来自单个IP地址的请求的处理速率。  |
|  --without-http_empty_gif_module              |  启用  |  禁用ngx_http_empty_gif_module  |  在内存中常驻了一个1*1的透明GIF图像，可以被非常快速的调用。  |
|  --without-http_browser_module                |  启用  |  禁用ngx_http_browser_module  |  解析HTTP请求头中的”User-Agent“ 的值，来生成变量，以供后续的请求逻辑处理。  |
|  --without-http_upstream_hash_module          |  启用  |  禁用http_upstream_hash_module  |  支持普通的hash及一致性hash两种负载均衡算法,默认的是普通的hash来进行负载均衡  |
|  --without-http_upstream_ip_hash_module       |  启用  |  禁用ngx_http_upstream_ip_hash_module  |  提供ip hash负载均衡方法  |
|  --without-http_upstream_least_conn_module    |  启用  |  禁用ngx_http_upstream_least_conn_module  |  实现least_conn负载平衡方法  |
|  --without-http_upstream_random_module        |  启用  |  禁用ngx_http_upstream_random_module  |  实现随机负载平衡方法  |
|  --without-http_upstream_keepalive_module     |  启用  |  禁用ngx_http_upstream_keepalive_module  |  提供缓存上游服务器连接，大于keepalive xx; 数值会被关闭  |
|  --without-http_upstream_zone_module          |  启用  |  禁用ngx_http_upstream_zone_module  |  可以将上游组的运行时状态存储在共享内存区域中  |
|                                               |
|  --with-http_perl_module                      |  关闭  |  启用ngx_http_perl_module  |  使nginx可以直接使用perl或通过ssi调用perl  |
|  --with-http_perl_module=dynamic              |    |  同上  |
|  --with-perl_modules_path=PATH                |    |  设定perl模块路径  |
|  --with-perl=PATH                             |    |  设定Perl二进制文件路径  |
|                                               |
|  --http-log-path=PATH                         |  <prefix>/logs/access.log  |  设定主请求日志文件access log路径  |  安装后，可在nginx.conf中使用access_log=xxx.log修改  |
|  --http-client-body-temp-path=PATH            |  <prefix>/client_body_temp  |  设定http客户端请求体的临时文件路径  |  安装后，可在nginx.conf中使用client_body_temp_path=xxx修改  |
|  --http-proxy-temp-path=PATH                  |  <prefix>/proxy_temp  |  设定从代理服务器接收的数据的临时文件路径  |  安装后，可在nginx.conf中使用proxy_temp_path=xxx修改  |
|  --http-fastcgi-temp-path=PATH                |  <prefix>/fastcgi_temp  |  设定从FastCGI服务器接收到的数据的临时文件路径  |  安装后，可在nginx.conf中使用fastcgi_temp=xxx修改  |
|  --http-uwsgi-temp-path=PATH                  |  <prefix>/uwsgi_temp。  |  设定从uwsgi服务器接收到的数据的临时文件路径  |  安装后，可在nginx.conf中使用uwsgi_temp=xxx修改  |
|  --http-scgi-temp-path=PATH                   |  <prefix>/scgi_temp  |  设定从SCGI服务器接收到的数据的临时文件路径  |  安装后，可在nginx.conf中使用scgi_temp=xxx修改  |
|                                               |
|  --without-http                               |  启用  |  禁用http server功能  |
|  --without-http-cache                         |  启用  |  禁用http cache功能  |
|                                               |
|  --with-mail                                  |  关闭  |  启用POP3/IMAP4/SMTP代理模块  |
|  --with-mail=dynamic                          |  关闭  |  启用POP3/IMAP4/SMTP代理模块  |
|  --with-mail_ssl_module                       |  关闭  |  启用ngx_mail_ssl_module  |  为邮件代理服务器添加SSL/TLS协议支持，需要OpenSSL库  |
|  --without-mail_pop3_module                   |  启用  |  禁用pop3协议  |
|  --without-mail_imap_module                   |  启用  |  禁用imap协议  |
|  --without-mail_smtp_module                   |  启用  |  禁用smtp协议  |
|                                               |    |    |    |
|  --with-stream                                |  关闭  |  启用基于通用TCP/UDP代理和负载平衡的流模块  |
|  --with-stream=dynamic                        |    |  同上  |
|  --with-stream_ssl_module                     |  关闭  |  启用ngx_http_stub_status_module  |  默认关闭。为流模块添加SSL/TLS协议支持，需要OpenSSL库  |
|  --with-stream_realip_module                  |  关闭  |  启用stream_realip_module  |  默认关闭。用于将客户端地址和端口更改为在PROXY协议报头中发送的地址和端口，为了让下游服务器获取到客户端真实IP  |
|  --with-stream_geoip_module                   |  关闭  |  enable ngx_stream_geoip_module  |
|  --with-stream_geoip_module=dynamic           |  关闭  |  enable dynamic ngx_stream_geoip_module  |
|  --with-stream_ssl_preread_module             |  关闭  |  enable ngx_stream_ssl_preread_module  |
|  --without-stream_limit_conn_module           |    |  禁用stream_limit_conn_module  |  该模块用来限制每个键的连接数，例如，来自单个IP地址的连接数。  |
|  --without-stream_access_module               |    |  禁用stream_access_module  |  该模块提供了基于主机ip地址，允许限制对某些客户端地址的访问  |
|  --without-stream_geo_module                  |    |  禁用ngx_stream_geo_module  |  该模块会根据客户端IP地址创建带有值的变量。  |
|  --without-stream_map_module                  |    |  禁用ngx_stream_map_module  |  该模块允许使用任意的键/值对设置配置变量  |
|  --without-stream_split_clients_module        |    |  禁用ngx_stream_split_clients_module  |  该模块适用于A / B测试的变量，也称为分割测试。  |
|                                               |    |    |    |
|  --without-stream_return_module               |    |  禁用ngx_stream_return_module  |  该模块允许发送一个指定的值给客户端，然后关闭连接  |
|  --without-stream_set_module                  |    |  禁用ngx_stream_set_module  |  启用模块可以为变量设置值  |
|  --without-stream_upstream_hash_module        |    |  禁用ngx_stream_upstream_hash_module  |  支持普通的hash及一致性hash两种负载均衡算法,默认的是普通的hash来进行负载均衡  |
|  --without-stream_upstream_least_conn_module  |    |  禁用ngx_stream_upstream_least_conn_module  |  实现least_conn负载平衡方法  |
|  --without-stream_upstream_random_module      |    |  禁用ngx_stream_upstream_random_module  |  实现随机负载平衡方法  |
|  --without-stream_upstream_zone_module        |    |  禁用ngx_stream_upstream_zone_module  |  可以将上游组的运行时状态存储在共享内存区域中  |
|                                               |
|  --with-google_perftools_module               |    |  启用ngx_google_perftools_module  |  （调试用，剖析程序性能瓶颈）  |
|  --with-cpp_test_module                       |    |  启用ngx_cpp_test_module  |
|                                               |
|  --add-module=PATH                            |    |  启用外部模块  |
|  --add-dynamic-module=PATH                    |    |  启用外部动态模块  |
|                                               |
|  --with-compat                                |    |  启用动态模块兼容性  |
|                                               |
|  --with-cc=PATH                               |    |  指向C编译器路径  |
|  --with-cpp=PATH                              |    |  指向C预处理路径  |
|  --with-cc-opt=OPTIONS                        |    |  设置C编译器参数  |
|  --with-ld-opt=OPTIONS                        |    |  设置连接文件参数  |
|  --with-cpu-opt=CPU                           |    |  指定编译的CPU  |  可用的值为: pentium, pentiumpro, pentium3, pentium4, athlon, opteron, amd64, sparc32, sparc64, ppc64  |
|                                               |
|  --without-pcre                               |    |  禁用pcre库  |
|  --with-pcre                                  |    |  启用pcre库  |
|  --with-pcre=DIR                              |    |  指向pcre库文件目录  |
|  --with-pcre-opt=OPTIONS                      |    |  在编译时为pcre库设置附加参数  |
|  --with-pcre-jit                              |    |  构建具有“即时编译”支持的PCRE库(1.1.12,pcre_jit指令)。  |
|  --without-pcre2                              |    |  禁用使用PCRE2库而不是原始的PCRE库(1.21.5)。  |
|                                               |
|  --with-zlib=DIR                              |    |  指向zlib库目录  |
|  --with-zlib-opt=OPTIONS                      |    |  在编译时为zlib设置附加参数  |
|  --with-zlib-asm=CPU                          |    |  为指定的CPU使用zlib汇编源进行优化，CPU类型为pentium, pentiumpro  |
|                                               |
|  --with-libatomic                             |    |  强制使用libomic_ops库  |
|  --with-libatomic=DIR                         |    |  设置libomic_ops库源的路径  |
|                                               |
|  --with-openssl=PATH                          |    |  向openssl安装目录  |
|  --with-openssl-opt=OPTIONS                   |    |  编译时为openssl设置附加参数  |
|                                               |
|  --with-debug                                 |    |  用debug日志  |


-----------------------


```text
--help              #打印帮助信息。

--prefix=PATH       #指向安装目录。这个目录也将被用于所有由configure设置的相对路径(库源路径除外)和nginx.conf配置文件中。默认设置为“/usr/local/nginx”。
--sbin-path=PATH    #指向可执行程序文件，默认文件名为<prefix>/sbin/nginx。
--modules-path=PATH    #定义安装nginx动态模块的目录。默认情况下使用<prefix>/modules目录。

--conf-path=PATH        指向配置文件（nginx.conf），默认为<prefix>/conf/nginx.conf。运行时可以通过在命令行参数-c file来自定义
--error-log-path=PATH   指向错误日志目录，默认为<prefix>/logs/error.log。安装后，可在nginx.conf中使用error_log=xxx.log修改
--pid-path=PATH         指向pid文件（nginx.pid），默认为<prefix>/logs/nginx.pid。安装后，可在nginx.conf中使用pid=xxx.pid修改
--lock-path=PATH        指向lock文件（nginx.lock），默认为<prefix>/logs/nginx.lock。安装后，可在nginx.conf中使用lock_file=xxx.lock修改

--user=USER      指定程序运行时的非特权用户，默认为nobody。安装后，可在nginx.conf中使用user=nginx修改
--group=GROUP    指定程序运行时的非特权用户组，缺省下组名为非特权用户名。安装后，可在nginx.conf中使用user=user group修改

--build=NAME      指向编译构建名称
--builddir=DIR    指向编译目录

--with-select_module       启用select模块支持（一种轮询模式,不推荐在高载环境下使用）
--without-select_module    禁用select模块支持
--with-poll_module         启用poll模块支持（功能与select相同，与select特性相同，为一种轮询模式,不推荐在高载环境下使用）
--without-poll_module      禁用poll模块支持

--with-threads             启用线程池支持

--with-file-aio            启用file aio支持（一种APL文件传输格式）

--without-quic_bpf_module  disable ngx_quic_bpf_module

--with-http_ssl_module                     启用ngx_http_ssl_module支持（使支持https请求，需已安装openssl）
--with-http_v2_module                      启用http v2协议，默认关闭
--with-http_v3_module                      启用http v3协议，默认关闭。建议构建时使用如BoringSSL、LibreSSL或QuicTLS支持SSL的库。使用OpenSSL库将不支持QUIC早期数据
--with-http_realip_module                  启用ngx_http_realip_module支持，默认不启用。这个模块允许从请求标头更改客户端的IP地址值
--with-http_addition_module                启用ngx_http_addition_module支持，默认不启用。作为一个输出过滤器，支持不完全缓冲，分部分响应请求
--with-http_xslt_module                    启用ngx_http_xslt_module支持，过滤转换XML请求
--with-http_xslt_module=dynamic            同上
--with-http_image_filter_module            启用ngx_http_image_filter_module支持，默认不启用。传输JPEG/GIF/PNG 图片的一个过滤器，要用到gd库
--with-http_image_filter_module=dynamic    同上
--with-http_geoip_module                   启用ngx_http_geoip_module支持，默认不启用。该模块通过客户端IP地址和MaxMind的GeoIP库，来创建客户端所在的国家，城市等变量
--with-http_geoip_module=dynamic           同上, 文末有使用示例访问链接[1]
--with-http_sub_module                     启用ngx_http_sub_module支持，默认关闭。允许通过将一个指定字符串替换为另一个字符串来修改响应
--with-http_dav_module                     启用ngx_http_dav_module支持，默认关闭。通过WebDAV协议提供文件管理自动化，需编译开启
--with-http_flv_module                     启用ngx_http_flv_module支持，默认关闭。为Flash Video (FLV)文件提供伪流服务器端支持
--with-http_mp4_module                     启用ngx_http_mp4_module支持，默认关闭。为MP4文件提供伪流服务器端支持
--with-http_gunzip_module                  启用ngx_http_gunzip_module支持，默认关闭。为不支持“gzip”编码方法的客户端自动解压具有“Content-Encoding: gzip”报头的响应
--with-http_gzip_static_module             启用ngx_http_gzip_static_module支持，默认关闭。负责搜索和发送经过Gzip功能预压缩的数据（在线实时压缩输出数据流）
--with-http_auth_request_module            启用ngx_http_auth_request_module支持，默认关闭。基于子请求结果的客户端认证，如果子请求返回2xx状态码，访问将被允许。
--with-http_random_index_module            启用ngx_http_random_index_module支持，默认关闭。处理以斜杠字符('/')结尾的请求，并在目录中随机选择一个文件作为索引文件
--with-http_secure_link_module             启用ngx_http_secure_link_module支持，默认关闭。可以对请求的链接进行真伪校验,并限制链接的有效时间
--with-http_degradation_module             启用ngx_http_degradation_module支持，默认关闭。允许在内存不足的情况下返回204或444码
--with-http_slice_module                   启用ngx_http_slice_module支持，默认关闭。它将请求拆分为子请求,每个子请求都返回一定范围的响应。实现如：分片上传功能
--with-http_stub_status_module             启用ngx_http_stub_status_module支持，默认关闭。获取nginx自上次启动以来的工作状态

--without-http_charset_module                禁用ngx_http_charset_module支持，将指定的charset添加到“Content-Type”响应报头(Response Headers)字段中，从而用将响应内容转换为另一种charset
--without-http_gzip_module                   禁用ngx_http_gzip_module支持，该模块同-with-http_gzip_static_module功能一样
--without-http_ssi_module                    禁用ngx_http_ssi_module支持，该模块提供了一个在输入端处理处理服务器包含文件（SSI）的过滤器，目前支持SSI命令的列表是不完整的
--without-http_userid_module                 禁用ngx_http_userid_module支持，设置适用于客户端标识的 cookie
--without-http_access_module                 禁用ngx_http_access_module支持，提供了基于主机ip地址，允许限制对某些客户端地址的访问
--without-http_auth_basic_module             禁用ngx_http_auth_basic_module支持，可以使用用户名和密码认证的方式来对站点或部分内容进行认证
--without-http_mirror_module                 禁用ngx_http_mirror_module支持，可以复制原始请求发送到一个特定的环境，同时Nginx会忽略这个复制的请求的返回值。如生产环境的流量拷贝到预上线环境或测试环境
--without-http_autoindex_module              禁用disable ngx_http_autoindex_module支持，处理以斜杠字符(' / ')结尾的请求，并在ngx_http_index_module模块找不到索引文件时生成目录列表。
--without-http_geo_module                    禁用ngx_http_geo_module支持，该模块会根据客户端IP地址创建带有值的变量。
--without-http_map_module                    禁用ngx_http_map_module支持，使用任意的键/值对设置配置变量
--without-http_split_clients_module          禁用ngx_http_split_clients_module支持，适用于A / B测试的变量，也称为分割测试。
--without-http_referer_module                禁用disable ngx_http_referer_module支持，该模块用来过滤请求，拒绝报头中Referer值不正确的请求
--without-http_rewrite_module                禁用ngx_http_rewrite_module支持，该模块允许使用正则表达式改变URI，并且根据变量来转向以及选择配置。此模块需要PCRE库
--without-http_proxy_module                  禁用ngx_http_proxy_module支持，http代理功能
--without-http_fastcgi_module                禁用ngx_http_fastcgi_module支持，允许Nginx 与FastCGI 进程交互，并通过传递参数来控制FastCGI 进程工作。 FastCGI一个常驻型的公共网关接口。
--without-http_uwsgi_module                  禁用ngx_http_uwsgi_module支持，启用uwsgi协议，uwsgi服务器相关
--without-http_scgi_module                   禁用ngx_http_scgi_module支持，启用SCGI协议支持，SCGI协议是CGI协议的替代。它是一种应用程序与HTTP服务接口标准。它有些像FastCGI但他的设计 更容易实现。
--without-http_grpc_module                   禁用ngx_http_grpc_module支持，允许将请求传递给 gRPC 服务器
--without-http_memcached_module              禁用ngx_http_memcached_module支持，启用对memcached的支持，用来提供简单的缓存，以提高系统效率
--without-http_limit_conn_module             禁用ngx_http_limit_zone_module支持，用来限制每个键的连接数，例如，来自单个IP地址的连接数。
--without-http_limit_req_module              禁用ngx_http_limit_req_module支持，用来限制每个键的请求处理速率，例如，来自单个IP地址的请求的处理速率。
--without-http_empty_gif_module              禁用ngx_http_empty_gif_module支持，在内存中常驻了一个1*1的透明GIF图像，可以被非常快速的调用。
--without-http_browser_module                禁用ngx_http_browser_module支持，解析HTTP请求头中的”User-Agent“ 的值，来生成变量，以供后续的请求逻辑处理。
--without-http_upstream_hash_module          禁用http_upstream_hash_module支持，支持普通的hash及一致性hash两种负载均衡算法,默认的是普通的hash来进行负载均衡
--without-http_upstream_ip_hash_module       禁用ngx_http_upstream_ip_hash_module支持，提供ip hash负载均衡方法
--without-http_upstream_least_conn_module    禁用ngx_http_upstream_least_conn_module支持，实现least_conn负载平衡方法
--without-http_upstream_random_module        禁用ngx_http_upstream_random_module支持，实现随机负载平衡方法
--without-http_upstream_keepalive_module     禁用ngx_http_upstream_keepalive_module支持，提供缓存上游服务器连接，大于keepalive xx; 数值会被关闭
--without-http_upstream_zone_module          禁用ngx_http_upstream_zone_module支持，可以将上游组的运行时状态存储在共享内存区域中

--with-http_perl_module              启用ngx_http_perl_module支持，使nginx可以直接使用perl或通过ssi调用perl
--with-http_perl_module=dynamic      同上
--with-perl_modules_path=PATH        设定perl模块路径
--with-perl=PATH                     设定Perl二进制文件路径

--http-log-path=PATH                 设定主请求日志文件access log路径，默认为<prefix>/logs/access.log。安装后，可在nginx.conf中使用access_log=xxx.log修改
--http-client-body-temp-path=PATH    设定http客户端请求体的临时文件路径，默认为<prefix>/client_body_temp。安装后，可在nginx.conf中使用client_body_temp_path=xxx修改
--http-proxy-temp-path=PATH          设定从代理服务器接收的数据的临时文件路径，默认为<prefix>/proxy_temp。安装后，可在nginx.conf中使用proxy_temp_path=xxx修改
--http-fastcgi-temp-path=PATH        设定从FastCGI服务器接收到的数据的临时文件路径，默认为<prefix>/fastcgi_temp。安装后，可在nginx.conf中使用fastcgi_temp=xxx修改
--http-uwsgi-temp-path=PATH          设定从uwsgi服务器接收到的数据的临时文件路径，默认为<prefix>/uwsgi_temp。安装后，可在nginx.conf中使用uwsgi_temp=xxx修改
--http-scgi-temp-path=PATH           设定从SCGI服务器接收到的数据的临时文件路径，默认为<prefix>/scgi_temp。安装后，可在nginx.conf中使用scgi_temp=xxx修改

--without-http                       禁用http server功能
--without-http-cache                 禁用http cache功能

--with-mail                          启用POP3/IMAP4/SMTP代理模块支持
--with-mail=dynamic                  启用POP3/IMAP4/SMTP代理模块支持
--with-mail_ssl_module               启用ngx_mail_ssl_module支持，默认关闭。为邮件代理服务器添加SSL/TLS协议支持，需要OpenSSL库
--without-mail_pop3_module           禁用pop3协议
--without-mail_imap_module           禁用imap协议
--without-mail_smtp_module           禁用smtp协议

--with-stream                                  启用基于通用TCP/UDP代理和负载平衡的流模块默认关闭。
--with-stream=dynamic                          同上
--with-stream_ssl_module                       启用ngx_http_stub_status_module支持，默认关闭。为流模块添加SSL/TLS协议支持，需要OpenSSL库
--with-stream_realip_module                    启用stream_realip_module支持，默认关闭。用于将客户端地址和端口更改为在PROXY协议报头中发送的地址和端口，为了让下游服务器获取到客户端真实IP
--with-stream_geoip_module                     enable ngx_stream_geoip_module
--with-stream_geoip_module=dynamic             enable dynamic ngx_stream_geoip_module
--with-stream_ssl_preread_module               enable ngx_stream_ssl_preread_module
--without-stream_limit_conn_module             禁用stream_limit_conn_module支持，该模块用来限制每个键的连接数，例如，来自单个IP地址的连接数。
--without-stream_access_module                 禁用stream_access_module支持，该模块提供了基于主机ip地址，允许限制对某些客户端地址的访问
--without-stream_geo_module                    禁用ngx_stream_geo_module支持，该模块会根据客户端IP地址创建带有值的变量。
--without-stream_map_module                    禁用ngx_stream_map_module支持，该模块允许使用任意的键/值对设置配置变量
--without-stream_split_clients_module          禁用ngx_stream_split_clients_module支持，该模块适用于A / B测试的变量，也称为分割测试。

--without-stream_return_module                 禁用ngx_stream_return_module支持，该模块允许发送一个指定的值给客户端，然后关闭连接
--without-stream_set_module                    禁用ngx_stream_set_module支持，启用模块可以为变量设置值
--without-stream_upstream_hash_module          禁用ngx_stream_upstream_hash_module支持，支持普通的hash及一致性hash两种负载均衡算法,默认的是普通的hash来进行负载均衡
--without-stream_upstream_least_conn_module    禁用ngx_stream_upstream_least_conn_module支持，实现least_conn负载平衡方法
--without-stream_upstream_random_module        禁用ngx_stream_upstream_random_module支持，实现随机负载平衡方法
--without-stream_upstream_zone_module          禁用ngx_stream_upstream_zone_module支持，可以将上游组的运行时状态存储在共享内存区域中

--with-google_perftools_module    启用ngx_google_perftools_module支持（调试用，剖析程序性能瓶颈）
--with-cpp_test_module            启用ngx_cpp_test_module支持

--add-module=PATH            启用外部模块支持
--add-dynamic-module=PATH    启用外部动态模块

--with-compat                启用动态模块兼容性

--with-cc=PATH               指向C编译器路径
--with-cpp=PATH              指向C预处理路径
--with-cc-opt=OPTIONS        设置C编译器参数
--with-ld-opt=OPTIONS        设置连接文件参数
--with-cpu-opt=CPU           指定编译的CPU，可用的值为: pentium, pentiumpro, pentium3, pentium4, athlon, opteron, amd64, sparc32, sparc64, ppc64

--without-pcre               禁用pcre库
--with-pcre                  启用pcre库
--with-pcre=DIR              指向pcre库文件目录
--with-pcre-opt=OPTIONS      在编译时为pcre库设置附加参数
--with-pcre-jit              构建具有“即时编译”支持的PCRE库(1.1.12,pcre_jit指令)。
--without-pcre2              禁用使用PCRE2库而不是原始的PCRE库(1.21.5)。

--with-zlib=DIR              指向zlib库目录
--with-zlib-opt=OPTIONS      在编译时为zlib设置附加参数
--with-zlib-asm=CPU          为指定的CPU使用zlib汇编源进行优化，CPU类型为pentium, pentiumpro

--with-libatomic              强制使用libomic_ops库
--with-libatomic=DIR          设置libomic_ops库源的路径

--with-openssl=PATH           向openssl安装目录
--with-openssl-opt=OPTIONS    编译时为openssl设置附加参数
                              
--with-debug                  用debug日志

```


# 查看nginx的编译参数
```shell
nginx -V
```


# 参考资料: 

[0] [从源代码构建nginx-编译配置参数](http://nginx.org/en/docs/configure.html)

[1] [如何给NGINX安装ngx_http_geoip2_module模块](https://www.azio.me/how-to-install-ngx_http_geoip2_module/)
