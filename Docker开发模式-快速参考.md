# Docker + Antigravity 开发模式 - 快速参考

## 🚀 一键启动

```bash
cd /Users/freeman/Documents/00-Project/smart-platform
./docker-manage.sh
```

选择选项 1，启动所有 Docker 服务。

---

## 📝 核心命令

```bash
# 启动服务
docker-compose -f docker-compose.dev.yml up -d

# 查看状态
docker-compose -f docker-compose.dev.yml ps

# 查看日志
docker-compose -f docker-compose.dev.yml logs -f

# 停止服务
docker-compose -f docker-compose.dev.yml down
```

---

## 🎯 完整流程

### 1️⃣ 首次使用

```bash
# 构建镜像（首次需要 5-10 分钟）
cd /Users/freeman/Documents/00-Project/smart-platform
docker-compose -f docker-compose.dev.yml build

# 启动服务
docker-compose -f docker-compose.dev.yml up -d

# 验证
curl http://localhost:48081/actuator/health  # System
curl http://localhost:48082/actuator/health  # Infra
curl http://localhost:48080/actuator/health  # Gateway
```

### 2️⃣ 启动 Eng 模块（Antigravity）

```bash
# 打开项目
code /Users/freeman/Documents/00-Project/smart-platform

# 在 Spring Boot Dashboard 中：
# 1. 找到 zkjsplat-module-audit-eng-biz
# 2. 点击 ▶️ Run 或 🐛 Debug
# 3. 点击 📄 查看日志
```

### 3️⃣ 日常开发

```
修改 Eng 代码 → 保存 → (自动/手动重启) → 查看日志
```

---

## 🔍 日志查看

### Docker 服务日志

```bash
# 方式 1: 命令行
docker-compose -f docker-compose.dev.yml logs -f system-service

# 方式 2: 使用管理脚本
./docker-manage.sh  # 选择选项 5

# 方式 3: Antigravity Docker 扩展
# 左侧边栏 → Docker → 右键容器 → View Logs
```

### Eng 模块日志（Antigravity）

```
Spring Boot Dashboard → 📄 View Log → OUTPUT 面板
```

---

## ⚡ 常用场景

### 场景 1: 早上开始工作

```bash
# 启动 Docker 服务
./docker-manage.sh  # 选择 1

# 打开 Antigravity
code /Users/freeman/Documents/00-Project/smart-platform

# 启动 Eng 模块（Dashboard 中点击 ▶️）
```

### 场景 2: 更新了其他模块代码

```bash
# 重新构建并启动
./docker-manage.sh  # 选择 6

# 或手动
docker-compose -f docker-compose.dev.yml up -d --build
```

### 场景 3: 某个服务出问题

```bash
# 查看日志
docker-compose -f docker-compose.dev.yml logs system-service | grep ERROR

# 重启服务
docker-compose -f docker-compose.dev.yml restart system-service
```

### 场景 4: 下班

```bash
# 停止 Eng 模块（Dashboard 中点击 ⏹️）

# （可选）停止 Docker 服务
./docker-manage.sh  # 选择 2
```

---

## 📊 端口映射

| 服务 | 端口 | 访问地址 |
|------|------|---------|
| System | 48081 | http://localhost:48081 |
| Infra | 48082 | http://localhost:48082 |
| Gateway | 48080 | http://localhost:48080 |
| Eng (宿主机) | 48090 | http://localhost:48090 |

---

## 🛠️ 故障排查

### 问题: 服务启动失败

```bash
# 查看日志
docker-compose -f docker-compose.dev.yml logs service-name

# 查看错误
docker-compose -f docker-compose.dev.yml logs | grep ERROR
```

### 问题: 端口被占用

```bash
# 查看端口占用
lsof -i :48081

# 杀死进程
kill -9 <PID>
```

### 问题: Eng 访问不到 Docker 服务

```bash
# 确认服务启动
docker-compose -f docker-compose.dev.yml ps

# 测试连接
curl http://localhost:48081/actuator/health
```

---

## 💡 提示

- ✅ Docker 服务在后台运行，可以一直保持启动状态
- ✅ 只有 Eng 模块需要频繁重启
- ✅ 修改其他模块代码后，需要重新构建 Docker 镜像
- ✅ 使用 `./docker-manage.sh` 管理脚本更方便

---

## 📂 相关文件

```
smart-platform/
├── Dockerfile.system          # System Dockerfile
├── Dockerfile.infra           # Infra Dockerfile
├── Dockerfile.gateway         # Gateway Dockerfile
├── docker-compose.dev.yml     # Docker Compose 配置
└── docker-manage.sh           # 管理脚本 ⭐
```

---

## 🎯 内存占用

| 组件 | 内存 |
|------|------|
| Docker 服务 (3个) | ~2GB |
| Antigravity + Eng | ~2-3GB |
| **总计** | **~4-5GB** |

vs IDEA + 4个服务: 8-10GB ✅ 节省 40-50%

---

**最后更新**: 2026-01-07
**项目**: Smart Platform
**模式**: Docker + Antigravity 混合开发
