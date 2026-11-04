#!/bin/bash
#
# XR30 eMMC 编译 — DIY 脚本 part 1（在 ./scripts/feeds update -a 之前执行）
#
# 说明：
#  - PassWall / OpenList 的软件源已写进本仓库的 feeds.conf.default，无需在此 clone。
#  - 原社区脚本里的 OpenAppFilter（oaf）已按需求裁剪，这里不再 clone。
#  - 如需额外软件源，可在此用 sed 插入 src-git 行，例如：
#      sed -i '1i src-git helloworld https://github.com/fw876/helloworld' feeds.conf.default

echo "[diy-part1] feeds 源已在 feeds.conf.default 中配置，无需额外 clone。"
echo "[diy-part1] 当前 feeds.conf.default 中的第三方源："
grep -E 'passwall|openlist' feeds.conf.default || true
