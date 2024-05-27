---
title: 华硕W519L安装Manjaro系统
date: 2024-05-24 12:51:31
categories: ['Linux', 'Arch Linux', 'Manjaro']
tags: ['Linux', 'Arch Linux', 'Manjaro']
---


# 一、前言

家里有一台闲置的15年款的华硕w519l笔记本。CUP低压版，频率不是很高，先安装了一个Win10。
再搞一个双系统，最后选择了Manjaro，主要的原因笔记本的无线网卡硬件比较低，驱动不好安装。
很多Linux发行版本不能支持。

桌面环境XFCE、LXDE、MATE都比较少用系统资源。
浏览器推荐安装chrome内核浏览器，观看视频CPU利用不高，火狐有点偏高。
| 分支 | 发行版 | 桌面 | 博通BCM43142无线网卡驱动 | 英伟达820M显卡驱动 | 备注 |
|:-------:|:-------:|:--------:|:-------:|:-------:|:-------:|
| Arch | Manjaro | KDE | mhwd -f -i pci network-broadcom-wl | mhwd -f -i pci video-nvidia-390xx | 系统流畅界面美观 |
| Arch | Manjaro | XFCE | mhwd -f -i pci network-broadcom-wl | mhwd -f -i pci video-nvidia-390xx | 系统流畅界面美观 |
| Redhat | Fedora | LXDE | dnf install broadcom-wl.noarch | dnf install xorg-x11-drv-nvidia-390xx.x86_64 | 安装驱动需要添加 RPMFusion 软件仓库 ，官方说适用于旧电脑、上网本，貌似装不上，弹幕流畅，火狐CPU利用率一般，菜单布局类似window|
| Redhat | Fedora | XFCE | dnf install broadcom-wl.noarch | dnf install xorg-x11-drv-nvidia-390xx.x86_64 | 安装驱动需要添加 RPMFusion 软件仓库 ，火狐CPU利用率不高、弹幕流畅，界面比LXDE差一些，菜单布局类似、弹幕流畅、自带浏览器负载低|
| Debian | LinuxMint | XFCE | apt install broadcom-stat-dkms | apt install xserver-xorg-video-nvidia-390 | 系统菜单接近window |
| Debian | LinuxMint | MATE | apt install broadcom-stat-dkms | apt install xserver-xorg-video-nvidia-390 | 汉化不错 |
| Debian | MX Linux | XFCE | apt install firmware-brcm80211 | apt install xserver-xorg-video-nvidia-legacy-390xx |  |
| Debian | Lubuntu | LXDE | apt install bcmwl-kernel-source | apt install xserver-xorg-video-nvidia-390 | 火狐负载不高、弹幕流畅 |
| Debian | Xubuntu | XFCE | apt install bcmwl-kernel-source | apt install xserver-xorg-video-nvidia-470 疑问 | 汉化做的很好、弹幕流畅 |


# 二、LiveCD 安装系统
- 1.准备一个至少6G的U盘。
- 2.下载[Ventoy](https://www.ventoy.net/cn/download.html)的iso镜像到本地。
- 3.安装Ventoy到U盘。
- 4.下载Manjaro系统镜像文件并拷贝到U盘根目录下。
- 5.插入U盘到笔记本，并开机，按ESC键，选择EFI 进入Ventoy liveCD系统，选择你的系统镜像进入。
- 6.开始安装Manjaro系统。


# 三、配置Manjaro系统

## 查询系统信息

### 系统信息
```bash
inxi -Fazy
```
输出
```txt
System:
  Kernel: 6.9.0-1-MANJARO arch: x86_64 bits: 64 compiler: gcc v: 13.2.1
    clocksource: tsc avail: acpi_pm
    parameters: BOOT_IMAGE=/boot/vmlinuz-6.9-x86_64
    root=UUID=1d9b73c5-6797-44a0-bfc7-cfdeac4eb185 rw quiet splash
    udev.log_priority=3
  Console: pty pts/1 DM: SDDM Distro: Manjaro base: Arch Linux
Machine:
  Type: Laptop System: ASUSTeK product: X555LD v: 1.0
    serial: <superuser required>
  Mobo: ASUSTeK model: X555LD v: 1.0 serial: <superuser required>
    part-nu: ASUS-NotebookSKU uuid: <superuser required>
    UEFI: American Megatrends v: X555LD.310 date: 08/14/2014
Battery:
  ID-1: BAT0 charge: 24.6 Wh (98.0%) condition: 25.1/37.3 Wh (67.3%) volts: 7.5
    min: 7.5 model: ASUSTeK X555-50 type: Li-ion serial: N/A status: not charging
    cycles: 251
CPU:
  Info: model: Intel Core i5-4210U bits: 64 type: MT MCP arch: Haswell
    gen: core 4 level: v3 note: check built: 2013-15 process: Intel 22nm
    family: 6 model-id: 0x45 (69) stepping: 1 microcode: 0x26
  Topology: cpus: 1x cores: 2 tpc: 2 threads: 4 smt: enabled cache:
    L1: 128 KiB desc: d-2x32 KiB; i-2x32 KiB L2: 512 KiB desc: 2x256 KiB
    L3: 3 MiB desc: 1x3 MiB
  Speed (MHz): avg: 800 min/max: 800/2700 scaling: driver: intel_cpufreq
    governor: schedutil cores: 1: 800 2: 800 3: 800 4: 800 bogomips: 19166
  Flags: avx avx2 ht lm nx pae sse sse2 sse3 sse4_1 sse4_2 ssse3 vmx
  Vulnerabilities:
  Type: gather_data_sampling status: Not affected
  Type: itlb_multihit status: KVM: VMX disabled
  Type: l1tf mitigation: PTE Inversion; VMX: conditional cache flushes, SMT
    vulnerable
  Type: mds mitigation: Clear CPU buffers; SMT vulnerable
  Type: meltdown mitigation: PTI
  Type: mmio_stale_data status: Unknown: No mitigations
  Type: reg_file_data_sampling status: Not affected
  Type: retbleed status: Not affected
  Type: spec_rstack_overflow status: Not affected
  Type: spec_store_bypass mitigation: Speculative Store Bypass disabled via
    prctl
  Type: spectre_v1 mitigation: usercopy/swapgs barriers and __user pointer
    sanitization
  Type: spectre_v2 mitigation: Retpolines; IBPB: conditional; IBRS_FW;
    STIBP: conditional; RSB filling; PBRSB-eIBRS: Not affected; BHI: Not
    affected
  Type: srbds mitigation: Microcode
  Type: tsx_async_abort status: Not affected
Graphics:
  Device-1: Intel Haswell-ULT Integrated Graphics vendor: ASUSTeK driver: i915
    v: kernel arch: Gen-7.5 process: Intel 22nm built: 2013 ports: active: eDP-1
    empty: DP-1,HDMI-A-1 bus-ID: 00:02.0 chip-ID: 8086:0a16 class-ID: 0300
  Device-2: NVIDIA GF117M [GeForce 610M/710M/810M/820M / GT
    620M/625M/630M/720M] vendor: ASUSTeK driver: nouveau v: kernel non-free:
    series: 390.xx+ status: legacy (EOL~2022-11-22) last: release: 390.157
    kernel: 6.0 xorg: 1.21 arch: Fermi code: GF1xx process: 40/28nm
    built: 2010-2016 pcie: gen: 1 speed: 2.5 GT/s lanes: 4 link-max: lanes: 8
    bus-ID: 04:00.0 chip-ID: 10de:1140 class-ID: 0302
  Device-3: Realtek USB Camera driver: uvcvideo type: USB rev: 2.0
    speed: 480 Mb/s lanes: 1 mode: 2.0 bus-ID: 2-5:6 chip-ID: 0bda:57b5
    class-ID: 0e02 serial: <filter>
  Display: server: X.org v: 1.21.1.13 with: Xwayland v: 23.2.6
    compositor: kwin_x11 driver: X: loaded: modesetting alternate: fbdev,vesa
    dri: crocus,nouveau gpu: i915 tty: 121x45
  Monitor-1: eDP-1 model: ChiMei InnoLux 0x15ab built: 2013 res: 1366x768
    dpi: 101 gamma: 1.2 size: 344x193mm (13.54x7.6") diag: 394mm (15.5")
    ratio: 16:9 modes: 1366x768
  API: EGL v: 1.5 hw: drv: intel crocus drv: nvidia nouveau platforms:
    device: 0 drv: crocus device: 1 drv: nouveau device: 2 drv: swrast
    surfaceless: drv: crocus inactive: gbm,wayland,x11
  API: OpenGL v: 4.6 compat-v: 4.3 vendor: mesa v: 24.0.6-manjaro1.1
    note: console (EGL sourced) renderer: Mesa Intel HD Graphics 4400 (HSW GT2),
    NVD7, llvmpipe (LLVM 17.0.6 256 bits)
  API: Vulkan Message: No Vulkan data available.
Audio:
  Device-1: Intel Haswell-ULT HD Audio vendor: ASUSTeK driver: snd_hda_intel
    v: kernel bus-ID: 00:03.0 chip-ID: 8086:0a0c class-ID: 0403
  Device-2: Intel 8 Series HD Audio vendor: ASUSTeK driver: snd_hda_intel
    v: kernel bus-ID: 00:1b.0 chip-ID: 8086:9c20 class-ID: 0403
  API: ALSA v: k6.9.0-1-MANJARO status: kernel-api with: aoss
    type: oss-emulator tools: alsactl,alsamixer,amixer
  Server-1: JACK v: 1.9.22 status: off tools: N/A
  Server-2: PipeWire v: 1.0.5 status: active with: 1: pipewire-pulse
    status: active 2: wireplumber status: active 3: pipewire-alsa type: plugin
    tools: pactl,pw-cat,pw-cli,wpctl
Network:
  Device-1: Realtek RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet
    vendor: ASUSTeK driver: r8169 v: kernel pcie: gen: 1 speed: 2.5 GT/s lanes: 1
    port: e000 bus-ID: 02:00.0 chip-ID: 10ec:8168 class-ID: 0200
  IF: enp2s0 state: up speed: 1000 Mbps duplex: full mac: <filter>
  Device-2: Broadcom BCM43142 802.11b/g/n vendor: Lite-On driver: N/A pcie:
    gen: 1 speed: 2.5 GT/s lanes: 1 bus-ID: 03:00.0 chip-ID: 14e4:4365
    class-ID: 0280
  Info: services: NetworkManager, sshd, systemd-timesyncd
Bluetooth:
  Device-1: Lite-On Broadcom BCM43142A0 Bluetooth Device driver: btusb v: 0.8
    type: USB rev: 2.0 speed: 12 Mb/s lanes: 1 mode: 1.1 bus-ID: 2-6:7
    chip-ID: 04ca:2006 class-ID: fe01 serial: <filter>
  Report: rfkill ID: hci0 rfk-id: 0 state: up address: see --recommends
Drives:
  Local Storage: total: 718.67 GiB used: 31.99 GiB (4.5%)
  SMART Message: Required tool smartctl not installed. Check --recommends
  ID-1: /dev/sda maj-min: 8:0 vendor: Colorful model: SL500 256GB
    size: 238.47 GiB block-size: physical: 512 B logical: 512 B speed: 6.0 Gb/s
    tech: SSD serial: <filter> fw-rev: 18C1 scheme: MBR
  ID-2: /dev/sdb maj-min: 8:16 vendor: Western Digital
    model: WD5000LPVX-80V0TT0 size: 465.76 GiB block-size: physical: 4096 B
    logical: 512 B speed: 6.0 Gb/s tech: HDD rpm: 5400 serial: <filter>
    fw-rev: 1A01 scheme: MBR
  ID-3: /dev/sdc maj-min: 8:32 vendor: Kingston model: DataTraveler 3.0
    size: 14.44 GiB block-size: physical: 512 B logical: 512 B type: USB rev: 3.2
    spd: 5 Gb/s lanes: 1 mode: 3.2 gen-1x1 tech: N/A serial: <filter>
    fw-rev: PMAP scheme: MBR
Partition:
  ID-1: / raw-size: 105.94 GiB size: 103.71 GiB (97.90%) used: 7.65 GiB (7.4%)
    fs: ext4 dev: /dev/sda3 maj-min: 8:3
  ID-2: /boot/efi raw-size: 300.5 MiB size: 299.9 MiB (99.79%)
    used: 288 KiB (0.1%) fs: vfat dev: /dev/sda2 maj-min: 8:2
Swap:
  Kernel: swappiness: 60 (default) cache-pressure: 100 (default) zswap: yes
    compressor: zstd max-pool: 20%
  ID-1: swap-1 type: partition size: 13 GiB used: 256 KiB (0.0%) priority: -2
    dev: /dev/sda4 maj-min: 8:4
Sensors:
  System Temperatures: cpu: 42.0 C pch: 40.5 C mobo: N/A
  Fan Speeds (rpm): cpu: 2600
Info:
  Memory: total: 12 GiB note: est. available: 11.14 GiB used: 1.33 GiB (11.9%)
  Processes: 192 Power: uptime: 5m states: freeze,mem,disk suspend: deep
    avail: s2idle wakeups: 0 hibernate: platform avail: shutdown, reboot,
    suspend, test_resume image: 4.42 GiB services: org_kde_powerdevil,
    power-profiles-daemon, upowerd Init: systemd v: 255 default: graphical
    tool: systemctl
  Packages: pm: pacman pkgs: 1170 libs: 345 tools: pamac pm: flatpak pkgs: 0
    Compilers: N/A Shell: Bash v: 5.2.26 running-in: pty pts/1 (SSH) inxi: 3.3.34
```

### 显卡信息
```text
[lby@manjaro ~]$ lspci|grep -E '(VGA|3D)'
00:02.0 VGA compatible controller: Intel Corporation Haswell-ULT Integrated Graphics Controller (rev 0b)
04:00.0 3D controller: NVIDIA Corporation GF117M [GeForce 610M/710M/810M/820M / GT 620M/625M/630M/720M] (rev a1)

[lby@manjaro ~]$ lspci -vnn
00:02.0 VGA compatible controller [0300]: Intel Corporation Haswell-ULT Integrated Graphics Controller [8086:0a16] (rev 0b) (prog-if 00 [VGA controller])
        Subsystem: ASUSTeK Computer Inc. Device [1043:16cd]
        Flags: bus master, fast devsel, latency 0, IRQ 47
        Memory at f7400000 (64-bit, non-prefetchable) [size=4M]
        Memory at d0000000 (64-bit, prefetchable) [size=256M]
        I/O ports at f000 [size=64]
        Expansion ROM at 000c0000 [virtual] [disabled] [size=128K]
        Capabilities: <access denied>
        Kernel driver in use: i915
        Kernel modules: i915

04:00.0 3D controller [0302]: NVIDIA Corporation GF117M [GeForce 610M/710M/810M/820M / GT 620M/625M/630M/720M] [10de:1140] (rev a1)
        Subsystem: ASUSTeK Computer Inc. GeForce 820M [1043:16cd]
        Flags: bus master, fast devsel, latency 0, IRQ 46
        Memory at f6000000 (32-bit, non-prefetchable) [size=16M]
        Memory at e0000000 (64-bit, prefetchable) [size=256M]
        Memory at f0000000 (64-bit, prefetchable) [size=32M]
        I/O ports at d000 [size=128]
        Expansion ROM at f7000000 [disabled] [size=512K]
        Capabilities: <access denied>
        Kernel driver in use: nouveau
        Kernel modules: nouveau

[lby@manjaro modules-load.d]$ sudo pacman -Sy lshw
[lby@manjaro modules-load.d]$ sudo lshw -c video
  *-display                 
       description: VGA compatible controller
       product: Haswell-ULT Integrated Graphics Controller
       vendor: Intel Corporation
       physical id: 2
       bus info: pci@0000:00:02.0
       logical name: /dev/fb0
       version: 0b
       width: 64 bits
       clock: 33MHz
       capabilities: msi pm vga_controller bus_master cap_list rom fb
       configuration: depth=32 driver=i915 latency=0 resolution=1366,768
       resources: irq:47 memory:f7400000-f77fffff memory:d0000000-dfffffff ioport:f000(size=64) memory:c0000-dffff
  *-display
       description: 3D controller
       product: GF117M [GeForce 610M/710M/810M/820M / GT 620M/625M/630M/720M]
       vendor: NVIDIA Corporation
       physical id: 0
       bus info: pci@0000:04:00.0
       version: a1
       width: 64 bits
       clock: 33MHz
       capabilities: pm msi pciexpress bus_master cap_list rom
       configuration: driver=nouveau latency=0
       resources: irq:46 memory:f6000000-f6ffffff memory:e0000000-efffffff memory:f0000000-f1ffffff ioport:d000(size=128) memory:f7000000-f707ffff
```

### 驱动程序

```text
[lby@manjaro ~]$ sudo mhwd -li
Warning: No installed PCI configs!
Warning: No installed USB configs!

[lby@manjaro ~]$ sudo pacman -Qs nvidia
local/libvdpau 1.5-2
    Nvidia VDPAU library
local/mhwd-nvidia 550.78-1
    MHWD module-ids for nvidia 550.78
local/mhwd-nvidia-390xx 390.157-10
    MHWD module-ids for nvidia 390.157
local/mhwd-nvidia-470xx 470.239.06-1
    MHWD module-ids for nvidia 470.239.06

[lby@manjaro ~]$ sudo pacman -Qs intel
local/intel-ucode 20240312-1
    Microcode update files for Intel CPUs
local/lib32-libva-intel-driver 2.4.1-1
    VA-API implementation for Intel G45 and HD Graphics family (32-bit)
local/libmfx 23.2.2-3
    Intel Media SDK dispatcher library
local/libva-intel-driver 2.4.1-2
    VA-API implementation for Intel G45 and HD Graphics family
local/libvpl 2.11.0-1
    Intel Video Processing Library
```


### 其他信息

```text
[lby@manjaro ~]$ sudo dmesg|grep -i nvidia
[    2.512621] nouveau 0000:04:00.0: NVIDIA GF117 (0d7000a2)


[lby@manjaro modules-load.d]$ lsmod | grep -i nvidia
[lby@manjaro modules-load.d]$ lsmod | grep -i nouveau
nouveau              3665920  2
drm_ttm_helper         12288  1 nouveau
gpu_sched              69632  1 nouveau
drm_gpuvm              45056  1 nouveau
drm_exec               12288  2 drm_gpuvm,nouveau
i2c_algo_bit           20480  2 i915,nouveau
mxm_wmi                12288  1 nouveau
ttm                   110592  3 drm_ttm_helper,i915,nouveau
drm_display_helper    274432  2 i915,nouveau
video                  77824  4 asus_wmi,asus_nb_wmi,i915,nouveau
wmi                    36864  4 video,asus_wmi,mxm_wmi,nouveau
```

## 更换软件源

```bash
# 国内软件源
sudo pacman-mirrors -c China -m rank
# 同步软件库
sudo pacman -Syy
# 更新系统
yes|sudo pacman -Syyu
```

### 加入archlinuxcn源
```bash
sudo bash -c 'cat >> /etc/pacman.conf << EOF

[archlinuxcn]
Server = https://mirrors.cernet.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.aliyun.com/archlinuxcn/\$arch
Server = https://mirrors.bfsu.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.sjtug.sjtu.edu.cn/manjaro/stable/\$repo/\$arch
Server = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch
Server = http://repo.archlinuxcn.org/\$arch
Server = https://repo.huaweicloud.com/archlinuxcn/\$arch
EOF'

# 本地信任 farseerfc 的 GPG key
sudo pacman-key --lsign-key "farseerfc@archlinux.org"

#导入archlinuxcn GPG key，让archlinuxcn软件源可以正常使用。
sudo pacman -Sy archlinuxcn-keyring
```

添加archlinuxcn源之后安装archlinuxcn-keyring失败
PS: 
https://help.mirrors.cernet.edu.cn/archlinuxcn/
https://www.cnblogs.com/kfw5264/p/17893266.html

## 安装开发工具包
```bash
yes|sudo pacman -Sy base-devel
```

## 安装输入法

### 安装fctix

```bash
yes|sudo pacman -Sy fcitx fcitx-configtool fcitx-googlepinyin

#KDE 的桌面环境可选安装, 让配置界面更好看
yes|sudo pacman -Sy kcm-fcitx

# 安装一个简洁的皮肤，然后在配置中启用
yes|sudo pacman -Sy fcitx-skin-material

#KDE 添加环境配置
sudo bash -c 'cat >> /etc/environment <<EOF

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
EOF'
```

### 安装fctix5
```bash
yes|sudo pacman -Sy fcitx5                   #基础包组
yes|sudo pacman -Sy fcitx5-configtool        #图形配置工具

yes|sudo pacman -Sy fcitx5-material-color    #类似微软拼音主题
yes|sudo pacman -Sy fcitx5-breeze            #KDE Breeze风格主题
yes|sudo pacman -Sy fcitx5-nord              #北方色彩主题

yes|sudo pacman -Sy fcitx5-chinese-addons    #包含与中文相关的插件，例如拼音、双拼和五笔。
yes|sudo pacman -Sy fcitx5-qt                #对于Qt程序的输入模块
yes|sudo pacman -Sy fcitx5-lua               #对于Lua程序的输入模块
yes|sudo pacman -Sy fcitx5-gtk               #gtk输入模块和基于glib的dbus客户端库
yes|sudo pacman -Sy fcitx5-pinyin-zhwiki     #来至中文维基百科的拼音词库，适用于 拼音输入法

yes|sudo pacman -Sy fcitx5-table-other       #一些更奇怪的码表支持，包括 Latex, Emoji, 以及一大堆不明字符等等。
#yes|sudo pacman -Sy fcitx5-table-extra       #额外码表支持，包括仓颉 3, 仓颉 5, 粤拼, 速成, 五笔, 郑码等等。


# KDE 添加环境配置
sudo bash -c 'cat >> /etc/environment <<EOF

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
EOF'

# Emoji 的字体
yes|sudo pacman -Sy noto-fonts-emoji

#然后前往 Fcitx5设置 -> 配置附加组件 -> 经典用户界面 -> 主题 设置主题。

# aur 手动安装搜狗输入法
git clone https://aur.archlinux.org/fcitx5-sogou.git
cd 
makepkg -si

#安装aur源的新版sogou输入法
yay -S fcitx5-sogou
```

### fcitx5软件包说明：
```
fcitx5                    #下一代fcitx
fcitx5-configtool         #图形界面的配置工具

主题:
fcitx5-breeze             #KDE Breeze风格主题
fcitx5-material-color     #类似微软拼音主题
fcitx5-nord               #北方色彩主题

输入法模块：
fcitx5-qt                 #对于Qt程序的输入模块
fcitx5-lua                #对于Lua程序的输入模块
fcitx5-gtk                #gtk输入模块和基于glib的dbus客户端库


中文：
fcitx5-chinese-addons     #包含与中文相关的插件，例如拼音、双拼和五笔。
fcitx5-chewing            #繁体中文注音输入法
fcitx5-rime               #中州韵-中文输入法引擎
fcitx5-pinyin-zhwiki      #来至中文维基百科的拼音词库，适用于 拼音输入法

日文：
fcitx5-anthy              #日文输入引擎
fcitx5-kkc                #基于libkkc包 的日文假名与汉字输入引擎
fcitx5-mozc               #Google 日文输入法的开源版
fcitx5-skk                #基于libskk包的日文假名与汉字输入引擎

越南语：
fcitx5-bamboo             #越南语输入法
fcitx5-unikey             #越南语输入法

其他语言：
fcitx5-hangul             #韩文输入引擎支持
fcitx5-sayura             #僧伽罗语输入
fcitx5-libthai            #泰语

其他：
fcitx5-m17n               #多国语言码表输入引擎。
fcitx5-table-extra        #额外码表支持，包括仓颉 3, 仓颉 5, 粤拼, 速成, 五笔, 郑码等等。
fcitx5-table-other        #一些更奇怪的码表支持，包括 Latex, Emoji, 以及一大堆不明字符等等。
```

## 日常软件安装
```bash
# 安装vim
yes|sudo pacman -S vim

sudo bash -c 'cat > /etc/profile.d/alias.sh <<EOF
alias vi="$(which vim)"

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
EOF'

source /etc/profile


# 安装yay
# PS: https://zhuanlan.zhihu.com/p/462061314
yes|sudo pacman -S yay


# 安装上传下载工具
sudo pacman -Sy lszrz

cat > ~/tmp <<EOF
alias rb="$(which lrzsz-rb)"
alias rx="$(which lrzsz-rx)"
alias rz="$(which lrzsz-rz)"
alias sb="$(which lrzsz-sb)"
alias sx="$(which lrzsz-sx)"
alias sz="$(which lrzsz-sz)"
EOF
cat /etc/profile.d/alias.sh >> ~/tmp && sudo mv ~/tmp /etc/profile.d/alias.sh


# 安装字体
yes|sudo pacman -Sy ttf-dejavu wqy-zenhei wqy-microhei ttf-monaco

#强大好用的备份、回滚系统工具
yes|sudo pacman -Sy timeshift

# 安装谷歌的浏览器
yes|yay -Sy google-chrome

# 基于Chromium内核的浏览器
yes|sudo pacman -Sy vivaldi

# 微信
yay -S wechat-uos

# 迅雷
yay -S xunlei-bin

# 安装图形化的解压软件
yes|sudo pacman -Sy p7zip file-roller unrar

# 安装gnome磁盘管理
yes|sudo pacman -Sy gnome-disk-utility

# gedit编辑器
# 该编辑器兼容 UTF-8 编码，同时支持语法高亮
yes|sudo pacman -Sy gedit

# 网易云音乐
yes|yay -S netease-cloud-music

# Audacity：音频处理软件
# 如果你听说过Cool Edit Pro的话，功能跟它差不多。
yes|yay -Sy audacity

# OBS Studio：免费开源的录屏/直播软件，兼容Bilibili等直播平台。
yes|yay -Sy obs-studio

# WPS
yes|yay -S wps-office-cn wps-office-mime-cn wps-office-mui-zh-cn

# 安装字体
yay -S wps-office-fonts ttf-ms-fonts ttf-wps-fonts

# aur方式安装ttf-wps-fonts
yes|sudo pacman -Sy git
git clone https://aur.archlinux.org/ttf-wps-fonts.git
cd ttf-wps-fonts
yes|makepkg -si
cd ~
rm -rf ttf-wps-fonts

# flameshot火焰截图
yes|yay -Sy flameshot

# git
yes|sudo pacman -Sy git

git config --global user.name "github昵称"
git config --global user.email "注册邮箱"

#一个Git客户端。archlinux/manjaro的主源里就有它。
yes|yay -Sy smartgit

## 屏幕分辨率配置工具
yes|sudo pacman -Sy xorg-xrandr

## 远程win电脑, 使用Remmina
yes|sudo pacman -S remmina freerdp

## 远程控制 xrdp / VNC
yes|sudo pacman -Sy xrdp
sudo systemctl enable xrdp
sudo systemctl start xrdp
sudo systemctl status xrdp
```

## 开启ssh

```bash
sudo sed -i 's|^#PermitRootLogin prohibit-password|PermitRootLogin yes|' /etc/ssh/sshd_config
sudo sed -i 's|^#PubkeyAuthentication|PubkeyAuthentication|' /etc/ssh/sshd_config
sudo systemctl enable sshd
sudo systemctl start sshd
```

## 挂载第二个磁盘

```bash
yes|sudo pacman -Sy ntfs-3g

sdb_uuid="$(lsblk -f|grep sdb1|awk '{print $4}')"
if lsblk|grep sdb1 > /dev/null ; then
    if ! grep -F "$sdb_uuid" /etc/fstab >/dev/null ; then
        sudo bash -c "cat >> /etc/fstab <<EOF
# 挂载第二个磁盘,lsblk -f 查看UUID
UUID=$sdb_uuid    /mnt/ntfs      ntfs-3g defaults,noatime 0 0

EOF"
    fi
fi

sudo mkdir -p /mnt/ntfs
sudo mount -a

systemctl daemon-reload
```


## 修改home目录
```bash
mkdir -p /mnt/ntfs/lby

for dir in ~/*; do
    if [ -d "$dir" ]; then
        dirname="`basename $dir`"
        cp -rp $dir "/mnt/ntfs/lby/$dirnmae"
        rm -rf $dir
        ln -sf "/mnt/ntfs/lby/$dirname" $dir
    fi
done
```


## 添加window启动项
```bash
if ! grep -F '/EFI/Microsoft/Boot/bootmgfw.efi' /etc/grub.d/40_custom >/dev/null ; then
    ms_uuid="$(lsblk -f|grep sda1|grep ntfs|awk '{print $3}')"
    sudo bash -c "cat >> /etc/grub.d/40_custom <<EOF

menuentry '启动微软 Windows 10' {
    insmod part_msdos
    insmod chain
    insmod ntfs
    set root=\"(hd0,msdos1)\"
    search --no-floppy --fs-uuid --set=root $ms_uuid 
    chainloader /EFI/Microsoft/Boot/bootmgfw.efi
}
EOF"

    sudo sed -i 's|GRUB_TIMEOUT_STYLE=hidden|GRUB_TIMEOUT_STYLE=menu|' /etc/default/grub
    sudo update-grub
fi
```

## 开启fstrim.timer
若是固态硬盘，可以启用 fstrim来延长 SSD 驱动器的寿命
```bash
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer
sudo systemctl status fstrim.timer

# 查看是否有fstrim.service计时任务
sudo systemctl list-timers --all 
```

## 安装网卡驱动

```bash
sudo mhwd -f -i pci network-broadcom-wl
```


## 其他配置
- 调整桌面主题
- 电源管理配置
- 触发角
- 面板添加小挂件
- 默认程序修改
- 调整软件中心配置
- 安装可用语言包
- 设置时间于日期
- 配置浏览器


---


## 安装显卡驱动

### 当前环境

```text
[lby@manjaro ~]$ inxi -bG
System:
  Host: manjaro Kernel: 6.9.0-1-MANJARO arch: x86_64 bits: 64
  Console: pty pts/1 Distro: Manjaro Linux
Machine:
  Type: Laptop System: ASUSTeK product: X555LD v: 1.0 serial: <superuser required>
  Mobo: ASUSTeK model: X555LD v: 1.0 serial: <superuser required> UEFI: American Megatrends
    v: X555LD.310 date: 08/14/2014
Battery:
  ID-1: BAT0 charge: 24.6 Wh (98.0%) condition: 25.1/37.3 Wh (67.3%) volts: 7.5 min: 7.5
CPU:
  Info: dual core Intel Core i5-4210U [MT MCP] speed (MHz): avg: 798 min/max: 800/2700
Graphics:
  Device-1: Intel Haswell-ULT Integrated Graphics driver: i915 v: kernel
  Device-2: NVIDIA GF117M [GeForce 610M/710M/810M/820M / GT 620M/625M/630M/720M] driver: nouveau
    v: kernel
  Device-3: Realtek USB Camera driver: uvcvideo type: USB
  Display: server: X.org v: 1.21.1.13 with: Xwayland v: 23.2.6 driver: X: loaded: modesetting
    dri: crocus,nouveau gpu: i915 tty: 121x45 resolution: 1366x768
  API: EGL v: 1.5 drivers: crocus,nouveau,swrast platforms: surfaceless,device
  API: OpenGL v: 4.6 compat-v: 4.3 vendor: mesa v: 24.0.6-manjaro1.1 note: console (EGL sourced)
    renderer: Mesa Intel HD Graphics 4400 (HSW GT2), NVD7, llvmpipe (LLVM 17.0.6 256 bits)
  API: Vulkan Message: No Vulkan data available.
Network:
  Device-1: Realtek RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet driver: r8169
  Device-2: Broadcom BCM43142 802.11b/g/n driver: wl
Drives:
  Local Storage: total: 718.67 GiB used: 58.98 GiB (8.2%)
Info:
  Memory: total: 12 GiB note: est. available: 11.14 GiB used: 2.25 GiB (20.2%)
  Processes: 188 Uptime: 57m Init: systemd Shell: Bash inxi: 3.3.34


[lby@manjaro ~]$ sudo lshw -c video
  *-display                 
       description: VGA compatible controller
       product: Haswell-ULT Integrated Graphics Controller
       vendor: Intel Corporation
       physical id: 2
       bus info: pci@0000:00:02.0
       logical name: /dev/fb0
       version: 0b
       width: 64 bits
       clock: 33MHz
       capabilities: msi pm vga_controller bus_master cap_list rom fb
       configuration: depth=32 driver=i915 latency=0 resolution=1366,768
       resources: irq:47 memory:f7400000-f77fffff memory:d0000000-dfffffff ioport:f000(size=64) memory:c0000-dffff
  *-display
       description: 3D controller
       product: GF117M [GeForce 610M/710M/810M/820M / GT 620M/625M/630M/720M]
       vendor: NVIDIA Corporation
       physical id: 0
       bus info: pci@0000:04:00.0
       version: a1
       width: 64 bits
       clock: 33MHz
       capabilities: pm msi pciexpress bus_master cap_list rom
       configuration: driver=nouveau latency=0
       resources: irq:46 memory:f6000000-f6ffffff memory:e0000000-efffffff memory:f0000000-f1ffffff ioport:d000(size=128) memory:f7000000-f707ffff

[lby@manjaro ~]$ lspci -vnn
00:02.0 VGA compatible controller [0300]: Intel Corporation Haswell-ULT Integrated Graphics Controller [8086:0a16] (rev 0b) (prog-if 00 [VGA controller])
        Subsystem: ASUSTeK Computer Inc. Device [1043:16cd]
        Flags: bus master, fast devsel, latency 0, IRQ 47
        Memory at f7400000 (64-bit, non-prefetchable) [size=4M]
        Memory at d0000000 (64-bit, prefetchable) [size=256M]
        I/O ports at f000 [size=64]
        Expansion ROM at 000c0000 [virtual] [disabled] [size=128K]
        Capabilities: <access denied>
        Kernel driver in use: i915
        Kernel modules: i915
04:00.0 3D controller [0302]: NVIDIA Corporation GF117M [GeForce 610M/710M/810M/820M / GT 620M/625M/630M/720M] [10de:1140] (rev a1)
        Subsystem: ASUSTeK Computer Inc. GeForce 820M [1043:16cd]
        Flags: bus master, fast devsel, latency 0, IRQ 46
        Memory at f6000000 (32-bit, non-prefetchable) [size=16M]
        Memory at e0000000 (64-bit, prefetchable) [size=256M]
        Memory at f0000000 (64-bit, prefetchable) [size=32M]
        I/O ports at d000 [size=128]
        Expansion ROM at f7000000 [disabled] [size=512K]
        Capabilities: <access denied>
        Kernel driver in use: nouveau
        Kernel modules: nouveau

[lby@manjaro ~]$ sudo mhwd -li
> Installed PCI configs:
--------------------------------------------------------------------------------
                  NAME               VERSION          FREEDRIVER           TYPE
--------------------------------------------------------------------------------
   network-broadcom-wl            2018.10.07               false            PCI


Warning: No installed USB configs!

[lby@manjaro ~]$ sudo pacman -Qs intel
local/intel-ucode 20240312-1
    Microcode update files for Intel CPUs
local/lib32-libva-intel-driver 2.4.1-1
    VA-API implementation for Intel G45 and HD Graphics family (32-bit)
local/libmfx 23.2.2-3
    Intel Media SDK dispatcher library
local/libva-intel-driver 2.4.1-2
    VA-API implementation for Intel G45 and HD Graphics family
local/libvpl 2.11.0-1
    Intel Video Processing Library


[lby@manjaro ~]$ sudo pacman -Qs nvidia
local/libvdpau 1.5-2
    Nvidia VDPAU library
local/mhwd-nvidia 550.78-1
    MHWD module-ids for nvidia 550.78
local/mhwd-nvidia-390xx 390.157-10
    MHWD module-ids for nvidia 390.157
local/mhwd-nvidia-470xx 470.239.06-1
    MHWD module-ids for nvidia 470.239.06


[lby@manjaro ~]$ sudo dmesg|grep -i nvidia
[    2.509544] nouveau 0000:04:00.0: NVIDIA GF117 (0d7000a2)

[lby@manjaro ~]$ lsmod|grep -i nvidia
[lby@manjaro ~]$ 
[lby@manjaro ~]$ lsmod|grep -i nouveau
nouveau              3665920  2
drm_ttm_helper         12288  1 nouveau
gpu_sched              69632  1 nouveau
drm_gpuvm              45056  1 nouveau
drm_exec               12288  2 drm_gpuvm,nouveau
mxm_wmi                12288  1 nouveau
i2c_algo_bit           20480  2 i915,nouveau
ttm                   110592  3 drm_ttm_helper,i915,nouveau
drm_display_helper    274432  2 i915,nouveau
video                  77824  4 asus_wmi,asus_nb_wmi,i915,nouveau
wmi                    36864  4 video,asus_wmi,mxm_wmi,nouveau
```

### 判断显卡型号
```bash
[lby@manjaro ~]$ lspci -k | grep -A 2 -E "(VGA|3D)"
00:02.0 VGA compatible controller: Intel Corporation Haswell-ULT Integrated Graphics Controller (rev 0b)
        Subsystem: ASUSTeK Computer Inc. Device 16cd
        Kernel driver in use: i915
--
04:00.0 3D controller: NVIDIA Corporation GF117M [GeForce 610M/710M/810M/820M / GT 620M/625M/630M/720M] (rev a1)
        Subsystem: ASUSTeK Computer Inc. GeForce 820M
        Kernel driver in use: nvidia

[lby@manjaro ~]$ lspci -vnn|grep 820M
04:00.0 3D controller [0302]: NVIDIA Corporation GF117M [GeForce 610M/710M/810M/820M / GT 620M/625M/630M/720M] [10de:1140] (rev a1)
        Subsystem: ASUSTeK Computer Inc. GeForce 820M [1043:16cd]
```

得知显卡型号是 NVIDIA Corporation GF117M ，GeForce 820M 型号。

前往[英伟达代号查询页](https://www.nvidia.com/en-us/drivers/unix/legacy-gpu/), 匹配到 GeForce 820M 的对应记录：

| Code name | Official Name |
|:-------:|:-------:|
| NVD7 (GF117) | Geforce GT 620M, 625M, (some) 630M, 710M, 720M |


前往[英伟达历史型号列表页](https://www.nvidia.com/en-us/drivers/unix/legacy-gpu/), 匹配到 GeForce 820M 的对应记录：

|NVIDIA GPU product | Device PCI ID | Subdevice PCI ID |
|:-------:|:--------:|:-------:|
|    GeForce 820M   |      1140     |    1043 16CD     |

根据 [archwiki](https://wiki.archlinuxcn.org/wiki/NVIDIA) 中的说明， NVDx 系的网卡对应的安装包为 nvidia-390xx
根据 [Unix 传统驱动程序](https://www.nvidia.cn/drivers/unix/) 官网的内容佐证了仅有 [传统GPU超级新版本(390.xx 系列): 390.157](https://www.nvidia.cn/Download/driverResults.aspx/196221/cn/) 支持该显卡类型

***请注意，这里不选择手动编译安装***
根据 [NVIDIA 驱动程序下载](https://www.nvidia.cn/Download/index.aspx?lang=cn) 筛选，手动安装脚本可选最新支持驱动为：[版本: 430.40](https://www.nvidia.cn/download/driverResults.aspx/149314/cn/)



### Pacman 钩子
为了避免更新 NVIDIA 驱动之后忘了更新 initramfs
```bash
sudo mkdir -p /etc/pacman.d/hooks/

sudo bash -c 'cat >> /etc/pacman.d/hooks/nvidia.hook <<EOF
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia-390xx

[Action]
Description=Update Nvidia module in initcpio
Depends=mkinitcpio
When=PostTransaction
Exec=/usr/bin/mkinitcpio -P
EOF'
```

### 安装video-nvidia-390xx显卡驱动

#### 方案1：

```
# 启用处理电源相关事件的守护进程，NVIDIA X驱动程序将尝试使用它来接收ACPI事件通知
sudo systemctl enable acpid
sudo systemctl restart acpid

# 安装驱动
sudo mhwd -f -i pci video-nvidia-390xx

sudo bash -c 'cat >> /etc/modprobe.d/mhwd-gpu.conf <<EOF

#解决英伟达显卡驱动画面撕裂的问题
options nvidia_drm modeset=1
EOF'

# 把上面配置的内核参数写入到内核镜像
sudo mkinitcpio -P

#这个时候不要重启系统，屏幕会无法点亮

# 安装切换显卡脚本
# 切换至intel并没有禁用nvidia显卡，所以切换后无需重启，实际只重启了窗口管理器sddm
git clone https://gitee.com/phpdragon/optimus-switch-sddm.git
cd optimus-switch-sddm
git switch ASUS-W519L && git pull
sudo sh ./install.sh

#sudo set-intel.sh
sudo set-nvidia.sh
# 卸载脚本
#sudo sh /etc/switch/switch-uninstall.sh


# 重启系统以生效配置
sudo reboot

# 验证是否安装成功，显示Kernel driver in use: nvidia 表明安装成功
lspci -k | grep -A 2 -E "(VGA|3D)"

#查看nouveau模块，没有输出表明禁用成功
lsmod|grep -i nouveau
#查看nvidia模块，有输出表明安装成功
lsmod|grep -i nvidia

# 查看nvidia_drm模块的配置信息是否起效
modprobe -c | grep -i nvidia_drm|grep 'options'
```

#### 方案2：
```
# 启用处理电源相关事件的守护进程，NVIDIA X驱动程序将尝试使用它来接收ACPI事件通知
sudo systemctl enable acpid
sudo systemctl restart acpid

sudo mhwd -f -i pci video-nvidia-390xx

sudo bash -c 'cat > /etc/modprobe.d/nvidia-gpu.conf <<EOF
#解决英伟达显卡驱动画面撕裂的问题
options nvidia_drm modeset=1
EOF'

# 将新驱动写入initramfs(临时文件系统)文件
sudo mkinitcpio -P

# 安装必要依赖库， linux69-headers 根据当前内核版本修改
sudo pacman -S linux69-headers acpi_call-dkms xorg-xrandr

# 加载内核模块
sudo modprobe acpi_call

#这个时候不要重启系统，屏幕会无法点亮，请删除mhwd自动生成的X11配置文件
sudo unlink /etc/X11/xorg.conf.d/90-mhwd.conf

# 拉取双显卡切换脚本
git clone https://gitee.com/phpdragon/optimus-switch-sddm.git
cd optimus-switch-sddm
# 安装双显卡切换脚本
sudo sh ./install.sh

# 切换显卡使用模式， 每次切换后要重启系统
#sudo set-intel.sh
sudo set-nvidia.sh

# 重启系统
sudo reboot
```

#### 查看安装后的信息
```
# 验证是否安装成功，显示Kernel driver in use: nvidia 表明安装成功
lspci -k | grep -A 2 -E "(VGA|3D)"

#查看nouveau模块，没有输出表明禁用成功
lsmod|grep -i nouveau
#查看nvidia模块，有输出表明安装成功
lsmod|grep -i nvidia

# 查看nvidia_drm模块的配置信息是否起效
modprobe -c | grep -i nvidia_drm|grep 'options'
```

其他信息
```bash
[lby@manjaro ~]$ inxi -bG
System:
  Host: manjaro Kernel: 6.9.0-1-MANJARO arch: x86_64 bits: 64
  Console: pty pts/1 Distro: Manjaro Linux
Machine:
  Type: Laptop System: ASUSTeK product: X555LD v: 1.0 serial: <superuser required>
  Mobo: ASUSTeK model: X555LD v: 1.0 serial: <superuser required> UEFI: American Megatrends
    v: X555LD.310 date: 08/14/2014
Battery:
  ID-1: BAT0 charge: 25.2 Wh (100.0%) condition: 25.2/37.3 Wh (67.7%) volts: 7.5 min: 7.5
CPU:
  Info: dual core Intel Core i5-4210U [MT MCP] speed (MHz): avg: 2369 min/max: 800/2700
Graphics:
  Device-1: Intel Haswell-ULT Integrated Graphics driver: i915 v: kernel
  Device-2: NVIDIA GF117M [GeForce 610M/710M/810M/820M / GT 620M/625M/630M/720M] driver: nvidia
    v: 390.157
  Device-3: Realtek USB Camera driver: uvcvideo type: USB
  Display: server: X.org v: 1.21.1.13 with: Xwayland v: 23.2.6 driver: X: loaded: modesetting
    dri: crocus gpu: i915 tty: 126x43 resolution: 1366x768
  API: EGL v: 1.5 drivers: crocus,kms_swrast platforms: gbm,surfaceless
  API: OpenGL v: 4.6 compat-v: 4.5 vendor: mesa v: 24.0.6-manjaro1.1 note: console (EGL sourced)
    renderer: llvmpipe (LLVM 17.0.6 256 bits), Mesa Intel HD Graphics 4400 (HSW GT2)
  API: Vulkan Message: No Vulkan data available.
Network:
  Device-1: Realtek RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet driver: r8169
  Device-2: Broadcom BCM43142 802.11b/g/n driver: wl
Drives:
  Local Storage: total: 704.24 GiB used: 44.79 GiB (6.4%)
Info:
  Memory: total: 12 GiB note: est. available: 11.14 GiB used: 1.16 GiB (10.4%)
  Processes: 187 Uptime: 6m Init: systemd Shell: Bash inxi: 3.3.34


[lby@manjaro ~]$ sudo lshw -c video
  *-display                 
       description: VGA compatible controller
       product: Haswell-ULT Integrated Graphics Controller
       vendor: Intel Corporation
       physical id: 2
       bus info: pci@0000:00:02.0
       logical name: /dev/fb0
       version: 0b
       width: 64 bits
       clock: 33MHz
       capabilities: msi pm vga_controller bus_master cap_list rom fb
       configuration: depth=32 driver=i915 latency=0 resolution=1366,768
       resources: irq:46 memory:f7400000-f77fffff memory:d0000000-dfffffff ioport:f000(size=64) memory:c0000-dffff
  *-display
       description: 3D controller
       product: GF117M [GeForce 610M/710M/810M/820M / GT 620M/625M/630M/720M]
       vendor: NVIDIA Corporation
       physical id: 0
       bus info: pci@0000:04:00.0
       version: a1
       width: 64 bits
       clock: 33MHz
       capabilities: pm msi pciexpress bus_master cap_list rom
       configuration: driver=nvidia latency=0
       resources: irq:49 memory:f6000000-f6ffffff memory:e0000000-efffffff memory:f0000000-f1ffffff ioport:d000(size=128) memory:f7000000-f707ffff

[lby@manjaro ~]$ lspci -k | grep -A 2 -E "(VGA|3D)"
00:02.0 VGA compatible controller: Intel Corporation Haswell-ULT Integrated Graphics Controller (rev 0b)
        Subsystem: ASUSTeK Computer Inc. Device 16cd
        Kernel driver in use: i915
--
04:00.0 3D controller: NVIDIA Corporation GF117M [GeForce 610M/710M/810M/820M / GT 620M/625M/630M/720M] (rev a1)
        Subsystem: ASUSTeK Computer Inc. GeForce 820M
        Kernel driver in use: nvidia


[lby@manjaro ~]$ sudo mhwd -li --pci
> Installed PCI configs:
--------------------------------------------------------------------------------
                  NAME               VERSION          FREEDRIVER           TYPE
--------------------------------------------------------------------------------
    video-nvidia-390xx            2023.03.23               false            PCI
   network-broadcom-wl            2018.10.07               false            PCI


[lby@manjaro ~]$ pacman -Qs intel
local/intel-ucode 20240312-1
    Microcode update files for Intel CPUs
local/lib32-libva-intel-driver 2.4.1-1
    VA-API implementation for Intel G45 and HD Graphics family (32-bit)
local/libmfx 23.2.2-3
    Intel Media SDK dispatcher library
local/libva-intel-driver 2.4.1-2
    VA-API implementation for Intel G45 and HD Graphics family
local/libvpl 2.11.0-1
    Intel Video Processing Library


[lby@manjaro ~]$ pacman -Qs nvidia
local/egl-wayland 2:1.1.13-1
    EGLStream-based Wayland external platform
local/lib32-nvidia-390xx-utils 390.157-4
    NVIDIA drivers utilities (32-bit)
local/libvdpau 1.5-2
    Nvidia VDPAU library
local/libxnvctrl-390xx 390.157-4
    NVIDIA NV-CONTROL X extension
local/linux69-nvidia-390xx 390.157-1 (linux69-extramodules)
    NVIDIA drivers for linux
local/mhwd-nvidia 550.78-1
    MHWD module-ids for nvidia 550.78
local/mhwd-nvidia-390xx 390.157-10
    MHWD module-ids for nvidia 390.157
local/mhwd-nvidia-470xx 470.239.06-1
    MHWD module-ids for nvidia 470.239.06
local/nvidia-390xx-settings 390.157-4
    Tool for configuring the NVIDIA graphics driver
local/nvidia-390xx-utils 390.157-10
    NVIDIA drivers utilities


[lby@manjaro ~]$ lsmod|grep -i nouveau
[lby@manjaro ~]$ 
[lby@manjaro ~]$ lsmod|grep -i nvidia
nvidia_uvm           2048000  0
nvidia_drm             65536  1
nvidia_modeset       1339392  1 nvidia_drm
nvidia              19795968  35 nvidia_uvm,nvidia_modeset
ipmi_msghandler        94208  2 ipmi_devintf,nvidia
video                  77824  4 nvidia,asus_wmi,asus_nb_wmi,i915
```

#### 几个有效的X11配置文件，可以用于切换显卡

/etc/X11/xorg.conf.d/90-mhwd.conf 文件内容：

独显模式：

配置1
```text
Section "Files"
        ModulePath "/usr/lib/nvidia"
        ModulePath "/usr/lib32/nvidia"
        ModulePath "/usr/lib32/nvidia/xorg/modules"
        ModulePath "/usr/lib32/xorg/modules"
        ModulePath "/usr/lib64/nvidia/xorg/modules"
        ModulePath "/usr/lib64/nvidia/xorg"
        ModulePath "/usr/lib64/xorg/modules"
EndSection

Section "ServerLayout"
        Identifier "layout"
        Screen 0 "nvidia"
        Inactive "integrated"
EndSection

Section "Device"
        Identifier "nvidia"
        Driver "nvidia"
        BusID "PCI:4:0:0"
        Option "Coolbits" "28"
EndSection

Section "Screen"
        Identifier "nvidia"
        Device "nvidia"
        Option "AllowEmptyInitialConfiguration"
EndSection

Section "Device"
        Identifier "integrated"
        Driver "modesetting"
        BusID "PCI:0:2:0"
EndSection

Section "Screen"
        Identifier "integrated"
        Device "integrated"
EndSection
```


配置2：
```text
#adjust BusID to match your nvidia GPU
#uncomment and edit the DPI option as needed
#to fix scaling issues.

Section "Module"
    Load "modesetting"
EndSection

Section "Device"
    Identifier "nvidia"
    Driver  "nvidia"
    BusID   "PCI:4:0:0"
    #Option  "DPI" "96 x 96"    #adjust this value as needed to fix scaling
    Option  "AllowEmptyInitialConfiguration"
EndSection

Section "Extensions"
    Option  "Composite" "Enable"
EndSection
```


配置3：
```text
Section "ServerLayout"
        Identifier     "X.org Configured"
        #开启英伟达
        Screen      0  "Screen0" 0 0
        #屏蔽因特尔
        #Screen      0   "Screen1" 0 0
        InputDevice    "Mouse0" "CorePointer"
        InputDevice    "Keyboard0" "CoreKeyboard"
EndSection

Section "Files"
        ModulePath   "/usr/lib/nvidia/xorg"
        ModulePath   "/usr/lib64/nvidia/xorg/modules"
        ModulePath   "/usr/lib64/nvidia/xorg"
        ModulePath   "/usr/lib32/nvidia/xorg/modules"
        ModulePath   "/usr/lib32/nvidia/xorg"
        ModulePath   "/usr/lib64/xorg/modules"
        ModulePath   "/usr/lib32/xorg/modules"
        FontPath     "/usr/share/fonts/misc"
        FontPath     "/usr/share/fonts/TTF"
        FontPath     "/usr/share/fonts/OTF"
        FontPath     "/usr/share/fonts/Type1"
        FontPath     "/usr/share/fonts/100dpi"
        FontPath     "/usr/share/fonts/75dpi"
EndSection

Section "Module"
        Load  "glx"
EndSection

Section "InputDevice"
        Identifier  "Keyboard0"
        Driver      "kbd"
EndSection

Section "InputDevice"
        Identifier  "Mouse0"
        Driver      "mouse"
        Option      "Protocol" "auto"
        Option      "Device" "/dev/input/mice"
        Option      "ZAxisMapping" "4 5 6 7"
EndSection

Section "Monitor"
        Identifier   "Monitor0"
        VendorName   "Monitor Vendor"
        ModelName    "Monitor Model"
EndSection

Section "Monitor"
        Identifier   "Monitor1"
        VendorName   "Monitor Vendor"
        ModelName    "Monitor Model"
EndSection

Section "Device"
        Identifier  "Card0"
        Driver      "nvidia"
        BusID       "PCI:4:0:0"
EndSection

Section "Device"
        Identifier  "Card1"
        Driver      "modesetting"
        BusID       "PCI:0:2:0"
EndSection

Section "Screen"
        Identifier "Screen0"
        Device     "Card0"
        Monitor    "Monitor0"
        SubSection "Display"
                Virtual 1366 768
                Viewport   0 0
                Depth     24
        EndSubSection
EndSection

Section "Screen"
        Identifier "Screen1"
        Device     "Card1"
        Monitor    "Monitor1"
        SubSection "Display"
                Virtual 1366 768
                Viewport   0 0
                Depth     24
        EndSubSection
EndSection
```


混合模式：
```

Section "Files"
        ModulePath "/usr/lib/nvidia"
        ModulePath "/usr/lib32/nvidia"
        ModulePath "/usr/lib32/nvidia/xorg/modules"
        ModulePath "/usr/lib32/xorg/modules"
        ModulePath "/usr/lib64/nvidia/xorg/modules"
        ModulePath "/usr/lib64/nvidia/xorg"
        ModulePath "/usr/lib64/xorg/modules"
EndSection

Section "ServerLayout"
        Identifier "layout"
        Screen 0 "integrated"
        Inactive "nvidia"
        Option "AllowNVIDIAGPUScreens"
EndSection

Section "Device"
        Identifier "integrated"
        Driver "modesetting"
        BusID "PCI:0:2:0"
        Option "DRI" "3"
EndSection

Section "Screen"
        Identifier "integrated"
        Device "integrated"
EndSection

Section "Device"
        Identifier "nvidia"
        Driver "nvidia"
        BusID "PCI:4:0:0"
        Option "Coolbits" "28"
EndSection

Section "Screen"
        Identifier "nvidia"
        Device "nvidia"
EndSection
```


集显模式：
```text
#this is to use the modesetting driver
#for the intel iGPU instead of the intel driver
#
#use lspci to find the BudID of your
#intel iGPU and edit the BusID below to match
#

Section "Device"
        Identifier "integrated"
        Driver "modesetting"
        BusID "PCI:0:2:0"
        Option "DRI" "3"         #如果DRI3性能较差，可以选择# DRI2和DRI1
EndSection
```

#### 配置英伟达显卡并随机启动加载

- 1. 打开英伟达显卡设置界面
- 2. 在“X服务器显示配置”选项卡中更改分辨率和刷新率。
- 3. 点击“Save to X Configuration File”按钮，保存到/etc/X11/mhwd.d/nvidia.conf
- 4. 现在在终端中输入以下命令来完成这个过程: `sudo mhwd-gpu --setmod nvidia --setxorg /etc/X11/mhwd.d/nvidia.conf`
- 5. 配置X屏幕设置(OpenGL 设置, Antialiasing, X Server XVideo)
- 6. 点击“nvidia-settings configuration”选项卡，点击“Save Current configuration”按钮。
- 7. 将.nvidia-settings-rc保存到指定的默认位置(/home/[您的帐户名])
- 8. 用您喜欢的文本编辑器编辑.xinitrc文件。例如，在您的终端中运行以下命令: `gedit ~/.xinitrc`
- 9. 打开后，将以下行添加到配置文件中，在以'exec'开头的最后一行之前: 
```bash
nvidia-settings --load-config-only
exec $(get_session)
```
- 10. 保存并退出。

PS: [配置NVIDIA(非自由)设置并在启动时加载它们](https://wiki.manjaro.org/index.php/Configure_NVIDIA_(non-free)_settings_and_load_them_on_Startup)


# 四、其他


## 进入命令行模式

请按 ctrl+alt+f2  ...f3  ...f4

ps：[如何在基于 Arch 的 Linux 发行版中安装 Google Chrome？](http://www.imangodoc.com/ca7b3edd.html)


## AUR 软件包安装方法

```bash
sudo pacman -S --needed base-devel git

git clone https://aur.archlinux.org/XXX.git
cd XXX
makepkg -si
```

# 五、参考

软件应用参考 [Manjaro从入门到爱不释手](https://link.zhihu.com/?target=https%3A//github.com/orangbus/Tool)
[Manjaro KDE 调教配置及美化（2022.01.23）](https://zhuanlan.zhihu.com/p/460826583)
桌面美化参考 [Manjaro+kde简单配置美化教程](https://www.bilibili.com/read/cv11183026/)
终端美化参考 [manjaro终端美化教程](https://blog.csdn.net/m0_46322376/article/details/105761285)
字体参考 [安装Manjaro之后的配置](https://panqiincs.me/2019/06/05/after-installing-manjaro/#%E4%B8%AD%E6%96%87%E7%8E%AF%E5%A2%83)

# 六、资料
- [Manjaro Linux系统安装配置，一篇小白必看入门指南](https://zhuanlan.zhihu.com/p/462061314)
- [Manjaro（KDE桌面环境）小白向完全安装教程（附Linux简要介绍）](https://www.cnblogs.com/ArrowKeys/p/13844174.html)
- [ArchLinux 简明安装手册](https://zhuanlan.zhihu.com/p/589673546)
- [Archlinux 安装 nvidia 驱动](https://www.wenjiangs.com/article/9z88pxf4nd89.html)
- [Manjaro配置显卡驱动程序](https://zhuanlan.zhihu.com/p/372587633)
- [Hybrid graphics- 完全关闭独立显卡](https://wiki.archlinux.org/title/Hybrid_graphics)
- [英伟达代号查询页](https://nouveau.freedesktop.org/CodeNames.html)
- [英伟达历史型号列表页](https://www.nvidia.com/en-us/drivers/unix/legacy-gpu/)
- [Unix 传统英伟达驱动程序](https://www.nvidia.cn/drivers/unix/)
- [NVIDIA 驱动程序下载](https://www.nvidia.cn/Download/index.aspx?lang=cn)
- [linux 设置分辨率](https://www.cnblogs.com/zhugeanran/p/9408426.html)
- [Fcitx5输入法](https://wiki.archlinuxcn.org/wiki/Fcitx5)
- [Fcitx输入法](https://wiki.archlinuxcn.org/wiki/Fcitx)


# 七、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->asus-w519l-install-manjaro-kde-24.x](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2FBlogDocs%2Ffiles%2Fasus-w519l-install-manjaro-kde-24.x)
