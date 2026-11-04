#!/bin/bash
#
# XR30 eMMC 编译 — DIY 脚本 part 2（在 ./scripts/feeds update/install -a 之后执行）
#

# 1) 删除 DDNS 自带的示例配置（减小体积，可选）
sed -i '/myddns_ipv4/,$d' feeds/packages/net/ddns-scripts/files/etc/config/ddns 2>/dev/null || true

# 2) 手动设置 MT7981B 的 CPU 显示频率（2.0GHz 芯片在 autocore 里显示为 1.3GHz 的修正在此）
sed -i '/"mediatek"\/\*|\"mvebu"\/\*/{n; s/.*/\tcpu_freq="1.3GHz" ;;/}' package/emortal/autocore/files/generic/cpuinfo 2>/dev/null || true

# 3) OpenList 需要较新的 Go 工具链（>=1.22）。hanwckf openwrt-21.02 内置 golang 较旧，
#    由 workflow 的 “Replace golang for OpenList” 步骤在开启 openlist 时替换 feeds/packages/lang/golang。
echo "[diy-part2] CPU 频率修正完成。"
