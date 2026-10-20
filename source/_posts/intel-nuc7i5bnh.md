---
title: 英特尔 第七代NUC（NUC7i5BNH）
date: 2026-10-20 11:49:43
categories: ['Computer', 'Intel', 'NUC', 'NUC7i5BNH']
tags: ['Computer', 'Intel', 'NUC', 'NUC7i5BNH']
---

# 一、硬件信息

1. 💻 核心硬件配置
- 处理器：Intel Core i5-7260U（双核四线程，基础频率 2.2 GHz，睿频最高 3.4 GHz，4MB 缓存，TDP 15W，支持9.5~25W调整，）。
- 显卡：集成显卡，型号为 Intel Iris Plus Graphics 640。
- 主板型号：NUC7i5BNB。
- 内存：需自行安装。提供 2 个 SO-DIMM 插槽，最高支持 32GB DDR4-2133 内存。
- 存储：需自行安装。支持 1 个 M.2 插槽（22x42/80，支持 PCIe x4 或 SATA）和 1 个 2.5 英寸 SATA 硬盘位。

2. 🔌 接口与网络
- 视频输出：HDMI 2.0a、USB-C（支持 DisplayPort 1.2），最多支持 3 台显示器。
- 雷电接口：1 个 Thunderbolt 3（通过 USB-C 接口）。
- USB 接口：共 6 个（4 个外部 USB 3.0，2 个内部 USB 2.0 插针）。
- 网络：Intel Ethernet Connection I219-V（有线千兆），内置 Intel Dual Band Wireless-AC 8265（无线）及蓝牙4.2。
- 其他：microSDXC 读卡器、双阵列麦克风、红外接收器 。

3. 📏 物理规格与状态
- 板型尺寸：UCFF（超紧凑），4" x 4" 。
- 产品状态：已停产，最初于 2017 年第一季度发布。
- 制造日期: 制造日期：05/2020。
- 电源支持：19V ⎓ 3.43A，65W直流输入。

4. 💾 当前配置

内存: 协德DDR4 4Gx2 1.2V 2400MHz

NVMe存储: 
- 型号：WDC PC SN520 (SDAPNUW-128G-1006)。
- 容量：128 GB。
- 接口与协议：PCIe Gen3 x2, NVMe。
- 外形规格：M.2 2280 (22mm x 80mm)。
- 闪存类型：3D TLC。
- 性能表现：官方标称顺序读取最高约 1500-1700 MB/s，顺序写入约 800 MB/s 。根据第三方实测数据，顺序读取速度大约在 1072 MB/s 至 1390 MB/s 之间，写入速度则因测试环境不同浮动较大，参考值约 489 MB/s 至 701 MB/s 。
- 耐用度 (TBW)：100 TBW。
- 健康度: 50%。
- 功耗：3.3V ⎓ 1.5A，实测运行功耗约 2.5W 。

内置硬盘:
- 希捷 ST9320325AS
- 系列: Momentus 5400.6
- 容量：320 GB
- 转速：5400 rpm
- 缓存：8 MB
- 接口：SATA 2.0（3Gb/s）
- 尺寸：2.5 英寸，厚度约 9.5mm
- 功耗：闲置约 0.81W，寻道约 1.54W
- 记录技术：PMR

外置硬盘：
- 西部数据 WD5000LPVX-80V0TT0 WD-WX51A84N5Z6T
- 系列：WD Blue（蓝盘）
- 容量：500 GB
- 转速：5400 rpm
- 缓存：8 MB
- 接口：SATA 3.0（6Gb/s）
- 尺寸：2.5 英寸，厚度约 7mm
- 功耗：闲置约 0.55W，寻道约 1.4W
- 记录技术：CMR

# 二、功耗

功耗计量器，得力 DL333501C。
办公室环境，室内25度.


华硕笔记本电源适配器 12V 3.42A 65W，插电空载 0.075 ~ 0.1W。
主机插电，关机空载 1W。
外接奥睿科透明2.5寸机械硬盘盒，2.5W。

飞牛OS开机空载8.4~9.5W, 平均9W以下。

空载        负载平均 1.62~2.4%    功耗7.5~7.9W,平均7.8W    温度36~37度
44G大文件上传到HDD  负载平均 18~33%    功耗14~21W,平均14W        温度38~40度
30G大文件外置拷贝到SSD  负载平均 20~23%    功耗16~19W,平均17W        温度41~42度
44G大文件HDD拷贝到外置HDD  负载平均 20~23%    功耗20~23W,平均21W        温度40~42度
HDD上44G-4K-HEVC.MKV-GPU硬解    负载平均 28~30%    功耗44.5~50W      温度55~66度
外置HDD上44G-4K-HEVC.MKV-GPU硬解    负载平均 28~30%    功耗44.5~50W      温度55~66度

外置+内置硬盘+qbittorrent下载 负载平均 15~18%    功耗14~16W,平均15W        温度38~41度

sudo stress-ng --cpu 4 --cpu-load 10 --timeout 10M    负载平均 11~13%    功耗11~12W,平均11W    温度36~45度
sudo stress-ng --cpu 4 --cpu-load 20 --timeout 10M    负载平均 21~25%    功耗12~15W,平均13W    温度38~47度
sudo stress-ng --cpu 4 --cpu-load 30 --timeout 10M    负载平均 32~35%    功耗12~17W,平均13W    温度38~47度
sudo stress-ng --cpu 4 --cpu-load 40 --timeout 10M    负载平均 39~44%    功耗12~17W,平均13W    温度38~47度
sudo stress-ng --cpu 4 --cpu-load 50 --timeout 10M    负载平均 50~53%    功耗12~24W,平均20W    温度40~52度
sudo stress-ng --cpu 4 --cpu-load 60 --timeout 10M    负载平均 60~62%    功耗25~27W,平均26W    温度60~62度
sudo stress-ng --cpu 4 --cpu-load 70 --timeout 10M    负载平均 70~72%    功耗27~29W,平均28W    温度62~66度
sudo stress-ng --cpu 4 --cpu-load 80 --timeout 10M    负载平均 80~82%    功耗28~30W,平均30W    温度67~71度
sudo stress-ng --cpu 4 --cpu-load 90 --timeout 10M    负载平均 90.2~90.5%    功耗30~32W,平均31W    温度73~75度
sudo stress-ng --cpu 4 --cpu-load 100 --timeout 10M   负载平均 99.5~100%    功耗31~32W,平均31W    温度73~75度


sudo stress-ng --gpu 4 --timeout 10m                  负载平均 68~72%    功耗44~44.5W,平均44W    温度78~80度

---

# 三、拆机清洁

首先，准备一个沾满灰尘的NUC7i5BNH。
{% asset_img 1.jpg 配置参数 %}

将其翻过来，松开四个角上的螺栓。
{% asset_img 2.jpg 配置参数 %}

可以看到 2.5 英寸 HDD/SSD 安装支架。
{% asset_img 3.jpg 配置参数 %}

轻轻抬起支架，拔下SATA线和电源线。小心不要弄断电线；拔出电线时请握住插座。
{% asset_img 4.jpg 配置参数 %}

如果拆下挡板，就可以看到安装了内存和 M.2 固态硬盘的主板。
{% asset_img 5.jpg 配置参数 %}

取出内存条和固态硬盘，并拧下标有红色圆圈的螺栓。
{% asset_img 6.jpg 配置参数 %}

断开电路板上的 WIFI+蓝牙天线线缆、麦克风线缆和电源指示灯线缆。小心不要弄断线缆；拔出线缆时请握住插座。
{% asset_img 7.jpg 配置参数 %}

取出电路板。必须从后端口方向抓住电路板才能将其取出。取出时要小心，防止电线被电路板卡住而损坏。
{% asset_img 8.jpg 配置参数 %}

哦，这很简单。
{% asset_img 9.jpg 配置参数 %}

将电路板翻过来，就能看到风扇和散热片。拧下螺栓即可拆下风扇。
{% asset_img 10.jpg 配置参数 %}

您不一定需要将风扇插座从主板上拆下来。您只需要拧下散热器上的三颗螺丝即可。
由于逐个拧下螺丝可能会损坏 CPU 和芯片组，因此最好交替着拧下这三颗螺丝，一点一点地拧下来。
{% asset_img 11.jpg 配置参数 %}

我拆开了散热器，不出所料，导热硅脂已经干涸，所以它无法正常工作。
{% asset_img 12.jpg 配置参数 %}

我已经彻底清除了导热硅脂。我推荐的清除方法是先用湿巾擦拭，再用超细纤维布擦干净。
请使用不含化妆品成分的湿巾。如果用湿巾吸干水分，可能会残留灰尘，降低导热硅脂的散热效果。 
{% asset_img 13.jpg 配置参数 %}

涂抹导热硅脂。由于它不是高粘度硅脂，只需涂抹米粒大小的量，并用散热片压紧即可；它会自然铺开。
{% asset_img 14.jpg 配置参数 %}

拧紧散热器时要比松开时更加小心。在三个不同的位置交替拧紧；
过度拧紧可能会损坏 CPU 或导致系统无法启动。适度拧紧，直到摇晃散热器时它不再晃动为止。
{% asset_img 15.jpg 配置参数 %}

组装步骤与拆卸步骤相反。只需将电缆对准主板上的前面板端口即可轻松插入。
注意不要将天线电缆挤压到主板上。如下图红色圆圈所示，那里是天线电缆的出口。
{% asset_img 16.jpg 配置参数 %}

组装完成了。我拍了照片，照片里有吸尘器、导热硅脂、镊子和螺丝刀，它们都帮了我不少忙。
{% asset_img 17.jpg 配置参数 %}

由于第七代 NUC 已经停产，未来您可能需要经常自己进行维修和清洁。
如果出现噪音或运行问题，请尝试清洁并重新涂抹导热硅脂。
这款风扇也是笔记本电脑的标准配件，所以应该很容易找到。

# 九、参考

- (暗云uboot)[https://mbd.pub/o/bread/mbd-ZZuTlJpu]：2023年更新，收费5元
- (志平uboot)[https://www.right.com.cn/forum/thread-8253375-1-1.html]：2022年更新，免费
- (天灵uboot不扩容)[https://drive.wrt.moe/uboot/qualcommax]：2024年更新，免费
- (小米 ax6 ax3600不死uboot引导官方和OP互刷)[https://www.right.com.cn/forum/thread-8253493-1-1.html] 什么uboot未知
- (红米AX6开源NSS固件)[https://www.right.com.cn/forum/thread-8417590-1-2.html]: 这里有个扩容版的天灵uboot，推荐使用
- (2025年入手AX6后刷机笔记)[https://www.right.com.cn/forum/thread-8455880-1-1.html]
- (QSDK+NSS加速OpenWrt固件)[https://www.right.com.cn/forum/thread-8273025-1-1.html]
- (红米AX6路由器刷机扩容教程！傻瓜式小白也能会，OpenWRT系统uboot多出60M空间 + 原厂恢复教程)[https://www.bilibili.com/video/BV1WfSGBNE8v/]
- (红米AX6刷机教程傻瓜式uboot扩容版openwrt系统RA69)[https://www.getpicion.com/archives/2841]
- (小米ax3600 ax6在原版开起ssh,命令刷不死uboot)[https://www.right.com.cn/forum/thread-8253375-1-1.html]
- (ax6最简单原厂+openwrt(lede)双系统方法)[https://www.right.com.cn/forum/thread-5812745-1-1.html]
- (ax6 ax3600刷uboot后恢复官方系统方法)[https://www.right.com.cn/forum/thread-8236039-1-1.html]
- (使用 xmir-patcher 工具开启SSH)[https://www.right.com.cn/forum/thread-8348196-1-1.html]
- (xmir-patcher仓库)[https://github.com/openwrt-xiaomi/xmir-patcher]


# 十、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->router-xiaomi-ra69-exploit](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2Fsharelink2076919717-858150382706250%2Ffiles%2Frouter-xiaomi-ra69-exploit)
