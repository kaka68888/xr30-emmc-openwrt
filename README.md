# XR30 (CMCC XR30) eMMC — OpenWrt 云端编译（GitHub Actions）

> 目标设备：**CMCC XR30 eMMC 版**（MediaTek MT7981B）
> 源码：`hanwckf/immortalwrt-mt798x` 分支 `openwrt-21.02`，闭源 MTK mtwifi 驱动（性能最佳）
> 预装：**luci-app-openlist**（网盘聚合挂载） + **luci-app-passwall**（科学上网）

---

## 一、仓库文件说明

| 文件 | 作用 |
|------|------|
| `.github/workflows/build.yml` | GitHub Actions 云端编译工作流 |
| `feeds.conf.default` | 软件源（lgs2007m 基础源 + passwall + openlist） |
| `adapt/xr30-emmc.config` | 设备与目标配置（`cmcc_xr30` + mtwifi + openlist + passwall，单编 xr30） |
| `adapt/diy-part1.sh` / `diy-part2.sh` | 适配脚本（CPU 频率修正等） |

---

## 二、怎么用（3 步，约 1 分钟准备 + 2~5 小时编译）

1. 在 GitHub 新建一个**公开**仓库（私有也可以，但免费 Actions 额度更少）。
2. 把本仓库**全部文件**（务必包含隐藏的 `.github` 目录）上传 / 推送到新仓库。
3. 进入新仓库的 **Actions** 标签页 → 选择 `Build XR30 eMMC OpenWrt` → 点 **Run workflow**：
   - 可勾选 / 取消 `openlist`、`passwall`（默认都编译）。
   - 等待编译完成（免费 Runner 2 核，约 2~5 小时，可能逼近 6 小时上限）。
   - 完成后在 **Artifacts** 区域下载 `xr30-emmc-firmware`（含固件 `.bin`）。

> 提示：首次编译如果超时（6h），可在 Run workflow 时**取消勾选 openlist** 减少工作量，或改用本地 WSL 编译（见第六节）。

---

## 三、固件产物与刷机

- 产物文件（文件名含 `cmcc_xr30`）：
  - `*-squashfs-factory.bin`：**首次刷入 / uboot 网页刷入**用
  - `*-squashfs-sysupgrade.bin`：已在 OpenWrt / ImmortalWrt 系统内升级用
- 产物目录对应：`bin/targets/mediatek/mt7981/`

⚠️ **刷机有变砖风险，务必先确认你的机器是 XR30 eMMC 版（不是 NAND / ubootmod 版）并先备份！**
- eMMC 版通常需先刷入 `hanwckf/bl-mt798x` 的 uboot（DHCP failsafe 版），再通过 uboot 网页（`192.168.1.1`）刷入 factory 固件。
- 救砖：MT7981 支持串口救砖（TTL 3.3V，115200 8N1）。
- 参考：`RSxiaoyu/bl-mt798x-xr30`、`sonytxl/XR30-eMMC` 仓库的教程。

---

## 四、关键决策说明

- **驱动选闭源 mtwifi**：XR30 eMMC 在官方 / ImmortalWrt 主线均无现成 profile；闭源 mtwifi 这条（hanwckf 源码 + 社区 XR30 eMMC 适配）是验证过能稳定出固件的组合。
- **passwall 源修正**：原社区脚本里的 `xiaorouji/openwrt-passwall` 已失效，改用 `xiaorouji/luci-app-passwall`（LuCI 界面）+ `xiaorouji/openwrt-passwall-packages`（核心程序）。
- **openlist 的 golang 处理**：openlist 需要较新的 Go 工具链，工作流在开启 openlist 时会自动把 `feeds/packages/lang/golang` 替换为 `OpenListTeam/packages_lang_golang` 的 `21.x` 分支（匹配 openwrt-21.02）。若 openlist 编译失败，可在 Run workflow 时取消勾选 openlist 重试，不影响 passwall。

---

## 五、常见问题

- **Runner 磁盘 / 时间不够**：工作流已清理 Runner 自带的大目录释放空间。若仍超时，关闭 openlist 或减少插件；或本地 WSL 编译。
- **`ubuntu-22.04` 被 GitHub 弃用**：把 `build.yml` 里的 `runs-on: ubuntu-22.04` 改为 `ubuntu-24.04`（openwrt-21.02 在 24.04 可能需额外 patch，遇到报错可反馈）。
- **`make download` 失败**：多为个别包源临时不可达，重新 Run workflow 即可；云端 Runner 访问 GitHub 不受国内网络限制。
- **只想要其中一个插件**：Run workflow 时只勾选需要的那一项即可。

---

## 六、备选：本地 WSL2 编译

同工作区的 `build-xr30-emmc.sh` 是本地一键脚本（需在本机 WSL2 Ubuntu 运行，不能放 `/mnt/c`）。
默认裁剪科学上网插件，若要包含 passwall，运行：
```bash
KEEP_VPN=yes bash ~/build-xr30-emmc.sh
```
openlist 需自行在 `make menuconfig`（设 `USE_MENUCONFIG=yes`）里勾选 LuCI → Applications → luci-app-openlist。
