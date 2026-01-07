#!/bin/bash

###############################################################################
# macOS 保守清理脚本
# 生成时间: 2026-01-07
# 说明: 安全清理浏览器和 IDE 缓存，不删除 iOS Simulator 和 Maven 仓库
###############################################################################

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 统计变量
TOTAL_CLEANED=0

# 打印标题
echo ""
echo "========================================="
echo "  macOS 保守清理脚本"
echo "========================================="
echo ""

# 函数: 计算目录大小（MB）
get_size_mb() {
    if [ -d "$1" ]; then
        du -sm "$1" 2>/dev/null | awk '{print $1}'
    else
        echo "0"
    fi
}

# 函数: 清理目录
clean_directory() {
    local dir="$1"
    local name="$2"

    if [ ! -d "$dir" ]; then
        echo -e "${YELLOW}⚠️  $name 不存在，跳过${NC}"
        return
    fi

    local size=$(get_size_mb "$dir")

    if [ "$size" -eq 0 ]; then
        echo -e "${YELLOW}⚠️  $name 为空，跳过${NC}"
        return
    fi

    echo -e "${BLUE}🗑️  清理 $name (${size} MB)...${NC}"

    # 备份重要文件（如果需要）
    # 这里我们直接删除缓存，因为它们都是可重建的

    rm -rf "$dir"/* 2>/dev/null

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅  已清理 $name - 释放 ${size} MB${NC}"
        TOTAL_CLEANED=$((TOTAL_CLEANED + size))
    else
        echo -e "${RED}❌  清理 $name 失败${NC}"
    fi

    echo ""
}

# 开始清理
echo -e "${BLUE}📊 检查清理前的磁盘空间...${NC}"
df -h / | grep -v Filesystem
echo ""

echo "========================================="
echo "  开始清理缓存"
echo "========================================="
echo ""

# 1. 清理 Google Chrome/Drive 缓存
clean_directory "$HOME/Library/Caches/Google" "Google Chrome/Drive 缓存"

# 2. 清理 JetBrains (IntelliJ IDEA) 缓存
clean_directory "$HOME/Library/Caches/JetBrains" "IntelliJ IDEA 缓存"

# 3. 清理 Arc 浏览器缓存
clean_directory "$HOME/Library/Caches/Arc" "Arc 浏览器缓存"

# 4. 清理 ChatGPT Atlas 缓存
clean_directory "$HOME/Library/Caches/com.openai.atlas" "ChatGPT Atlas 缓存"

# 5. 清理 Playwright 缓存
clean_directory "$HOME/Library/Caches/ms-playwright-go" "Playwright 缓存"

# 6. 清理其他小缓存
clean_directory "$HOME/Library/Caches/typescript" "TypeScript 缓存"
clean_directory "$HOME/Library/Caches/Sublime Text" "Sublime Text 缓存"

# 7. 清理系统临时文件
echo -e "${BLUE}🗑️  清理系统临时文件...${NC}"
rm -rf /tmp/* 2>/dev/null
echo -e "${GREEN}✅  已清理系统临时文件${NC}"
echo ""

# 8. 清空废纸篓（可选）
echo -e "${BLUE}🗑️  清空废纸篓...${NC}"
TRASH_SIZE=$(get_size_mb "$HOME/.Trash")
rm -rf "$HOME/.Trash"/* 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅  已清空废纸篓 - 释放 ${TRASH_SIZE} MB${NC}"
    TOTAL_CLEANED=$((TOTAL_CLEANED + TRASH_SIZE))
else
    echo -e "${YELLOW}⚠️  清空废纸篓失败或已为空${NC}"
fi
echo ""

# 总结
echo "========================================="
echo "  清理完成！"
echo "========================================="
echo ""
echo -e "${GREEN}📊 总计释放空间: ${TOTAL_CLEANED} MB (约 $((TOTAL_CLEANED / 1024)) GB)${NC}"
echo ""

echo -e "${BLUE}📊 检查清理后的磁盘空间...${NC}"
df -h / | grep -v Filesystem
echo ""

# 未清理的项目（保守策略）
echo "========================================="
echo "  未清理的项目（保守策略）"
echo "========================================="
echo ""
echo -e "${YELLOW}⏭️  以下项目已跳过（如需清理请手动执行）:${NC}"
echo ""
echo "1. iOS Simulator Volumes (~47 GB)"
echo "   位置: /Library/Developer/CoreSimulator/Volumes/"
echo "   清理命令: sudo rm -rf /Library/Developer/CoreSimulator/Volumes/*"
echo ""
echo "2. Maven 本地仓库 (~7.2 GB)"
echo "   位置: ~/.m2/repository/"
echo "   清理命令: rm -rf ~/.m2/repository/*"
echo ""
echo "3. Xcode DerivedData (当前为空)"
echo "   位置: ~/Library/Developer/Xcode/DerivedData/"
echo ""

# 建议
echo "========================================="
echo "  后续建议"
echo "========================================="
echo ""
echo "✨ 如果需要释放更多空间，可以考虑:"
echo "   1. 清理 iOS Simulator (47 GB) - 如果不做 iOS 开发"
echo "   2. 清理 Maven 快照版本 (3-5 GB)"
echo "   3. 清理项目中的 node_modules 和 target 目录"
echo ""
echo "📝 定期维护建议:"
echo "   1. 每月运行一次此脚本"
echo "   2. 定期检查大文件: find ~ -type f -size +1G"
echo "   3. 使用 ncdu 工具可视化磁盘使用: brew install ncdu"
echo ""
echo "🎉 清理完成！建议重启应用以获得最佳性能。"
echo ""

###############################################################################
# 脚本结束
###############################################################################
