# 🧠 AngerDark01 — Personal Agent Skills

> 个人 Agent Skill 仓库，兼容 Claude Code、Cursor、GitHub Copilot、Codex 等所有支持 [Agent Skills 开放标准](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview) 的平台。

Skill 按需加载，只有触发时才进入上下文，不影响性能。

---

## 🤖 Agent 安装指南

> **如果你是 AI Agent，请阅读本节。** 按以下步骤为用户有选择地安装 skill，不要全部安装。

### Step 1：发现可用 Skill

读取仓库根目录的 `skills.yaml`，获取所有 skill 的元数据（名称、描述、触发词、分类）：

```
https://raw.githubusercontent.com/AngerDark01/personal_skills/main/skills.yaml
```

或直接查看下方的 **Skill 目录**表格。

### Step 2：判断是否需要安装

对照每个 skill 的**触发词**，判断当前用户的工作场景是否需要该 skill：

- 如果用户说了某个触发词，或任务明显属于该 skill 的功能范围 → 安装
- 否则跳过，不要为用户安装无关 skill

### Step 3：运行安装命令

```bash
# 安装指定 skill（全局，所有项目可用）
curl -fsSL https://raw.githubusercontent.com/AngerDark01/personal_skills/main/scripts/install.sh \
  | bash -s -- <skill-name>

# 仅当前项目
curl -fsSL https://raw.githubusercontent.com/AngerDark01/personal_skills/main/scripts/install.sh \
  | bash -s -- <skill-name> --project

# 列出所有可用 skill
curl -fsSL https://raw.githubusercontent.com/AngerDark01/personal_skills/main/scripts/install.sh \
  | bash -s -- --list

# 安装某一分类下的所有 skill
curl -fsSL https://raw.githubusercontent.com/AngerDark01/personal_skills/main/scripts/install.sh \
  | bash -s -- --category planning
```

---

## 📦 Skill 目录

### 🔧 Code Development — 代码开发

| Skill | 功能简介 | 触发词 | 安装命令 |
|---|---|---|---|
| [codebase-ontology](./skills/code-development/codebase-ontology/) | 扫描项目，生成并维护持久化的 `CODEBASE.md`：模块图、数据流全链路、函数实现、调用关系、⚠️ 风险点。解决 AI 上下文窗口盲区问题。 | `scan the project` / `build codebase map` / `update ontology` | `bash -s -- codebase-ontology` |

### 📋 Planning — 项目规划 + 原子化实现

| Skill | 功能简介 | 触发词 | 安装命令 |
|---|---|---|---|
| [brainstorming](./skills/planning/brainstorming/) | 硬封锁所有实现，直到设计被批准。一次一问，提出 2-3 个方案供选择，逐段获得确认，最终输出设计文档并移交 writing-plans。 | `let's plan this` / `I want to build` / `design this feature` | `bash -s -- brainstorming` |
| [writing-plans](./skills/planning/writing-plans/) | 把批准的设计拆成 2-5 分钟原子任务，含完整代码片段、精确文件路径、TDD 验证命令。保存到 `docs/plans/`。 | `write a plan` / `break this into tasks` / `create implementation plan` | `bash -s -- writing-plans` |
| [subagent-driven-development](./skills/planning/subagent-driven-development/) | 每个任务派独立 subagent 执行，完成后两阶段 review（spec 合规 → 代码质量），过了才继续。高质量快速迭代。 | `execute the plan with subagents` / `run subagent-driven dev` | `bash -s -- subagent-driven-development` |
| [executing-plans](./skills/planning/executing-plans/) | 批量执行计划，每组任务后暂停等待人工 review。适合需要人工介入检查点的场景。 | `execute this plan` / `run the plan` / `implement from the plan` | `bash -s -- executing-plans` |

### 🔍 Code Review — 代码审查

| Skill | 功能简介 | 触发词 | 安装命令 |
|---|---|---|---|
| [requesting-code-review](./skills/code-review/requesting-code-review/) | 派遣 code-reviewer subagent 在问题扩散前发现它。subagent-driven-development 每任务后强制触发，合并前必须执行。含完整的 reviewer 提示模板。 | `request code review` / `review this code` / `code review` | `bash -s -- requesting-code-review` |
| [receiving-code-review](./skills/code-review/receiving-code-review/) | 处理 review 反馈的协议：先验证再实现，不懂先问，有理由可以反驳。禁止"Great point!"式的表演性同意。 | `process code review` / `I got review feedback` / `responding to review` | `bash -s -- receiving-code-review` |

### 🐛 Debugging — 调试

| Skill | 功能简介 | 触发词 | 安装命令 |
|---|---|---|---|
| [systematic-debugging](./skills/debugging/systematic-debugging/) | 四阶段强制 debug 流程：根因调查 → 模式分析 → 假设验证 → 实现。铁律：没有根因不许修 bug。失败 3 次后质疑架构。含 `root-cause-tracing.md` 和 `defense-in-depth.md`。 | `debug this` / `fix this bug` / `tests are failing` / `something's broken` | `bash -s -- systematic-debugging` |

---

## 🔀 推荐工作流

完整开发流水线（所有 skill 协同）：

```
1. [新项目/功能启动]
   codebase-ontology SCAN      ← 了解项目全貌
         ↓
2. [设计阶段]
   brainstorming               ← 探索需求，设计方案，禁止提前动手
         ↓
3. [任务规划]
   writing-plans               ← 拆成 2-5 分钟原子任务，TDD
         ↓
4. [执行阶段（选一）]
   subagent-driven-development ← 每任务独立 subagent + 双重 review（推荐）
   executing-plans             ← 批量执行 + 人工检查点
         ↓
5. [每任务完成后]
   requesting-code-review      ← 强制 review，发现问题早
   receiving-code-review       ← 处理反馈，技术验证优先
         ↓
6. [遇到 bug]
   systematic-debugging        ← 根因优先，禁止猜测式修复
         ↓
7. [功能确认后]
   codebase-ontology UPDATE    ← 同步项目地图
```

---

## 🚀 人工安装方式

### 方式一：一行命令（推荐）

```bash
# 安装单个 skill（全局）
curl -fsSL https://raw.githubusercontent.com/AngerDark01/personal_skills/main/scripts/install.sh \
  | bash -s -- systematic-debugging

# 安装整个分类
curl -fsSL https://raw.githubusercontent.com/AngerDark01/personal_skills/main/scripts/install.sh \
  | bash -s -- --category planning

# 安装全部
curl -fsSL https://raw.githubusercontent.com/AngerDark01/personal_skills/main/scripts/install.sh \
  | bash -s -- --all
```

### 方式二：手动克隆

```bash
git clone https://github.com/AngerDark01/personal_skills.git

# 安装指定 skill（全局）
cp -r personal_skills/skills/debugging/systematic-debugging ~/.claude/skills/

# 安装指定 skill（当前项目）
cp -r personal_skills/skills/debugging/systematic-debugging .claude/skills/
```

详细安装说明（各平台路径、卸载方法）见 [INSTALL.md](./INSTALL.md)。

---

## 📁 仓库结构

```
personal_skills/
├── README.md                              ← 你在这里
├── INSTALL.md                             ← 各平台详细安装指引
├── skills.yaml                            ← 机器可读的 skill 注册表（Agent 读这里）
├── scripts/
│   └── install.sh                         ← 自动安装脚本
└── skills/
    ├── _template/                         ← 新建 skill 用这个模板
    │   └── SKILL.md
    ├── code-development/
    │   └── codebase-ontology/
    │       ├── SKILL.md
    │       └── references/
    │           └── CODEBASE_TEMPLATE.md
    ├── planning/
    │   ├── brainstorming/SKILL.md
    │   ├── writing-plans/SKILL.md
    │   ├── subagent-driven-development/SKILL.md
    │   └── executing-plans/SKILL.md
    ├── code-review/
    │   ├── requesting-code-review/
    │   │   ├── SKILL.md
    │   │   └── code-reviewer.md           ← reviewer subagent 提示模板
    │   └── receiving-code-review/SKILL.md
    └── debugging/
        └── systematic-debugging/
            ├── SKILL.md
            ├── root-cause-tracing.md      ← 调用链回溯技术
            └── defense-in-depth.md        ← 多层防御验证技术
```

---

## ➕ 添加新 Skill

```bash
# 1. 复制模板
cp -r skills/_template skills/<分类>/<skill-name>

# 2. 编辑 SKILL.md（填写 name、description、触发词、instructions）

# 3. 在 skills.yaml 增加一条 skill 记录

# 4. 在本 README 的目录表格加一行

# 5. git add . && git commit && git push
```

`install.sh` 会自动发现新 skill，无需修改脚本。

---

## 🔗 相关链接

- [Agent Skills 官方文档](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)
- [Skill 编写最佳实践](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
- [obra/superpowers](https://github.com/obra/superpowers) — 原始 skill 来源，强烈推荐
- [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) — 社区 skill 索引（500+）
