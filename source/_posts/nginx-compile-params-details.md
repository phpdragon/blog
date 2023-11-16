---
title: Nginx编译参数详解
date: 2023-11-16 22:05:41
tags:
---

Nginx 编译参数说明：

```text
--prefix=PATH                                  指向安装目录
--sbin-path=PATH                               指向（执行）程序文件
--conf-path=PATH                               指向配置文件（nginx.conf）
--error-log-path=PATH                          指向错误日志目录
--pid-path=PATH                                指向pid文件（nginx.pid）
--lock-path=PATH                               指向lock文件（nginx.lock）（安装文件锁定，防止安装文件被别人利用，或自己误操作。）        
                                               
--user=USER                                    指定程序运行时的非特权用户
--group=GROUP                                  指定程序运行时的非特权用户组
                                               
--builddir=DIR                                 指向编译目录

--with-select_module                           启用select模块支持（一种轮询模式,不推荐在高载环境下使用）禁用：--without-select_module
--without-select_module                        禁用：--without-select_module
--with-poll_module                             启用poll模块支持（功能与select相同，与select特性相同，为一种轮询模式,不推荐在高载环境下使用）
--without-poll_module                          禁用：--without-select_module
                                              
--with-threads                                 启用线程池支持
                                               
--with-file-aio                                启用file aio支持（一种APL文件传输格式）
--with-ipv6                                    启用ipv6支持
                                               
--with-http_ssl_module                         启用ngx_http_ssl_module支持（使支持https请求，需已安装openssl）
--with-http_v2_module                          
--with-http_realip_module                      启用ngx_http_realip_module支持（这个模块允许从请求标头更改客户端的IP地址值，默认为关）
--with-http_addition_module                    启用ngx_http_addition_module支持（作为一个输出过滤器，支持不完全缓冲，分部分响应请求）
--with-http_xslt_module                        启用ngx_http_xslt_module支持（过滤转换XML请求）
--with-http_image_filter_module                启用ngx_http_image_filter_module支持（传输JPEG/GIF/PNG 图片的一个过滤器）（默认为不启用。gd库要用到）
--with-http_geoip_module                       启用ngx_http_geoip_module支持（该模块创建基于与MaxMind GeoIP二进制文件相配的客户端IP地址的ngx_http_geoip_module变量）
--with-http_sub_module                         启用ngx_http_sub_module支持（允许用一些其他文本替换nginx响应中的一些文本）
--with-http_dav_module                         启用ngx_http_dav_module支持（增加PUT,DELETE,MKCOL：创建集合,COPY和MOVE方法）默认情况下为关闭，需编译开启
--with-http_flv_module                         启用ngx_http_flv_module支持（提供寻求内存使用基于时间的偏移量文件）
--with-http_mp4_module        
--with-http_gunzip_module                      
--with-http_gzip_static_module                 启用ngx_http_gzip_static_module支持（在线实时压缩输出数据流）
--with-http_auth_request_module                
--with-http_random_index_module                启用ngx_http_random_index_module支持（从目录中随机挑选一个目录索引）
--with-http_secure_link_module                 启用ngx_http_secure_link_module支持（计算和检查要求所需的安全链接网址）
--with-http_degradation_module                 启用ngx_http_degradation_module支持（允许在内存不足的情况下返回204或444码）
--with-http_slice_module            
--with-http_stub_status_module                 启用ngx_http_stub_status_module支持（获取nginx自上次启动以来的工作状态）

--without-http_charset_module                  禁用ngx_http_charset_module支持（重新编码web页面，但只能是一个方向--服务器端到客户端，并且只有一个字节的编码可以被重新编码）
--without-http_gzip_module                     禁用ngx_http_gzip_module支持（该模块同-with-http_gzip_static_module功能一样）
--without-http_ssi_module                      禁用ngx_http_ssi_module支持（该模块提供了一个在输入端处理处理服务器包含文件（SSI）的过滤器，目前支持SSI命令的列表是不完整的）
--without-http_userid_module                   禁用ngx_http_userid_module支持（该模块用来处理用来确定客户端后续请求的cookies）
--without-http_access_module                   禁用ngx_http_access_module支持（该模块提供了一个简单的基于主机的访问控制。允许/拒绝基于ip地址）
--without-http_auth_basic_module               禁用ngx_http_auth_basic_module（该模块是可以使用用户名和密码基于http基本认证方法来保护你的站点或其部分内容）
--without-http_autoindex_module                禁用disable ngx_http_autoindex_module支持（该模块用于自动生成目录列表，只在ngx_http_index_module模块未找到索引文件时发出请求。）
--without-http_geo_module                      禁用ngx_http_geo_module支持（创建一些变量，其值依赖于客户端的IP地址）
--without-http_map_module                      禁用ngx_http_map_module支持（使用任意的键/值对设置配置变量）
--without-http_split_clients_module            禁用ngx_http_split_clients_module支持（该模块用来基于某些条件划分用户。条件如：ip地址、报头、cookies等等）
--without-http_referer_module                  禁用disable ngx_http_referer_module支持（该模块用来过滤请求，拒绝报头中Referer值不正确的请求）
--without-http_rewrite_module                  禁用ngx_http_rewrite_module支持（该模块允许使用正则表达式改变URI，并且根据变量来转向以及选择配置。如果在server级别设置该选项，那么他们将在 location之前生效。如果在location还有更进一步的重写规则，location部分的规则依然会被执行。如果这个URI重写是因为location部分的规则造成的，那么 location部分会再次被执行作为新的URI。 这个循环会执行10次，然后Nginx会返回一个500错误。）
--without-http_proxy_module                    禁用ngx_http_proxy_module支持（有关代理服务器）
--without-http_fastcgi_module                  禁用ngx_http_fastcgi_module支持（该模块允许Nginx 与FastCGI 进程交互，并通过传递参数来控制FastCGI 进程工作。 ）FastCGI一个常驻型的公共网关接口。
--without-http_uwsgi_module                    禁用ngx_http_uwsgi_module支持（该模块用来医用uwsgi协议，uWSGI服务器相关）
--without-http_scgi_module                     禁用ngx_http_scgi_module支持（该模块用来启用SCGI协议支持，SCGI协议是CGI协议的替代。它是一种应用程序与HTTP服务接口标准。它有些像FastCGI但他的设计 更容易实现。）
--without-http_memcached_module                禁用ngx_http_memcached_module支持（该模块用来提供简单的缓存，以提高系统效率）
--without-http_limit_conn_module               禁用ngx_http_limit_zone_module支持（该模块可以针对条件，进行会话的并发连接数控制）
--without-http_limit_req_module                禁用ngx_http_limit_req_module支持（该模块允许你对于一个地址进行请求数量的限制用一个给定的session或一个特定的事件）
--without-http_empty_gif_module                禁用ngx_http_empty_gif_module支持（该模块在内存中常驻了一个1*1的透明GIF图像，可以被非常快速的调用）
--without-http_browser_module                  禁用ngx_http_browser_module支持（该模块用来创建依赖于请求报头的值。如果浏览器为modern ，则$modern_browser等于modern_browser_value指令分配的值；如 果浏览器为old，则$ancient_browser等于 ancient_browser_value指令分配的值；如果浏览器为 MSIE中的任意版本，则 $msie等于1）
--without-http_upstream_hash_module        
--without-http_upstream_ip_hash_module         禁用ngx_http_upstream_ip_hash_module支持（该模块用于简单的负载均衡）
--without-http_upstream_least_conn_module      
--without-http_upstream_keepalive_module       
--without-http_upstream_zone_module

--with-http_perl_module                        启用ngx_http_perl_module支持（该模块使nginx可以直接使用perl或通过ssi调用perl）
--with-perl_modules_path=PATH                  设定perl模块路径
--with-perl=PATH                               设定perl库文件路径
--http-log-path=PATH                           设定access log路径
--http-client-body-temp-path=PATH              设定http客户端请求临时文件路径
--http-proxy-temp-path=PATH                    设定http代理临时文件路径
--http-fastcgi-temp-path=PATH                  设定http fastcgi临时文件路径
--http-uwsgi-temp-path=PATH                    设定http uwsgi临时文件路径
--http-scgi-temp-path=PATH                     设定http scgi临时文件路径
                                               
--without-http                                 禁用http server功能
--without-http-cache                           禁用http cache功能
    
--with-mail                                    启用POP3/IMAP4/SMTP代理模块支持
--with-mail_ssl_module                         启用ngx_mail_ssl_module支持
--without-mail_pop3_module                     禁用pop3协议
--without-mail_imap_module                     禁用imap协议
--without-mail_smtp_module                     禁用smtp协议

--with-stream                                  
--with-stream_ssl_module                       
--without-stream_limit_conn_module             
--without-stream_access_module                 
--without-stream_upstream_hash_module          
--without-stream_upstream_least_conn_module    
--without-stream_upstream_zone_module          
--with-google_perftools_module                 启用ngx_google_perftools_module支持（调试用，剖析程序性能瓶颈）
--with-cpp_test_module                         启用ngx_cpp_test_module支持

--add-module=PATH                              启用外部模块支持

--with-cc=PATH                                  指向C编译器路径
--with-cpp=PATH                                指向C预处理路径
--with-cc-opt=OPTIONS                          设置C编译器参数
--with-ld-opt=OPTIONS                          设置连接文件参数
--with-cpu-opt=CPU                             指定编译的CPU，可用的值为: pentium, pentiumpro, pentium3, pentium4, athlon, opteron, amd64, sparc32, sparc64, ppc64
--without-pcre                                 禁用pcre库
--with-pcre                                    启用pcre库
--with-pcre=DIR                                指向pcre库文件目录
--with-pcre-opt=OPTIONS                        在编译时为pcre库设置附加参数
--with-pcre-jit                                
--with-md5=DIR                                 指向md5库文件目录
--with-md5-opt=OPTIONS                         在编译时为md5库设置附加参数
--with-md5-asm                                 使用md5汇编源
--with-sha1=DIR                                指向sha1库目录（数字签名算法，主要用于数字签名）
--with-sha1-opt=OPTIONS                        在编译时为sha1库设置附加参数
--with-sha1-asm                                使用sha1汇编源
--with-zlib=DIR                                指向zlib库目录
--with-zlib-opt=OPTIONS                        在编译时为zlib设置附加参数
--with-zlib-asm=CPU                            为指定的CPU使用zlib汇编源进行优化，CPU类型为pentium, pentiumpro

--with-libatomic                               原子内存的更新操作的实现提供一个架构
--with-libatomic=DIR                           向libatomic_ops安装目录

--with-openssl=DIR                             向openssl安装目录
--with-openssl-opt=OPTIONS                     编译时为openssl设置附加参数

--with-debug                                   用debug日志
```

转载至：[nginx 编译参数中文详解](https://www.cnblogs.com/weipan/p/17677536.html)