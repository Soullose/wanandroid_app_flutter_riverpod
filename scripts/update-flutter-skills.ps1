# update-flutter-skills.ps1
# 从 git submodule 同步最新的 Flutter skills 到 .reasonix/skills/
#
# 用法: .\scripts\update-flutter-skills.ps1

$ProjectDir = Get-Location
$SourceDir = "$ProjectDir\.reasonix\vendor\flutter-skills\skills"
$TargetDir = "$ProjectDir\.reasonix\skills"

Write-Host "🔄 同步 flutter/skills 到项目中..." -ForegroundColor Cyan

# 1. 初始化/更新子模块
Write-Host "📦 更新子模块..." -ForegroundColor Yellow
git submodule update --init --recursive

# 2. 清空目标目录中的技能文件夹
Write-Host "🧹 清理旧的技能文件..." -ForegroundColor Yellow
if (Test-Path $TargetDir) {
    Get-ChildItem -Path $TargetDir -Directory | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
}
New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null

# 3. 复制每个技能
Write-Host "📋 复制最新技能..." -ForegroundColor Green
$count = 0
Get-ChildItem -Path $SourceDir -Directory | ForEach-Object {
    $skillName = $_.Name
    $sourceFile = "$($_.FullName)\SKILL.md"
    if (Test-Path $sourceFile) {
        $targetPath = "$TargetDir\$skillName"
        New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
        Copy-Item -Path $sourceFile -Destination "$targetPath\SKILL.md" -Force
        Write-Host "   ✅ $skillName" -ForegroundColor Green
        $count++
    }
}

Write-Host "`n🎉 完成！已同步 $count 个 Flutter 技能" -ForegroundColor Cyan
