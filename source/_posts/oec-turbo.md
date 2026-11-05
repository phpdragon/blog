---
title: 网心云 OneThingCloud OEC (OEC-turbo)
date: 2026-11-05 10:39:33
categories: ['Computer', 'ARM', '瑞芯微RK3566', 'OEC', 'OEC-turbo']
tags: ['Computer', 'ARM', '瑞芯微RK3566', 'OEC', 'OEC-turbo']
---

OEC-turbo 是网心云推出的一款边缘计算小盒子，原本的设计用途是共享家庭闲置带宽来换取收益。
但在数码玩家圈子里，它更出名的身份是“矿渣神器”——因为硬件底子不错且二手价格便宜，常被买来刷成其他系统，当作轻量 NAS 或软路由使用。

## 竞品分析

| 项目 | CPU | 内存插槽/最大内存 | M.2(NVMe/SATA) | 2.5" SATA(7/9.5mm) |
| :--- | :---: | :---: | :---: | :---: |
| 英特尔 NUC7i5DNH | i5-7260U | 2/32GB | 支持 | 支持 |
| 华硕PN60 | i3-8130U | 2/32GB | 支持 | 支持 |


## 一、硬件信息

### 1. 💻 核心硬件配置

| 项目 | 规格 |
| --- | --- |
| 代号 | OneThing Edge Cube(OEC-turbo) |
| CPU | 瑞芯微 RK3566 四核 ARM Cortex-A55 主频1.8GHz |
| GPU | ARM Mali-G52 2EE（集成于 RK3566） |
| NPU | 算力约 1 TOPS，可用于轻量 AI 推理 |
| 内存 | 4GB LPDDR4X |
| 存储 | 8GB eMMC，生产日期2022年11月 |
| 有线网口 | 1 个千兆以太网口 |
| SATA 接口 | 1 个 SATA 3.0，支持内置 2.5 寸7mm硬盘 |
| 调试口 | 1 个 USB Type-C，方说明仅用于生产调试，不具备实际功能。仅用于刷机 |
| USB 接口 | 1 个外部 USB 3.0 接口 |
| 尺寸 | 145mm × 90mm × 47mm |
| 散热 | 无主动风扇 |
| 产品状态 | 已停产，发布 2023年6月20日 |
| 电源支持 | 12V ⎓ 2A，24W 直流输入 |
| 功耗参考 | 每月耗电约 4 度 |


### 4. 💾 当前配置

#### 内置硬盘

| 项目 | 详情 |
| --- | --- |
| 型号 | 西部 WD5000LPVX |
| 系列 | WD Blue（蓝盘） |
| 容量 | 单碟 500GB |
| 转速 | 5400 rpm |
| 缓存 | 8 MB |
| 接口 | SATA 3.0（6Gb/s） |
| 尺寸 | 2.5 英寸，厚度约 7mm |
| 功耗 | 读取/写入功耗约 1.4W，空闲约 0.55W，待机约 0.13W |
| 记录技术 | CMR |

---

| 项目 | 详情 |
| --- | --- |
| 型号 | 长城（Great Wall） |
| 系列 | GW560 |
| 容量 | 128GB |
| 闪存类型 | TLC |
| 顺序写入 | 400MB/s |
| TBW | 80TBW |
| 接口 | SATA 3.0（6Gb/s） |
| 尺寸 | 2.5 英寸，厚度约 7mm |
| 功耗 | 读取/写入功耗约 1.4W，空闲约 0.55W，待机约 0.13W |


#### 外置U盘


| 项目 | 详情 |
| --- | --- |
| 型号 | Sandisk/闪迪(32G) |
| 系列 | 酷豆 CZ430 |
| 容量 | 32GB |
| 接口 | USB 3.2Gen1 |


## 二、功耗/性能实测

### 测试条件
- 功耗计量器 - 得力 DL333501C。
- 办公室环境 - 室内 25℃。

### 基础空载

| 场景 | 功耗W |
| :--- | :---: |
| 主机插电 + 内置机械硬盘 + 关机空载 | 1.03 (深度睡眠 0.288 ~ 0.3310、插网线支持唤醒 0.384 ~ 0.402) |
| 内置机械硬盘开机 | 最高 7.87 |
| 内置固态硬盘开机 | 最高 6.76 |
| 飞牛OS开机闲置空载(机械) | 4.48 ~ 7.87（平均 4.5 以下） |
| 飞牛OS开机闲置空载(固态) | 3.46 ~ 3.91（平均 3.5 以下） |

### 日常负载

| 场景 | 负载平均% | 功耗W | CPU温度℃ | 硬盘温度℃ |
| :--- | :---: | :---: | :---: |
| 飞牛OS开机闲置空载(机械) | 3.5 ~ 6.1 | 4.3 ~ 4.79（平均 4.62） | 41.2 ~ 43.1 | 45 |
| 飞牛OS开机闲置空载(固态) | 4.3 ~ 8.7 | 2.96 ~ 3.42（平均 3.1） | 41.2 ~ 43.1 | 40 |
| DD命令读取200G(机械读取106.5MB/s) | 18.3 ~ 25.3 | 6.6 ~ 7.0（平均 6.82） | 43.8 ~ 52.5 | 46(没有中央空调则48) |
| DD命令读取200G(固态读取298.2MB/s) | 27.3 ~ 34.2 | 4.63 ~ 5.03（平均 4.7） | 51.9 ~ 55 | 40 |


## 三、CPU跑分

```bash
curl -fsSL https://raw.githubusercontent.com/huladabang/coremark-goufan/main/run.sh | sh
```

得到CUP跑分 **29067**

```text
========================================
  狗点饭 NAS CoreMark 跑分工具
========================================

检测系统信息...
操作系统: linux
架构: arm64
CPU 型号: 
CPU 核心数: 4
✓ 找到可执行目录: /var/tmp

正在从 GitHub 下载 CoreMark (arm64)...
#################################################################################################################################### 100.0%
下载完成!

正在运行 CoreMark 跑分...
使用 4 个线程 (逻辑核心数)
这可能需要几分钟时间，请耐心等待...


========================================
 CoreMark 跑分结果
========================================
分数: 29067.846997 CoreMark/MHz
迭代次数: 440000
总耗时: 15.137000 秒
========================================

跑分结果详情:
2K performance run parameters for coremark.
CoreMark Size    : 666
Total ticks      : 15137
Total time (secs): 15.137000
Iterations/Sec   : 29067.846997
Iterations       : 440000
Compiler version : GCC13.3.0
Compiler flags   : -O3 -DMULTITHREAD=64 -DUSE_PTHREAD -static  -pthread
Parallel PThreads : 4
Memory location  : Please put data memory location here
                        (e.g. code in flash, data on heap etc)
seedcrc          : 0xe9f5
[0]crclist       : 0xe714
[1]crclist       : 0xe714
[2]crclist       : 0xe714
[3]crclist       : 0xe714
[0]crcmatrix     : 0x1fd7
[1]crcmatrix     : 0x1fd7
[2]crcmatrix     : 0x1fd7
[3]crcmatrix     : 0x1fd7
[0]crcstate      : 0x8e3a
[1]crcstate      : 0x8e3a
[2]crcstate      : 0x8e3a
[3]crcstate      : 0x8e3a
[0]crcfinal      : 0x33ff
[1]crcfinal      : 0x33ff
[2]crcfinal      : 0x33ff
[3]crcfinal      : 0x33ff
Correct operation validated. See README.md for run and reporting rules.
CoreMark 1.0 : 29067.846997 / GCC13.3.0 -O3 -DMULTITHREAD=64 -DUSE_PTHREAD -static  -pthread / Heap / 4:PThreads

========================================
 想要提交你的跑分结果？
========================================
📸 请截图保存：CPU信息 + 跑分结果
🌐 然后访问提交页面：
   https://gou.fan/coremark/submit

💡 提交后需管理员审核，通过后将会显示在 NAS/迷你主机 CPU 性能天梯图中！
   感谢你帮助我们完善低功耗CPU性能排行榜！

清理临时文件...
清理完成!

感谢使用狗点饭 CoreMark 跑分工具！
```

## 四、刷机

### 4.1 刷机准备

#### 4.1.1. 工具准备

- 电脑：Windows10 / Windows 11 64bit 电脑
- 驱动：[Rockchip_DriverAssitant_v5.1.1.zip](https://static2.fnnas.com/installer/DriverAssitant_v5.1.1.zip)
- 刷机工具：[RKDevTool_Release_v3.37.zip](https://static2.fnnas.com/installer/RKDevTool_v3.37_for_window.zip)
- 卡针： 用于顶住`RESET`按钮
- 镊子： 用来做短接线路使用
- USB 刷机线：A-C Type-C数据线

#### 4.1.2. Bootloader文件准备

Bootloader文件，用于 USB 线刷引导，在 RKDevTools 工具的文件夹下面，对应 $SOC/MiniLoaderAll.bin 文件名称。
> 例如 RK3566，对应 rk3566/MiniLoaderAll.bin 文件，不要选错哦。
{% asset_img bootloader.png MiniLoaderAll.bin %}

#### 4.1.3. Rockchip驱动安装

下载`Rockchip USB`线刷驱动（[Rockchip_DriverAssitant_v5.1.1.zip](https://static2.fnnas.com/installer/DriverAssitant_v5.1.1.zip)）：
{% asset_img install_driver.png 安装驱动 %}
{% asset_img install_driver2.png 驱动安装成功 %}


### 4.2 选择刷机模式

> 注意：刷机过程中不需要连接电源，Type-C接口会给设备供电。

#### 4.2.1 `LOADER`模式(二刷)

> `LOADER`模式适用已经刷过第三方固件的设备，所以不需要拆机。

长按机器后面的`RESET`小孔不松开，再用`Type-C`数据线连接电脑，等2-3秒后松开`RESET`孔。
等烧录工具显示“发现一个LOADER设备”，就进入`LOADER`模式了。

PS: `LOADER`模式下不需要刷入`boot`固件，只要刷入`system`固件就行。

#### 4.2.1 `MASKROM`模式(首刷/救砖)

> `MASKROM`模式是瑞芯微 SoC 内置的底层恢复 / 烧录模式，也就是刷机模式。

要拆机短接才能进入，首次刷机和救砖要进入MASKROM模式，需要勾选`Boot`和`system`两个包，路径要根据下载的解压后的实际路径选择，点后面的`···`可以选择对应文件。

下面开始拆机短接:

1. 可以先插好Type-C接口数据，另一侧USB口先不插入电脑端(短接时不容易被插线的动作干扰)。

2. 底部朝开锁标志方向推动底部盖板可以取下盖板。
{% asset_img 1.png 取下盖板 %}

3. 卸下底部四颗螺丝。
{% asset_img 2.png 卸下底部四颗螺丝 %}

4. 卸下底部螺丝后向上推动侧边盖板可以取下侧边盖板。
{% asset_img 3.png 取下侧边盖板 %}

5. 卸下硬盘位周围的8颗螺丝，sata接口上的螺丝可以不用拆。
{% asset_img 4.png 拆卸四周8颗螺丝 %}

6. 顶住右侧可以将硬盘位翘起，注意左侧sata排线有点短，别用力过猛扯坏了。
{% asset_img 5.png 顶住右侧将硬盘位翘起 %}

7. 硬盘位翘起来后可以插在左边竖起来，避免扯坏sata排线。
{% asset_img 6.png 翘起硬盘位 %}

8. 用镊子捏住图中电容两侧，相当于短接1V8和GND触点，但是比短接触点要简单。
{% asset_img duanjie.png 短接1V8和GND触点 %}

{% asset_img pcb.png 短接1V8和GND触点 %}

9. USB接口插入电脑2-3秒后松开镊子，烧录工具会从“没有发现设备”变为“发现一个MASKROM设备”，这时就可以开始刷机了。如果没成功就多短接几次。


### 4.6 刷入固件

> **记得勾上`强制按照地址写`，同时地址是否是`0xCCCCCCCC`/`0x00000000`，分别对应`Boot`和固件`System`。**

栏目字段介绍：
| 地址 | 名字 | 路径 | 说明 |
| :---: | :---: | :---: | :---: |
| 0xCCCCCCCC | Boot | D:\OECT\rk3566\MiniLoaderAll.bin | **硬件初始化引导程序固件**，是`.bin`后缀格式 |
| 0x00000000 | system | D:\OECT\firmware\fnos.img | 系统固件，`.img`后缀格式 |

#### 4.6.1. `LOADER`模式刷入

> **注意: 系统固件为`img`格式，如果下载为 gz/zip/rar 格式需要先解压。**

1. `LOADER`模式时去掉勾选刷`Boot`的选项。
2. 点击`system`这一行，选择要刷入的`.img`后缀固件。
3. 直接点击`执行`，刷入`Image`固件镜像即可。
{% asset_img maskrom4.png LOADER模式刷机 %}

#### 4.6.2. `MASKROM`模式刷入

> **注意: boot固件为`.bin`格式，system固件为`.img`格式，如果下载为 gz/zip/rar 格式需要先解压。**

1. 根据设备的SOC选择合适的`Boot`文件和`system`固件镜像，不要选错。
{% asset_img maskrom.png 进入MASKROM模式 %}

2. 然后点击`执行`，开始刷机。
{% asset_img maskrom1.png 进入MASKROM模式刷机，图片仅供参考 %}

3. 等待刷机进度 100% 完成后，即可拔掉所有线，然后接上电源重新启动即可。

{% asset_img maskrom2.png 开始MASKROM模式刷机 %}

{% asset_img maskrom3.png MASKROM模式刷机完成 %}

4. 然后登录路由器后台，查看多出来哪个设备，哪个就是飞牛的ip地址，浏览器访问http://ip地址开始使用。


## 五、参考

- [网心云OEC/OECTubro的刷机教程/短接技巧/救砖心得](https://www.right.com.cn/forum/thread-8459375-1-1.html)
- [Rockchip 瑞芯微系列 eMMC USB 线刷教程](https://help.fnnas.com/articles/v1/arm/arm-rk-usb)
- [OEC-Turbo刷群晖、Armbian流程记录](https://www.right.com.cn/forum/thread-8446774-1-1.html)
- [OEC/OEC-turbo刷机救砖，用RKDevTool避开‘下载boot失败’的保姆级教程](https://blog.csdn.net/John_Lenon/article/details/146461220)
- [OEC/OEC-Turbo刷飞牛258版详细流程，包含手动迁移根分区到sata硬盘无需刻录后扩容](https://www.right.com.cn/forum/thread-8459939-1-1.html)
- [RKDevTool](https://docs.radxa.com/template/module/radxa-os/low-level-dev/rkdevtool)
- [oec/oect最新飞牛rk3566-null-1.2.0701+刷机后恢复应用中心数据](https://www.right.com.cn/forum/thread-8462653-1-1.html)
- [OEC/OECT刷飞牛终极教程](https://mp.weixin.qq.com/s/g8d-Q-HhBPZwax45E_HJYg)

## 六、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->oec-turbo](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Foec-turbo)
