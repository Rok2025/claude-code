# macOS 系统资源使用分析报告

> 生成时间：2026-01-07 09:58:40
> 系统版本：Darwin 25.3.0

---

## 📊 硬盘使用情况

### ⚠️ 严重警告：主硬盘几乎已满！

| 分区 | 总容量 | 已使用 | 可用 | 使用率 | 状态 |
|------|--------|--------|------|--------|------|
| **/System/Volumes/Data** | 460 GB | **412 GB** | **20 GB** | **96%** | 🔴 危险 |
| / (根分区) | 460 GB | 11 GB | 20 GB | 36% | 🟢 正常 |
| /System/Volumes/VM | 460 GB | 8.0 GB | 20 GB | 29% | 🟢 正常 |
| iOS Simulator Vol 1 | 16 GB | 16 GB | 426 MB | 98% | 🔴 满 |
| iOS Simulator Vol 2 | 16 GB | 16 GB | 436 MB | 98% | 🔴 满 |
| iOS Simulator Vol 3 | 16 GB | 16 GB | 439 MB | 98% | 🔴 满 |

**关键问题：**
- 主数据分区仅剩 **20 GB** 可用空间（4%）
- iOS Simulator 卷占用 **48 GB**（3个卷，各16GB）
- 系统可能很快会出现性能问题
- 需要立即清理空间

---

## 🧠 内存使用情况

### 物理内存概览

**总内存：约 16 GB**

```
已使用：15 GB（94%）
├─ 活跃内存(Active)：3.0 GB (191,595 pages × 16KB)
├─ 非活跃内存(Inactive)：3.0 GB (188,694 pages × 16KB)
├─ 固定内存(Wired)：2.4 GB (151,751 pages × 16KB)
└─ 压缩内存(Compressed)：7.3 GB (470,621 pages × 16KB)

可用内存：124 MB（4,202 pages × 16KB）
可清除内存：2.8 MB (180 pages × 16KB)
```

### 虚拟内存统计

| 指标 | 数值 | 说明 |
|------|------|------|
| 页面大小 | 16 KB | macOS Apple Silicon 标准 |
| 空闲页面 | 4,202 | 仅 65 MB 可用 |
| 活跃页面 | 191,595 | 2.98 GB |
| 非活跃页面 | 188,694 | 2.94 GB |
| 压缩器占用 | 470,621 页 | 7.3 GB |
| 被压缩数据 | 1,544,815 页 | 24 GB 数据被压缩 |

### Swap 使用情况

```
Swap 输入(Swapins)：128,455 次
Swap 输出(Swapouts)：509,904 次
页面换入(Pageins)：2,901,988 次
页面换出(Pageouts)：56,494 次
```

**状态：** 🟡 内存压力较大，频繁使用 Swap，可能影响性能

---

## 🔝 内存占用 TOP 20 应用

| 排名 | 应用名称 | 内存占用 | 占比 | CPU使用 | 进程ID | 说明 |
|------|----------|----------|------|---------|--------|------|
| 1 | **Visual Studio Code (Renderer)** | 416 MB | 2.5% | 0.0% | 13401 | 代码编辑器渲染进程 |
| 2 | **ChatGPT Atlas (Renderer)** | 365 MB | 2.2% | 0.4% | 1719 | AI 聊天应用渲染器 |
| 3 | **Antigravity (Renderer)** | 294 MB | 1.8% | 5.6% | 3055 | 代码编辑器渲染进程 |
| 4 | **Claude CLI** | 199 MB | 1.2% | **36.6%** | 7224 | 当前运行的 Claude Code |
| 5 | **IntelliJ IDEA Ultimate** | 200 MB | 1.2% | 1.6% | 5902 | Java IDE 主进程 |
| 6 | **Arc Browser** | 173 MB | 1.1% | 0.1% | 694 | Arc 浏览器主进程 |
| 7 | **Google Chrome** | 175 MB | 1.1% | 0.1% | 686 | Chrome 浏览器主进程 |
| 8 | Chrome Helper (Extension) | 155 MB | 0.9% | 0.0% | 21185 | Chrome 扩展进程 |
| 9 | VS Code (Main) | 125 MB | 0.8% | 0.1% | 13386 | VS Code 主进程 |
| 10 | VS Code Helper (Plugin) | 117 MB | 0.7% | 0.0% | 16761 | VS Code 插件进程 |
| 11 | Antigravity (Main) | 114 MB | 0.7% | 0.0% | 3050 | Antigravity 主进程 |
| 12 | Chrome Helper (Extension) | 105 MB | 0.6% | 0.0% | 21154 | Chrome 扩展进程 |
| 13 | Chrome Helper (Extension) | 103 MB | 0.6% | 0.0% | 21153 | Chrome 扩展进程 |
| 14 | **Java Debug Process** | 101 MB | 0.6% | 0.0% | 19358 | Java 应用调试进程 |
| 15 | Antigravity Helper (Plugin) | 102 MB | 0.6% | 0.8% | 3631 | Antigravity 插件进程 |
| 16 | Chrome Helper (Renderer) | 85 MB | 0.5% | 3.4% | 5761 | Chrome 标签页渲染器 |
| 17 | Chrome Helper (Renderer) | 77 MB | 0.5% | 0.0% | 5430 | Chrome 标签页渲染器 |
| 18 | Antigravity Language Server | 78 MB | 0.5% | 3.7% | 3677 | 代码语言服务器 |
| 19-20 | 其他进程 | < 70 MB | < 0.4% | 各异 | - | 系统/后台进程 |

---

## 🎯 应用类别汇总分析

### 1. 开发工具（最占内存）

```
总计：~1.5 GB+
├─ IntelliJ IDEA Ultimate: 200 MB (Java IDE)
├─ Visual Studio Code: ~660 MB
│   ├─ 主进程: 125 MB
│   ├─ 渲染器: 416 MB
│   └─ 插件进程: 117 MB
├─ Antigravity: ~590 MB
│   ├─ 主进程: 114 MB
│   ├─ 渲染器: 294 MB
│   ├─ 插件进程: 102 MB
│   └─ 语言服务器: 78 MB
└─ Java 调试进程: 101 MB
```

**问题：** 同时运行 3 个重量级代码编辑器

---

### 2. 浏览器（内存大户）

```
总计：~1.2 GB+
├─ Google Chrome: ~700 MB
│   ├─ 主进程: 175 MB
│   ├─ 扩展进程 × 3: ~360 MB (155+105+103 MB)
│   └─ 标签页渲染器 × 2: ~162 MB
└─ Arc Browser: 173 MB
```

**问题：** Chrome 有 10+ 个渲染进程，可能打开了很多标签页/扩展

---

### 3. AI 工具

```
总计：~564 MB
├─ ChatGPT Atlas: 365 MB
└─ Claude CLI: 199 MB (当前 CPU 使用率 36.6%)
```

---

### 4. 系统进程

```
估计：~2-3 GB
├─ WindowServer (图形界面)
├─ Finder
├─ Spotlight 索引
└─ 其他系统服务
```

---

## 🚨 发现的主要问题

### 🔴 高优先级问题

#### 1. **硬盘空间严重不足**
- **剩余空间：仅 20 GB (4%)**
- **可能导致：**
  - ✗ 系统运行缓慢
  - ✗ 无法安装软件更新
  - ✗ Swap 性能下降（影响内存管理）
  - ✗ 文件保存失败
  - ✗ 应用崩溃
  - ✗ Time Machine 备份失败

#### 2. **iOS Simulator 占用 48 GB**
- 3 个 Simulator 卷，各 16 GB
- 使用率 98%，几乎满载
- **如果不是 iOS 开发者，建议立即删除**

---

### 🟡 中优先级问题

#### 3. **内存压力大**
- 物理内存使用率：94%
- 可用内存：仅 124 MB
- 压缩内存：7.3 GB（24 GB 数据被压缩）
- Swap 频繁使用：509,904 次输出
- **影响：** 系统响应变慢，风扇噪音增大

#### 4. **多个 IDE 同时运行**
- IntelliJ IDEA + VS Code + Antigravity
- 总占用：~1.5 GB 内存
- **建议：** 关闭不使用的 IDE

#### 5. **浏览器标签页/扩展过多**
- Chrome 有 10+ 个进程
- 总占用：~700 MB
- **建议：** 关闭不用的标签页，禁用不常用扩展

---

## 💡 优化建议

### 🔴 立即执行（清理硬盘空间）

#### 1. 清理 iOS Simulator（可释放 ~48 GB）

```bash
# 删除所有不可用的 Simulator
xcrun simctl delete unavailable

# 清空所有 Simulator 数据
xcrun simctl erase all

# 如果完全不需要 Simulator，删除缓存
sudo rm -rf ~/Library/Developer/CoreSimulator/Caches/*
```

---

#### 2. 清理 Xcode 缓存（可释放 10-30 GB）

```bash
# 删除 Derived Data（编译产物）
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# 删除旧的 Archives（应用归档）
rm -rf ~/Library/Developer/Xcode/Archives/*

# 删除设备支持文件（可选）
rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport/*
```

---

#### 3. 清理 Homebrew（可释放 5-10 GB）

```bash
# 清理旧版本的包
brew cleanup -s

# 自动删除不需要的依赖
brew autoremove

# 查看可清理的空间
brew cleanup -n
```

---

#### 4. 清理 Node.js/pnpm 缓存（可释放 5-10 GB）

```bash
# 清理 pnpm 缓存
pnpm store prune

# 清理 npm 缓存
npm cache clean --force

# 清理 yarn 缓存（如果使用）
yarn cache clean
```

---

#### 5. 清理 Docker（如果安装了，可释放 10-50 GB）

```bash
# 删除所有未使用的镜像、容器、网络、卷
docker system prune -a --volumes

# 查看当前占用
docker system df
```

---

#### 6. 清理用户缓存和日志

```bash
# 清理用户缓存（谨慎操作，可能需要重新登录某些应用）
# 建议先查看大小
du -sh ~/Library/Caches

# 清理特定应用缓存（示例）
rm -rf ~/Library/Caches/Google/Chrome/*
rm -rf ~/Library/Caches/com.microsoft.VSCode/*

# 清理系统日志（需要管理员权限）
sudo rm -rf /var/log/*.log
sudo rm -rf ~/Library/Logs/*
```

---

#### 7. 查找和删除大文件

```bash
# 查找 > 1GB 的文件
find ~ -type f -size +1G 2>/dev/null | head -20

# 查找 > 500MB 的文件
find ~ -type f -size +500M 2>/dev/null | head -30

# 可视化磁盘使用（推荐安装 ncdu）
brew install ncdu
ncdu ~
```

---

#### 8. 清理下载文件夹

```bash
# 查看下载文件夹大小
du -sh ~/Downloads

# 删除超过 30 天的文件（谨慎操作）
find ~/Downloads -type f -mtime +30 -delete
```

---

#### 9. 清理 IntelliJ IDEA 缓存

```bash
# 清理 IntelliJ IDEA 缓存
rm -rf ~/Library/Caches/JetBrains/IntelliJIdea*

# 清理编译产物（确保项目已提交）
# 在项目目录中
find ~/Documents/00-Project -name "target" -type d -exec rm -rf {} +
find ~/Documents/00-Project -name "node_modules" -type d -exec rm -rf {} +
```

---

#### 10. 清理微信读书缓存

```bash
# 从挂载点看，微信读书可能占用较多空间
# 检查应用数据大小
du -sh ~/Library/Containers/com.tencent.WeReadMac*
```

---

### 🟡 推荐执行（优化内存）

#### 1. 关闭不使用的应用

**当前运行的重量级应用：**
- IntelliJ IDEA (200 MB)
- Visual Studio Code (660 MB)
- Antigravity (590 MB)
- Chrome (700 MB)
- ChatGPT Atlas (365 MB)
- Arc Browser (173 MB)

**建议：**
```bash
# 只保留正在使用的 IDE
# 关闭 Chrome 或 Arc（二选一）
# 如果不用 ChatGPT，可以退出
```

---

#### 2. 重启内存占用高的应用

```bash
# VS Code 长时间运行后内存占用会增加
# 定期重启可释放内存
# 使用 Command + Q 完全退出，再重新打开
```

---

#### 3. 减少 Chrome 扩展和标签页

```bash
# Chrome 当前有 10+ 个进程
# 建议：
# - 关闭不用的标签页
# - 禁用不常用的扩展
# - 使用 OneTab 等扩展管理标签页
```

---

#### 4. 使用活动监视器监控

```bash
# 打开活动监视器
open -a "Activity Monitor"

# 或使用命令行工具
top -o mem
```

---

#### 5. 考虑硬件升级

**当前配置：**
- 内存：16 GB
- 硬盘：460 GB SSD

**建议：**
- 如果预算允许，升级到 32 GB 内存
- 或使用外置 SSD 存储项目文件

---

### 🟢 长期优化（预防性维护）

#### 1. 创建定期清理脚本

```bash
# 创建清理脚本
cat > ~/cleanup.sh << 'EOF'
#!/bin/bash

echo "========================================="
echo "macOS 系统清理脚本"
echo "========================================="
echo ""

echo "📦 清理 pnpm 缓存..."
pnpm store prune
echo "✅ 完成"
echo ""

echo "🍺 清理 Homebrew..."
brew cleanup -s
brew autoremove
echo "✅ 完成"
echo ""

echo "📱 清理 Xcode..."
rm -rf ~/Library/Developer/Xcode/DerivedData/*
echo "✅ 完成"
echo ""

echo "📦 清理 npm 缓存..."
npm cache clean --force
echo "✅ 完成"
echo ""

echo "🗑️ 清空废纸篓..."
rm -rf ~/.Trash/*
echo "✅ 完成"
echo ""

echo "========================================="
echo "清理完成！请重启电脑以获得最佳性能。"
echo "========================================="
EOF

# 添加执行权限
chmod +x ~/cleanup.sh

# 运行清理
~/cleanup.sh
```

---

#### 2. 安装磁盘分析工具

```bash
# 安装 ncdu（终端磁盘分析工具）
brew install ncdu

# 使用方法
ncdu ~                          # 分析主目录
ncdu ~/Documents               # 分析特定目录
ncdu --exclude node_modules ~  # 排除 node_modules
```

**推荐的 GUI 工具：**
- **DaisyDisk** - 可视化磁盘空间分析
- **OmniDiskSweeper** - 免费磁盘清理工具
- **CleanMyMac X** - 综合清理工具（付费）

---

#### 3. 设置自动清理任务

```bash
# 创建 launchd 任务，每周自动清理
# 文件路径: ~/Library/LaunchAgents/com.user.cleanup.plist

cat > ~/Library/LaunchAgents/com.user.cleanup.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.cleanup</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/freeman/cleanup.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Weekday</key>
        <integer>0</integer>
        <key>Hour</key>
        <integer>2</integer>
    </dict>
</dict>
</plist>
EOF

# 加载任务
launchctl load ~/Library/LaunchAgents/com.user.cleanup.plist
```

---

#### 4. 使用外部存储

```bash
# 将不常用的项目移到外置硬盘
# 创建符号链接保持路径一致

# 示例：移动旧项目
mv ~/Documents/00-Project/old-project /Volumes/External/Projects/
ln -s /Volumes/External/Projects/old-project ~/Documents/00-Project/old-project
```

---

#### 5. 配置 Git 清理

```bash
# 清理所有 Git 仓库的未跟踪文件
find ~/Documents/00-Project -name ".git" -type d | while read gitdir; do
    cd "$(dirname "$gitdir")"
    echo "清理 $(pwd)"
    git gc --aggressive --prune=now
done
```

---

## 📊 系统整体状态

### CPU 使用情况
```
用户进程：22.58%
系统进程：19.4%
空闲：58.37%
负载平均：4.18 (1分钟), 7.10 (5分钟), 6.66 (15分钟)
```

**状态：** 🟢 CPU 使用正常，但负载较高（可能因为 Claude CLI 和 Antigravity）

---

### 网络活动
```
接收：1,855,731 个包 / 1.14 GB
发送：1,520,845 个包 / 763 MB
```

---

### 磁盘 I/O
```
读取：2,955,768 次 / 52 GB
写入：777,044 次 / 22 GB
```

---

## 📋 快速行动清单

### 立即执行（今天）

- [ ] **删除 iOS Simulator 数据** → 释放 ~48 GB
- [ ] **清理 Xcode 缓存** → 释放 ~10-30 GB
- [ ] **清理 Homebrew** → 释放 ~5-10 GB
- [ ] **清理 pnpm/npm 缓存** → 释放 ~5-10 GB
- [ ] **查找并删除大文件** → 释放可变

**目标：至少释放 50-100 GB 空间**

---

### 本周内执行

- [ ] 关闭不使用的 IDE（IntelliJ/VS Code/Antigravity 三选一）
- [ ] 减少 Chrome 标签页和扩展
- [ ] 清理下载文件夹
- [ ] 清理应用缓存
- [ ] 创建定期清理脚本

---

### 长期规划

- [ ] 安装磁盘分析工具（ncdu/DaisyDisk）
- [ ] 设置自动清理任务
- [ ] 考虑购买外置 SSD
- [ ] 考虑升级内存到 32 GB
- [ ] 定期运行清理脚本（每月一次）

---

## 🔍 详细命令参考

### 查看当前磁盘使用的详细命令

```bash
# 查看各分区使用情况
df -h

# 查看主目录各文件夹大小
du -sh ~/* | sort -hr | head -20

# 查看隐藏文件夹大小
du -sh ~/Library/* | sort -hr | head -20

# 查看项目目录大小
du -sh ~/Documents/00-Project/* | sort -hr

# 查看 node_modules 总大小
find ~/Documents/00-Project -name "node_modules" -type d -exec du -sh {} + | awk '{sum+=$1} END {print sum}'
```

---

### 内存监控命令

```bash
# 实时内存使用
vm_stat 1

# 查看内存压力
memory_pressure

# 查看进程内存使用
top -o mem -n 20

# 按内存排序的进程列表
ps aux | sort -nrk 4 | head -20
```

---

## 📝 备注

**生成工具：** Claude Code CLI
**分析时间：** 2026-01-07 09:58:40
**系统版本：** macOS (Darwin 25.3.0)
**机器型号：** Apple Silicon (推测基于页面大小 16KB)

**重要提示：**
1. 执行删除操作前，请确保已备份重要数据
2. 如果不确定某个文件是否需要，请先移动到备份位置而不是直接删除
3. 建议先从 iOS Simulator 和 Xcode 缓存开始清理（影响最小）
4. 内存压力大时，考虑重启电脑以释放内存
5. 长期解决方案是增加物理内存或使用外置存储

---

## ❓ 需要帮助？

如需执行任何清理操作，请告诉我具体要清理的项目，我可以：
1. 生成安全的清理命令
2. 帮助查找占用空间最大的文件/文件夹
3. 分析特定目录的空间使用
4. 创建自动化清理脚本

**安全第一，清理谨慎！**
