#!/usr/bin/env bash
# update-flutter-skills.sh
# 从 git submodule 同步最新的 Flutter skills 到 .reasonix/skills/
#
# 用法: bash scripts/update-flutter-skills.sh

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$PROJECT_DIR/.reasonix/vendor/flutter-skills/skills"
TARGET_DIR="$PROJECT_DIR/.reasonix/skills"

echo "🔄 同步 flutter/skills 到项目中..."

# 1. 初始化/更新子模块
echo "📦 更新子模块..."
git -C "$PROJECT_DIR" submodule update --init --recursive

# 2. 清空目标目录（只删技能子文件夹，保留目录本身）
echo "🧹 清理旧的技能文件..."
mkdir -p "$TARGET_DIR"
find "$TARGET_DIR" -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} \; 2>/dev/null

# 3. 复制每个技能
echo "📋 复制最新技能..."
count=0
for skill_dir in "$SOURCE_DIR"/*/; do
  [ -d "$skill_dir" ] || continue
  skill_name="$(basename "$skill_dir")"
  source_file="$skill_dir/SKILL.md"
  if [ -f "$source_file" ]; then
    target_path="$TARGET_DIR/$skill_name"
    rm -rf "$target_path"
    mkdir -p "$target_path"
    cp "$source_file" "$target_path/SKILL.md"
    echo "   ✅ $skill_name"
    count=$((count + 1))
  fi
done

echo ""
echo "🎉 完成！已同步 $count 个 Flutter 技能"
