---
title: 小米R3G路由器固件分析
date: 2025-11-20 18:39:43
categories: ['OpenWrt', 'Xiaomi', 'R3G']
tags: ['OpenWrt', 'Xiaomi', 'R3G', 'exploit']
---

```
export STAGING_DIR=/home/phpdragon/OpenWrtSDK/staging_dir
export PATH=$STAGING_DIR/toolchain-mipsel_1004kc+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/bin:$PATH
```

```bash
cat > monitor_hash.c << EOF
#define _GNU_SOURCE
#include <stdio.h>
#include <dlfcn.h>

// EVP_DigestUpdate - 只打印参数，不影响原始调用
int EVP_DigestUpdate(void *ctx, const void *data, size_t len) {
    static int (*real_func)(void*,const void*,size_t) = NULL;
    if (!real_func) real_func = dlsym(RTLD_NEXT, "EVP_DigestUpdate");
    
    printf("HOOK: EVP_DigestUpdate(ctx=%p, data=%p, len=%zu)\n", ctx, data, len);
    
    int result = real_func(ctx, data, len);
    return result;
}

// EVP_VerifyFinal - 打印完整的签名值
int EVP_VerifyFinal(void *ctx, const unsigned char *sig, unsigned int sig_len, void *pkey) {
    static int (*real_func)(void*,const unsigned char*,unsigned int,void*) = NULL;
    if (!real_func) real_func = dlsym(RTLD_NEXT, "EVP_VerifyFinal");
    
    printf("HOOK: EVP_VerifyFinal(ctx=%p, sig_len=%u, pkey=%p)\n", ctx, sig_len, pkey);
    
    // 打印完整的签名值
    if (sig && sig_len > 0) {
        printf("FULL_SIGNATURE (%u bytes): ", sig_len);
        for (unsigned int i = 0; i < sig_len; i++) {
            printf("%02x", sig[i]);
        }
        printf("\n");
    }
    
    int result = real_func(ctx, sig, sig_len, pkey);
    printf("VERIFY_RESULT: %d\n\n", result);
    return result;
}

// EVP_DigestInit_ex - 只打印参数
int EVP_DigestInit_ex(void *ctx, void *type, void *impl) {
    static int (*real_func)(void*,void*,void*) = NULL;
    if (!real_func) real_func = dlsym(RTLD_NEXT, "EVP_DigestInit_ex");
    
    printf("HOOK: EVP_DigestInit_ex(ctx=%p, type=%p, impl=%p)\n", ctx, type, impl);
    
    int result = real_func(ctx, type, impl);
    return result;
}

// EVP_sha1 - 只打印调用
const void *EVP_sha1() {
    static const void *(*real_func)() = NULL;
    if (!real_func) real_func = dlsym(RTLD_NEXT, "EVP_sha1");
    
    printf("HOOK: EVP_sha1() called\n");
    
    const void *result = real_func();
    return result;
}
EOF
```

```
# 编译
mipsel-openwrt-linux-uclibc-gcc monitor_hash.c -o monitor_hash.so -shared -fPIC -ldl -mips32 -mtune=mips32 -msoft-float -Os -s -std=c99

cp monitor_hash.so miwifi_extract_20251201_094901/rootfs_final/bin/

sudo chroot miwifi_extract_20251201_094901/rootfs_final/ \
    /bin/sh -c "LD_PRELOAD=/bin/monitor_hash.so /bin/mkxqimage -v /tmp/firmware.bin" > ./hook.log

# 获得hash计算的累加字节大小，示例输出：24605100
cat hook.log | grep "HOOK: EVP_DigestUpdate" | grep "len=" | awk -F 'len=' '{sum+=$2+0} END {print sum}'

# 获得固件大小，示例输出：24605384
ls -l firmware.bin|awk '{print $5}'
```
通过示例输出：
```bash
# 固件大小 - hash计算的累加字节大小 - 末尾校验区域字节，得出有12字节未参与hash
echo $((24605384 - 24605100 - 272))
```

```
# 提取末尾256字节的加密二进制
dd if="firmware.bin" of="sha1sum-length-256-hash-value.bin" bs=1M skip=24605128 count=256 iflag=skip_bytes,count_bytes

# 使用公钥校验
openssl rsautl -verify -in sha1sum-length-256-hash-value.bin -inkey public.pem -pubin -asn1parse 
The command rsautl was deprecated in version 3.0. Use 'pkeyutl' instead.
    0:d=0  hl=2 l=  33 cons: SEQUENCE          
    2:d=1  hl=2 l=   9 cons:  SEQUENCE          
    4:d=2  hl=2 l=   5 prim:   OBJECT            :sha1
   11:d=2  hl=2 l=   0 prim:   NULL              
   13:d=1  hl=2 l=  20 prim:  OCTET STRING      
      0000 - ad 0d e5 8a 68 03 d7 0a-9e 36 30 fb 3d e6 7e de   ....h....60.=.~.
      0010 - 7c 6e 00 92                                       |n..

# 得到hash =>  ad0de58a6803d70a9e3630fb3de67ede7c6e0092
echo 'ad 0d e5 8a 68 03 d7 0a 9e 36 30 fb 3d e6 7e de 7c 6e 00 92' | tr -d ' ' > hash-value.txt

# 计算固件的hash值, 得到hash => ad0de58a6803d70a9e3630fb3de67ede7c6e0092
dd if="firmware.bin" bs=1M skip=12 count=24605100 iflag=skip_bytes,count_bytes | sha1sum | awk '{print $1}'> hash-value2.txt

# 比对, 应该显示匹配成功
diff hash-value.txt hash-value2.txt && echo '匹配成功！' || echo '匹配失败！'
```

这是校验文件CRC32的值逻辑
```bash
python3 -c '
import binascii

"""
固件CRC32校验工具
功能说明：
1. 读取固件文件firmware.bin
2. 截取12字节后的内容计算CRC32
3. 对计算结果按位取反（保留32位无符号）
4. 读取固件中8-12字节位置存储的CRC值（小端序）
5. 对比计算值与存储值，输出验证结果
"""

# 以二进制模式打开固件文件
with open("firmware.bin", "rb") as f:
    data = f.read()
    
    # 截取需要计算CRC的部分：从第12字节开始到文件末尾（索引12及之后）
    crc_calc_part = data[12:]
    
    # 计算标准CRC32值，与0xFFFFFFFF按位与 确保结果为32位无符号整数
    crc_standard = binascii.crc32(crc_calc_part) & 0xFFFFFFFF
    
    # 对标准CRC32结果按位取反，同样保留32位无符号整数范围
    crc_inverted = ~crc_standard & 0xFFFFFFFF
    
    # 从固件数据中读取预存储的CRC值：
    # 位置：第8-12字节（索引8到11），字节序：小端序（little-endian）
    stored_crc_value = int.from_bytes(data[8:12], "little")
    
    # 输出存储的CRC值（十六进制格式，8位补零）
    print(f"存储的CRC32: 0x{stored_crc_value:08x}")
    
    # 输出计算并取反后的CRC值（十六进制格式，8位补零）
    print(f"计算的CRC32: 0x{crc_inverted:08x}")
    
    # 对比计算值与存储值，判定验证结果
    verify_result = "匹配" if stored_crc_value == crc_inverted else "不匹配"
    
    # 输出最终验证结果
    print(f"→ 最终验证结果: {verify_result}")
'
```


# 总结

固件结构：
1~4  位字节：27 05 19 56 (魔术字HDR1)。
5~8  位字节：固件验签截取大小。
9~12 位字节：固件CRC32值。
13~16位字节：00 0d 00 00 = 0x000D0000 (小端序)  含义: 十进制: 851968     字节。
61~64位字节：ff ff 00 00  转小端序转10进制得到 65535， 感觉是每次读取的大小快。正好是4K块
末尾272字节： 16字节 + 256字节(哈希值私钥加密后的二进制)


字节 0: 00 (填充)
字节 5-8: 15 87 2d ac (头部CRC)
字节 9-12: 5d a9 84 74 (时间戳)
字节 13-16: 00 35 6e a2 ← 这就是镜像大小！ (3,501,730)


提取办法：
- 通过魔术字 xiaoqiang_version 找到偏移量 V1，往前偏移8字节后取4字节是版本信息截取大小 V2。
- 跳过的偏移量是 V1 + (xiaoqiang_version + 补齐字节) 32 , 总共截取 V2 字节。
    dd if=firmware.bin of=xiaoqiang_version bs=1M skip=$((V1 + 32)) count=$V2 iflag=skip_bytes,count_bytes
- 通过魔术字 uImage.bin 找到偏移量 U1，往前偏移8字节后取4字节是内核截取大小 U2。

示例：
```
# 得出偏移量 64
VERSION_OFFEST=$(strings -t x miwifi_r3g_firmware_9be74_2.28.44.bin | grep "xiaoqiang_version" | head -1 | awk '{printf "%d\n", "0x"$1}')
echo $VERSION_OFFEST

# 获取版本信息截取大小， 64 - 8 => 56 , 输出 529
VERSION_SIZE=$(echo $(dd if=miwifi_r3g_firmware_9be74_2.28.44.bin bs=1 skip=$(($VERSION_OFFEST - 8)) count=4 2>/dev/null| xxd -p)  | fold -w2 | tac | tr -d '\n' | awk '{print "0x"$0}' | xargs printf "%d\n")
echo $VERSION_SIZE

# 提取版本信息, 64 + 32 => 96
# dd if=miwifi_r3g_firmware_9be74_2.28.44.bin of=xiaoqiang_version bs=1 skip=96 count=529
dd if=miwifi_r3g_firmware_9be74_2.28.44.bin of=xiaoqiang_version bs=1M skip=$(($VERSION_OFFEST + 32)) count=$VERSION_SIZE iflag=skip_bytes,count_bytes

# 得出偏移量 644
KERNEL_OFFSET=$(strings -t x miwifi_r3g_firmware_9be74_2.28.44.bin | grep "uImage\.bin" | head -1 | awk '{printf "%d\n", "0x"$1}')
echo $KERNEL_OFFSET

# 获取内核文件截取大小， 644 - 8 => 636
KERNEL_SIZE=$(echo $(dd if=miwifi_r3g_firmware_9be74_2.28.44.bin bs=1 skip=$(($KERNEL_OFFSET - 8)) count=4 2>/dev/null| xxd -p)  | fold -w2 | tac | tr -d '\n' | awk '{print "0x"$0}' | xargs printf "%d\n")
echo $KERNEL_SIZE

# 提取内核文件, 644 + 32 => 676
# dd if=miwifi_r3g_firmware_9be74_2.28.44.bin of=uImage.bin bs=1M skip=676 count=3501794
dd if=miwifi_r3g_firmware_9be74_2.28.44.bin of=uImage.bin bs=1M skip=$(($KERNEL_OFFSET + 32)) count=$KERNEL_SIZE iflag=skip_bytes,count_bytes


# 得出偏移量 3502488
ROOTFS_OFFSET=$(strings -t x miwifi_r3g_firmware_9be74_2.28.44.bin | grep "root\.ubi" | head -1 | awk '{printf "%d\n", "0x"$1}')
echo $ROOTFS_OFFSET

# 获取文件系统文件截取大小， 3502488 - 8 => 3502480
ROOTFS_SIZE=$(echo $(dd if=miwifi_r3g_firmware_9be74_2.28.44.bin bs=1 skip=$(($ROOTFS_OFFSET - 8)) count=4 2>/dev/null| xxd -p)  | fold -w2 | tac | tr -d '\n' | awk '{print "0x"$0}' | xargs printf "%d\n")
echo $ROOTFS_SIZE

# 提取文件系统文件, 644 + 32 => 676
# dd if=miwifi_r3g_firmware_9be74_2.28.44.bin of=root.ubi bs=1 skip=3502520 count=21102592
dd if=miwifi_r3g_firmware_9be74_2.28.44.bin of=root.ubi bs=1M skip=$(($ROOTFS_OFFSET + 32)) count=$ROOTFS_SIZE iflag=skip_bytes,count_bytes

# 校验hash计算
# dd if="firmware.bin" bs=1M skip=12 count=24605100 iflag=skip_bytes,count_bytes | sha1sum | awk '{print $1}'
BIN_SIZE=$(ls -l miwifi_r3g_firmware_9be74_2.28.44.bin | awk '{print $5}')
dd if=miwifi_r3g_firmware_9be74_2.28.44.bin bs=1M skip=12 count=$(($BIN_SIZE - 272 - 12)) iflag=skip_bytes,count_bytes 2>/dev/null | sha1sum | awk '{print $1}'

# 公钥验证
dd if=miwifi_r3g_firmware_9be74_2.28.44.bin of=firmware_tail.bin bs=1M skip=$(($BIN_SIZE - 256)) count=256 iflag=skip_bytes,count_bytes
openssl rsautl -verify -in firmware_tail.bin -inkey public.pem -pubin -asn1parse

# 通过输出的内容，比对之前的hash，值应该是一样的
```

这是官方工具提取的文件MD5
```text
0088d86edd392b0cdaef9e5c3a7f59db  xiaoqiang_version
cd9ff72bdfb2e06be1114e8ae09813c1  root.ubi
45eb7803927e945da86bc946491e7a6f  uImage.bin
```


# 八、附件

本文使用到的软件包已上传网盘：[BlogDocs->files->router-xiaomi-r3g-exploit](https://pan.baidu.com/s/1yEbHDQBzy43uV8gIYXqbnw?pwd=6666#list/path=%2Fsharelink2076919717-858150382706250%2Ffiles%2Frouter-xiaomi-r3g-exploit)


