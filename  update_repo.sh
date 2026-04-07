#!/bin/bash

# ==============================================
# 0513 源 终极保护脚本（保留本地修改 + 自动推送）
# 本地路径：/var/containers/Bundle/Application/.jbroot-4C230FDECB1D3D55/var/mobile/Documents/sevexs0513
# ==============================================

# 1. 配置
REPO_DIR="/var/containers/Bundle/Application/.jbroot-4C230FDECB1D3D55/var/mobile/Documents/sevexs0513"
GITHUB_PAT="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"
REPO_URL="https://${GITHUB_PAT}@github.com/sevexs/sevexs-0513.git"

# 2. 信任目录
git config --global --add safe.directory "${REPO_DIR}"
git config --global --add safe.directory "/rootfs/private/var/mobile/Containers/Shared/AppGroup/.jbroot-4C230FDECB1D3D55/var/mobile/Documents/sevexs0513"

# 3. 进入目录
cd "${REPO_DIR}" || exit 1

# 4. 【关键】先拉取远程，但保留本地修改（不会覆盖）
echo "🔄 同步远程代码，保留本地修改..."
git fetch origin main
git merge origin/main --allow-unrelated-histories -m "合并远程更新"

# 5. Git 配置
git config --global http.postBuffer 524288000
git config --global core.compression 0
git config --global http.sslVerify false

# 6. 绑定远程
git remote set-url origin "${REPO_URL}"

# 7. 刷新 Packages
echo "🔄 生成 Packages 索引..."
dpkg-scanpackages debs /dev/null > Packages
gzip -kf Packages
bzip2 -kf Packages
xz -kf Packages
zstd -19 Packages > Packages.zst

# 8. 提交本地所有修改（包含你编辑的 index.html、图片）
echo "📤 提交本地修改..."
git add .
git commit -m "保留本地修改并更新源: $(date +"%Y-%m-%d %H:%M:%S")"

# 9. 强制推送
echo "🚀 推送..."
git push origin main --force

echo "✅ 0513 源推送完成！本地文件已保留！"