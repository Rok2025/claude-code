# Gemini / Antigravity 项目配置

## 项目概述

这是一个由 Antigravity 驱动的微服务开发文档和工具集项目，主要包含：

- **Smart Platform** - 微服务架构项目的文档和配置
  - System 模块 (48081)
  - Infra 模块 (48082)
  - Eng 模块 (48090) - 主开发模块
  - Gateway 网关 (48080)
  - 前端项目 (30000)

- **开发工具与规则**
  -项目规则见：[.gemini/rules/project_rules.md](file:///Users/freeman/Documents/00-Project/claude_code/.gemini/rules/project_rules.md)
  -自动化工作流见：[.agent/workflows/](file:///Users/freeman/Documents/00-Project/claude_code/.agent/workflows/)

## 核心开发规则 (详见 project_rules.md)

1. **文档规范**：使用中文命名，技术名词保持英文。
2. **Eng 模块开发**：仅在 Antigravity 中本地启动 Eng 模块，其他依赖使用 Docker 运行。
3. **日志查看**：专注查看 OUTPUT 面板中的 Eng 模块日志。
4. **热重载**：利用 Spring Boot DevTools 实现自动编译与重启。

## 常用工作流

使用 `/` 命令调用以下工作流：

- **/start-eng**: 本地启动 Eng 模块（Run/Debug 模式）。
- **/start-deps**: 通过 Docker 启动 System, Infra, Gateway 等依赖服务。

## 常用命令

```bash
# 查看所有文档
ls *.md

# 启动 Eng 模块 (命令行方式)
mvn spring-boot:run -pl zkjsplat-module-audit-eng/zkjsplat-module-audit-eng-biz -Dspring-boot.run.profiles=local

# Docker 操作
docker-compose up -d [service]
docker-compose ps
```

## 注意事项

- ⚠️ 严禁提交敏感信息。
- ✅ 修改文档后务必进行格式验证。
- ✅ 优先通过集成工具（Spring Boot Dashboard）管理服务。
