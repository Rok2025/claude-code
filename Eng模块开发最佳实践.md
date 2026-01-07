# Eng 模块开发最佳实践（Antigravity）

## 核心策略

**您的情况**：
- ✅ 主要开发 **eng 模块**（zkjsplat-module-audit-eng）
- ✅ 需要经常查看 eng 模块日志
- ✅ 需要频繁修改和调试

**优化方案**：
- 🎯 **Antigravity 中只启动 eng 模块**（节省内存）
- 🐳 **其他模块用 Docker 运行**（如果需要依赖）
- 📊 **专注查看 eng 模块日志**

---

## 方案一：只启动 Eng 模块（最省资源）

### 适用场景
- Eng 模块可以独立运行
- 或者依赖的服务已经在远程/测试环境运行

### 操作步骤

#### 使用 Spring Boot Dashboard（推荐）

**1. 安装扩展**
```bash
code --install-extension vscjava.vscode-spring-boot-dashboard
```

**2. 打开项目**
```bash
cd /Users/freeman/Documents/00-Project/smart-platform
code .
```

**3. 启动 Eng 模块**
- 点击左侧 Spring Boot 图标 🍃
- 找到 `EngApplication`
- 点击 **▶️ Run** 或 **🐛 Debug**（如果需要调试）

**4. 查看日志**
- 点击 **📄 View Log** 图标
- 日志会在 OUTPUT 面板显示
- 可以全屏查看，不受其他服务干扰

**内存占用**：约 2-3GB（Antigravity + Java LS + Eng 模块）

---

#### 使用终端（备选）

**启动**
```bash
# 在集成终端中运行
mvn spring-boot:run -pl zkjsplat-module-audit-eng/zkjsplat-module-audit-eng-biz -Dspring-boot.run.profiles=local
```

**查看日志**
- 日志直接在终端中显示
- 按 `Cmd+F` 搜索关键词

---

### 日志查看技巧（重点）

#### 1. 实时过滤错误日志
```bash
# 在终端中过滤只看 ERROR
mvn spring-boot:run -pl zkjsplat-module-audit-eng/zkjsplat-module-audit-eng-biz -Dspring-boot.run.profiles=local | grep --line-buffered ERROR
```

#### 2. 搜索特定关键词
在 OUTPUT 或终端中：
- 按 `Cmd+F`
- 输入关键词（如 `Exception`, `SQL`, `审计`）

#### 3. 清空日志重新查看
- 右键 OUTPUT 面板 → `Clear Output`
- 或者重启服务

#### 4. 保存日志到文件
```bash
# 同时输出到终端和文件
mvn spring-boot:run -pl zkjsplat-module-audit-eng/zkjsplat-module-audit-eng-biz -Dspring-boot.run.profiles=local 2>&1 | tee eng.log
```

然后可以用 Antigravity 打开 `eng.log` 文件查看。

---

## 方案二：Eng 调试 + 其他模块 Docker

### 适用场景
- Eng 模块依赖其他服务（System、Infra、Gateway）
- 需要完整环境测试

### 架构
```
┌─────────────────────────────────────┐
│  Antigravity                        │
│  ├─ Eng 模块（调试）  ← 重点开发   │
│  └─ 日志查看                        │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  Docker                             │
│  ├─ System 模块                     │
│  ├─ Infra 模块                      │
│  ├─ Gateway 网关                    │
│  └─ MySQL / Redis                   │
└─────────────────────────────────────┘
```

### 操作步骤

#### 1. 创建 docker-compose.yml

在项目根目录创建（或修改现有的）：

```yaml
version: '3.8'

services:
  # System 模块
  system-service:
    build:
      context: .
      dockerfile: Dockerfile.system
    ports:
      - "48081:48081"
    environment:
      - SPRING_PROFILES_ACTIVE=local
    networks:
      - smart-platform
    restart: unless-stopped

  # Infra 模块
  infra-service:
    build:
      context: .
      dockerfile: Dockerfile.infra
    ports:
      - "48082:48082"
    environment:
      - SPRING_PROFILES_ACTIVE=local
    networks:
      - smart-platform
    restart: unless-stopped

  # Gateway 网关
  gateway-service:
    build:
      context: .
      dockerfile: Dockerfile.gateway
    ports:
      - "48080:48080"
    environment:
      - SPRING_PROFILES_ACTIVE=local
    networks:
      - smart-platform
    restart: unless-stopped
    depends_on:
      - system-service
      - infra-service

  # MySQL（如果需要）
  mysql:
    image: mysql:8.0
    ports:
      - "3306:3306"
    environment:
      - MYSQL_ROOT_PASSWORD=your_password
      - MYSQL_DATABASE=your_database
    networks:
      - smart-platform

networks:
  smart-platform:
    driver: bridge
```

#### 2. 创建 Dockerfile（示例）

**Dockerfile.system**
```dockerfile
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY zkjsplat-dependencies ./zkjsplat-dependencies
COPY zkjsplat-framework ./zkjsplat-framework
COPY zkjsplat-module-system ./zkjsplat-module-system
RUN mvn clean package -pl zkjsplat-module-system/zkjsplat-module-system-biz -DskipTests

FROM openjdk:21-jdk-slim
WORKDIR /app
COPY --from=build /app/zkjsplat-module-system/zkjsplat-module-system-biz/target/*.jar app.jar
ENV JAVA_OPTS="-Xmx512m -Xms256m"
EXPOSE 48081
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
```

类似的创建 `Dockerfile.infra` 和 `Dockerfile.gateway`

#### 3. 启动其他服务（Docker）

```bash
# 启动 System、Infra、Gateway
docker-compose up -d system-service infra-service gateway-service

# 查看状态
docker-compose ps

# 查看日志（如果需要）
docker-compose logs -f system-service
```

#### 4. 在 Antigravity 中启动 Eng 模块

- 使用 Spring Boot Dashboard 启动 eng 模块
- 或者在终端中运行：
```bash
mvn spring-boot:run -pl zkjsplat-module-audit-eng/zkjsplat-module-audit-eng-biz -Dspring-boot.run.profiles=local
```

#### 5. 专注查看 Eng 日志

OUTPUT 面板只显示 eng 模块日志，清晰无干扰！

**内存占用**：约 5-6GB（Antigravity + Java LS + Eng + Docker 3个服务）

---

## 方案三：快速重启 Eng 模块

### 使用热重载（推荐）

#### 1. 添加 Spring Boot DevTools

在 `zkjsplat-module-audit-eng-biz/pom.xml` 中添加：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <optional>true</optional>
</dependency>
```

#### 2. 配置 Antigravity 自动编译

在 `.vscode/settings.json` 中：

```json
{
  "java.autobuild.enabled": true,
  "java.compile.nullAnalysis.mode": "automatic"
}
```

#### 3. 修改代码后自动重启

- 修改 Java 代码后保存
- Antigravity 自动编译
- DevTools 检测到变化，自动重启 Eng 模块
- **无需手动重启！**

---

### 手动快速重启

如果不想用 DevTools：

**使用 Dashboard**
1. 点击 **🔄 Restart** 图标

**使用快捷键**（配置后）
1. 在 `.vscode/keybindings.json` 中添加：
```json
[
  {
    "key": "cmd+shift+r",
    "command": "spring-boot-dashboard.localapp.restart"
  }
]
```

2. 按 `Cmd+Shift+R` 快速重启

---

## 高效日志查看配置

### 1. 配置日志级别

在 `application-local.yml` 中：

```yaml
logging:
  level:
    root: INFO
    # 只看 eng 模块的详细日志
    com.your.package.eng: DEBUG
    # 屏蔽其他模块的 DEBUG 日志
    com.your.package: WARN
    # SQL 日志
    org.hibernate.SQL: DEBUG
    org.hibernate.type.descriptor.sql.BasicBinder: TRACE
```

### 2. 使用彩色日志

添加依赖（如果还没有）：
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-logging</artifactId>
</dependency>
```

在 `application-local.yml`:
```yaml
spring:
  output:
    ansi:
      enabled: ALWAYS
```

### 3. 创建日志搜索快捷键

在 `.vscode/keybindings.json`:
```json
[
  {
    "key": "cmd+shift+e",
    "command": "workbench.action.output.toggleOutput",
    "when": "!outputFocus"
  }
]
```

按 `Cmd+Shift+E` 快速打开 OUTPUT 面板

---

## 日常开发工作流

### 早上开始工作

```bash
# 1. 打开项目
cd /Users/freeman/Documents/00-Project/smart-platform
code .

# 2. （可选）启动依赖服务
docker-compose up -d system-service infra-service gateway-service

# 3. 在 Spring Boot Dashboard 中启动 Eng 模块
#    点击 ▶️ 或 🐛（调试模式）

# 4. 打开 OUTPUT 面板查看日志
#    点击 📄 View Log
```

### 开发过程

```bash
# 1. 修改代码
# 2. 保存（Cmd+S）
# 3. DevTools 自动重启
# 4. 查看日志确认变更生效
```

### 调试

```bash
# 1. 在代码中设置断点（点击行号左侧）
# 2. 以 Debug 模式启动（🐛 图标）
# 3. 触发请求
# 4. 在断点处暂停，查看变量
# 5. 单步执行（F10/F11）
```

### 下班

```bash
# 1. 停止 Eng 模块
#    点击 ⏹️ Stop

# 2. （可选）停止 Docker 服务
docker-compose down

# 3. 关闭 Antigravity
```

---

## 常用快捷键（Antigravity）

| 功能 | 快捷键 | 说明 |
|------|--------|------|
| 打开终端 | `Ctrl+` ` | 集成终端 |
| 打开命令面板 | `Cmd+Shift+P` | 运行任何命令 |
| 搜索文件 | `Cmd+P` | 快速打开文件 |
| 全局搜索 | `Cmd+Shift+F` | 搜索代码 |
| 搜索当前文件 | `Cmd+F` | 搜索日志/代码 |
| 跳转到定义 | `F12` | 查看方法定义 |
| 查找引用 | `Shift+F12` | 查看方法被调用的地方 |
| 格式化代码 | `Shift+Alt+F` | 自动格式化 |
| 打开 OUTPUT | `Cmd+Shift+U` | 查看输出日志 |

---

## 推荐的 Antigravity 扩展

```bash
# 必装
code --install-extension vscjava.vscode-spring-boot-dashboard  # Spring Boot 管理
code --install-extension vscjava.vscode-java-pack              # Java 开发包

# 推荐
code --install-extension GabrielBB.vscode-lombok               # Lombok 支持
code --install-extension vmware.vscode-spring-boot             # Spring Boot 工具
code --install-extension redhat.java                           # Java 语言支持

# 增强体验
code --install-extension humao.rest-client                     # API 测试
code --install-extension esbenp.prettier-vscode                # 代码格式化
code --install-extension eamodio.gitlens                       # Git 增强
```

---

## 调试 Eng 模块的高级技巧

### 1. 条件断点

- 右键断点 → Edit Breakpoint
- 输入条件（如 `userId == 123`）
- 只在满足条件时暂停

### 2. 日志断点

- 右键断点 → Edit Breakpoint
- 勾选 "Log Message"
- 输入日志信息（如 `User ID: {userId}`）
- 不会暂停，只输出日志

### 3. 查看变量值

- 在断点暂停时，鼠标悬停在变量上
- 或在左侧 VARIABLES 面板查看
- 可以添加到 Watch 监视

### 4. 修改变量值

- 在 VARIABLES 面板中右键变量
- 选择 "Set Value"
- 修改值继续执行

### 5. 表达式求值

- 在 DEBUG CONSOLE 中输入表达式
- 按回车查看结果
- 如 `user.getName()` 查看用户名

---

## 性能监控（可选）

### 使用 Spring Boot Actuator

在 OUTPUT 面板查看：
- JVM 内存使用
- 请求响应时间
- SQL 执行时间

### 使用 Java Flight Recorder

```bash
# 启动时添加参数
mvn spring-boot:run -Dspring-boot.run.jvmArguments="-XX:StartFlightRecording=duration=60s,filename=eng.jfr"
```

---

## 故障排查清单

### Eng 模块启动失败

1. **查看完整错误日志**
   - 在 OUTPUT 面板搜索 `ERROR` 或 `Exception`

2. **检查端口占用**
   ```bash
   lsof -i :48090
   ```

3. **检查配置文件**
   - `application-local.yml` 是否正确
   - 数据库连接是否配置

4. **清理重新构建**
   ```bash
   mvn clean install -DskipTests
   ```

### 日志看不到输出

1. **确认 profile 正确**
   ```bash
   # 查看启动命令中是否有 -Dspring.profiles.active=local
   ```

2. **检查日志级别**
   ```yaml
   logging:
     level:
       root: INFO  # 不要设置成 ERROR
   ```

3. **重启服务**
   - 点击 🔄 Restart

---

## 总结

### 🎯 最佳实践

**对于主要开发 Eng 模块的您**：

1. ✅ **只在 Antigravity 中启动 Eng 模块**
2. ✅ **使用 Spring Boot Dashboard 管理**
3. ✅ **在 OUTPUT 面板专注查看 Eng 日志**
4. ✅ **配置 DevTools 实现热重载**
5. ✅ **其他模块用 Docker 或远程环境**

**内存占用**：2-3GB（仅 Eng）或 5-6GB（Eng + Docker 其他服务）

**开发效率**：
- 修改代码后 1-2 秒自动重启
- 日志清晰，无其他模块干扰
- 调试方便，断点、变量查看完整

---

## 快速开始

```bash
# 1. 安装扩展
code --install-extension vscjava.vscode-spring-boot-dashboard

# 2. 打开项目
cd /Users/freeman/Documents/00-Project/smart-platform
code .

# 3. 点击左侧 Spring Boot 图标
# 4. 启动 EngApplication（▶️ 或 🐛）
# 5. 点击 📄 查看日志

# 完成！
```

---

**最后更新**: 2026-01-07
**针对模块**: zkjsplat-module-audit-eng
**开发工具**: Antigravity
