# 安装指引

## 一行安装（推荐）

```bash
# 安装指定 skill（全局）
curl -fsSL https://raw.githubusercontent.com/AngerDark01/personal_skills/main/scripts/install.sh \
  | bash -s -- <skill-name>

# 列出所有可用 skill
curl -fsSL https://raw.githubusercontent.com/AngerDark01/personal_skills/main/scripts/install.sh \
  | bash -s -- --list

# 安装某分类下所有 skill
curl -fsSL https://raw.githubusercontent.com/AngerDark01/personal_skills/main/scripts/install.sh \
  | bash -s -- --category code-development

# 安装全部 skill
curl -fsSL https://raw.githubusercontent.com/AngerDark01/personal_skills/main/scripts/install.sh \
  | bash -s -- --all
```

加 `--project` 仅在当前项目生效：

```bash
curl -fsSL https://raw.githubusercontent.com/AngerDark01/personal_skills/main/scripts/install.sh \
  | bash -s -- codebase-ontology --project
```

---

## 各平台安装路径

| 平台 | 全局路径 | 项目路径 |
|---|---|---|
| Claude Code | `~/.claude/skills/` | `.claude/skills/` |
| GitHub Copilot / VS Code | `~/.github/skills/` | `.github/skills/` |
| Cursor | `~/.cursor/skills/` | `.cursor/skills/` |
| OpenAI Codex | `~/.codex/skills/` | `.codex/skills/` |
| Gemini CLI | `~/.gemini/skills/` | `.gemini/skills/` |

> `install.sh` 默认安装到 Claude Code 的 `~/.claude/skills/`。其他平台请手动复制到对应路径。

---

## 手动安装

```bash
git clone https://github.com/AngerDark01/personal_skills.git

# Claude Code 全局
cp -r personal_skills/skills/code-development/codebase-ontology ~/.claude/skills/

# 当前项目
cp -r personal_skills/skills/code-development/codebase-ontology .claude/skills/
```

---

## 卸载

```bash
# 全局
rm -rf ~/.claude/skills/codebase-ontology

# 项目级
rm -rf .claude/skills/codebase-ontology
```

---

## 验证安装

重启 Claude Code 后运行：
```
/skills
```
看到 `codebase-ontology` 出现在列表中即安装成功。
