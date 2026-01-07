# Antigravity 启动微服务和查看日志完整方案

## 目录
- [方案概览](#方案概览)
- [推荐方案：Spring Boot Dashboard](#推荐方案spring-boot-dashboard)
- [方案二：集成终端](#方案二集成终端)
- [方案三：Tasks 配置](#方案三tasks-配置)
- [方案四：多终端分屏](#方案四多终端分屏)
- [对比总结](#对比总结)

---

## 方案概览

| 方案 | 难度 | 日志查看便利度 | 推荐度 |
|------|------|---------------|--------|
| **Spring Boot Dashboard** | ⭐ | ⭐⭐⭐⭐⭐ | **⭐⭐⭐⭐⭐** |
| 集成终端 | ⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| Tasks 配置 | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| 多终端分屏 | ⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

---

## 推荐方案：Spring Boot Dashboard

### 这是什么？

Spring Boot Dashboard 是 VS Code（Antigravity）的官方扩展，提供类似 IDEA Services 窗口的功能。

**核心功能**：
- ✅ 可视化管理所有 Spring Boot 应用
- ✅ 一键启动/停止服务
- ✅ 专门的输出窗口查看每个服务的日志
- ✅ 支持调试模式启动
- ✅ 自动发现项目中的 Spring Boot 模块

---

### 步骤 1: 安装扩展

#### 方式 A: 通过扩展市场（推荐）

1. 打开 Antigravity
2. 点击左侧边栏的扩展图标（或按 `Cmd+Shift+X`）
3. 搜索：`Spring Boot Dashboard`
4. 找到 `Spring Boot Dashboard` by **Microsoft**
5. 点击 **Install** 安装

#### 方式 B: 通过命令行

```bash
code --install-extension vscjava.vscode-spring-boot-dashboard
```

#### 同时推荐安装这些扩展（增强体验）

```bash
# Spring Boot 工具
code --install-extension vmware.vscode-spring-boot

# Java 扩展包（包含调试、Maven 等）
code --install-extension vscjava.vscode-java-pack

# Lombok 支持（如果项目使用了）
code --install-extension GabrielBB.vscode-lombok
```

---

### 步骤 2: 打开 Spring Boot Dashboard

安装完成后，有两种方式打开：

**方式 1: 侧边栏**
- 左侧边栏会出现 Spring Boot 图标（像一片叶子）
- 点击即可打开 Dashboard

**方式 2: 命令面板**
- 按 `Cmd+Shift+P` 打开命令面板
- 输入 `Spring Boot Dashboard`
- 选择 `Spring Boot Dashboard: Focus on Spring Boot Dashboard View`

---

### 步骤 3: 使用 Dashboard 启动服务

#### Dashboard 界面说明

```
SPRING BOOT DASHBOARD
├─ 📁 user-service
│  └─ 🍃 UserServiceApplication
├─ 📁 order-service
│  └─ 🍃 OrderServiceApplication
├─ 📁 product-service
│  └─ 🍃 ProductServiceApplication
└─ 📁 payment-service
   └─ 🍃 PaymentServiceApplication
```

#### 启动服务

在 Dashboard 中，每个应用右侧有几个图标：

- **▶️ Run** - 普通模式启动
- **🐛 Debug** - 调试模式启动
- **⏹️ Stop** - 停止服务
- **🔄 Restart** - 重启服务
- **📄 Open Log** - 打开日志输出

**操作步骤**：
1. 找到要启动的服务（如 `UserServiceApplication`）
2. 点击右侧的 **▶️ Run** 按钮
3. 服务启动后，图标会变成 **⏹️ Stop**
4. 点击 **📄** 图标查看日志

---

### 步骤 4: 查看日志

#### 方式 A: 通过 Dashboard（推荐）

1. 在 Dashboard 中，点击已启动服务旁边的 **📄** 图标
2. 底部会打开 `OUTPUT` 面板，显示该服务的日志
3. 可以同时打开多个服务的日志，通过下拉菜单切换

```
┌─────────────────────────────────────────┐
│ OUTPUT                          ▼       │
├─────────────────────────────────────────┤
│ 选择输出通道:                            │
│   • Spring Boot: user-service    ← 切换 │
│   • Spring Boot: order-service          │
│   • Spring Boot: product-service        │
└─────────────────────────────────────────┘
```

#### 方式 B: 通过终端查看（补充）

Dashboard 启动的服务，日志也会在集成终端中显示。

---

### 步骤 5: 管理多个服务

#### 同时启动多个服务

逐个点击每个服务的 **▶️** 按钮，或者：

1. 右键点击服务
2. 选择 `Run` 或 `Debug`

#### 查看服务状态

- 🟢 **绿色点** - 服务正在运行
- 🔴 **红色点** - 服务已停止
- 🟡 **黄色点** - 服务正在启动

#### 停止所有服务

逐个点击 **⏹️** 按钮，或者关闭 Antigravity 时会提示是否停止所有服务。

---

### 高级功能

#### 1. 配置启动参数

如果需要自定义启动参数（如端口、profile 等）：

1. 右键服务
2. 选择 `Open Config`
3. 会打开 `.vscode/launch.json`
4. 可以配置 JVM 参数、环境变量等

示例配置：

```json
{
  "type": "java",
  "name": "Spring Boot-UserServiceApplication",
  "request": "launch",
  "cwd": "${workspaceFolder}/user-service",
  "mainClass": "com.example.UserServiceApplication",
  "projectName": "user-service",
  "args": "",
  "envFile": "${workspaceFolder}/.env",
  "vmArgs": "-Xmx512m -Dspring.profiles.active=dev"
}
```

#### 2. 设置不同的 Profile

在 `application.properties` 或通过启动参数：

```bash
# 在 vmArgs 中添加
-Dspring.profiles.active=dev
```

#### 3. 实时热重载

安装 Spring Boot DevTools：

```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <optional>true</optional>
</dependency>
```

修改代码后，Antigravity 会自动触发重新编译，DevTools 会自动重启服务。

---

## 方案二：集成终端

### 适用场景
- 不想安装额外扩展
- 需要完全控制启动命令
- 习惯命令行操作

---

### 使用步骤

#### 步骤 1: 打开多个终端

1. 按 `Ctrl+` ` (反引号) 打开集成终端
2. 点击终端右上角的 **+** 按钮，创建多个终端
3. 为每个终端命名（点击终端标签，输入名称）

建议终端布局：
```
├─ Terminal 1: user-service
├─ Terminal 2: order-service
├─ Terminal 3: product-service
└─ Terminal 4: payment-service
```

---

#### 步骤 2: 在每个终端中启动服务

**Maven 项目**：

```bash
# Terminal 1 - user-service
cd user-service
mvn spring-boot:run

# Terminal 2 - order-service
cd order-service
mvn spring-boot:run

# Terminal 3 - product-service
cd product-service
mvn spring-boot:run
```

**Gradle 项目**：

```bash
# Terminal 1
cd user-service
./gradlew bootRun

# Terminal 2
cd order-service
./gradlew bootRun
```

**直接运行 JAR**：

```bash
# 先构建
mvn clean package -DskipTests

# 运行
java -jar target/user-service-0.0.1-SNAPSHOT.jar
```

---

#### 步骤 3: 查看日志

**日志直接显示在对应的终端窗口中**

切换终端即可查看不同服务的日志：
- 点击底部终端标签切换
- 或使用快捷键：`Cmd+K, Cmd+↑/↓`

---

#### 步骤 4: 停止服务

在对应的终端中按 `Ctrl+C` 停止服务

---

### 优化技巧

#### 1. 终端分屏

可以将终端分屏显示：

1. 右键终端标签
2. 选择 `Split Terminal`
3. 可以同时看到多个服务的日志

```
┌───────────────┬───────────────┐
│ user-service  │ order-service │
│               │               │
│ [日志输出...] │ [日志输出...] │
└───────────────┴───────────────┘
```

#### 2. 保存启动命令

创建终端配置文件（可选）

在项目根目录创建 `.vscode/settings.json`：

```json
{
  "terminal.integrated.profiles.osx": {
    "user-service": {
      "path": "bash",
      "args": ["-c", "cd user-service && mvn spring-boot:run"]
    },
    "order-service": {
      "path": "bash",
      "args": ["-c", "cd order-service && mvn spring-boot:run"]
    }
  }
}
```

然后可以在终端下拉菜单中直接选择启动。

---

## 方案三：Tasks 配置

### 适用场景
- 需要一键启动所有服务
- 需要标准化团队操作流程
- 经常重复启动相同服务

---

### 配置步骤

#### 步骤 1: 创建 tasks.json

在项目根目录创建 `.vscode/tasks.json`：

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "启动 user-service",
      "type": "shell",
      "command": "cd user-service && mvn spring-boot:run",
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
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "dedicated",
        "showReuseMessage": false,
        "clear": true,
        "group": "microservices"
      }
    },
    {
      "label": "启动 order-service",
      "type": "shell",
      "command": "cd order-service && mvn spring-boot:run",
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
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "dedicated",
        "showReuseMessage": false,
        "clear": true,
        "group": "microservices"
      }
    },
    {
      "label": "启动 product-service",
      "type": "shell",
      "command": "cd product-service && mvn spring-boot:run",
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
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "dedicated",
        "showReuseMessage": false,
        "clear": true,
        "group": "microservices"
      }
    },
    {
      "label": "启动所有微服务",
      "dependsOn": [
        "启动 user-service",
        "启动 order-service",
        "启动 product-service"
      ],
      "dependsOrder": "parallel"
    }
  ]
}
```

---

#### 步骤 2: 运行 Task

**方式 1: 通过命令面板**
1. 按 `Cmd+Shift+P`
2. 输入 `Tasks: Run Task`
3. 选择要运行的任务（如 `启动 user-service`）

**方式 2: 通过快捷键**
1. 按 `Cmd+Shift+B` (Build Task)
2. 选择任务

**启动所有服务**：
- 选择 `启动所有微服务` 任务
- 会并行启动所有配置的服务

---

#### 步骤 3: 查看日志

每个 Task 会在独立的终端 panel 中运行：

```
TERMINAL
├─ Task - 启动 user-service
├─ Task - 启动 order-service
└─ Task - 启动 product-service
```

点击对应的标签页切换查看日志。

---

#### 步骤 4: 停止服务

1. 点击终端右上角的 **🗑️** (垃圾桶图标)
2. 或在终端中按 `Ctrl+C`

---

### 高级配置

#### 为不同环境配置不同 Profile

```json
{
  "label": "启动 user-service (dev)",
  "command": "cd user-service && mvn spring-boot:run -Dspring-boot.run.profiles=dev"
},
{
  "label": "启动 user-service (prod)",
  "command": "cd user-service && mvn spring-boot:run -Dspring-boot.run.profiles=prod"
}
```

#### 设置快捷键

在 `.vscode/keybindings.json` 中：

```json
[
  {
    "key": "cmd+shift+1",
    "command": "workbench.action.tasks.runTask",
    "args": "启动 user-service"
  },
  {
    "key": "cmd+shift+2",
    "command": "workbench.action.tasks.runTask",
    "args": "启动 order-service"
  }
]
```

---

## 方案四：多终端分屏

### 适用场景
- 需要同时看到多个服务的日志
- 监控服务启动状态
- 实时对比不同服务输出

---

### 使用步骤

#### 步骤 1: 创建并分屏终端

1. 打开终端 (`Ctrl+` `)
2. 点击右上角的 **Split Terminal** 图标（或 `Cmd+\`）
3. 重复分屏，创建多个终端窗格

布局示例（2x2）：
```
┌──────────────┬──────────────┐
│ user-service │ order-service│
├──────────────┼──────────────┤
│product-svc   │ payment-svc  │
└──────────────┴──────────────┘
```

---

#### 步骤 2: 在每个窗格启动服务

切换到每个窗格（点击或 `Alt+方向键`），运行启动命令：

```bash
# 窗格 1
cd user-service && mvn spring-boot:run

# 窗格 2
cd order-service && mvn spring-boot:run

# 窗格 3
cd product-service && mvn spring-boot:run

# 窗格 4
cd payment-service && mvn spring-boot:run
```

---

#### 步骤 3: 实时查看所有日志

所有服务的日志同时显示在各自的窗格中，方便监控。

---

### 优化技巧

#### 1. 调整终端布局

右键终端窗格 → `Change Terminal Layout` 选择布局：
- 水平分割
- 垂直分割
- 网格布局

#### 2. 使用 Tmux（进阶）

如果需要更强大的分屏和会话管理：

```bash
# 安装 tmux
brew install tmux

# 创建会话并分屏
tmux new -s microservices
# 按 Ctrl+B 然后按 % 垂直分屏
# 按 Ctrl+B 然后按 " 水平分屏
```

---

## 对比总结

### 各方案优缺点

| 方案 | 优点 | 缺点 | 适合人群 |
|------|------|------|---------|
| **Spring Boot Dashboard** | • 可视化界面<br>• 类似 IDEA 体验<br>• 一键操作<br>• 日志独立显示 | • 需要安装扩展 | **所有人（强烈推荐）** |
| **集成终端** | • 无需配置<br>• 灵活度高<br>• 熟悉的命令行 | • 需要手动切换<br>• 日志混在终端中 | 命令行爱好者 |
| **Tasks 配置** | • 一键启动所有服务<br>• 可自定义快捷键<br>• 团队标准化 | • 需要配置文件<br>• 学习成本稍高 | 团队协作项目 |
| **多终端分屏** | • 同时查看多个日志<br>• 直观监控 | • 屏幕空间有限<br>• 字体可能较小 | 需要监控多服务 |

---

## 我的推荐

### 🏆 最佳方案：Spring Boot Dashboard

**理由**：
1. ✅ **最接近 IDEA 体验** - 熟悉的界面和操作
2. ✅ **日志查看最方便** - 专门的输出窗口，可切换
3. ✅ **零配置** - 安装扩展后自动识别项目
4. ✅ **功能完整** - 启动、停止、调试、查看日志一应俱全

**立即开始**：
```bash
# 1. 安装扩展
code --install-extension vscjava.vscode-spring-boot-dashboard

# 2. 打开 Antigravity，左侧会出现 Spring Boot 图标

# 3. 点击服务旁边的 ▶️ 启动

# 4. 点击 📄 查看日志
```

---

### 🥈 备选方案：集成终端 + 分屏

如果不想安装扩展，使用这个组合：

1. 打开 4 个终端（每个服务一个）
2. 分屏显示（2x2 布局）
3. 在每个终端启动服务
4. 日志实时显示在各自窗格

---

## 快速上手指南

### 5 分钟快速开始

#### 第 1 步：安装扩展（30 秒）

```bash
code --install-extension vscjava.vscode-spring-boot-dashboard
```

#### 第 2 步：打开项目（10 秒）

```bash
cd your-microservices-project
code .
```

#### 第 3 步：启动服务（1 分钟）

1. 点击左侧 Spring Boot 图标
2. 点击 `user-service` 旁的 ▶️
3. 点击 `order-service` 旁的 ▶️
4. 重复其他服务

#### 第 4 步：查看日志（10 秒）

1. 点击已启动服务旁的 📄 图标
2. 底部 OUTPUT 面板显示日志
3. 下拉菜单切换不同服务

**完成！** 🎉

---

## 常见问题

### Q1: Spring Boot Dashboard 没有显示我的服务？

**原因**：
- 项目不是 Spring Boot 项目
- 没有正确的项目结构
- Maven/Gradle 配置有问题

**解决**：
1. 确保项目有 `@SpringBootApplication` 注解
2. 确保 `pom.xml` 或 `build.gradle` 正确配置
3. 重启 Antigravity
4. 按 `Cmd+Shift+P`，运行 `Java: Clean Language Server Workspace`

---

### Q2: 如何只查看某个服务的错误日志？

在 OUTPUT 面板中：
1. 选择对应服务的输出
2. 使用 `Cmd+F` 搜索 `ERROR` 或 `Exception`
3. 或在启动命令中添加日志级别：
   ```bash
   mvn spring-boot:run -Dspring-boot.run.arguments=--logging.level.root=ERROR
   ```

---

### Q3: 服务启动后如何切换查看不同服务的日志？

**Spring Boot Dashboard 方式**：
- 在 OUTPUT 面板顶部下拉菜单选择不同服务

**终端方式**：
- 点击底部终端标签切换

**快捷键**：
- `Cmd+K Cmd+↑/↓` 切换终端

---

### Q4: 如何过滤日志，只看关心的部分？

**方式 1: 使用搜索**
- 在 OUTPUT 面板按 `Cmd+F`
- 输入关键词（如 `ERROR`, `user`, `SQL`）

**方式 2: 配置日志级别**
在 `application.properties`:
```properties
logging.level.root=WARN
logging.level.com.example=DEBUG
```

**方式 3: 使用 grep 过滤**
```bash
mvn spring-boot:run | grep ERROR
```

---

### Q5: 多个服务的日志能合并查看吗？

**不能直接合并**，但有几个办法：

**方式 1: 使用多终端分屏**
- 同时看到多个服务日志

**方式 2: 使用日志聚合（高级）**
- 配置 Logback/Log4j2 输出到同一个文件
- 使用 tail 命令查看：
  ```bash
  tail -f logs/all-services.log
  ```

**方式 3: 使用 Docker Compose**
```bash
docker-compose logs -f
# 会合并显示所有服务日志，并标注服务名
```

---

## 附录：完整工作流示例

### 日常开发流程

```bash
# 1. 早上开始工作
cd your-project
code .

# 2. 打开 Spring Boot Dashboard（左侧图标）

# 3. 启动需要的服务
#    点击 user-service ▶️
#    点击 order-service ▶️

# 4. 开始编码...

# 5. 查看日志（点击 📄）
#    在 OUTPUT 面板查看

# 6. 修改代码后，如果配置了 DevTools，自动重启
#    如果没有，点击 🔄 手动重启

# 7. 下班前停止所有服务
#    点击每个服务的 ⏹️

# 完成！
```

---

## 推荐的 Antigravity 扩展组合

```bash
# Spring Boot 开发套件
code --install-extension vscjava.vscode-spring-boot-dashboard  # Dashboard
code --install-extension vmware.vscode-spring-boot             # Spring Boot 工具
code --install-extension vscjava.vscode-java-pack              # Java 开发包

# 增强功能
code --install-extension GabrielBB.vscode-lombok               # Lombok 支持
code --install-extension ms-azuretools.vscode-docker           # Docker 支持
code --install-extension humao.rest-client                     # API 测试

# 数据库工具
code --install-extension cweijan.vscode-mysql-client2          # MySQL 客户端
```

---

**最后更新**: 2026-01-07
**适用工具**: Antigravity / VS Code
**目标场景**: Spring Boot 微服务开发
