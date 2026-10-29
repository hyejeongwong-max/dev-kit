#!/usr/bin/env bash
# 把 skills/ 下的所有技能复制到 Cursor 的个人技能目录。
# 用法：./install.sh            安装到 ~/.cursor/skills
#       ./install.sh --claude   同时安装到 ~/.claude/skills（Claude Code）
set -euo pipefail

cd "$(dirname "$0")"

targets=("$HOME/.cursor/skills")
if [[ "${1:-}" == "--claude" ]]; then
  targets+=("$HOME/.claude/skills")
fi

for target in "${targets[@]}"; do
  mkdir -p "$target"
  for dir in skills/*/; do
    name="$(basename "$dir")"
    rm -rf "${target:?}/$name"
    cp -R "$dir" "$target/$name"
    echo "已安装 $name → $target/$name"
  done
done

echo "完成。新开一个对话（或重启 Cursor）后生效。"
