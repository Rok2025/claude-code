# Docker + Antigravity 混合开发模式使用指南

## 🎯 方案概述

**架构**：
```
┌──────────────────────────────────┐
│  Docker 容器                      │
│  ├─ System 模块 (48081)          │
│  ├─ Infra 模块 (48082)           │
│  └─ Gateway 网关 (48080)         │
└──────────────────────────────────┘
           ↕
┌──────────────────────────────────┐
│  Antigravity (宿主机)            │
│  └─ Eng 模块 (48090) ← 您开发的 │
└──────────────────────────────────┘
```

**优势**：
- ✅ **内存占用低**：Docker 服务共用约 2GB，Antigravity + Eng 约 2-3GB，总计 4-5GB
- ✅ **Eng 日志清晰**：只看 Eng 模块日志，无其他服务干扰
- ✅ **启动快**：其他服务在后台运行，只需启动 Eng 模块
- ✅ **调试方便**：Eng 模块可以断点调试，其他服务稳定运行

---

## 📁 文件说明

已为您创建以下文件：

```
smart-platform/
├── Dockerfile.system          # System 模块 Dockerfile
├── Dockerfile.infra           # Infra 模块 Dockerfile
├── Dockerfile.gateway         # Gateway 模块 Dockerfile
└── docker-compose.dev.yml     # Docker Compose 配置文件
```

---

## 🚀 快速开始

### 第一步：构建 Docker 镜像（首次或代码更新后）

```bash
cd /Users/freeman/Documents/00-Project/smart-platform

# 构建所有服务镜像（首次需要 5-10 分钟）
docker-compose -f docker-compose.dev.yml build

# 或者单独构建某个服务
docker-compose -f docker-compose.dev.yml build system-service
```

**说明**：
- 使用多阶段构建，自动编译 Maven 项目
- 镜像构建完成后，后续启动非常快

---

### 第二步：启动 Docker 服务

```bash
# 启动所有服务（后台运行）
docker-compose -f docker-compose.dev.yml up -d

# 查看服务状态
docker-compose -f docker-compose.dev.yml ps
```

**预期输出**：
```
NAME            STATUS          PORTS
zkjs-system     Up 30 seconds   0.0.0.0:48081->48081/tcp
zkjs-infra      Up 30 seconds   0.0.0.0:48082->48082/tcp
zkjs-gateway    Up 30 seconds   0.0.0.0:48080->48080/tcp
```

---

### 第三步：验证服务启动

```bash
# 检查 System 模块
curl http://localhost:48081/actuator/health

# 检查 Infra 模块
curl http://localhost:48082/actuator/health

# 检查 Gateway
curl http://localhost:48080/actuator/health
```

**成功响应**：
```json
{"status":"UP"}
```

---

### 第四步：在 Antigravity 中启动 Eng 模块

1. **打开项目**
   ```bash
   cd /Users/freeman/Documents/00-Project/smart-platform
   code .
   ```

2. **使用 Spring Boot Dashboard 启动**
   - 点击左侧 Spring Boot 图标 🍃
   - 找到 **zkjsplat-module-audit-eng-biz**
   - 点击 **▶️ Run** 或 **🐛 Debug**

3. **查看 Eng 日志**
   - 点击 **📄 View Log** 图标
   - 在 OUTPUT 面板查看日志
   - 只显示 Eng 模块日志，清晰无干扰！

---

### 第五步：验证 Eng 模块

```bash
# 检查 Eng 模块
curl http://localhost:48090/actuator/health
```

---

## 📊 查看日志

### 查看 Docker 服务日志

```bash
# 查看所有服务日志
docker-compose -f docker-compose.dev.yml logs -f

# 查看单个服务日志
docker-compose -f docker-compose.dev.yml logs -f system-service
docker-compose -f docker-compose.dev.yml logs -f infra-service
docker-compose -f docker-compose.dev.yml logs -f gateway-service

# 查看最近 100 行
docker-compose -f docker-compose.dev.yml logs --tail=100 system-service

# 只看错误日志
docker-compose -f docker-compose.dev.yml logs | grep ERROR
```

### 查看 Eng 模块日志（在 Antigravity）

- 在 OUTPUT 面板直接查看
- 或者在集成终端查看
- 按 `Cmd+F` 搜索关键词

---

## 🛠️ 日常使用

### 早上开始工作

```bash
# 1. 启动 Docker 服务（如果没启动）
cd /Users/freeman/Documents/00-Project/smart-platform
docker-compose -f docker-compose.dev.yml up -d

# 2. 打开 Antigravity
code .

# 3. 在 Spring Boot Dashboard 中启动 Eng 模块
#    点击 ▶️ 或 🐛
```

**内存占用**：约 4-5GB

---

### 开发过程

```bash
# 1. 修改 Eng 模块代码
# 2. 保存（Cmd+S）
# 3. 如果配置了 DevTools，会自动重启
# 4. 查看日志确认变更生效
```

---

### 下班

```bash
# 1. 停止 Eng 模块
#    在 Dashboard 中点击 ⏹️

# 2. （可选）停止 Docker 服务
docker-compose -f docker-compose.dev.yml down

# 或者保持 Docker 服务运行，明天直接用
```

---

## 🔄 常用命令

### Docker Compose 管理

```bash
# 启动所有服务
docker-compose -f docker-compose.dev.yml up -d

# 停止所有服务
docker-compose -f docker-compose.dev.yml stop

# 停止并删除容器
docker-compose -f docker-compose.dev.yml down

# 重启服务
docker-compose -f docker-compose.dev.yml restart

# 重启单个服务
docker-compose -f docker-compose.dev.yml restart system-service

# 查看服务状态
docker-compose -f docker-compose.dev.yml ps

# 查看资源占用
docker stats
```

---

### 重新构建（代码更新后）

```bash
# 停止服务
docker-compose -f docker-compose.dev.yml down

# 重新构建并启动
docker-compose -f docker-compose.dev.yml up -d --build

# 或者只重建某个服务
docker-compose -f docker-compose.dev.yml up -d --build system-service
```

---

### 进入容器内部

```bash
# 进入容器
docker-compose -f docker-compose.dev.yml exec system-service bash

# 或使用 sh（如果没有 bash）
docker-compose -f docker-compose.dev.yml exec system-service sh

# 查看容器内的日志文件
docker-compose -f docker-compose.dev.yml exec system-service cat /app/logs/app.log
```

---

## 🐛 调试技巧

### Eng 模块调试（在 Antigravity）

1. **设置断点**
   - 在代码行号左侧点击，设置断点

2. **以 Debug 模式启动**
   - 在 Dashboard 中点击 **🐛 Debug** 图标

3. **触发请求**
   - 使用浏览器或 Postman 发送请求

4. **断点暂停**
   - 程序在断点处暂停
   - 查看变量值、调用堆栈

5. **单步执行**
   - F10：单步跳过
   - F11：单步进入
   - Shift+F11：跳出

---

### Docker 服务问题排查

```bash
# 查看服务日志中的错误
docker-compose -f docker-compose.dev.yml logs system-service | grep -i error

# 查看容器资源占用
docker stats zkjs-system zkjs-infra zkjs-gateway

# 重启有问题的服务
docker-compose -f docker-compose.dev.yml restart system-service

# 查看健康检查状态
docker inspect zkjs-system | grep -A 10 Health
```

---

## 🔧 配置说明

### 端口映射

| 服务 | 容器端口 | 宿主机端口 | 说明 |
|------|---------|-----------|------|
| System | 48081 | 48081 | 系统模块 |
| Infra | 48082 | 48082 | 基础设施模块 |
| Gateway | 48080 | 48080 | 网关 |
| Eng (宿主机) | 48090 | 48090 | 您开发的模块 |

所有服务都可以通过 `localhost:端口` 访问。

---

### 资源限制

每个服务限制：
- **CPU**: 最多 1 核
- **内存**: 最多 768MB
- **预留内存**: 512MB

可以根据实际情况在 `docker-compose.dev.yml` 中调整。

---

### 网络配置

所有服务在同一个网络 `smart-platform-network` 中：
- Docker 容器之间可以通过服务名访问（如 `http://system-service:48081`）
- 宿主机上的 Eng 模块通过 `localhost` 访问 Docker 服务

---

## 📝 进阶技巧

### 1. 配置热重载（Eng 模块）

在 `zkjsplat-module-audit-eng-biz/pom.xml` 中添加：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <optional>true</optional>
</dependency>
```

修改代码后自动重启，无需手动操作！

---

### 2. 只启动部分服务

```bash
# 只启动 System 和 Gateway
docker-compose -f docker-compose.dev.yml up -d system-service gateway-service

# 停止不需要的服务
docker-compose -f docker-compose.dev.yml stop infra-service
```

---

### 3. 查看实时日志

**在 Antigravity 的集成终端中**：

```bash
# 新建终端（Ctrl+`）
# 实时查看所有 Docker 服务日志
docker-compose -f docker-compose.dev.yml logs -f
```

可以分屏显示：
- 左侧：Docker 服务日志
- 右侧：Eng 模块日志（OUTPUT 面板）

---

### 4. 使用 Antigravity Docker 扩展

安装扩展：
```bash
code --install-extension ms-azuretools.vscode-docker
```

功能：
- 左侧边栏查看容器列表
- 右键容器查看日志
- 一键启动/停止容器
- 查看容器资源占用

---

## ❓ 常见问题

### Q1: 首次构建很慢怎么办？

**A**: 首次构建需要下载 Maven 依赖，可能需要 5-10 分钟。

**加速方法**：
1. 使用国内 Maven 镜像
2. 构建完成后，后续启动很快

---

### Q2: Eng 模块访问 Docker 服务失败？

**A**: 确认 Docker 服务已启动：

```bash
docker-compose -f docker-compose.dev.yml ps
```

检查服务健康状态：
```bash
curl http://localhost:48081/actuator/health
```

---

### Q3: Docker 容器启动失败？

**A**: 查看日志排查：

```bash
# 查看启动日志
docker-compose -f docker-compose.dev.yml logs system-service

# 查看错误信息
docker-compose -f docker-compose.dev.yml logs system-service | grep -i error
```

常见原因：
- 端口被占用
- 配置文件错误
- 依赖服务未启动

---

### Q4: 如何更新 Docker 中的代码？

**A**: 重新构建镜像：

```bash
# 停止服务
docker-compose -f docker-compose.dev.yml down

# 重新构建并启动
docker-compose -f docker-compose.dev.yml up -d --build
```

---

### Q5: Docker 占用磁盘空间太大？

**A**: 清理未使用的资源：

```bash
# 删除停止的容器
docker container prune

# 删除未使用的镜像
docker image prune -a

# 删除未使用的卷
docker volume prune

# 一键清理所有
docker system prune -a
```

---

### Q6: 想查看某个服务的完整日志？

**A**: 导出日志到文件：

```bash
docker-compose -f docker-compose.dev.yml logs system-service > system.log
```

然后在 Antigravity 中打开 `system.log` 文件查看。

---

## 📊 性能对比

| 方案 | 内存占用 | 启动时间 | 日志清晰度 | 推荐度 |
|------|---------|---------|-----------|--------|
| IDEA + 4个服务 | 8-10GB | 慢 | ⭐⭐⭐ | ⭐⭐ |
| Antigravity + 4个服务 | 4-5GB | 中等 | ⭐⭐⭐ | ⭐⭐⭐ |
| **Docker (3) + Antigravity (1)** | **4-5GB** | **快** | **⭐⭐⭐⭐⭐** | **⭐⭐⭐⭐⭐** |

---

## 🎯 工作流总结

### 推荐的日常流程

```bash
# ========== 早上 ==========
# 1. 启动 Docker 服务
cd /Users/freeman/Documents/00-Project/smart-platform
docker-compose -f docker-compose.dev.yml up -d

# 2. 打开 Antigravity
code .

# 3. 在 Dashboard 中启动 Eng 模块（▶️ 或 🐛）

# ========== 开发中 ==========
# 4. 修改 Eng 代码
# 5. 保存后自动/手动重启
# 6. 在 OUTPUT 面板查看日志

# ========== 需要时 ==========
# 7. 查看其他服务日志
docker-compose -f docker-compose.dev.yml logs -f system-service

# 8. 重启某个 Docker 服务
docker-compose -f docker-compose.dev.yml restart infra-service

# ========== 下班 ==========
# 9. 停止 Eng 模块（⏹️）
# 10. （可选）停止 Docker 服务
docker-compose -f docker-compose.dev.yml down
```

---

## 📚 附录

### 快捷命令别名（可选）

在 `~/.zshrc` 或 `~/.bashrc` 中添加：

```bash
# Smart Platform Docker 快捷命令
alias sp-up='cd /Users/freeman/Documents/00-Project/smart-platform && docker-compose -f docker-compose.dev.yml up -d'
alias sp-down='cd /Users/freeman/Documents/00-Project/smart-platform && docker-compose -f docker-compose.dev.yml down'
alias sp-logs='cd /Users/freeman/Documents/00-Project/smart-platform && docker-compose -f docker-compose.dev.yml logs -f'
alias sp-ps='cd /Users/freeman/Documents/00-Project/smart-platform && docker-compose -f docker-compose.dev.yml ps'
alias sp-restart='cd /Users/freeman/Documents/00-Project/smart-platform && docker-compose -f docker-compose.dev.yml restart'
```

使用：
```bash
sp-up      # 启动所有服务
sp-down    # 停止所有服务
sp-logs    # 查看日志
sp-ps      # 查看状态
```

---

### 目录结构

```
smart-platform/
├── Dockerfile.system              # System 模块 Dockerfile
├── Dockerfile.infra               # Infra 模块 Dockerfile
├── Dockerfile.gateway             # Gateway 模块 Dockerfile
├── docker-compose.dev.yml         # Docker Compose 配置
├── zkjsplat-module-system/        # System 模块源码
├── zkjsplat-module-infra/         # Infra 模块源码
├── zkjsplat-gateway/              # Gateway 源码
└── zkjsplat-module-audit-eng/     # Eng 模块源码（您主要开发）
```

---

## ✅ 检查清单

启动前确认：
- [ ] Docker Desktop 已安装并运行
- [ ] 项目在 `/Users/freeman/Documents/00-Project/smart-platform`
- [ ] 已创建 Dockerfile.system、Dockerfile.infra、Dockerfile.gateway
- [ ] 已创建 docker-compose.dev.yml
- [ ] Antigravity 已安装 Spring Boot Dashboard 扩展

启动后确认：
- [ ] Docker 服务状态为 `Up`
- [ ] 健康检查返回 `{"status":"UP"}`
- [ ] Eng 模块在 Antigravity 中成功启动
- [ ] 可以在 OUTPUT 面板看到 Eng 日志

---

**最后更新**: 2026-01-07
**适用项目**: Smart Platform
**开发模式**: Docker + Antigravity 混合
