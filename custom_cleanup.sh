#!/bin/bash

###############################################################################
# 定制清理脚本 - 基于用户需求
# 目标：释放约 10+ GB 空间
# 说明：清理不活跃项目和缓存
###############################################################################

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo "========================================="
echo "  定制清理脚本"
echo "========================================="
echo ""

# 记录清理前的空间
echo -e "${BLUE}📊 清理前的磁盘空间：${NC}"
df -h / | grep -v Filesystem
echo ""

echo "========================================="
echo "  开始清理"
echo "========================================="
echo ""

# 1. 清理不活跃项目的 node_modules
echo -e "${BLUE}🗑️  清理不活跃项目的 node_modules...${NC}"

if [ -d ~/Documents/00-Project/ruoyi/RuoYi-Vue/ruoyi-ui/node_modules ]; then
    rm -rf ~/Documents/00-Project/ruoyi/RuoYi-Vue/ruoyi-ui/node_modules
    echo -e "${GREEN}✅ 已清理 ruoyi node_modules (864 MB)${NC}"
fi

if [ -d ~/Documents/00-Project/nuxt3 ]; then
    rm -rf ~/Documents/00-Project/nuxt3/*/node_modules
    echo -e "${GREEN}✅ 已清理 nuxt3 node_modules (1 GB)${NC}"
fi

if [ -d ~/Documents/00-Project/yudao/yudao-ui-admin-vue2/node_modules ]; then
    rm -rf ~/Documents/00-Project/yudao/yudao-ui-admin-vue2/node_modules
    echo -e "${GREEN}✅ 已清理 yudao node_modules (392 MB)${NC}"
fi

if [ -d ~/Documents/00-Project/geminiAI/node_modules ]; then
    rm -rf ~/Documents/00-Project/geminiAI/node_modules
    echo -e "${GREEN}✅ 已清理 geminiAI node_modules (352 MB)${NC}"
fi

echo ""

# 2. 清理 Maven target 目录
echo -e "${BLUE}🗑️  清理 Maven 构建产物...${NC}"
find ~/Documents/00-Project -name "target" -type d -exec rm -rf {} + 2>/dev/null
echo -e "${GREEN}✅ 已清理 Maven target 目录 (200 MB)${NC}"
echo ""

# 3. 清理 Maven SNAPSHOT 版本
echo -e "${BLUE}🗑️  清理 Maven SNAPSHOT 版本...${NC}"
if [ -d ~/.m2/repository ]; then
    find ~/.m2/repository -name "*-SNAPSHOT" -type d -exec rm -rf {} + 2>/dev/null
    echo -e "${GREEN}✅ 已清理 Maven SNAPSHOT (2-3 GB)${NC}"
else
    echo -e "${YELLOW}⚠️  Maven 仓库不存在${NC}"
fi
echo ""

# 4. 清理 iOS Simulator（使用正确的方法）
echo -e "${BLUE}🗑️  清理不可用的 iOS Simulator...${NC}"
if command -v xcrun &> /dev/null; then
    xcrun simctl delete unavailable 2>/dev/null
    echo -e "${GREEN}✅ 已清理不可用的 iOS Simulator${NC}"
else
    echo -e "${YELLOW}⚠️  xcrun 命令不可用，跳过 iOS Simulator 清理${NC}"
fi
echo ""

# 注意：旧版本 iOS Simulator 需要在 Xcode 中手动删除
echo -e "${YELLOW}📝 注意：要删除旧版本的 iOS Simulator Runtime（31 GB），请：${NC}"
echo "   1. 打开 Xcode"
echo "   2. Settings/Preferences -> Platforms"
echo "   3. 删除 iOS 26.0 和 iOS 26.1，保留 iOS 26.2"
echo ""

# 总结
echo "========================================="
echo "  清理完成！"
echo "========================================="
echo ""

echo -e "${BLUE}📊 清理后的磁盘空间：${NC}"
df -h / | grep -v Filesystem
echo ""

echo -e "${GREEN}🎉 已清理以下内容：${NC}"
echo "  ✅ ruoyi node_modules: 864 MB"
echo "  ✅ nuxt3 node_modules: 1 GB"
echo "  ✅ yudao node_modules: 392 MB"
echo "  ✅ geminiAI node_modules: 352 MB"
echo "  ✅ Maven target: 200 MB"
echo "  ✅ Maven SNAPSHOT: 2-3 GB"
echo "  ✅ 不可用的 Simulator: 可变"
echo ""
echo -e "${GREEN}预计释放空间：约 5-6 GB${NC}"
echo ""

echo -e "${YELLOW}📌 额外优化建议：${NC}"
echo "  1. 在 Xcode 中删除旧 iOS Runtime (31 GB)"
echo "  2. 清理下载文件夹 (629 MB)"
echo "  3. 考虑归档不用的项目"
echo ""

###############################################################################
# 脚本结束
###############################################################################
