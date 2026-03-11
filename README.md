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

### 🎨 Interaction Design — 交互设计

| Skill | 功能简介 | 触发词 | 安装命令 |
|---|---|---|---|
| [interaction-flow-designer](./skills/interaction/interaction-flow-designer/) | 把用户旅程建模为状态机：ASCII 流程图、完整状态清单、边界情况列表、TypeScript 类型规格。防止隐式状态变成 bug。 | `design the user flow` / `state machine for this feature` / `UX flow` | `bash -s -- interaction-flow-designer` |
| [microinteraction-designer](./skills/interaction/microinteraction-designer/) | 设计并实现 hover 效果、loading 状态、页面过渡、动画反馈。含 CSS 动画代码、Framer Motion 模板、timing 规范，以及 `prefers-reduced-motion` 无障碍处理。 | `add animations` / `hover effects` / `loading states` / `micro-interactions` | `bash -s -- microinteraction-designer` |
| [ux-heuristic-reviewer](./skills/interaction/ux-heuristic-reviewer/) | 对照 Nielsen 10 大可用性原则 + WCAG 2.1 AA 审查 UI。输出 Critical/Major/Minor 分级问题，含 file:line 定位和可操作修复方案。 | `review the UX` / `usability audit` / `check accessibility` | `bash -s -- ux-heuristic-reviewer` |

### 🖼️ UI / Design System — 组件与设计系统

| Skill | 功能简介 | 触发词 | 安装命令 |
|---|---|---|---|
| [design-system-architect](./skills/ui/design-system-architect/) | 设计三层 token 架构（primitive → semantic → component）、暗色模式策略、组件 API 规范。含完整 CSS 变量模板和 hardcoded values 审查清单。 | `design system` / `design tokens` / `theming` / `typography scale` | `bash -s -- design-system-architect` |
| [ui-component-generator](./skills/ui/ui-component-generator/) | 生成有鲜明设计方向的生产级 React/Vue 组件。拒绝"AI 通用美学"，每次提交 BOLD 视觉方向，含排版/色彩/动效/无障碍全套规范。 | `build this component` / `make a landing page` / `build a dashboard` | `bash -s -- ui-component-generator` |
| [figma-to-component](./skills/ui/figma-to-component/) | 把 Figma 设计（截图/规格/描述）转为生产级 React/Vue 组件。完整提取视觉清单 → 映射到 token → 确定组件结构 → 实现所有交互状态。 | `implement this Figma design` / `convert this design to code` / `build this from the mockup` | `bash -s -- figma-to-component` |

### ⚙️ Frontend Engineering — 前端工程

| Skill | 功能简介 | 触发词 | 安装命令 |
|---|---|---|---|
| [frontend-refactor](./skills/frontend-engineering/frontend-refactor/) | React 组件重构：boolean props → variants、render props → children composition、自定义 hook 提取、props drilling 消除、大组件拆分。含代码异味检测清单和安全重构流程。 | `refactor this component` / `too many props` / `split this component` | `bash -s -- frontend-refactor` |
| [frontend-code-reviewer](./skills/frontend-engineering/frontend-code-reviewer/) | 前端代码 review：WCAG 2.1 AA 无障碍、React 最佳实践（hooks/keys/状态）、CSS 性能反模式。输出分级问题，含 file:line 定位和具体修复代码。 | `review this frontend code` / `accessibility audit` / `frontend review` | `bash -s -- frontend-code-reviewer` |
| [testing-generator](./skills/frontend-engineering/testing-generator/) | 生成 React 组件测试、自定义 hook 测试、表单测试、异步测试（MSW mock）。测试行为而非实现，含 jest-axe 无障碍测试和测试策略覆盖层级。 | `write tests for this` / `generate unit tests` / `test this component` | `bash -s -- testing-generator` |

### ⚡ Performance — 性能优化

| Skill | 功能简介 | 触发词 | 安装命令 |
|---|---|---|---|
| [frontend-performance-analyzer](./skills/performance/frontend-performance-analyzer/) | 分析 Core Web Vitals（LCP/INP/CLS）、渲染阻塞资源和 JS 执行。用 Lighthouse + DevTools 诊断，给出 LCP/CLS/INP 根因和优先级优化矩阵。 | `analyze performance` / `improve Web Vitals` / `why is this slow` | `bash -s -- frontend-performance-analyzer` |
| [bundle-size-optimizer](./skills/performance/bundle-size-optimizer/) | 缩减 JS bundle：替换重型依赖（moment→date-fns、lodash→native）、修复 barrel file、路由/组件级代码分割、动态导入。含 CI bundle 体积预算配置。 | `bundle is too large` / `reduce bundle size` / `code splitting` | `bash -s -- bundle-size-optimizer` |
| [react-render-optimizer](./skills/performance/react-render-optimizer/) | 定位并消除 React 不必要重渲染：React Profiler + why-did-you-render 诊断，React.memo / useMemo / useCallback / 状态下移 / react-window 虚拟列表。含决策树和性能报告模板。 | `component re-renders too much` / `React is slow` / `optimize re-renders` | `bash -s -- react-render-optimizer` |

### 🏗️ Architecture — 前端架构

| Skill | 功能简介 | 触发词 | 安装命令 |
|---|---|---|---|
| [frontend-architecture-designer](./skills/architecture/frontend-architecture-designer/) | 设计可扩展前端目录结构（小/中/大型项目三档）、feature-based 模块化、组件层级（pages/features/shared）、模块公开 API 规范。含 ESLint 边界检查和 ADR 模板。 | `design the architecture` / `frontend architecture` / `modular architecture` | `bash -s -- frontend-architecture-designer` |
| [state-management-architect](./skills/architecture/state-management-architect/) | 为每类状态选择正确工具：React Query（服务器状态）、Zustand（全局 UI 状态）、React Hook Form（表单）、useState/useReducer（本地状态）。防止全部用 Redux 的反模式。 | `state management` / `should I use Redux` / `React Query setup` / `Zustand` | `bash -s -- state-management-architect` |
| [project-structure-manager](./skills/architecture/project-structure-manager/) | 审查项目结构：检测循环依赖、god 目录、分散的领域逻辑和模块边界违规。输出分阶段迁移计划，含 ESLint 规则、路径别名和命名规范。 | `audit project structure` / `find circular dependencies` / `organize the codebase` | `bash -s -- project-structure-manager` |

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

### 🎯 Product Strategy — 产品战略

| Skill | 功能简介 | 触发词 | 安装命令 |
|---|---|---|---|
| [jobs-to-be-done](./skills/product-strategy/jobs-to-be-done/) | 用 Christensen JTBD 框架挖掘客户"雇佣"产品的真正原因。含 Job Statement 格式（When/I want/So I can）、进步四力（Push/Pull/焦虑/惯性）、Big vs Little Hire、非显性竞争者，以及完整的 Switch Interview 访谈协议。 | `jobs to be done` / `JTBD` / `why do customers use this` / `non-obvious competition` | `bash -s -- jobs-to-be-done` |
| [inspired-product](./skills/product-strategy/inspired-product/) | Marty Cagan 赋能产品团队模型：双轨制（Discovery + Delivery）、四大产品风险（价值/可用性/可行性/商业可行性）、10 问机会评估、产品愿景和 OKR 落地。 | `product discovery` / `dual track agile` / `product risks` / `opportunity assessment` / `product OKRs` | `bash -s -- inspired-product` |
| [obviously-awesome](./skills/product-strategy/obviously-awesome/) | April Dunford 5 步定位框架：竞争替代品 → 独特属性 → 价值主题 → 最佳客户 → 市场品类选择。输出完整定位画布和定位陈述。 | `product positioning` / `market category` / `positioning statement` / `value proposition` | `bash -s -- obviously-awesome` |

### 🔬 Product Discovery — 产品发现

| Skill | 功能简介 | 触发词 | 安装命令 |
|---|---|---|---|
| [mom-test](./skills/product-discovery/mom-test/) | Fitzpatrick Mom Test 客户访谈规则：聊他们的生活而非你的想法，问具体过去事实而非假设，听而不推销，要承诺而非赞美。含完整对话结构和避免虚假验证的问题模板。 | `customer interview` / `user interview` / `validate my idea` / `customer discovery` | `bash -s -- mom-test` |
| [continuous-discovery](./skills/product-discovery/continuous-discovery/) | Teresa Torres 持续发现节奏：每周客户接触、机会方案树（OST）、假设映射与快速实验，PM/设计/工程三角协同。含每周 discovery 会议模板。 | `continuous discovery` / `opportunity solution tree` / `OST` / `weekly discovery` | `bash -s -- continuous-discovery` |
| [user-personas](./skills/product-discovery/user-personas/) | 基于 JTBD + 行为研究 + 真实客户数据构建有证据支撑的用户画像。含数据来源清单、行为聚类方法、完整画像模板（含置信度）、以及常见反模式。 | `create user personas` / `define our users` / `who are our customers` / `persona template` | `bash -s -- user-personas` |

### 📝 Requirements — 需求梳理

| Skill | 功能简介 | 触发词 | 安装命令 |
|---|---|---|---|
| [prd-writer](./skills/requirements/prd-writer/) | 生成结构化产品需求文档（PRD）：问题陈述、成功指标（OKR 格式）、用户故事、方案描述、范围分期、风险表、依赖项和待解问题。预先厘清范围，保存到 `docs/prd/`。 | `write a PRD` / `product requirements` / `spec this feature` / `document this feature` | `bash -s -- prd-writer` |
| [user-stories](./skills/requirements/user-stories/) | 用 INVEST 原则和 Given/When/Then 验收标准编写高质量用户故事。含故事拆分技巧、Epic→Feature→Story 层级、故事卡模板和常见反模式。 | `write user stories` / `break this into stories` / `acceptance criteria` / `split this epic` | `bash -s -- user-stories` |
| [feature-prioritization](./skills/requirements/feature-prioritization/) | 用 RICE、ICE、Kano、MoSCoW、机会评分五大框架客观排列功能优先级。含各框架评分表、选框架指南和优先级会议协议。 | `prioritize features` / `RICE scoring` / `MoSCoW` / `what should we build next` / `Kano model` | `bash -s -- feature-prioritization` |

### 🖌️ Product Design — 产品设计

| Skill | 功能简介 | 触发词 | 安装命令 |
|---|---|---|---|
| [lean-ux](./skills/product-design/lean-ux/) | Gothelf Lean UX：声明假设、写假设陈述、设计最小可验证实验（纸原型 → Wizard of Oz → A/B 测试）、运行协作 Design Studio，整合进双轨敏捷。含 Lean UX Canvas。 | `lean UX` / `hypothesis-driven design` / `test this assumption` / `design studio` | `bash -s -- lean-ux` |
| [design-sprint](./skills/product-design/design-sprint/) | Jake Knapp 5 天 Design Sprint 完整流程：周一（地图）→ 周二（草图）→ 周三（决策）→ 周四（原型）→ 周五（5 用户测试）。含每日活动时间表、团队角色、访谈脚本和 Sprint 报告模板。 | `design sprint` / `5-day sprint` / `prototype and test` / `validate before building` | `bash -s -- design-sprint` |
| [customer-journey-map](./skills/product-design/customer-journey-map/) | 绘制 7 阶段（感知→推荐）客户旅程全貌，识别 Aha 时刻、流失触发点、痛点和改进机会。含各阶段数据来源、工作坊引导指南和机会优先矩阵。 | `customer journey` / `journey map` / `where do users drop off` / `aha moment` / `churn triggers` | `bash -s -- customer-journey-map` |

### 🛠️ Meta — Skill 开发 & 通用工具

| Skill | 功能简介 | 触发词 | 安装命令 |
|---|---|---|---|
| [skill-creator](./skills/meta/skill-creator/) | Anthropic 官方 skill 制作工具：草稿 → 测试用例 → subagent 并行运行 → eval viewer 定性审查 → 定量 benchmark → 迭代优化 → description 自动调优 → 打包。含完整 eval/grader/comparator/analyzer 子 agent 体系。 | `create a skill` / `make a skill` / `improve this skill` / `benchmark this skill` | `bash -s -- skill-creator` |
| [frontend-design](./skills/meta/frontend-design/) | Anthropic 官方前端设计指南：避免"AI 通用美学"，提交大胆美学方向，选用独特字体、有主张的色彩、有意义的动效和破格版式。适用于所有 Web 组件、页面、应用和 UI 设计任务。 | `build a UI` / `design this page` / `make this look good` / `web design` / `frontend interface` | `bash -s -- frontend-design` |
| [doc-coauthoring](./skills/meta/doc-coauthoring/) | Anthropic 官方文档协作工作流：三阶段结构化共写——阶段 1 上下文收集（倾倒信息 + 追问）→ 阶段 2 逐节精炼（头脑风暴 → 策划 → 草稿 → 迭代）→ 阶段 3 读者测试（新鲜 Claude 验证文档可读性）。适合 PRD、设计文档、RFC、决策文档等。 | `write a doc` / `draft a proposal` / `create a spec` / `decision doc` / `RFC` | `bash -s -- doc-coauthoring` |

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
├── README.md
├── INSTALL.md
├── skills.yaml                            ← 机器可读注册表（38 skills）
├── scripts/install.sh
└── skills/
    ├── _template/SKILL.md
    ├── meta/                              ← Skill 开发 & 通用工具（3）[Anthropic 官方]
    │   ├── skill-creator/                 ← 含 agents/、scripts/、eval-viewer/
    │   ├── frontend-design/
    │   └── doc-coauthoring/
    ├── code-development/
    │   └── codebase-ontology/
    ├── product-strategy/                  ← 产品战略（3）
    │   ├── jobs-to-be-done/
    │   ├── inspired-product/
    │   └── obviously-awesome/
    ├── product-discovery/                 ← 产品发现（3）
    │   ├── mom-test/
    │   ├── continuous-discovery/
    │   └── user-personas/
    ├── requirements/                      ← 需求梳理（3）
    │   ├── prd-writer/
    │   ├── user-stories/
    │   └── feature-prioritization/
    ├── product-design/                    ← 产品设计（3）
    │   ├── lean-ux/
    │   ├── design-sprint/
    │   └── customer-journey-map/
    ├── interaction/                       ← 交互设计（3）
    │   ├── interaction-flow-designer/
    │   ├── microinteraction-designer/
    │   └── ux-heuristic-reviewer/
    ├── ui/                                ← UI / 设计系统（3）
    │   ├── design-system-architect/
    │   ├── ui-component-generator/
    │   └── figma-to-component/
    ├── frontend-engineering/              ← 前端工程（3）
    │   ├── frontend-refactor/
    │   ├── frontend-code-reviewer/
    │   └── testing-generator/
    ├── performance/                       ← 性能优化（3）
    │   ├── frontend-performance-analyzer/
    │   ├── bundle-size-optimizer/
    │   └── react-render-optimizer/
    ├── architecture/                      ← 前端架构（3）
    │   ├── frontend-architecture-designer/
    │   ├── state-management-architect/
    │   └── project-structure-manager/
    ├── planning/                          ← 项目规划（4）
    │   ├── brainstorming/
    │   ├── writing-plans/
    │   ├── subagent-driven-development/
    │   └── executing-plans/
    ├── code-review/                       ← 代码审查（2）
    │   ├── requesting-code-review/
    │   └── receiving-code-review/
    └── debugging/                         ← 调试（1）
        └── systematic-debugging/
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
