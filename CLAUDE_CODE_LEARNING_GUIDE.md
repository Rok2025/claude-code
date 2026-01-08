# Claude Code 学习指南

> 这份指南帮助你系统掌握 Claude Code，从基础到高级特性

## 🎯 必须掌握的 5 大核心

### 1. 基础交互方式

```bash
claude                    # 交互模式（最常用）
claude "任务描述"          # 一次性任务
claude -p "问题" --output-format json  # 脚本化使用
claude -c                 # 继续上次会话
```

**关键快捷键**：
- `Shift+Tab` - 切换权限模式（正常/自动/计划）
- `Ctrl+O` - 显示 Claude 思考过程
- `@文件名` - 快速引用文件
- `!命令` - 直接执行 bash
- `Ctrl+R` - 搜索命令历史
- `Esc Esc` - 撤销回退

### 2. CLAUDE.md 记忆系统（最重要！）

这是让 Claude 记住项目规则的核心机制：

```
项目根目录/CLAUDE.md           # 团队共享规则（提交到 git）
.claude/rules/*.md            # 按主题分类的规则
CLAUDE.local.md               # 个人偏好（不提交 git）
~/.claude/CLAUDE.md           # 用户全局配置（所有项目）
```

**快速初始化**：
```bash
> /init    # Claude 自动生成项目 CLAUDE.md
```

**最小化模板示例**：
```markdown
# 项目架构
- 前端：React + TypeScript
- 后端：Node.js + Express
- 数据库：PostgreSQL
- 测试：Jest

# 代码约定
- 2 空格缩进
- 变量用 camelCase
- 常量用 UPPER_SNAKE_CASE
- 所有公开 API 需要 JSDoc

# 常用命令
- npm run dev - 启动开发服务器
- npm test - 运行测试
- npm run build - 生产构建

# 测试指南
- 新功能必须 100% 覆盖
- 集成测试在 tests/integration/
- Mock 外部 API，不要真实请求
```

**模块化规则（大型项目推荐）**：
```
.claude/rules/
├── frontend.md     # React/TypeScript 规则
├── backend.md      # API 设计规则
├── testing.md      # 测试约定
├── security.md     # 安全要求
└── git.md          # Git 工作流
```

### 3. 权限管理（安全必备）

在 `.claude/settings.json` 配置：

```json
{
  "permissions": {
    "defaultMode": "ask",    // 每次都询问（推荐）

    "allow": [
      "Bash(npm run test:*)",     // 允许测试命令
      "Bash(git diff:*)",         // 允许查看 diff
      "Read(src/**)"              // 允许读 src
    ],

    "deny": [
      "Read(.env)",               // 保护环境变量
      "Read(.env.*)",
      "Read(secrets/**)",         // 保护敏感目录
      "Read(.aws/**)",
      "Read(.ssh/**)",
      "Bash(rm:*)",              // 禁止删除命令
      "WebFetch"                 // 禁用网络请求
    ]
  }
}
```

**权限模式三种**：
- `ask` - 每次询问（默认，最安全）
- `acceptEdits` - 自动接受所有操作
- `plan` - 只读分析模式

**配置优先级**（从高到低）：
```
1. Enterprise Settings（企业级，IT 管理）
2. 命令行参数
3. 本地项目设置 (.claude/settings.local.json)
4. 共享项目设置 (.claude/settings.json)
5. 用户设置 (~/.claude/settings.json)
```

### 4. 三大扩展机制

#### A. Skills（让 Claude 学会做事）

**用途**：教会 Claude 如何做特定事情，自动应用

**存储位置**：
```
.claude/skills/my-skill/SKILL.md     # 项目级（团队共享）
~/.claude/skills/my-skill/SKILL.md   # 用户级（跨项目）
```

**创建示例**：
```bash
mkdir -p .claude/skills/code-review
```

```markdown
---
name: code-review
description: 代码审查时自动使用，检查质量和安全性
allowed-tools: Read, Grep, Bash
---

# 代码审查 Skill

## 使用场景
当用户要求审查代码或创建 PR 时使用。

## 审查清单

1. **代码质量**
   - 代码清晰易读
   - 变量命名良好
   - 无重复代码

2. **安全性**
   - 无硬编码密钥
   - 输入验证完善
   - 无 SQL 注入风险

3. **可维护性**
   - 函数职责单一
   - 适当的注释
   - 错误处理完善

## 执行步骤
1. 运行 `git diff` 查看变更
2. 逐文件审查
3. 提供具体改进建议
```

**最佳实践**：
- 描述清晰，包含触发关键词
- 保持文件在 500 行以内
- 使用 `allowed-tools` 限制权限

#### B. Hooks（自动化执行）

**用途**：在特定事件时自动运行脚本

```bash
> /hooks    # 打开配置界面
```

**常见应用**：

**1. 代码格式化（每次编辑后）**：
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [{
          "type": "command",
          "command": "prettier --write $(jq -r '.tool_input.file_path')"
        }]
      }
    ]
  }
}
```

**2. 防止修改敏感文件**：
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit(.env)",
        "hooks": [{
          "type": "command",
          "command": "echo 'BLOCKED: Cannot modify .env' && exit 1"
        }]
      }
    ]
  }
}
```

**3. 自动记录命令**：
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{
          "type": "command",
          "command": "jq -r '.tool_input.command' >> ~/.claude/cmd-log.txt"
        }]
      }
    ]
  }
}
```

**核心事件**：
- `PreToolUse` - 工具执行前（可以阻止）
- `PostToolUse` - 工具执行后（格式化输出）
- `PermissionRequest` - 权限请求时
- `SessionStart` - 会话开始

#### C. MCP Servers（连接外部工具）

**用途**：将 Claude 连接到外部工具和数据源

**安装示例**：

```bash
# GitHub 集成
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# Sentry 错误追踪
claude mcp add --transport http sentry https://sentry.io/mcp/

# PostgreSQL 数据库
claude mcp add --transport stdio postgres \
  --env DATABASE_URL=postgresql://localhost/mydb \
  -- npx -y @modelcontextprotocol/server-postgres
```

**三种作用域**：
```bash
claude mcp add --scope local github ...     # 仅你，仅本项目
claude mcp add --scope project github ...  # 团队，存在 .mcp.json
claude mcp add --scope user github ...     # 仅你，所有项目
```

**使用示例**：
```bash
# 安装后直接使用
> review PR #456 and suggest improvements
> create an issue for this bug
> show me all open PRs assigned to me
> query the database for users created last week
```

**常用 MCP 服务器**：
- GitHub - PR、Issues、代码审查
- Sentry - 错误日志、异常追踪
- PostgreSQL - 数据库查询
- Notion - 文档访问
- Google Drive - 设计文档

### 5. 提示词技巧

#### 具体 > 模糊

❌ **不好的提示**：
```
> fix the bug
> make it faster
> improve this
```

✅ **好的提示**：
```
> fix login bug where blank screen appears after entering wrong credentials
> optimize the database query in getUserProfile - it's taking 3 seconds
> refactor the auth module to use OAuth2 instead of session cookies
```

#### 分步执行

```
> 1. analyze auth system structure
> 2. design OAuth2 implementation plan
> 3. refactor to use OAuth2
> 4. update tests
> 5. verify all tests pass
```

#### 先探索，再修改

```
> explain how the auth system works    # 先理解
> [Claude 分析...]
> now add 2FA support                   # 再动手
```

#### 使用文件引用（@）

```
> Explain the logic in @src/utils/auth.js
> Compare @schema-old.ts with @schema-new.ts
> What's the structure of @src/components?
> Analyze @package.json, @tsconfig.json, and @jest.config.js together
```

#### 魔法短语

| 短语 | 效果 | 何时使用 |
|------|------|---------|
| `ultrathink:` | 启用深度推理 | 复杂架构决策 |
| `step by step` | 逐步实现 | 多步骤任务 |
| `don't modify`, `read-only` | 限制修改 | 探索代码库 |
| `before making changes`, `first analyze` | 先分析再行动 | 大型重构 |

---

## 📚 进阶必知

### Subagents（子代理）

**用途**：创建专业化的 AI 助手处理特定任务

```bash
> /agents    # 管理界面
```

**Subagent 文件结构**：
```markdown
---
name: code-reviewer
description: 代码审查专家，检查质量/安全/可维护性。立即使用。
tools: Read, Grep, Glob, Bash
model: inherit
skills: code-review, security-check
---

你是资深代码审查员，确保高质量标准。

当被调用时：
1. 运行 git diff 查看最近变更
2. 关注修改的文件
3. 立即开始审查

审查清单：
- 代码清晰易读
- 变量命名良好
- 无重复代码
- 错误处理完善
- 无泄露的密钥
```

**内置 Subagent**：
- **Explore** - 快速代码探索（只读，Haiku 模型）
- **Plan** - 计划模式下的研究助手
- **General** - 通用任务处理（Sonnet，所有工具）

### 会话管理

```bash
# 命名会话
claude --resume feature-auth

# 会话中重命名
> /rename payment-integration

# 查看会话列表
claude --resume
```

**会话选择器快捷键**：
```
↑/↓     - 导航
Enter   - 选择
P       - 预览内容
R       - 重命名
B       - 按分支过滤
/       - 搜索
```

### Plan Mode（计划模式）

**用途**：先分析，再行动。Claude 只读操作规划，你审核后再执行

**启用方式**：

```bash
# 1. 交互中切换：Shift+Tab
# 状态：⏸ plan mode on

# 2. 启动时启用
claude --permission-mode plan

# 3. 设为默认
# .claude/settings.json:
{
  "permissions": {
    "defaultMode": "plan"
  }
}
```

**使用场景**：
- 复杂重构前先看计划
- 大量文件变更前审查策略
- 不确定影响范围时探索

### 环境变量配置

**三种方式**：

```bash
# 1. 临时（这次会话）
export MY_VAR=value
claude

# 2. 永久（所有项目）
# ~/.bashrc 或 ~/.zshrc:
export CLAUDE_ENV_FILE=~/.claude/env.sh

# ~/.claude/env.sh:
export NODE_ENV=development
export API_KEY=xxx
conda activate myenv

# 3. 项目级（settings.json）
{
  "env": {
    "NODE_ENV": "development",
    "API_URL": "http://localhost:3000"
  }
}
```

---

## 🚀 推荐学习路径

### 第一周：基础掌握

**目标**：熟悉基本操作，建立项目规则

- [ ] 学习基本命令和快捷键
  ```bash
  claude          # 启动交互
  Shift+Tab       # 切换权限模式
  Ctrl+O          # 显示思考过程
  @文件名          # 文件引用
  ```

- [ ] 创建项目 CLAUDE.md
  ```bash
  > /init
  # 编辑生成的 CLAUDE.md，添加项目规则
  ```

- [ ] 配置权限保护敏感文件
  ```json
  # .claude/settings.json
  {
    "permissions": {
      "deny": [
        "Read(.env)",
        "Read(secrets/**)",
        "Bash(rm:*)"
      ]
    }
  }
  ```

- [ ] 练习基本任务
  ```bash
  > explain the project structure
  > find all TODO comments in the code
  > run the tests and show me the results
  ```

### 第二周：提升效率

**目标**：掌握进阶功能，优化工作流

- [ ] 掌握文件引用（@）
  ```bash
  > Compare @old-config.js with @new-config.js
  > Explain @src/utils/auth.js
  ```

- [ ] 使用计划模式处理复杂任务
  ```bash
  # 按 Shift+Tab 进入 plan mode
  > analyze the authentication system
  > [审核分析结果]
  # 按 Shift+Tab 退出，开始实施
  ```

- [ ] 配置第一个 Hook
  ```bash
  > /hooks
  # 例如：PostToolUse/Edit - prettier 自动格式化
  ```

- [ ] 命名和管理会话
  ```bash
  > /rename feature-user-profile
  claude -c    # 继续会话
  ```

### 第三周：高级定制

**目标**：创建自定义扩展，整合外部工具

- [ ] 创建第一个 Skill
  ```bash
  mkdir -p .claude/skills/code-review
  # 创建 SKILL.md，定义审查流程
  ```

- [ ] 安装需要的 MCP Server
  ```bash
  claude mcp add --transport http github https://api.githubcopilot.com/mcp/
  > review PR #123
  ```

- [ ] 探索 Subagents
  ```bash
  > /agents
  # 创建专门的代码审查或测试 Subagent
  ```

- [ ] 配置模块化规则
  ```
  .claude/rules/
  ├── frontend.md
  ├── backend.md
  └── testing.md
  ```

### 第四周：团队协作

**目标**：设置团队共享配置，优化协作流程

- [ ] 提交项目配置到 Git
  ```bash
  git add .claude/
  git commit -m "Add Claude Code team configuration"
  ```

- [ ] 创建团队 Skills
  ```
  .claude/skills/
  ├── code-review/SKILL.md
  ├── test-runner/SKILL.md
  └── deployment/SKILL.md
  ```

- [ ] 配置 CI/CD 集成
  ```yaml
  # .github/workflows/claude-review.yml
  - name: Claude Code Review
    run: |
      cat diff.txt | claude -p "review this code change"
  ```

- [ ] 编写团队文档
  ```markdown
  # team-guide.md
  - 如何使用 Claude Code
  - 项目特定的 Skills
  - MCP Servers 配置
  ```

---

## ⚡ 实用速查表

### 常用命令

```bash
/help          # 帮助
/config        # 设置界面
/memory        # 编辑 CLAUDE.md
/init          # 初始化项目
/agents        # 管理 Subagents
/skills        # 查看可用 Skill
/hooks         # 配置 Hooks
/mcp           # MCP 服务器
/resume        # 恢复会话
/rename        # 重命名会话
/vim           # 启用 Vim 模式
```

### 快捷键

```
Shift+Tab       - 切换权限模式
Ctrl+O          - 显示思考过程
Ctrl+R          - 搜索历史
Esc Esc         - 撤销回退
@               - 文件引用
/               - 斜杠命令
!               - 直接执行 bash
?               - 显示所有快捷键
```

### 工作流模板

#### 快速 Bug 修复
```bash
claude
> I'm seeing "TypeError: cannot read property 'name' of null"
> Analyze the error and find root cause
> Implement the fix
> Run tests to verify
```

#### 代码库理解
```bash
claude --permission-mode plan
> give me a 30-second overview
> how does authentication work?
> where is the database schema?
# 理解后按 Shift+Tab 退出 plan mode
```

#### 功能开发
```bash
claude --resume feature-payment
> 1. analyze existing payment flow
> 2. design the new refund feature
> 3. implement the refund API
> 4. add tests
> 5. update documentation
```

---

## 💡 最佳实践

### DO（推荐做法）

✅ **先写 CLAUDE.md** - 一次投入，长期受益
✅ **保护敏感信息** - 用 `permissions.deny` 排除 .env 等
✅ **命名会话** - 方便管理多个任务
✅ **善用 @ 引用** - 快速添加文件上下文
✅ **Shift+Tab 常切换** - 灵活控制权限
✅ **具体的提示词** - 描述清晰的需求和症状
✅ **分步验证** - 复杂任务分步执行和测试
✅ **团队共享配置** - Skills、Subagents 提交到 Git

### DON'T（避免做法）

❌ 不要跳过 CLAUDE.md 初始化
❌ 不要在 .env 文件中暴露敏感信息
❌ 不要使用模糊的提示词
❌ 不要一次性做太多变更
❌ 不要忘记测试和验证
❌ 不要让 Claude 访问不必要的文件
❌ 不要在生产环境直接执行未验证的操作

---

## 🔧 项目初始化清单

启动新项目时执行：

```bash
# 1. 初始化项目记忆
> /init

# 2. 设置权限
# 编辑 .claude/settings.json
{
  "permissions": {
    "deny": [
      "Read(.env)",
      "Read(.env.*)",
      "Read(secrets/**)",
      "Bash(rm:*)"
    ]
  }
}

# 3. 创建团队 Skill（可选）
mkdir -p .claude/skills/code-review
# 创建 SKILL.md

# 4. 配置 MCP（如果需要）
claude mcp add --scope project --transport http github https://api.githubcopilot.com/mcp/

# 5. 设置 Hooks（如果需要）
> /hooks
# 配置自动格式化或验证

# 6. 创建 Subagents（可选）
> /agents
# 创建项目特定代理

# 7. 提交配置到 Git
git add .claude/
git commit -m "Initialize Claude Code configuration"
```

---

## 🎓 进阶资源

### Unix 管道模式

```bash
# 作为 linter
cat code.js | claude -p "check for security issues" > review.txt

# 日志分析
tail -f app.log | claude -p "alert me if you see anomalies"

# 批处理
for file in *.ts; do
  claude -p "add JSDoc to $file" --output-format json
done
```

### 自定义状态行

显示项目特定信息（git 分支、环境变量等）：

```bash
> /statusline
```

### CI/CD 集成

```yaml
# .github/workflows/claude-code.yml
name: Claude Code Review
on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Review code
        run: |
          git diff origin/main...HEAD | \
          claude -p "Review this code change and suggest improvements" \
          --output-format json > review.json
```

---

## 🆘 常见问题

### Q: Claude 没有使用我的 Skill
**A**: 检查 `description` 字段中的关键词。Claude 用语义匹配，需要清晰的触发词。

### Q: 环境变量在 Bash 命令间不持久
**A**: 每个 Bash 命令是独立的。用 `CLAUDE_ENV_FILE` 或 SessionStart hook。

### Q: 我想限制 Claude 的某些权限
**A**: 用 `permissions.deny` 规则。例如：
```json
{
  "permissions": {
    "deny": ["Bash(rm:*)", "Read(.env)"]
  }
}
```

### Q: 如何在团队中共享配置
**A**: 提交到 Git：
- Skills 放 `.claude/skills/`
- Subagents 放 `.claude/agents/`
- Settings 放 `.claude/settings.json`
- Rules 放 `.claude/rules/`

### Q: 如何看 Claude 的思考过程
**A**: 按 `Ctrl+O` 启用详细模式，看到灰色斜体的内部推理。

### Q: 命令执行失败怎么办
**A**:
1. 检查权限配置是否阻止了操作
2. 查看 Hooks 是否有拦截
3. 使用 `Ctrl+O` 查看详细错误信息

---

## 📖 更多帮助

- 官方文档：使用 `> /help` 查看
- 问题反馈：https://github.com/anthropics/claude-code/issues
- 查询功能：问我任何关于 Claude Code 的问题

---

**最后的建议**：

1. **循序渐进** - 不要一次性尝试所有功能
2. **实践为主** - 在实际项目中应用学到的知识
3. **迭代优化** - 根据使用体验不断调整配置
4. **团队协作** - 与团队分享最佳实践

祝你使用 Claude Code 愉快！🚀
