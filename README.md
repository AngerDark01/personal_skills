# 🧠 AngerDark01 — Personal Agent Skills

> 个人 Agent Skill 仓库，兼容 Claude Code、Cursor、GitHub Copilot、Codex 等所有支持 [Agent Skills 开放标准](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview) 的平台。

Skill 按需加载，只有触发时才进入上下文，不影响性能。

---

## 📦 Skill 目录

### 🔧 Code Development — 代码开发

| Skill | 功能 | 触发词 |
|---|---|---|
| [codebase-ontology](./skills/code-development/codebase-ontology/) | 扫描项目，生成并维护持久化的 `CODEBASE.md`：模块图、数据流全链路、函数实现、调用关系、⚠️ 风险点。解决 AI 上下文窗口盲区问题。 | `scan the project` / `build codebase map` / `update ontology` |

---

### 🔗 推荐配套：obra/superpowers

以下 skill 来自 [obra/superpowers](https://github.com/obra/superpowers)，是经过社区验证的完整开发流水线，**直接通过 Claude Code 插件安装，无需复制进本仓库**：

```
brainstorming          需求探索 → 设计方案 → 保存设计文档
writing-plans          把设计拆成 2-5 分钟原子任务
subagent-driven-dev    每任务派独立 subagent，两阶段 review
test-driven-development RED-GREEN-REFACTOR 强制执行
systematic-debugging   4 阶段根因定位
requesting-code-review 任务间触发 code review
finishing-a-branch     收尾：验证测试 → PR/merge 选项
```

安装 superpowers：
```bash
# 在 Claude Code 终端里运行
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

**推荐工作流（本仓库 skill + superpowers 组合）：**
```
[新项目] codebase-ontology SCAN
    ↓
brainstorming → writing-plans → subagent-driven-development
    ↓
[功能确认] codebase-ontology UPDATE
```

---

## 🚀 安装方式

### 方式一：一行命令（推荐）

```bash
# 全局安装（所有项目可用）
curl -fsSL https://raw.githubusercontent.com/AngerDark01/personal_skills/main/scripts/install.sh \
  | bash -s -- codebase-ontology

# 仅当前项目
curl -fsSL https://raw.githubusercontent.com/AngerDark01/personal_skills/main/scripts/install.sh \
  | bash -s -- codebase-ontology --project
```

### 方式二：Claude Code 插件

```bash
/plugin add AngerDark01/personal_skills/skills/code-development/codebase-ontology
```

### 方式三：手动克隆

```bash
git clone https://github.com/AngerDark01/personal_skills.git

# 全局
cp -r personal_skills/skills/code-development/codebase-ontology ~/.claude/skills/

# 当前项目
cp -r personal_skills/skills/code-development/codebase-ontology .claude/skills/
```

---

## 📁 仓库结构

```
personal_skills/
├── README.md                              ← 你在这里
├── INSTALL.md                             ← 各平台详细安装指引
├── scripts/
│   └── install.sh                         ← 自动安装脚本
└── skills/
    ├── _template/                         ← 新建 skill 用这个模板
    │   └── SKILL.md
    └── code-development/                  ← 分类：代码开发
        └── codebase-ontology/
            ├── SKILL.md
            └── references/
                └── CODEBASE_TEMPLATE.md
```

### 分类规划（持续扩展）

| 目录 | 用途 |
|---|---|
| `code-development/` | 代码分析、项目理解、代码质量 |
| `planning/` | *(待添加)* 项目规划、任务拆解 |
| `debugging/` | *(待添加)* 调试、根因分析 |
| `writing/` | *(待添加)* 文档、commit、changelog |

---

## ➕ 添加新 Skill

```bash
# 1. 复制模板
cp -r skills/_template skills/<分类>/<skill-name>

# 2. 编辑 SKILL.md（填写 name、description、instructions）

# 3. 在本 README 的目录表格加一行

# 4. git add . && git commit && git push
```

`install.sh` 会自动发现新 skill，无需修改脚本。

---

## 🔗 相关链接

- [Agent Skills 官方文档](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)
- [Skill 编写最佳实践](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
- [obra/superpowers](https://github.com/obra/superpowers) — 强烈推荐的配套开发流水线
- [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) — 社区 skill 索引（500+）
