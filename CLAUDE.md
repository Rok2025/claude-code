# Claude Code 项目配置

## 项目概述

这是一个微服务开发文档和工具集项目，主要包含：

- **Smart Platform** - 微服务架构项目的文档和配置
  - System 模块 (端口 48081)
  - Infra 模块 (端口 48082)
  - Eng 模块 (端口 48090)
  - Gateway 网关 (端口 48080)
  - 前端项目 (端口 30000)

- **开发工具文档**
  - Antigravity IDE 使用指南
  - Docker 开发模式指南
  - 微服务开发最佳实践

- **辅助工具**
  - 系统清理脚本
  - 开发环境优化方案

## 项目结构

```
.
├── CLAUDE.md                          # 本文件：项目配置
├── CLAUDE_CODE_LEARNING_GUIDE.md     # Claude Code 学习指南
├── .claude/                           # Claude Code 配置目录
│   └── settings.local.json           # 本地权限设置
├── demo/                              # 演示项目
├── doc/                               # 文档目录
└── *.md                               # 各类文档
```

## 文档规范

### 文档命名
- 使用中文命名，描述清晰
- 技术名词保持英文（如 Docker、Antigravity）
- 使用连字符分隔（如 `Docker开发模式-快速参考.md`）

### 文档结构
- 使用 Markdown 格式
- 包含清晰的目录结构
- 代码示例使用代码块标注语言
- 重要信息使用 emoji 标记（✅ ❌ ⚠️ 💡）

## 代码约定

### Shell 脚本
- 使用 bash
- 添加执行权限 (`chmod +x`)
- 包含错误处理
- 添加清晰的注释

### 文档更新
- 保持文档与实际环境同步
- 更新时注明日期或版本
- 重大变更需要说明原因

## 常用命令

### 文档相关
```bash
# 查看所有文档
ls *.md

# 搜索文档内容
grep -r "关键词" *.md

# 查看文档结构
tree -L 2
```

### Smart Platform 相关
```bash
# 项目路径
cd /Users/freeman/Documents/00-Project/smart-platform

# 常用端口
# System: 48081
# Infra: 48082
# Eng: 48090
# Gateway: 48080
# 前端: 30000
```

## 开发环境

- **操作系统**: macOS (Darwin 25.3.0)
- **IDE**: Antigravity / VS Code
- **容器**: Docker
- **Java**: Spring Boot 微服务
- **前端**: (端口 30000)

## 注意事项

### 安全
- ⚠️ 不要提交包含敏感信息的文件（密码、密钥等）
- ⚠️ 清理脚本执行前务必备份重要数据
- ⚠️ sudo 命令需谨慎使用

### 最佳实践
- ✅ 文档修改后验证格式正确性
- ✅ 代码示例保持可运行性
- ✅ 定期更新过时的文档
- ✅ 重要操作提供回滚方案

## Claude Code 使用建议

### 文档编辑
- 使用 `@文件名` 引用具体文档
- 修改前先阅读完整内容
- 保持文档风格一致

### 学习辅助
- 参考 `CLAUDE_CODE_LEARNING_GUIDE.md` 学习 Claude Code
- 循序渐进，先掌握基础再进阶
- 实践中应用学到的技巧

### 项目维护
- 定期检查文档准确性
- 清理过时的临时文件
- 保持目录结构清晰
