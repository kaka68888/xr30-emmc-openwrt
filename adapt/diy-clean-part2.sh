#!/bin/bash
#
# XR30 eMMC 纯净版 — DIY 脚本 part 2（在 ./scripts/feeds update/install -a 之后执行）
#

# 1) 手动设置 MT7981B 的 CPU 显示频率（2.0GHz 芯片在 autocore 里显示为 1.3GHz 的修正）
sed -i '/"mediatek"\/\*|\"mvebu"\/\*/{n; s/.*/\tcpu_freq="1.3GHz" ;;/}' package/emortal/autocore/files/generic/cpuinfo 2>/dev/null || true

echo "[diy-part2] CPU 频率修正完成（纯净版）。"
