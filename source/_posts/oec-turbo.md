---
title: 网心云 OneThingCloud OEC (OEC-turbo)
date: 2026-11-05 10:39:33
categories: ['Computer', 'ARM', '瑞芯微RK3566', 'OEC', 'OEC-turbo']
tags: ['Computer', 'ARM', '瑞芯微RK3566', 'OEC', 'OEC-turbo']
---

OEC-turbo 是网心云推出的一款边缘计算小盒子，原本的设计用途是共享家庭闲置带宽来换取收益。
但在数码玩家圈子里，它更出名的身份是“矿渣神器”——因为硬件底子不错且二手价格便宜，常被买来刷成其他系统，当作轻量 NAS 或软路由使用。

## 竞品分析

| 项目 | CPU | GPU | 内存 | eMMC | USB3 | 2.5" SATA(7mm) | 2.5" SATA(9.5mm) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 储流箱A3Pro | RK3568 | - | 4GB | 128GB | 2个 | 支持 | 支持 |
| 派享云pro(光速盒子) | RK3568 | Mali-G52 | 4GB | 128GB | 2个 | 支持 | 支持 |


## 一、硬件信息

### 1. 💻 核心硬件配置

| 项目 | 规格 |
| --- | --- |
| 代号 | OneThing Edge Cube(OEC-turbo) |
| CPU | 瑞芯微 RK3566 四核 ARM Cortex-A55 主频1.8GHz |
| GPU | ARM Mali-G52 2EE（集成于 RK3566） |
| NPU | 算力约 1 TOPS，可用于轻量 AI 推理 |
| 内存 | 4GB LPDDR4X |
| 存储 | 8GB eMMC，生产日期2022年11月(Samsung eMMC 5.1 MLC系列？) |
| 有线网口 | 1 个千兆以太网口 |
| SATA 接口 | 1 个 SATA 3.0，支持内置 2.5 寸7mm硬盘 |
| 调试口 | 1 个 USB Type-C，方说明仅用于生产调试，不具备实际功能。仅用于刷机 |
| USB 接口 | 1 个外部 USB 3.0 接口 |
| 尺寸 | 145mm × 90mm × 47mm |
| 散热 | 无主动风扇 |
| 产品状态 | 已停产，发布 2023年6月20日 |
| 电源支持 | 12V ⎓ 2A 5521 24W 规格直流输入 |
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
| :--- | :---: | :---: | :---: | :---: |
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

## 四、刷入飞牛OS

### 4.1 刷机准备

#### 4.1.1. 工具准备

- 电脑：Windows10 / Windows 11 64bit 电脑
- 驱动：[Rockchip_DriverAssitant_v5.1.1.zip](https://static2.fnnas.com/installer/DriverAssitant_v5.1.1.zip)
- 刷机工具：[RKDevTool_Release_v3.37.zip](https://static2.fnnas.com/installer/RKDevTool_v3.37_for_window.zip)
- 引导固件: [MiniLoaderAll.bin](https://pan.quark.cn/s/a719af4c2816#/list/share/064813152b344753b8dfa88b2d2c7ef0)
- 系统固件：[fnos_Mainland-PE_arm_1.2.0302_onethingcloud-oec_2288.img](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Foec-turbo&vmode=list)
- 卡针： 用于顶住`RESET`按钮
- 镊子： 用来做短接线路使用
- USB 刷机线：`A-C` `Type-C`数据线

#### 4.1.2. Bootloader文件准备

> 请使用[L1.0-1.01-2.0-MiniLoaderAll.bin](https://pan.quark.cn/s/a719af4c2816#/list/share/064813152b344753b8dfa88b2d2c7ef0), 或者[git源](https://github.com/ophub/u-boot/blob/main/u-boot/rockchip/wxy-oect/MiniLoaderAll.bin)

`Bootloader`文件，用于`USB`线刷引导，在`RKDevTools`工具的文件夹下面，对应`SOC/MiniLoaderAll.bin`文件名称。
> 例如`RK3566`，对应`rk3566/MiniLoaderAll.bin`文件，不要选错哦。
{% asset_img bootloader.png MiniLoaderAll.bin %}

#### 4.1.3. Rockchip驱动安装

下载`Rockchip USB`线刷驱动（[Rockchip_DriverAssitant_v5.1.1.zip](https://static2.fnnas.com/installer/DriverAssitant_v5.1.1.zip)）：
{% asset_img install_driver.png 安装驱动 %}
{% asset_img install_driver2.png 驱动安装成功 %}


### 4.2 选择刷机模式

> 注意：刷机过程中不需要连接电源，`Type-C`接口会给设备供电。

#### 4.2.1 `LOADER`模式(二刷)

> `LOADER`模式适用已经刷过第三方固件的设备，所以不需要拆机。

长按机器后面的`RESET`小孔不松开，再用`Type-C`数据线连接电脑，等2-3秒后松开`RESET`孔。
等烧录工具显示“发现一个LOADER设备”，就进入`LOADER`模式了。

PS: `LOADER`模式下不需要刷入`boot`固件，只要刷入`system`固件就行。

#### 4.2.1 `MASKROM`模式(首刷/救砖)

> `MASKROM`模式是瑞芯微`SoC`内置的底层恢复 / 烧录模式，也就是刷机模式。

要拆机短接才能进入，首次刷机和救砖要进入`MASKROM`模式，需要勾选`Boot`和`system`两个包，路径要根据下载的解压后的实际路径选择，点后面的`···`可以选择对应文件。

下面开始拆机短接:

1. 可以先插好`Type-C`接口数据，另一侧`USB`口先不插入电脑端(短接时不容易被插线的动作干扰)。

2. 底部朝开锁标志方向推动底部盖板可以取下盖板。
{% asset_img 1.png 取下盖板 %}

3. 卸下底部四颗螺丝。
{% asset_img 2.png 卸下底部四颗螺丝 %}

4. 卸下底部螺丝后向上推动侧边盖板可以取下侧边盖板。
{% asset_img 3.png 取下侧边盖板 %}

5. 卸下硬盘位周围的8颗螺丝，`SATA排线`接口上的螺丝可以不用拆。
{% asset_img 4.png 拆卸四周8颗螺丝 %}

6. 顶住右侧可以将硬盘位翘起，注意左侧`SATA排线`有点短，别用力过猛扯坏了。
{% asset_img 5.png 顶住右侧将硬盘位翘起 %}

7. 硬盘位翘起来后可以插在左边竖起来，避免扯坏`SATA排线`。
{% asset_img 6.png 翘起硬盘位 %}

8. 用镊子捏住图中电容两侧，相当于短接`1V8`和`GND`触点，但是比短接触点要简单。
{% asset_img duanjie.png 短接1V8和GND触点 %}

{% asset_img pcb.png 短接1V8和GND触点 %}

9. `USB`接口插入电脑2-3秒后松开镊子，烧录工具会从“没有发现设备”变为“发现一个MASKROM设备”，这时就可以开始刷机了。如果没成功就多短接几次。


### 4.6 刷入固件

> **记得勾上`强制按照地址写`，同时地址是否是`0xCCCCCCCC`/`0x00000000`，分别对应`Boot`和固件`System`。**

栏目字段介绍：
| 地址 | 名字 | 路径 | 说明 |
| :---: | :---: | :---: | :---: |
| 0xCCCCCCCC | Boot | D:\OECT\rk3566\MiniLoaderAll.bin | **硬件初始化引导程序固件**，是`.bin`后缀格式 |
| 0x00000000 | system | D:\OECT\firmware\fnos_Mainland-PE_arm_1.2.0302_onethingcloud-oec_2288.img | 系统固件，`.img`后缀格式 |

#### 4.6.1. `LOADER`模式刷入

> **注意: 系统固件为`img`格式，如果下载为 gz/zip/rar 格式需要先解压。**

1. `LOADER`模式时去掉勾选刷`Boot`的选项。
2. 点击`system`这一行，选择要刷入的`.img`后缀固件。
3. 直接点击`执行`，刷入`Image`固件镜像即可。
{% asset_img maskrom4.png LOADER模式刷机 %}

4. 等待下载完毕。
{% asset_img maskrom5.png LOADER模式完毕 %}

#### 4.6.2. `MASKROM`模式刷入

> **注意: boot固件为`.bin`格式，system固件为`.img`格式，如果下载为 gz/zip/rar 格式需要先解压。**

1. 根据设备的`SOC`选择合适的`Boot`文件和`system`固件镜像，不要选错。
{% asset_img maskrom.png 进入MASKROM模式 %}

2. 然后点击`执行`，开始刷机，图片仅供参考。
{% asset_img maskrom1.png 进入MASKROM模式刷机，图片仅供参考 %}

3. 刷机进行中，图片仅供参考。
{% asset_img maskrom2.png 刷机进行中，图片仅供参考 %}

4. 刷机进度100%完成，拔掉刷机数据线，然后接上电源重新启动即可。
{% asset_img maskrom3.png MASKROM模式刷机完成 %}

5. 然后登录路由器后台，查看多出来哪个设备，哪个就是飞牛的ip地址，浏览器访问`http://ip:5666`地址开始使用。

## 五、添加sudo免密

```bash
echo 'phpdragon ALL=(ALL:ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/phpdragon
sudo chmod 0440 /etc/sudoers.d/phpdragon
sudo -k

# 验证,不提示密码即成功
sudo ls /root
```

## 六、修改MAC地址

刷机后可能`MAC`地址跟原厂的不匹配，就需要修改`MAC`地址了。

```bash
# 禁用飞牛官方的MAC地址初始化
sudo systemctl disable --now system_setmac.service

# 清除可能存在的旧绑定（防止被自动还原）
sudo nmcli connection modify "Wired connection 1" 802-3-ethernet.mac-address ""

# 设置新的克隆 MAC 地址
sudo nmcli connection modify "Wired connection 1" 802-3-ethernet.cloned-mac-address 2C:C4:4F:A0:61:1E

# 重新启用连接使配置生效
sudo nmcli connection down "Wired connection 1" && sudo nmcli connection up "Wired connection 1"

# 另开ssh控制台登录并验证
sudo ifconfig end0 | grep ether
```

还原飞牛MAC初始化逻辑：
```bash
# 启用飞牛官方的mac地址初始化
sudo systemctl enable --now system_setmac.service

# 清掉 NM 的 cloned MAC
sudo nmcli connection modify "Wired connection 1" 802-3-ethernet.cloned-mac-address ""
sudo nmcli connection up "Wired connection 1"
```

## 七、迁移系统至U盘

> 当前U盘的主控是`慧荣SM3267AE`。
> JEYI佳翼硬盘盒转M2，主控是`RTL9201C`，不兼容，感觉应该是握手协议不稳定的问题。


当前设备是插入了`SATA硬盘`和`USB盘`的, 所以`USB盘`的设备路径应该是`/dev/sdb`。
如果没有插入`SATA硬盘`，`USB盘`的设备路径应该是`/dev/sda`，这里不要用错了。

### 7.1 U盘分区

```
 进入 fdisk 交互界面
fdisk /dev/sdb
```

{% asset_img fdisk-usb.png 对U盘进行分区 %}

这里只新建一个分区，剩余的容量可用作为软件安装的存储空间，在web后台操作即可。


### 7.2 克隆分区至U盘

`dd`命令是块级别拷贝，会把导致`UUID`等信息一模一样，所以需要处理。

```bash
# 克隆前先卸载分区
umount /dev/sdb1

# 克隆根分区至U盘的系统分区
dd if=/dev/mmcblk0p2 of=/dev/sdb1 bs=4M status=progress conv=fsync

# 更换UUID，不然会和 /dev/mmcblk0p2 一模一样
# 执行 blkid /dev/mmcblk0p2 和 blkid /dev/sdb1 ，对比便知
btrfstune -u /dev/sdb1
```

{% asset_img dd-usb.png 对U盘克隆和修改UUID %}


### 7.3 U盘根分区扩容

`dd`命令是块级别拷贝，会把导致容量显示和克隆源头信息一模一样，所以需要处理。

```
# 创建临时挂载点
mkdir -p /tmp/sata_root

# 挂载格式化后的分区
mount /dev/sdb1 /tmp/sata_root

# 强制扩容文件系统至分区上限
btrfs filesystem resize max /tmp/sata_root

# 3. 验证容量是否变回 32GB
df -h /tmp/sata_root
```

{% asset_img resize-usb-max.png 对U盘根分区扩容 %}


### 7.4 修改U盘fstab

```bash
# 查看原始内容
cat /tmp/sata_root/etc/fstab

# 替换 /dev/mmcblk0p2 为 /dev/sdb1
sed -i 's|/dev/mmcblk0p2|/dev/sdb1|g' /tmp/sata_root/etc/fstab

# 验证替换结果, 应该为 /dev/sdb1
grep -e sdb1 /tmp/sata_root/etc/fstab
```

{% asset_img edit-usb-fstab.png 切换为sdb1 %}


### 7.4 从U盘启动

从U盘启动需要修改`/boot/extlinux/extlinux.conf` 文件。

```bash
# 查看原始内容
cat /boot/extlinux/extlinux.conf

# 替换 /dev/mmcblk0p2 为 /dev/sdb1
sed -i 's|root=/dev/mmcblk0p2|root=/dev/sdb1|g' /boot/extlinux/extlinux.conf

# 验证替换结果, 应该为 /dev/sdb1
grep -e sdb1 /boot/extlinux/extlinux.conf
```

{% asset_img switch-usb-boot.png 改为从U盘启动 %}


### 7.5 重启系统并验证

```bash
# 卸载SATA临时挂载点
umount /tmp/sata_root

# 重启
reboot
```

重新进`ssh`控制台，验证切换结果。

```bash
# 确认 /dev/sdb1 的挂载点是 / ，表示切换成功了
df -h
```

{% asset_img usb-boot-info.png 确认是从U盘启动 %}


### 7.6 总结

迁移采用的是`dd`命令，块级别克隆方案，然后再扩容的办法，优点就是比文件拷贝更靠谱。

然后就是设备认USB硬件！！！

1. 这里的U盘主控芯片是`慧荣SM3267AE - ISP (180806-001)`。

- 主控厂商：SMI（慧荣）
- 主控型号：SM3267AE - ISP 180509-0AE
- 闪存识别码: 453CA5937ED0 - WDC(西部数据) SDTNRHDMC-128G - 4CE/单通道 [MLC-16K] -> 总容量 = 128GB
- 闪存类型：MLC
- 容量：128GB

    {% asset_img usbinfo.png 确认是从U盘启动 %}


2. 另一个`JEYI佳翼`M.2移动硬盘盒 NVME/SATA双协议，主控是`RTL9210C`，固态是`海力士BC711-2242`。
整个组合不可用，应该是硬盘盒与设备硬件层面的不兼容。
大概率是硬盘盒供电问题或者UASP握手协议不稳定导致，因为有时候会出现丢盘现象。


## 八、迁移系统至SATA盘

> 个别设备无法从`USB`的根分区启动系统，很不幸我手上这台设备就是。
> 请切换到`root`用户执行以下操作。

顾名思义，就是把根系统从`eMMC`中迁移出来到`SATA`盘中。
一是缓解`eMMC`的写入寿命，二是给系统盘扩容。
但不是所有设备都支持从`USB`启动根分区的，可以自己尝试，无非就是启动不了重新线刷罢了。

1. 准备工作

    - 系统固件：[fnos_Mainland-PE_arm_1.2.0302_onethingcloud-oec_2288.img](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Foec-turbo&vmode=list)
    - SATA硬盘一块。
    - U盘一个，用于保存系统固件。

2. 切换为root用户

    下面的操作建议都切换到`root`用户进行操作，减少不必要的操作权限问题。

    ```bash
    # 切换到root用户
    sudo -i
    ```


### 8.1、查看SATA盘分区

```
# 查看设备
lsblk
```

{% asset_img lsblk.png 查看设备信息 %}

sda就是sata硬盘，sda1就是分区，我这个盘有2个区，飞牛自动挂载到了`/vol00/Colorful SL500 256GB`，重新分区，要先把这个分区卸载。

### 8.2、卸载SATA盘分区

{% asset_img umount-sda1.png 卸载SATA盘分区 %}

```
# 卸载分区
umount "/dev/sda1"

# 验证是否卸载
lsblk
```

命令中的挂载路径要根据实际路径修改，如果有多个分区被挂载了，都要卸载一遍，卸载过后可以再`lsblk`查看一下是否卸载成功。


### 8.3、SATA盘重新分区

#### 8.3.1. SATA盘创建两个分区

假设SATA盘在系统中识别为 /dev/sda（请先执行`lsblk`命令确认，写错盘符会清空错误磁盘）。

```bash
# 进入 fdisk 交互界面
fdisk /dev/sda
```

在`fdisk`中按顺序输入（每输一个按回车）：
| 输入 | 作用 |
| :---: | :--- |
| o | 创建新的空 DOS 分区表，会清空所有分区 |
| n | 新建分区（系统分区） |
| p | 选择分区类型为主动分区 |
| 1 | 分区号 1 |
| 回车 | 默认起始扇区2048 |
| +32G | 给系统分区 32G 空间 |
| p | 打印最终分区表信息，用于确认 |
| w | 保存并退出 |

{% asset_img fdisk-sda1.png 新建一个32GB分区 %}

这里只建了一个32G的分区，大小可以随意调节。剩余的空间先不创建分区，后面可以在飞牛内创建存储空间。

#### 8.3.2. 格式化分区

```bash
# 系统分区格式化为 btrfs（与当前飞牛系统一致）
mkfs.btrfs -f /dev/sda1
```

{% asset_img mkfs-btrfs.png 格式化分区 %}


### 8.4、克隆根系统到SATA盘

> 推荐用方案一，减少`rsync`同步文件带来的权限等不可确定性。DD命令块拷贝更可靠。

- 方案一

```bash
# 创建临时挂载点
mkdir -p /tmp/usb

# 挂载U盘到 /tmp/usb
mount /dev/sdb1 /tmp/usb

# 关联官方镜像，losetup -fP /path/to/你的镜像.img
losetup -fP /tmp/usb/fnos_Mainland-PE_arm_1.2.0302_onethingcloud-oec_2288.img 

# 把镜像的系统分区写入 SATA 系统分区
dd if=/dev/loop0p2 of=/dev/sda1 bs=4M status=progress conv=fsync

# 释放关联
losetup -D
```

系统扩容, 扩容`SATA`系统分区：由于镜像只有3.4G，我们需要让它填满 32G 的 sda1。
不扩容的话内置系统盘显示3.XG。

```bash
# 创建临时挂载点
mkdir -p /tmp/sata_root

# 挂载格式化后的分区
mount /dev/sda1 /tmp/sata_root

# 强制扩容文件系统至硬件上限
btrfs filesystem resize max /tmp/sata_root

# 3. 验证容量是否变回 32GB
df -h /tmp/sata_root
```


- 方案二

```bash
# 创建临时挂载点
mkdir -p /tmp/sata_root

# 挂载格式化后的分区
mount /dev/sda1 /tmp/sata_root

# 分区开启压缩
btrfs property set /tmp/sata_root compression zstd:3

# 克隆eMMC根分区数据到SATA盘，排除无用目录
rsync -aAXv \
  --exclude=/proc --exclude=/sys --exclude=/dev \
  --exclude=/mnt --exclude=/tmp --exclude=/media \
  --exclude=/boot --exclude='/vol*' \
  / /tmp/sata_root/
```

执行上面的命令，克隆根分区等几分钟就好了。


### 8.5、切换启动分区

> 调整为从`SATA`硬盘的根分区启动

#### 8.5.1. 修改`fstab`文件

修改`SATA`硬盘分区上的`fstab`文件，指定新的根分区挂载，原`eMMC`根分区的`fstab`不需要修改。

{% asset_img edit-fstab.png fstab内容详情 %}

```bash
# 查看原始内容
cat /tmp/sata_root/etc/fstab

# 替换 /dev/mmcblk0p2 为 /dev/sda1
sed -i 's|/dev/mmcblk0p2|/dev/sda1|g' /tmp/sata_root/etc/fstab

# 验证替换结果, 应该为 /dev/sda1
grep -e sda1 /tmp/sata_root/etc/fstab
```

#### 8.5.2. 修改`extlinux`引导配置

修改`/boot/extlinux/extlinux.conf`引导配置文件，决定系统是从`eMMC`启动还是`SATA`启动的关键。

{% asset_img edit-extlinux-cfg.png fstab内容详情 %}

```bash
# 查看原始内容
cat /boot/extlinux/extlinux.conf

# 替换 /dev/mmcblk0p2 为 /dev/sda1
sed -i 's|root=/dev/mmcblk0p2|root=/dev/sda1|g' /boot/extlinux/extlinux.conf

# 验证替换结果, 应该为 /dev/sda1
grep -e sda1 /boot/extlinux/extlinux.conf
```

#### 8.5.3. 重启系统并验证

```bash
# 卸载SATA临时挂载点
umount /tmp/sata_root

# 重启
reboot
```

如果使用的方案一进行的克隆迁移，请先登录网页版本进行后台，开启`SSH`权限。

重新进`ssh`控制台，验证切换结果。

```bash
# 确认 /dev/sda1 的挂载点是 / ，表示切换成功了
df -h
```


#### 8.5.4. 恢复从`eMMC`启动

```bash
# 替换回从eMMC启动
sed -i 's|root=/dev/sda1|root=/dev/mmcblk0p2|g' /boot/extlinux/extlinux.conf

# 校验
grep -e root /boot/extlinux/extlinux.conf

# 重启
reboot
```

**注意：千万不要用`eMMC`创建存储空间，因为`boot`分区还在`eMMC`里，`boot`分区被删除就启动不了了，只能用`SATA`硬盘的剩余空间或者外接存储创建。**


## 九、迁移后的系统升级

> 需要两边都做升级处理，先切换回`eMMC`升级，还原`boot`分区，再切回`SATA`升级。

当前系统升级是已知的最优解，极大程度上减少了对`eMMC`的写入量，主要写入量 = 两遍升级写入 + 还原写入。

首先请进入`ssh`控制台，切换为`root`用户执行以下操作，以减少不必要的权限校验。

```bash
# 切换为root用户
sudo -i
```

### 9.1. 备份`eMMC`的`boot`分区

```bash
# 备份boot分区
dd if=/dev/mmcblk0p1 of=./boot-partition-backup_1.2.0302.img bs=4M status=progress
```

### 9.2. 从`eMMC`启动系统

```bash
sed -i 's|root=/dev/sda1|root=/dev/mmcblk0p2|g' /boot/extlinux/extlinux.conf

# 校验
grep -e root /boot/extlinux/extlinux.conf

# 重启
reboot
```

### 9.3. 从`eMMC`升级系统

在后台进行系统升级操作，等待系统升级完毕自动重启。

### 9.4. 备份`eMMC`新`boot`分区

进入`eMMC`系统的控制台，备份最新版的`boot`分区。

```
dd if=/dev/mmcblk0p1 of=./boot-partition-backup_1.2.1010.img bs=4M status=progress
```

### 9.5. 还原`boot`分区为旧版

```
# 先卸载boot分区
umount /boot

# 还原为旧版本
sudo dd if=./boot-partition-backup_1.2.0302.img of=/dev/mmcblk0p1 bs=4M status=progress

# 确认已还原为旧版本boot分区数据
grep -e sda1 /boot/extlinux/extlinux.conf

# 重启，从SATA启动
reboot
```

### 9.6. 从`SATA`升级系统

进入`SATA`版本的系统后台，操作升级，等待升级完毕自动重启。

### 9.7. 确认升级结果

登录`ssh`控制台，查看是否是从`SATA`启动系统，如果不是则切换从`SATA`启动系统。

```bash
# 确认 /dev/sda1 的挂载点是 / ，表示是从 SATA 启动系统
df -h
```

切换从`SATA`启动系统。
```bash
cat /boot/extlinux/extlinux.conf
sed -i 's|root=/dev/mmcblk0p2|root=/dev/sda1|g' /boot/extlinux/extlinux.conf
grep -e sda1 /boot/extlinux/extlinux.conf

reboot
```

切换从`eMMC`启动系统（可忽略这步操作）。

> 主要是确认能否切换回去，从eMMC正常启动。

```bash
sudo sed -i 's|root=/dev/sda1|root=/dev/mmcblk0p2|g' /boot/extlinux/extlinux.conf
grep -e root /boot/extlinux/extlinux.conf
reboot
```

一起顺利，应该可以两边互相切换启动。
后续的操作可以依照此步骤进行手动升级操作。


## 十、参考

- [OECTurbo 刷机短接点新方法](https://www.right.com.cn/forum/thread-8445911-1-1.html)
- [网心云OEC/OECTubro的刷机教程/短接技巧/救砖心得](https://www.right.com.cn/forum/thread-8459375-1-1.html)
- [Rockchip 瑞芯微系列 eMMC USB 线刷教程](https://help.fnnas.com/articles/v1/arm/arm-rk-usb)
- [OEC-Turbo刷群晖、Armbian流程记录](https://www.right.com.cn/forum/thread-8446774-1-1.html)
- [OEC/OEC-turbo刷机救砖，用RKDevTool避开‘下载boot失败’的保姆级教程](https://blog.csdn.net/John_Lenon/article/details/146461220)
- [OEC/OEC-Turbo刷飞牛258版详细流程，包含手动迁移根分区到sata硬盘无需刻录后扩容](https://www.right.com.cn/forum/thread-8459939-1-1.html)
- [RKDevTool](https://docs.radxa.com/template/module/radxa-os/low-level-dev/rkdevtool)
- [oec/oect最新飞牛rk3566-null-1.2.0701+刷机后恢复应用中心数据](https://www.right.com.cn/forum/thread-8462653-1-1.html)
- [OEC/OECT刷飞牛终极教程](https://mp.weixin.qq.com/s/g8d-Q-HhBPZwax45E_HJYg)
- [OEC/OETC-RK3566刷机飞牛NAS最新版330固件及刷机工具](https://www.right.com.cn/forum/thread-8459705-1-1.html)
- [OEC ARM飞牛OTA最强工具-多系统切换 升级 克隆 LED灯 修改MAC 一键工具](https://www.right.com.cn/forum/thread-8459910-1-1.html)
- [OEC/OECT-飞牛双系统切换软更新系统-安装到SATA硬盘，解决eMMC硬盘太小问题](https://www.right.com.cn/forum/thread-8459776-1-1.html)
- [OECT-飞牛系统迁移到SATA硬盘启动+调整系统分区大小【亲测】【命令简单适合小白搬砖】](https://www.right.com.cn/forum/thread-8459871-1-1.html)


## 十一、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->oec-turbo](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Foec-turbo)
