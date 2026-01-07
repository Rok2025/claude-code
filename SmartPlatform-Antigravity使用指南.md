# Smart Platform 在 Antigravity 中的启动和日志查看方案

## 您的项目情况

**项目路径**: `/Users/freeman/Documents/00-Project/smart-platform`

**主要模块**:
- System 模块 (端口 48081)
- Infra 模块 (端口 48082)
- Eng 模块 (端口 48090)
- Gateway 网关 (端口 48080)
- 前端项目 (端口 30000)

**当前启动方式**: 使用 `.agent/workflows/*.md` 文件中的命令

---

## 🏆 推荐方案：Spring Boot Dashboard（最简单）

### 为什么推荐？

✅ **无需配置** - 自动识别项目中的 Spring Boot 模块
✅ **可视化界面** - 类似 IDEA 的体验
✅ **日志独立显示** - 每个模块的日志单独查看
✅ **一键操作** - 启动、停止、重启都是一键完成

---

### 快速开始（5 分钟）

#### 步骤 1: 安装扩展（1 分钟）

打开 Antigravity，按 `Cmd+Shift+X` 打开扩展市场，搜索并安装：

1. **Spring Boot Dashboard** (必装)
2. **Spring Boot Tools** (推荐)
3. **Java Extension Pack** (如果还没装)

或使用命令行：
```bash
code --install-extension vscjava.vscode-spring-boot-dashboard
code --install-extension vmware.vscode-spring-boot
code --install-extension vscjava.vscode-java-pack
```

---

#### 步骤 2: 打开项目（10 秒）

```bash
cd /Users/freeman/Documents/00-Project/smart-platform
code .
```

---

#### 步骤 3: 查看 Spring Boot Dashboard（10 秒）

安装完成后，左侧边栏会出现 **Spring Boot** 图标（像一片叶子 🍃）

点击图标，会看到类似这样的列表：

```
SPRING BOOT DASHBOARD
├─ zkjsplat-module-system
│  └─ 🍃 SystemApplication
├─ zkjsplat-module-infra
│  └─ 🍃 InfraApplication
├─ zkjsplat-module-audit-eng
│  └─ 🍃 EngApplication
├─ zkjsplat-gateway
│  └─ 🍃 GatewayApplication
└─ ... (其他模块)
```

---

#### 步骤 4: 配置启动参数（2 分钟）

您的项目使用 `local` profile，需要配置一下启动参数。

**方式 1: 直接配置（推荐）**

1. 在项目根目录找到或创建 `.vscode/launch.json`
2. 添加配置：

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "java",
      "name": "System 模块",
      "request": "launch",
      "mainClass": "找到的主类名",
      "projectName": "zkjsplat-module-system-biz",
      "args": "",
      "vmArgs": "-Dspring.profiles.active=local -Xmx512m"
    },
    {
      "type": "java",
      "name": "Infra 模块",
      "request": "launch",
      "mainClass": "找到的主类名",
      "projectName": "zkjsplat-module-infra-biz",
      "args": "",
      "vmArgs": "-Dspring.profiles.active=local -Xmx512m"
    },
    {
      "type": "java",
      "name": "Eng 模块",
      "request": "launch",
      "mainClass": "找到的主类名",
      "projectName": "zkjsplat-module-audit-eng-biz",
      "args": "",
      "vmArgs": "-Dspring.profiles.active=local -Xmx512m"
    },
    {
      "type": "java",
      "name": "Gateway 网关",
      "request": "launch",
      "mainClass": "找到的主类名",
      "projectName": "zkjsplat-gateway",
      "args": "",
      "vmArgs": "-Dspring.profiles.active=local -Xmx512m"
    }
  ]
}
```

**方式 2: 让 Dashboard 自动生成**

1. 在 Dashboard 中右键某个应用
2. 选择 `Open Config`
3. 会自动创建配置文件
4. 手动添加 `"vmArgs": "-Dspring.profiles.active=local"`

---

#### 步骤 5: 启动模块（1 分钟）

在 Spring Boot Dashboard 中：

1. 找到 `SystemApplication`，点击右侧的 **▶️ Run** 按钮
2. 找到 `InfraApplication`，点击 **▶️**
3. 找到 `EngApplication`，点击 **▶️**
4. 找到 `GatewayApplication`，点击 **▶️**

**状态指示**：
- 🟢 绿点 = 运行中
- 🔴 红点 = 已停止
- 🟡 黄点 = 启动中

---

#### 步骤 6: 查看日志（关键！）

**这是您最关心的部分！**

有 3 种方式查看日志：

##### 方式 A: 通过 Dashboard（最方便）

1. 在 Dashboard 中，找到已启动的服务
2. 点击服务名称旁边的 **📄 View Log** 图标
3. 底部会打开 `OUTPUT` 面板，显示该服务的日志

```
┌──────────────────────────────────────────┐
│ OUTPUT                    ▼ Spring Boot: │
├──────────────────────────────────────────┤
│ 选择输出通道：                            │
│   • Spring Boot: System    ← 当前        │
│   • Spring Boot: Infra                   │
│   • Spring Boot: Eng                     │
│   • Spring Boot: Gateway                 │
└──────────────────────────────────────────┘
```

**切换查看不同模块的日志**：
- 点击 OUTPUT 面板右上角的下拉菜单
- 选择对应的服务

##### 方式 B: 通过终端查看

Dashboard 启动的服务，日志也会在专门的终端中显示。

点击底部 `TERMINAL` 标签，会看到每个服务的终端：

```
TERMINAL
├─ Spring Boot: System
├─ Spring Boot: Infra
├─ Spring Boot: Eng
└─ Spring Boot: Gateway
```

点击对应标签切换查看。

##### 方式 C: 搜索日志

在 OUTPUT 面板中：
- 按 `Cmd+F` 打开搜索
- 输入关键词（如 `ERROR`, `Exception`, `SQL`）
- 快速定位问题

---

### 常见操作

#### 重启某个模块

1. 在 Dashboard 中找到该模块
2. 点击 **🔄 Restart** 图标

或者：
1. 点击 **⏹️ Stop**
2. 再点击 **▶️ Run**

---

#### 停止所有服务

逐个点击每个服务的 **⏹️ Stop** 按钮

---

#### 只查看某个模块的错误日志

在 OUTPUT 面板中：
1. 选择对应模块的输出通道
2. 按 `Cmd+F` 搜索 `ERROR` 或 `Exception`

---

#### 同时查看多个模块日志

**方案 1: 快速切换**
- 在 OUTPUT 面板下拉菜单中切换不同模块

**方案 2: 分屏显示（推荐）**
1. 打开第一个模块的 OUTPUT
2. 右键 OUTPUT 面板标题栏
3. 选择 `Split Editor Right`
4. 在新面板中打开另一个模块的日志

```
┌────────────────┬────────────────┐
│ System 日志    │ Infra 日志     │
│                │                │
└────────────────┴────────────────┘
```

**方案 3: 使用终端分屏（进阶）**
1. 打开终端
2. 点击右上角的分屏按钮
3. 可以创建 2x2 网格，同时看 4 个服务日志

---

## 备选方案：使用集成终端（无需扩展）

如果不想安装 Spring Boot Dashboard，可以直接使用终端。

### 步骤 1: 打开项目

```bash
cd /Users/freeman/Documents/00-Project/smart-platform
code .
```

---

### 步骤 2: 打开 4 个终端

1. 按 `Ctrl+` ` 打开终端
2. 点击终端右上角的 **+** 创建新终端
3. 重复创建 4 个终端
4. 为每个终端重命名（点击终端标签旁的下拉箭头 → Rename）

```
TERMINAL
├─ 1: System
├─ 2: Infra
├─ 3: Eng
└─ 4: Gateway
```

---

### 步骤 3: 在每个终端启动对应服务

复制您 workflows 中的命令：

**Terminal 1 - System**
```bash
mvn spring-boot:run -pl zkjsplat-module-system/zkjsplat-module-system-biz -Dspring-boot.run.profiles=local
```

**Terminal 2 - Infra**
```bash
mvn spring-boot:run -pl zkjsplat-module-infra/zkjsplat-module-infra-biz -Dspring-boot.run.profiles=local
```

**Terminal 3 - Eng**
```bash
mvn spring-boot:run -pl zkjsplat-module-audit-eng/zkjsplat-module-audit-eng-biz -Dspring-boot.run.profiles=local
```

**Terminal 4 - Gateway**
```bash
mvn spring-boot:run -pl zkjsplat-gateway -Dspring-boot.run.profiles=local
```

---

### 步骤 4: 查看日志

**日志直接显示在各自的终端中**

- 点击底部终端标签切换
- 或使用快捷键 `Cmd+K Cmd+↑/↓`

---

### 优化：终端分屏

右键终端 → `Split Terminal`

可以创建 2x2 布局，同时查看 4 个服务：

```
┌──────────────┬──────────────┐
│ System       │ Infra        │
│ 启动日志...  │ 启动日志...  │
├──────────────┼──────────────┤
│ Eng          │ Gateway      │
│ 启动日志...  │ 启动日志...  │
└──────────────┴──────────────┘
```

---

## 高级方案：Tasks 配置（一键启动所有）

### 创建 `.vscode/tasks.json`

在项目根目录创建此文件：

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "启动 System 模块",
      "type": "shell",
      "command": "mvn spring-boot:run -pl zkjsplat-module-system/zkjsplat-module-system-biz -Dspring-boot.run.profiles=local",
      "isBackground": true,
      "problemMatcher": {
        "pattern": {
          "regexp": "^(.*)$",
          "file": 1,
          "location": 2,
          "message": 3
        },
        "background": {
          "activeOnStart": true,
          "beginsPattern": "^.*Scanning for projects.*$",
          "endsPattern": "^.*Started.*Application in.*seconds.*$"
        }
      },
      "presentation": {
        "reveal": "always",
        "panel": "dedicated",
        "group": "backend"
      }
    },
    {
      "label": "启动 Infra 模块",
      "type": "shell",
      "command": "mvn spring-boot:run -pl zkjsplat-module-infra/zkjsplat-module-infra-biz -Dspring-boot.run.profiles=local",
      "isBackground": true,
      "problemMatcher": {
        "pattern": {
          "regexp": "^(.*)$",
          "file": 1,
          "location": 2,
          "message": 3
        },
        "background": {
          "activeOnStart": true,
          "beginsPattern": "^.*Scanning for projects.*$",
          "endsPattern": "^.*Started.*Application in.*seconds.*$"
        }
      },
      "presentation": {
        "reveal": "always",
        "panel": "dedicated",
        "group": "backend"
      }
    },
    {
      "label": "启动 Eng 模块",
      "type": "shell",
      "command": "mvn spring-boot:run -pl zkjsplat-module-audit-eng/zkjsplat-module-audit-eng-biz -Dspring-boot.run.profiles=local",
      "isBackground": true,
      "problemMatcher": {
        "pattern": {
          "regexp": "^(.*)$",
          "file": 1,
          "location": 2,
          "message": 3
        },
        "background": {
          "activeOnStart": true,
          "beginsPattern": "^.*Scanning for projects.*$",
          "endsPattern": "^.*Started.*Application in.*seconds.*$"
        }
      },
      "presentation": {
        "reveal": "always",
        "panel": "dedicated",
        "group": "backend"
      }
    },
    {
      "label": "启动 Gateway",
      "type": "shell",
      "command": "mvn spring-boot:run -pl zkjsplat-gateway -Dspring-boot.run.profiles=local",
      "isBackground": true,
      "problemMatcher": {
        "pattern": {
          "regexp": "^(.*)$",
          "file": 1,
          "location": 2,
          "message": 3
        },
        "background": {
          "activeOnStart": true,
          "beginsPattern": "^.*Scanning for projects.*$",
          "endsPattern": "^.*Started.*Application in.*seconds.*$"
        }
      },
      "presentation": {
        "reveal": "always",
        "panel": "dedicated",
        "group": "backend"
      }
    },
    {
      "label": "启动所有后端服务",
      "dependsOn": [
        "启动 System 模块",
        "启动 Infra 模块",
        "启动 Eng 模块",
        "启动 Gateway"
      ],
      "dependsOrder": "parallel"
    }
  ]
}
```

---

### 使用方法

1. 按 `Cmd+Shift+P` 打开命令面板
2. 输入 `Tasks: Run Task`
3. 选择 `启动所有后端服务`

**一键启动所有服务！**

每个服务会在独立的终端面板中运行，日志分别显示。

---

### 查看日志

底部会出现多个终端：

```
TERMINAL
├─ Task - 启动 System 模块
├─ Task - 启动 Infra 模块
├─ Task - 启动 Eng 模块
└─ Task - 启动 Gateway
```

点击标签切换查看不同服务的日志。

---

## 方案对比

| 方案 | 优点 | 缺点 | 日志查看 | 推荐度 |
|------|------|------|---------|--------|
| **Spring Boot Dashboard** | • 可视化<br>• 类似 IDEA<br>• 一键操作 | • 需要安装扩展 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **集成终端** | • 无需配置<br>• 立即可用 | • 需要手动输命令 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Tasks 配置** | • 一键启动所有<br>• 标准化 | • 需要配置文件 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

---

## 我的推荐

### 🏆 最佳组合

**日常开发**：
1. 安装 **Spring Boot Dashboard**
2. 在 Dashboard 中点击启动需要的模块
3. 在 OUTPUT 面板查看日志
4. 下拉菜单快速切换不同模块日志

**需要同时监控多个服务**：
1. 使用终端分屏（2x2 网格）
2. 每个窗格显示一个服务日志
3. 实时对比

---

## 验证服务是否启动成功

### 方式 1: 查看日志

在日志中搜索：`Started.*Application in`

### 方式 2: 健康检查（推荐）

在 Antigravity 终端中运行：

```bash
# 检查 System 模块
curl -s http://localhost:48081/actuator/health

# 检查 Infra 模块
curl -s http://localhost:48082/actuator/health

# 检查 Eng 模块
curl -s http://localhost:48090/actuator/health

# 检查 Gateway
curl -s http://localhost:48080/actuator/health
```

返回 `{"status":"UP"}` 表示成功。

---

## 常见问题

### Q: 日志太多，如何过滤？

在 OUTPUT 或终端中：
1. 按 `Cmd+F` 打开搜索
2. 输入关键词（如 `ERROR`, `SQLException`, `用户`）
3. 使用上下箭头跳转

### Q: 如何只看某个时间段的日志？

由于是实时日志，建议：
1. 在操作前清空日志（右键 OUTPUT → Clear Output）
2. 执行操作
3. 查看新日志

### Q: 日志输出中文乱码？

在 `.vscode/settings.json` 中添加：
```json
{
  "java.jdt.ls.vmargs": "-Dfile.encoding=UTF-8"
}
```

### Q: 某个模块启动失败，如何排查？

1. 在对应模块的日志中搜索 `ERROR` 或 `Exception`
2. 查看端口是否被占用：
   ```bash
   lsof -i :48081
   ```
3. 检查配置文件（`application-local.yml`）

---

## 快速开始清单

✅ **安装扩展**
```bash
code --install-extension vscjava.vscode-spring-boot-dashboard
```

✅ **打开项目**
```bash
cd /Users/freeman/Documents/00-Project/smart-platform
code .
```

✅ **启动服务**
- 点击左侧 Spring Boot 图标
- 逐个点击服务的 ▶️ 按钮

✅ **查看日志**
- 点击服务的 📄 图标
- 在 OUTPUT 面板查看
- 下拉菜单切换不同服务

**完成！**

---

## 下一步

如果您经常需要同时启动这 4 个服务，建议：

1. 创建 `tasks.json`（使用上面的配置）
2. 创建快捷键绑定
3. 一键启动所有服务

或者：

1. 使用 Docker Compose
2. 将服务容器化
3. 进一步减少内存占用

---

**最后更新**: 2026-01-07
**项目**: Smart Platform
**适用工具**: Antigravity / VS Code
