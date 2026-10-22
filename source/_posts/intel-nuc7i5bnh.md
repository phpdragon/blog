---
title: 英特尔 第七代 NUC（NUC7i5BNH）
date: 2026-10-20 11:49:43
categories: ['Computer', 'Intel', 'NUC', 'NUC7i5BNH']
tags: ['Computer', 'Intel', 'NUC', 'NUC7i5BNH']
---

**一台已停产的小钢炮：Intel NUC7i5BNH Baby Canyon 厚款的硬件档案、功耗实测与拆机清洁全记录。**

本文涵盖：核心配置 · 接口网络 · 当前存储 · 功耗实测 · 拆机清灰 · 更换硅脂


## 竞品分析

| 项目 | CPU | 内存插槽/最大内存 | M.2(NVMe/SATA) | 2.5" SATA(7/9.5mm) |
| :--- | :---: | :---: | :---: | :---: |
| 英特尔 NUC7i5DNH | i5-7260U | 2/32GB | 支持 | 支持 |
| 华硕PN60 | i3-8130U | 2/32GB | 支持 | 支持 |
| 技嘉 GB-BRi3H-8130 | i3-8130U | 2/32GB | 支持 | 支持 |


## 一、硬件信息

### 1. 💻 核心硬件配置

| 项目 | 规格 |
| --- | --- |
| 代号 | Baby Canyon(婴儿峡谷) 发布 2017 Q1 |
| 处理器 | Intel Core i5-7260U，2核4线，基础 2.2 GHz / 睿频 3.4 GHz，L3=4MB，14NM，TDP 15W，支持 9.5~15W 调整|
| 核显 | Iris Plus Graphics 640，64EU，300–950MHz，支持 HDMI2.0 4K@60Hz |
| 主板型号 | NUC7i5BNB |
| 内存 | 2×DDR4 SO-DIMM，DDR4-2133 1.2V，双通道，最大 **32GB** |
| 存储 | 1×M.2 2280：支持 NVMe PCIe3.0 x4 / SATA；1×2.5" SATA 9.5mm 厚度（HDD/SSD），双盘位脚本之家 |

{% asset_img inside.png 内部图 %}


### 2. 🔌 接口与网络

| 类别 | 详情 |
| --- | --- |
| 视频输出 | HDMI 2.0a、USB-C（支持 DisplayPort 1.2），最多支持 3 台显示器 |
| 雷电接口 | 1 个 Thunderbolt 3（通过 USB-C 接口） |
| USB 接口 | 共 6 个（4 个外部 USB 3.0，2 个内部 USB 2.0 插针） |
| 无线 | Intel Ethernet Connection I219-V（有线千兆）；内置 Intel Dual Band Wireless-AC 8265（无线）及蓝牙 4.2 |
| 后置IO | HDMI2.0、Thunderbolt3（USB‑C，DP 输出）、4×USB3.0、RJ45、DC 电源口 |
| 前置IO | 3.5mm 复合音频口、**microSDXC，UHS-I**（TF 卡）读卡器、电源键、红外接收 |
| 左侧IO | microSDXC UHS‑I 读卡器、Kensington 锁孔 |

{% asset_img front-panel‌.png 前面板 %}

{% asset_img back-panel‌.png 后面板 %}

{% asset_img side.png 侧面板 %}


### 3. 📏 物理规格与状态

| 项目 | 详情 |
| --- | --- |
| 板型尺寸 | UCFF（超紧凑），4" x 4"，115×111×51mm（厚款） |
| 产品状态 | 已停产，最初于 2017 年第一季度发布 |
| 制造日期 | 05/2020 |
| 电源支持 | 19V ⎓ 3.43A，65W 直流输入 |

{% asset_img backside‌.png 背面板 %}

### 4. 💾 当前配置

#### 内存

| 项目 | 详情 |
| --- | --- |
| 型号 | 英睿达 DDR4 4G 1.2V，2400MHz|
| 容量 | 4 GB x 2|
| 类型 | DDR4 SDRAM |
| 频率 | 2400 MT/s (PC4-19200) |
| 外形规格 | SODIMM（笔记本/迷你主机专用） |
| 引脚数 | 260-pin |
| 电压 | 1.2V |
| 时序 | CL17 |
| 时序 | CL17 |

{% asset_img memory.png 内存参数 %}

{% asset_img cachemem.png 内存测试 %}


#### NVMe 存储

| 项目 | 详情 |
| --- | --- |
| 型号 | WDC PC SN520 (SDAPNUW-128G-1006) |
| 容量 | 128 GB |
| 接口与协议 | PCIe Gen3 x2, NVMe |
| 外形规格 | M.2 2280 (22mm x 80mm) |
| 闪存类型 | 3D TLC |
| 性能表现 | 官方标称顺序读取约 1500–1700 MB/s，顺序写入约 800 MB/s；第三方实测顺序读取约 1072–1390 MB/s，写入约 489–701 MB/s（视测试环境浮动） |
| 耐用度 (TBW) | 100 TBW |
| 健康度 | 50% |
| 功耗 | 3.3V ⎓ 1.5A，实测运行功耗约 2.5W |

{% asset_img nvme.png nvme参数 %}

{% asset_img nvme-test.png nvme测试 %}

#### 内置硬盘

| 项目 | 详情 |
| --- | --- |
| 型号 | 希捷 ST9320325AS |
| 系列 | Momentus 5400.6 |
| 容量 | 320 GB |
| 转速 | 5400 rpm |
| 缓存 | 8 MB |
| 接口 | SATA 2.0（3Gb/s） |
| 尺寸 | 2.5 英寸，厚度约 9.5mm |
| 功耗 | 闲置约 0.81W，寻道约 1.54W |
| 记录技术 | PMR |

#### 外置硬盘

| 项目 | 详情 |
| --- | --- |
| 型号 | 西部数据 WD5000LPVX-80V0TT0（WD-WX51A84N5Z6T） |
| 系列 | WD Blue（蓝盘） |
| 容量 | 500 GB |
| 转速 | 5400 rpm |
| 缓存 | 8 MB |
| 接口 | SATA 3.0（6Gb/s） |
| 尺寸 | 2.5 英寸，厚度约 7mm |
| 功耗 | 闲置约 0.55W，寻道约 1.4W |
| 记录技术 | CMR |


## 二、功耗实测

### 测试条件
- 功耗计量器 - 得力 DL333501C。
- 办公室环境 - 室内 25℃。

### 基础空载

| 场景 | 功耗W |
| :--- | :---: |
| 华硕笔记本电源适配器 12V 3.42A 65W，接电空载 | 0.075 ~ 0.1 |
| 主机插电 + 内置机械硬盘 + 关机空载 | 1.03 (深度睡眠 0.288 ~ 0.3310、插网线支持唤醒 0.384 ~ 0.402) |
| 内置机械硬盘 + 外置机械硬盘(奥睿科透明 2.5 寸盒) | 2.5 |
| 飞牛 OS 开机空载 | 8.4 ~ 9.5（平均 9 以下） |

### 日常负载

电源均衡模式：
| 场景 | 负载平均% | 功耗W | 温度℃ |
| :--- | :---: | :---: | :---: |
| 飞牛OS开机闲置空载 | 0.7 ~ 1.2 | 8.3 ~ 8.8W（平均 8.5） | 34 ~ 35 |
| 44G 大文件上传到 HDD | 18 ~ 33 | 14 ~ 21（平均 14） | 38 ~ 40 |
| 30G 大文件外置拷贝到 SSD | 20 ~ 23 | 16 ~ 19（平均 17） | 41 ~ 42 |
| 44G 大文件 HDD 拷贝到外置 HDD | 20 ~ 23 | 20 ~ 23（平均 21） | 40 ~ 42 |
| HDD 上 44G-4K-HEVC.MKV GPU 硬解 | 28 ~ 30 | 44.5 ~ 50 | 55 ~ 66 |
| 外置 HDD 上 44G-4K-HEVC.MKV GPU 硬解 | 28 ~ 30 | 44.5 ~ 50 | 55 ~ 66 |
| 外置 + 内置硬盘 + qBittorrent 下载 | 15 ~ 18 | 14 ~ 16（平均 15） | 38 ~ 41 |

电源Low模式：
| 场景 | 负载平均% | 功耗W | 温度℃ |
| :--- | :---: | :---: | :---: |
| 飞牛OS开机闲置空载 | 0.7 ~ 1.2 | 7.6 ~ 8.1W（平均 7.7） | 34 ~ 35 |


### CPU 压力测试（stress-ng）

```bash
sudo stress-ng --cpu 4 --cpu-load <负载> --timeout 10M
```

电源均衡模式：
| CPU 负载 | 负载平均 | 功耗 | 温度 |
| :---: | :---: | :---: | :---: |
| 10 | 11 ~ 13 | 11 ~ 12（平均 11） | 36 ~ 45 |
| 20 | 21 ~ 25 | 12 ~ 15（平均 13） | 38 ~ 47 |
| 30 | 32 ~ 35 | 12 ~ 17（平均 13） | 38 ~ 47 |
| 40 | 39 ~ 44 | 12 ~ 17（平均 13） | 38 ~ 47 |
| 50 | 50 ~ 53 | 12 ~ 24（平均 20） | 40 ~ 52 |
| 60 | 60 ~ 62 | 25 ~ 27（平均 26） | 60 ~ 62 |
| 70 | 70 ~ 72 | 27 ~ 29（平均 28） | 62 ~ 66 |
| 80 | 80 ~ 82 | 28 ~ 30（平均 30） | 67 ~ 71 |
| 90 | 90.2 ~ 90.5 | 30 ~ 32（平均 31） | 73 ~ 75 |
| 100 | 99.5 ~ 100 | 31 ~ 32（平均 31） | 73 ~ 75 |

电源Low模式：
| CPU 频率 | CPU 负载 | 负载平均 | 功耗 | 温度 |
| :---: | :---: | :---: | :---: | :---: |
| 900 ~ 1100 | 30 | 31.3 ~ 35 | 9.8 ~ 11（平均 10） | 41 ~ 42 |
| 3200 ~ 3300 | 100 | 99.5 ~ 100 | 29.2 ~ 29.6（平均 29.2） | 68 ~ 72 |

### GPU 压力测试

```bash
sudo stress-ng --gpu 4 --timeout 10M
```

| 电源模式 | CPU负载平均% | GPU负载平均% | 功耗W | 温度℃ |
| :---: | :---: | :---: | :---: | :---: |
| 均衡 | 68 ~ 72 | 86 ~ 90 | 44 ~ 44.5（平均 44） | 78 ~ 80 |
| Low | 68 ~ 72 | 89 ~ 91 | 34.2 ~ 34.9（平均 34.5） | 65 ~ 68 |


### 总结

24小时开机建议开启low模式。能省更多电量，负载100%时，也只是降低100~200MHz频率，可接受。


## 三、BIOS

### 3.1. 更新BIOS

> 1.BIOS下载地址：[NUC7I5BNH-产品技术支持](https://www.asus.com/uk/supportonly/nuc7i5bnh/helpdesk_bios/)。
> 2.键盘优先插入前面板，开机时键盘才会自动上电。

1. 准备 U 盘：将 U 盘格式化为 FAT32 格式。
2. 拷贝文件：把下载好的 `*.bio` 文件直接复制到 U 盘根目录。
3. 插入NUC：将 U 盘插到 NUC 的 USB 接口上。
4. 开机按F7：启动 NUC，在开机出现 Intel NUC 标志时，留意屏幕下方的提示，按下 F7 进入 BIOS Flash Update 工具。
5. 选择文件：在界面中选中你的 U 盘，然后选中 `*.bio` 文件，按回车确认。
6. 确认更新：屏幕会提示确认是否更新，按回车开始。
7. 等待完成：更新过程大约需要 2 到 5 分钟，期间绝对不能断电或强制关机。
8. 更新完成：会自动重启，按 F2 进 BIOS 查询配置是否需要调整。


### 3.2. 设置BIOS

{% asset_img home.png 首页1 %}

BIOS首页-监控概览。

{% asset_img home2.png 首页2 %}

BIOS首页-信息概览。

{% asset_img main.png 主页2 %}

BIOS主页-系统时间、事件日志、核心硬件概览。

{% asset_img devices-usb.png 设备-USB配置页 %}

左侧：USB Configuration (USB 配置)

- USB Legacy (USB 传统模式 / 旧版支持): ☑ 已勾选
    - 作用: 允许在进入操作系统之前（例如在 BIOS 界面或 DOS 环境中）使用 USB 键盘和鼠标。对于现代系统（如您这台装了 Debian 的机器），建议保持勾选，以防在 BIOS 或引导菜单中键鼠失灵。
- Portable Device Charging Mode (便携设备充电模式): Charging in S3/S4/S5
    - 作用: 决定当电脑处于睡眠（S3）、休眠（S4）或完全关机（S5）状态时，USB 接口是否继续为手机等外接设备供电。当前设置允许在机器关机后继续充电（也就是常说的“关机充电”功能）。如果不需要此功能，可以改为 Disabled 以节省待机功耗。

右侧：USB Ports (USB 端口控制)
- 主板上的 6 个 USB 逻辑端口（Port 01 到 Port 06）。
    - 当前所有端口的状态均为 Enable (启用)。
    - 应用场景: 这通常用于企业级安全或特殊硬件调试。如果您想彻底禁用某个特定的物理 USB 接口（例如防止员工插 U盘拷贝资料），可以在对应的端口号将其设为 Disable。

{% asset_img devices-sata.png 设备-SATA配置页 %}

Chipset SATA Controller Configuration (芯片组 SATA 控制器配置)：

- Chipset SATA (芯片组 SATA 控制器): ☑ 已勾选
    - 作用: 启用主板上的 SATA 控制器。如果取消勾选，所有通过 SATA 接口连接的硬盘（如您的 320GB 机械硬盘）都将无法被系统识别。通常必须保持勾选。
- Chipset SATA Mode (芯片组 SATA 模式): AHCI
    - 作用: 这是硬盘的工作模式。AHCI 是现代操作系统的标准模式，支持热插拔和 NCQ（原生命令队列），能发挥固态硬盘的最佳性能。(注：如果您的系统是旧版 Windows XP，可能需要改为 IDE 模式，但您运行的是 Debian Linux，AHCI 是绝对正确的选择，请勿更改。)
- S.M.A.R.T. (自我监测、分析及报告技术): ☑ 已勾选
    - 作用: 开启后，允许操作系统读取硬盘的健康状态数据（如温度、坏道预警、通电时间等）。建议保持开启，方便使用工具监控硬盘寿命。
- SATA Port (SATA 接口): ST9320325AS (320.0GB-3.0Gb/s)
    - 识别到一块 320GB 的机械硬盘（希捷），传输速率为 SATA II (3.0Gb/s)。
- M.2 NVMe SSD:
    - 识别到一块 WDC PC SN520 SDAPNUW-128G-1006 (128.1GB-PCIe x2, 8.0GT/s)
    - 这是西部数据（WD）的 128GB 固态硬盘，走 PCIe 通道。(注：它显示运行在 x2 速率，这通常取决于该 M.2 接口的硬件通道分配限制)。
- Hard Disk Pre-Delay (硬盘预延迟): 0
    - 作用: 设定主板在启动时等待硬盘就绪的延迟时间。设置为 0 可以加快开机速度。如果遇到老旧硬盘无法被识别的情况，可以适当增加该延迟。
- HDD Activity LED (机械硬盘活动指示灯): ☑ 已勾选
    - 作用: 当机械硬盘有读写操作时，机箱面板的硬盘指示灯会闪烁。
- M.2 PCIe SSD LED (M.2 固态硬盘活动指示灯): ☑ 已勾选
    - 作用: 当 M.2 固态硬盘有读写操作时，指示灯也会亮起。

{% asset_img devices-video.png 设备-视频配置页 %}

Video Configuration (视频配置)：

- IGD Minimum Memory (IGD 最小内存 / 核显专用显存): 64 MB
    - 说明: IGD 代表 Integrated Graphics Device（集成图形设备）。这里设置的是系统强制预留给核显的专用物理内存大小。设置为 64 MB 是标准值，足够系统正常点亮和输出基础画面。
- IGD Aperture Size (IGD 映射空间 / 动态显存共享上限): 256 MB
    - 说明: 这是 CPU 与核显之间进行数据交换的地址空间（Aperture）。它并非实打实扣除的物理内存。核显在运行游戏或视频时，会通过动态共享技术调用系统内存。256 MB 是默认设置。
    - (注：一般来说，普通办公或日常使用保持默认的 64MB/256MB 即可。如果您运行对图形要求较高的软件，在内存充足的情况下，可以适当调大这两个数值，但通常改动带来的性能提升非常有限，因为现代操作系统的动态共享机制已经非常成熟。)
- IGD Primary Video Port (IGD 首选视频输出端口): Auto (自动)
    - 说明: 决定主板开机时优先从哪个接口输出显示信号。设置为 Auto 时，主板会自动检测哪个接口连接了显示器（例如 HDMI 或 Type-C 转接），并将画面输出到该接口。除非您遇到开机黑屏不显示，需要强制指定 HDMI 输出，否则强烈建议保持 Auto。


{% asset_img devices-board.png 板载设备配置页 %}

左侧：Onboard Device Configuration (板载设备配置)

- Audio (音频): ☑ 已勾选 —— 启用主板自带的音频功能。
- Audio DSP (音频数字信号处理器): Enabled (启用) —— 这是 Intel 智能声音技术（Smart Sound Technology）的底层硬件支持，有助于降低音频延迟和功耗。建议保持启用。
- HDMI/DisplayPort Audio (HDMI/DP 音频输出): ☑ 已勾选 —— 允许通过 HDMI 或 DisplayPort 接口将声音传输到显示器或电视。如果您使用显示器自带音响，必须保持勾选。
- Digital Microphone (数字麦克风): ☑ 已勾选 —— 启用数字麦克风接口（部分 NUC 顶部有麦克风阵列）。
- LAN (有线网卡): ☑ 已勾选 —— 启用主板集成的 Intel 千兆有线网卡。
- Thunderbolt™ Controller (雷电控制器): ☑ 已勾选 —— 启用雷电 3 接口的控制芯片。(注：NUC7i5BNH 的雷电接口同时也兼容 USB Type-C，如果关闭可能会导致该接口失效)。
- WLAN (无线网卡): ☑ 已勾选 —— 启用 Wi-Fi 模块。
- Bluetooth (蓝牙): ☑ 已勾选 —— 启用蓝牙模块。
- SD Card (SD 读卡器): Read/Write (读写) —— 允许对 SD 卡进行读取和写入。如果需要防止数据被拷贝，可以将其改为 Read Only (只读) 或 Disabled (禁用)。

右侧：Legacy Device Configuration (传统/旧版设备配置)

- Enhanced Consumer IR (增强型消费级红外线): ☐ 未勾选 —— 用于红外遥控器。默认关闭。
- HDMI CEC Control (HDMI CEC 控制): ☑ 已勾选 —— 这是一个非常实用的功能。允许 NUC 通过 HDMI 线缆控制连接的电视或显示器（例如：按 NUC 开机，电视自动亮起并切换到对应信号源；或者用电视遥控器控制 NUC）。
- TV HDMI Port (电视 HDMI 端口): HDMI 1 —— 指定 CEC 控制信号通过哪个接口发送。
- Auto Turn On TV (自动打开电视): From S3/S4/S5 Boot —— 当 NUC 从睡眠(S3)、休眠(S4)或关机(S5)状态启动时，会自动唤醒连接的电视。
- Auto Turn Off TV (自动关闭电视): Disable (禁用) —— 当 NUC 关机或休眠时，不自动关闭电视。
- Wake On TV (电视唤醒): Disable (禁用) —— 不允许通过电视的遥控器或信号来唤醒 NUC。
- Standby by TV (跟随电视待机): Disable (禁用) —— 当电视关闭时，NUC 不跟着进入待机状态。
- High Precision Event Timers (高精度事件定时器 - HPET): ☑ 已勾选 —— 系统底层定时器，通常建议开启，对多媒体和某些系统功能有好处。
- Num Lock (数字键盘锁定): ☑ 已勾选 —— 开机时自动开启小键盘的数字锁定（如果您外接了键盘的话）。

{% asset_img devices-pci.png 设备-PCI配置页 %}

PCI Configuration (PCI 配置)：

- M.2 Slot (M.2 插槽): ☑ 已勾选
    - 作用: 启用或禁用主板上的 M.2 接口。勾选状态下，插在 M.2 插槽上的设备（固态硬盘或无线网卡等）才能被系统识别。
- M.2 Slot (M.2 插槽运行状态): Using: x2 Speed: 8.0 GT/s
    - 说明: 这一行是硬件自动检测的结果，不可修改。它表示当前 M.2 设备正运行在 PCIe x2 通道上，单通道速率为 8.0 GT/s（即 PCIe 3.0 标准）。(注：对于第七代 NUC 来说，这个接口通常最高支持 PCIe 3.0 x4，但当前的硬盘或插槽连接方式限制在了 x2)。
- M.2 Slot Vendor ID:Device ID (M.2 插槽 厂商 ID 与设备 ID): <15B7:5003>
    - 说明: 这是底层硬件识别码。15B7 是西部数据（Western Digital/SanDisk）的厂商代码，5003 是设备的特定型号代码。
- M.2 NVMe SSD (已识别的 M.2 固态硬盘):
    - 具体型号: WDC PC SN520 SDAPNUW-128G-1006 (西部数据 SN520 系列，容量 128GB)=
    - 接口规格: (128.1GB-PCIe x2, 8.0GT/s) (容量 128.1GB，PCIe x2 通道，8.0GT/s 速率)

{% asset_img devices-addin.png 附加卡配置页 %}

Add-In Config (附加卡配置)：

- iSCSI Configuration (iSCSI 配置): [ Configure ] (配置按钮)
    - 说明: iSCSI 是一种将 SCSI 指令通过 TCP/IP 网络传输的技术。简单来说，它允许这台 NUC 通过网络连接到一个远程的存储服务器（NAS/SAN），并把这个网络存储当作本地硬盘来使用（常用于无盘工作站或企业虚拟化）。
    - 操作: 如果您不使用网络存储服务器，不需要点击进去。如果需要配置，点击 Configure 会进入一个子菜单，允许您输入目标服务器的 IP 地址、端口和 CHAP 认证信息。

Intel(R) Ethernet Connection (4) I219-V
- MAC 地址: 1C:69:7A:65:BC:27
    - 说明: 这是主板自带的 Intel 千兆有线网卡的硬件信息。MAC 地址是这块网卡的唯一物理地址。
    - 操作: 点击旁边的 [ Configure ] 按钮，通常会进入网卡的底层配置界面（如设置 VLAN、唤醒功能、PXE 启动参数等）。


{% asset_img cooling.png 散热配置页 %}

Cooling（散热）：

左侧：Performance Monitor (性能监控)

- Fan Speeds (RPM) - 风扇转速: 当前 CPU 风扇转速为 3599 RPM。
- Temperatures (C) - 温度:
    - CPU Core Temp (CPU核心温度): 49.00°C
    - Memory Temp (内存温度): 45.00°C
    - Motherboard Ambient (主板环境温度): 44.00°C
    - PCH Temp (芯片组温度): 48.00°C
- Thresholds (V) - 电压:
    - CPU I/O (CPU输入输出): 0.95V
    - SDRAM (内存): 1.17V
    - CPU INPUT (CPU输入): 0.74V

右侧：CPU Fan Header (CPU 风扇接口策略)

- Fan Control Mode (风扇控制模式): Balanced (均衡)
    - 说明: 目前系统采用了“均衡”模式，兼顾散热和噪音。其他选项通常还有 Quiet (静音)、Performance (性能) 或 Custom (自定义)。如果选择 Custom，下面的滑块就可以自由调节。
- Primary Temperature Sensor (主温度传感器): Processor (处理器)
    - 说明: 指示风扇主要根据 CPU 的温度来决定转速。
- Fan off capability (风扇停转功能): ☑ 已勾选
    - 说明: 当温度极低时，允许风扇完全停转，实现绝对的零噪音。
- Fan Off Temperature (风扇停转温度): 40°C
    - 说明: 当 CPU 温度低于 40°C 时，风扇会直接停转。
- Minimum Temperature (最低温度): 80°C
    - 说明: 当温度达到 80°C 时，风扇将开始进入按曲线加速的状态。（在40°C到80°C之间，风扇会按最低占空比运行）。
- Minimum Duty Cycle (%) (最低占空比/最低转速百分比): 46%
    - 说明: 只要风扇转动（未停转），它的最低转速将保持在最大转速的 46%。此时观测到的 3599 RPM 就是在这个 46% 占空比下产生的。
- Secondary Temperature Sensor (次要温度传感器): Memory (内存)
    - 说明: 设定了一个次要参考温度传感器，当前绑定的是内存温度。
    - 下面是对应的次要温度阈值: 停转温度 37°C，最低温度 50°C，最低占空比 46%。（当内存温度升高时，也会促使风扇加速）。
- Duty Cycle Increment (%/°C) (占空比增量): 8
    - 说明: 当温度超过设定的最低温度（80°C）后，温度每升高 1°C，风扇转速（占空比）就会增加 8%。

{% asset_img processor.png 性能-处理器配置页 %}

左侧：Core Settings (核心设置)

- Host Clock Frequency (基准时钟频率): 100 MHz (主板基础时钟，只读)。
- Max Processor Speed (最大处理器速度): 3.4 Ghz (开启睿频后的最高频率，只读)。
- Intel® Hyper-Threading Technology (英特尔超线程技术): ☑ 已勾选
    - 作用: 允许每个物理核心处理两个线程（您的 i5-7260U 是双核四线程）。开启此功能可以显著提升多任务处理能力。建议保持勾选。
- Intel® Turbo Boost Technology (英特尔睿频加速技术): ☑ 已勾选
    - 作用: 允许 CPU 在需要时自动超过基础频率（2.20GHz）运行，最高可达 3.4GHz。建议保持勾选，这是提升日常使用流畅度的关键。
- Active Processor Cores (活动处理器核心): ALL (全部)
    - 作用: 设置开启几个物理核心。选择 ALL 表示双核全开。除非您在排查硬件故障或需要极致省电，否则请勿修改。
- Real-Time Performance Tuning (实时性能调优): ☑ 已勾选
    - 作用: 允许系统在运行时动态调整性能状态以适应负载。建议保持勾选。
- Silicon Debug Features (硅片调试功能): ☐ 未勾选
    - 作用: 这是供 Intel 工程师和主板开发人员使用的底层硬件调试开关。普通用户请务必保持不勾选。

右侧：Uncore Settings (非核心设置)

- Processor Ring Frequency (处理器环形总线频率): 3.2 Ghz
    - 说明: 环形总线是连接 CPU 核心、核显（GPU）、缓存以及内存控制器的内部高速通道。这里的 3.2GHz 是硬件自动设定的总线速度，在此页面为只读状态，不可更改。


{% asset_img graphics.png 性能-核显配置页 %}

Performance（性能） 菜单下的 Graphics（显卡）：

General Settings (常规设置)
- Graphics Dynamic Frequency (显卡动态频率): 0.95 Ghz-
    - 说明: 这是您处理器内置的 Intel HD Graphics 620 核显当前的动态最高运行频率。
    - 意义: 核显没有独立的物理显存和固定的主频，它会根据系统负载（如看视频、玩游戏或系统空闲）自动在基础频率和这个最高频率（0.95 GHz，即 950 MHz）之间动态调整，以平衡性能和功耗。这个数值是由 CPU 硬件规格决定的，在此页面只读，不可更改。

{% asset_img bios-memory.png 性能-内存配置页1 %}

Performance（性能） -> Memory（内存）

左侧：Timing Settings (时序/硬件信息设置 - 只读)

- Total Memory (总内存): 8 GB
- Memory Speed (内存频率): 2133 MHz (这是第7代酷睿支持的标准最高频率)
- Memory Clock (内存时钟): 1333 MHz (注意：由于是 DDR 内存，实际物理时钟是频率的一半，1333 x 2 ≈ 2666。但这里显示系统运行在 2133 等效频率下)
- SODIMM 1 & 2: 显示插了两根 4GB 的内存条（组成双通道）。
- Memory Voltage (内存电压): 1.2V (标准的 DDR4 内存电压)。

右侧：General Settings (常规/高级设置 - 可操作)

- Memory Profiles (内存配置文件): Automatic (自动)
    - 说明: 这是最安全的设置。主板会自动读取内存条上的 SPD 信息并应用最稳定的参数。如果您是普通用户，强烈建议保持 Automatic。
- Memory Multiplier (内存倍频): 16
    - 说明: 16 x 100MHz (基准时钟) = 1600MHz (等效 3200)。由于被锁定在自动模式，此项为灰色不可调。

{% asset_img memory-1.png 性能-内存配置页2 %}

右侧：General Settings (常规/高级设置 - 可操作)

- Round Trip Latency Optimization (往返延迟优化): ☑ 已勾选
    - 说明: 这是一个内存高级优化功能。开启后，主板会尝试优化 CPU 与内存之间的数据往返延迟。开启它通常对系统性能有微小的正面提升，且兼容性较好。保持勾选即可。
- TCR (Temperature Compensated Refresh / 温度补偿刷新): Disable (禁用)
    - 说明: 这是 DDR4 内存的一项高级功能。开启后，内存控制器会根据温度动态调整内存的刷新率（温度高时增加刷新频率以保证数据不丢失，温度低时降低刷新频率以省电）。由于您的主板当前设置为 Disable，说明为了绝对的稳定性，此功能被关闭了。建议保持禁用状态，因为强制开启有时会导致老旧内存条出现兼容性不稳定问题。

{% asset_img security.png 安全配置页2 %}

Security（安全） 设置

左侧：Passwords (密码设置)

- Supervisor Password (管理员密码): 用于限制进入 BIOS 设置界面的权限。设置后，没有密码无法修改 BIOS 设置。
- User Password (用户密码): 用于限制开机启动的权限。设置后，每次开机都需要输入密码。
- SATA Port: ST9320325AS (硬盘密码): 针对您那块 320GB 机械硬盘的硬件级加密（HDD Password）。设置了硬盘密码后，就算把这块硬盘拆下来接到别的电脑上，如果没有密码也无法读取数据。（注意：一旦忘记此密码，硬盘数据将永久无法找回，通常不建议普通用户设置）。

右侧：Security Features (安全特性)

- Allow UEFI 3rd party driver loaded (允许加载 UEFI 第三方驱动): ☑ 已勾选 。
    - 说明: 允许在 UEFI 启动早期加载第三方的 EFI 驱动（对于 Linux 或特定扩展卡很有用）。
- Unattended BIOS Configuration (无人值守 BIOS 配置): Always Prompt (总是提示)。
    - 说明: 防止恶意软件在后台静默修改 BIOS 设置。
- Execute Disable Bit (执行禁用位 / 硬件防病毒): ☑ 已勾选。
    - 说明: 也就是常说的 NX 位，防止恶意代码在数据内存区执行，是系统安全的基础，必须开启。
- Intel® Virtualization Technology (Intel 虚拟化技术 / VT-x): ☑ 已勾选。
    - 说明: 允许 CPU 支持硬件虚拟化。如果您要在系统里运行虚拟机（如 VirtualBox、VMware、KVM 或 Docker），必须开启。
- Intel® VT for Directed I/O (VT-d): ☑ 已勾选。
    - 说明: 允许将物理硬件设备（如网卡、硬盘控制器）直接分配给虚拟机使用（PCI 直通）。配合 Debian 系统非常有用，建议开启。
- Fixed Disk Boot Sector (固定磁盘引导扇区保护): Normal (正常)。
    - 说明: 防止引导型病毒修改主引导记录（MBR）。
- Intel® Platform Trust Technology (Intel PTT): ☑ 已勾选。
    - 说明: 这是 Intel 的固件可信平台模块（相当于内置的 TPM 2.0 芯片）。用于 Windows 11 的安全启动或 BitLocker 磁盘加密。在 Linux 下也可以配合 LUKS 进行全盘加密。保持开启即可。
- Intel® Software Guard Extension (SGX) (软件防护扩展): Software Controlled (软件控制)
    - 说明: 这是一个用于保护敏感数据（如密钥）在内存中不被窃取的安全飞地技术。对于普通用户和常规 Linux 使用，保持由软件控制即可。
- Thunderbolt Security Level (雷电接口安全级别): Unique ID (唯一 ID)
    - 说明: 防止“恶意外设”（如 DMA 攻击）。设置为 Unique ID 时，首次插入雷电设备会弹窗请求授权，安全性较高。

{% asset_img power.png 电源配置页2 %}

Power（电源）配置

左侧：Primary Power Settings (主电源设置)
- Balanced Enabled (启用均衡模式): ☐ 未勾选
- Low Power Enabled (启用低功耗模式): ☑ 已勾选
    - 说明: 当前主机运行在低功耗策略下。这通常会限制 CPU 的最低频率和最高睿频，以达到省电和降低发热的目的。
- Max Performance Enabled (启用最大性能模式): ☐ 未勾选
    - 说明: 如果您希望 NUC 发挥最大性能（比如跑虚拟机、编译代码），可以取消勾选 Low Power，改为勾选此项。

右侧：Secondary Power Settings (次级电源设置)
- Power Sense (电源感应): ☑ 已勾选 (通常指主板能感知外部电源状态的变化)
    - 说明: 防止因整机功耗过高而导致电源适配器（外接电源）过载而意外断电，主板会立刻向 CPU 发送一个名为 PROCHOT#（Processor Hot，处理器过热）的信号降低功耗。
- After Power Failure (断电恢复后的状态): Last State (上一次的状态)
    - 说明: 如果您正在使用电脑时突然停电，来电后，机器会自动恢复到停电前的状态（如果停电前是开机的，来电就自动开机；如果停电前是关机的，来电就保持关机）。
- Deep S4/S5 (深度休眠/关机): ☑ 已勾选
    - 说明: 开启此功能后，在 S4（休眠）或 S5（完全关机）状态下，主板会切断几乎所有非必要硬件的供电，以达到最低的待机功耗（通常低于 0.5W）。
- Button LED (电源按钮指示灯): Power State Indicator (电源状态指示)
    - 说明: 电源键上的灯光会根据电脑的开关机状态亮起或熄灭。
- S0 / S3 / S5 Indicator (S0/S3/S5 状态指示灯):
    - S0 代表正常工作状态（开机），S3 代表睡眠（待机），S5 代表关机。
    - 这里可以分别设置这三种状态下，机箱前面板指示灯（或电源键环形灯）的亮度 (Brightness)、闪烁频率 (blinking/Fade) 和 颜色 (Color)。
    - 例如截图中：S0（开机）设为蓝色常亮，亮度100%；S3（睡眠）设为琥珀色 0.5Hz 呼吸/闪烁；S5（关机）设为琥珀色常亮。
- Ring LED (环形灯): Power State Indicator (电源键的外圈灯光跟随电源状态变化)。

{% asset_img power-1.png 电源配置页2 %}

右侧：Secondary Power Settings (次级电源设置)
- Wake on LAN from S4/S5 (局域网唤醒): Power On - Normal Boot (开机 - 正常启动)
    - 说明: 允许通过网络发送“魔术包（Magic Packet）”来唤醒处于休眠(S4)或关机(S5)状态的 NUC。当前设置为正常开机。
- Wake System from S5 (从 S5 关机状态定时唤醒): ☐ 未勾选
    - 说明: 如果勾选，下方会弹出时间设置，允许设置一个具体的日期和时间让电脑自动开机。
- Wake From Thunderbolt Devices (雷电设备唤醒): ☑ 已勾选
    - 说明: 允许通过连接在雷电 3 接口上的设备（如扩展坞）来唤醒电脑。建议保持开启，方便外接设备唤醒。
- PCIe ASPM Support (PCIe 主动状态电源管理): ☑ 已勾选
    - 说明: 这是非常重要的节能功能。它允许空闲的 PCIe 设备（如您的 M.2 固态硬盘、网卡等）进入低功耗状态。建议保持开启，不仅能省电，还能降低 NUC 内部的发热。(注：极少数老旧 Linux 内核对 ASPM 兼容性不佳，如果发现死机可尝试关闭此项，但通常 Debian 下没问题)。
- Native ACPI OS PCIe Support (原生 ACPI 操作系统 PCIe 支持): ☐ 未勾选
    - 说明: 允许现代操作系统（如您的 Debian）直接接管 PCIe 总线的电源管理。建议保持开启。
- Flash Update Sleep Delay (BIOS 刷新休眠延迟): ☑ 已勾选
    - 说明: 在使用 F7 更新 BIOS 时，如果系统进入休眠，会延迟更新操作以保护主板不被刷坏。保持默认即可。

{% asset_img boot.png 启动项配置页1 %}

左侧：UEFI Boot Priority (UEFI 启动优先级)
- UEFI Boot (UEFI 启动): ☑ 已勾选
    - 说明: 当前系统处于现代标准的 UEFI 启动模式。这也是安装 Windows 10/11 和现代 Linux（如您的 Debian）的推荐模式。
- Boot Drive Order (启动驱动器顺序):
    - 第一启动项: UEFI : debian : PART 0 : OS Bootloader
    - 表示主板会优先从安装了 Debian Linux 系统的硬盘分区加载 GRUB 引导程序。这正是您想要的结果。
    - 第二启动项: UEFI : LAN : PXE IP4 Intel(R) Ethernet Connection (4) I219-V
    - 第三启动项: UEFI : LAN : PXE IP6 Intel(R) Ethernet Connection (4) I219-V

---

右侧：Legacy Boot Priority (传统启动优先级)
- Legacy Boot (传统 BIOS 启动): ☐ 未勾选
    - 说明: 当前被禁用。Legacy 即老式的 CSM（兼容性支持模块），主要用于引导早期的 Windows 7 或很老的 Linux 系统。对于您当前的 Debian 系统，保持不勾选是完全正确的，因为 Debian 完美支持 UEFI。


{% asset_img boot-1.png 启动项配置页2 %}

Boot（启动） 菜单下的 Boot Configuration（启动配置）

左侧：UEFI Boot & Boot Devices (启动选项与设备)
- Fast Boot (快速启动): ☐ 未勾选（关闭）
    - 说明: 关闭状态下，主板在开机时会进行完整的硬件自检。如果您经常需要按 F2 进 BIOS 或按 F10 选启动项，保持关闭比较方便，因为你有足够的时间按键。
    - 如果勾选开启，开机速度会变快，但按键进 BIOS 的时间窗口极短。
- Boot USB Devices First (优先启动 USB 设备): ☑ 已勾选
    - 说明: 如果您插着带引导系统的 U 盘开机，主板会优先从 U 盘启动。这对于维护系统或重装系统非常方便。
- Boot Network Devices Last (网络设备最后启动): ☑ 已勾选
    - 说明: 只有在本地硬盘和 U 盘都找不到系统时，才会去尝试网络启动（PXE）。建议保持。
- Unlimited Boot to Network Attempts(允许无限次尝试从网络启动)
    - 电脑会一直、反复地向网络发送请求，尝试通过网络启动，直到它成功连上服务器为止。
    - 如果网络环境有问题，它就会一直卡在“寻找网络启动”的界面，无限循环。
- BIOS Setup Auto-Entry (自动进入 BIOS 设置): ☐ 未勾选
    - 说明: 如果勾选，每次开机都会自动进入 BIOS 界面，通常只在刷机或深度调试时才会打开。
- Startup Sound (开机提示音): ☐ 未勾选
    - 说明: 如果勾选，每次开机主板上的蜂鸣器（如果连接了的话）会发出“滴”的一声。当前处于关闭状态，开机非常安静。

Boot Devices (可引导设备类型)：
- 内部 UEFI Shell、USB、雷电 USB 启动、雷电启动、光驱（Optical）、Network Boot (网络引导方式：UEFI PXE & iSCSI)。当前基本都处于开启状态，这能保证最大的兼容性。

---

右侧：Boot Display Config (启动显示配置)
- Failsafe Watchdog (故障保护看门狗): ☑ 已勾选
    - 说明: 如果开机时卡死，主板会在一定时间后自动重启，防止永久死机。
- BIOS Self Recovery (BIOS 自我恢复): ☑ 已勾选
    - 说明: 如果 BIOS 发生损坏或刷写失败，主板会尝试从备份中恢复。强烈建议保持开启。
- Suppress Alert Messages At Boot (在启动时抑制警报信息): ☐ 未勾选
    - 说明: 如果遇到硬件故障（如风扇没转、内存没插紧），开机时屏幕上会显示大字警告。不勾选可以让你看到这些救命信息。
- Expansion Card Text (扩展卡文本): Enable (启用)
    - 说明: 允许在开机画面显示第三方 PCIe 扩展卡（如您安装的 M.2 硬盘或网卡）的初始化信息。
- Keyboard Ready Beep (键盘就绪提示音): ☑ 已勾选
    - 说明: 开机自检到键盘时，主板上的蜂鸣器（如果有的话）会“滴”一声。
- POST Function Hotkeys Displayed (显示 POST 功能热键): ☑ 已勾选
- Display F2 to Enter Setup (显示 F2 进设置): ☑ 已勾选
- Display F7 to Update BIOS (显示 F7 更新 BIOS): ☑ 已勾选
- Display F8 to Activate Windows Recovery Mode (显示 F8 激活 Windows 恢复模式): ☑ 已勾选
- Display F10 to Enter Boot Menu (显示 F10 进启动菜单): ☑ 已勾选
- Display F12 for Network Boot (显示 F12 网络引导): ☑ 已勾选
    - 说明: 上面这一长串（F2/F7/F8/F10/F12），都是控制开机那一瞬间（屏幕底部）是否显示对应的快捷键提示文字。保持勾选能让你清楚知道按哪个键能做什么。

{% asset_img boot-2.png 启动项配置页3 %}


{% asset_img boot-3.png 启动项配置页4 %}

Secure Boot Config (安全启动配置)
- Secure Boot (安全启动): ☐ 未勾选 (关闭)
    - 说明: 核心开关。当前处于关闭状态。这意味着主板不会验证引导程序（如 GRUB）的数字签名。
    - (重点：对于大多数自行安装的 Linux 发行版，通常需要关闭此项才能正常引导，否则会报错“Security Violation”或直接进不去系统。您之前能顺利进入 Debian，正是因为这个开关是关着的。)
- Secure Boot Mode (安全启动模式): Standard (标准)
    - 说明: 只有在开启 Secure Boot 后此项才生效，保持标准即可。
- Platform Key (PKpub): Not Installed (未安装)
    - 说明: 平台密钥，是安全启动最高级别的密钥。显示未安装进一步印证了当前安全启动处于完全关闭的状态。
- Key Exchange Key (KEK): Installed (已安装)
- Signature Database (db): Installed (已安装)
- Blacklisted Signature Database (dbx): Installed (已安装)
    - 说明: 这三项（KEK、db、dbx）是安全启动的证书库。虽然它们显示已安装（通常是 Intel 预置的微软或 Intel 自己的证书），但因为主开关 Secure Boot 没勾选，它们目前不发挥作用。

下方灰色的选项（当前不可操作）：
- Install Intel Platform Key (安装 Intel 平台密钥)
- Force Secure Boot Defaults (强制恢复安全启动默认值)
- Clear Secure Boot Data (清除安全启动数据)
- Generate New Platform Key (生成新的平台密钥)
    - 解释: 由于当前 Secure Boot 处于关闭状态，这些高级密钥管理操作被锁定了，无法点击。

## 四、拆机清洁

> 首先，准备一个沾满灰尘的 NUC7i5BNH。

{% asset_img 1.jpg 俯拍图 %}

将其翻过来，松开四个角上的螺栓。

{% asset_img 2.jpg 背面图 %}

可以看到 2.5 英寸 HDD/SSD 安装支架。

{% asset_img 3.jpg 内部图1 %}

轻轻抬起支架，拔下 SATA 线和电源线。小心不要弄断电线；拔出电线时请握住插座。

{% asset_img 4.jpg 内部图2 %}

如果拆下挡板，就可以看到安装了内存和 M.2 固态硬盘的主板。

{% asset_img 5.jpg 主板图1 %}

取出内存条和固态硬盘，并拧下标有红色圆圈的螺栓。

{% asset_img 6.jpg 主板图2 %}

断开电路板上的 WIFI + 蓝牙天线线缆、麦克风线缆和电源指示灯线缆。小心不要弄断线缆；拔出线缆时请握住插座。

{% asset_img 7.jpg 主板图3 %}

取出电路板。必须从后端口方向抓住电路板才能将其取出。取出时要小心，防止电线被电路板卡住而损坏。

{% asset_img 8.jpg 主板图4 %}

哦，这很简单。

{% asset_img 9.jpg 外壳+主板图 %}

将电路板翻过来，就能看到风扇和散热片。拧下螺栓即可拆下风扇。

{% asset_img 10.jpg 主板背面图1 %}

您不一定需要将风扇插座从主板上拆下来。您只需要拧下散热器上的三颗螺丝即可。

> ⚠️ **注意**：由于逐个拧下螺丝可能会损坏 CPU 和芯片组，因此最好交替着拧下这三颗螺丝，一点一点地拧下来。

{% asset_img 11.jpg 主板背面图2 %}

我拆开了散热器，不出所料，导热硅脂已经干涸，所以它无法正常工作。

{% asset_img 12.jpg 主板+CPU+散热器1 %}

我已经彻底清除了导热硅脂。我推荐的清除方法是先用湿巾擦拭，再用超细纤维布擦干净。

> 💡 **提示**：请使用不含化妆品成分的湿巾。如果用湿巾吸干水分，可能会残留灰尘，降低导热硅脂的散热效果。

{% asset_img 13.jpg 主板+CPU+散热器2 %}

涂抹导热硅脂。由于它不是高粘度硅脂，只需涂抹米粒大小的量，并用散热片压紧即可；它会自然铺开。

> 💡 **提示**：推荐购买霍伟尼尔ptm7950相变片(规格:20*30*0.2毫米)，一次安装顶多年。安装时将相变片放入冰箱冷冻30小时再安装，冷冻后的相变片两面的塑料片好掀开，安装方便，不会扯破相变片。相变片可以覆盖一大两小芯片。
> CPU 两侧的是 eDRAM 缓存颗粒，不要弄丢上面的散热垫片。这两个芯片和CPU高度不一致，会导致 eDRAM 无法接触散热底座导出热量。

{% asset_img 14.jpg 涂抹硅脂 %}

拧紧散热器时要比松开时更加小心。在三个不同的位置交替拧紧。

> ⚠️ **注意**：过度拧紧可能会损坏 CPU 或导致系统无法启动。适度拧紧，直到摇晃散热器时它不再晃动为止。

{% asset_img 15.jpg 安装散热器 %}

组装步骤与拆卸步骤相反。只需将电缆对准主板上的前面板端口即可轻松插入。

> ⚠️ **注意**：不要将天线电缆挤压到主板上。如下图红色圆圈所示，那里是天线电缆的出口。

{% asset_img 16.jpg 安装主板 %}

组装完成了。我拍了照片，照片里有吸尘器、导热硅脂、镊子和螺丝刀，它们都帮了我不少忙。

{% asset_img 17.jpg 所有工具 %}

由于第七代 NUC 已经停产，未来您可能需要经常自己进行维修和清洁。

如果出现噪音或运行问题，请尝试清洁并重新涂抹导热硅脂。这款风扇也是笔记本电脑的标准配件，所以应该很容易找到。


## 五、参考

- [NUC7I5BNH-产品技术支持](https://www.asus.com/uk/supportonly/nuc7i5bnh/helpdesk_bios/)
- [清洁英特尔 第七代NUC（NUC7i5BNH）](https://www.clien.net/service/board/use/15653775#1)
- [别再乱拆7代NUC正确保养](https://www.bilibili.com/video/BV1UxoFB9E6P/)
- [300多的NUC7，刷飞牛做NAS的体验怎么样？](https://www.bilibili.com/video/BV1y4rkBFERA/)


## 六、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->intel-nuc7i5bnh](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Fintel-nuc7i5bnh)
