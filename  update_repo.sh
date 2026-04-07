#!/bin/bash

# ==============================================
# 0513 源 仿点点格式 终极免密推送脚本（完全适配你的路径+PAT）
# 本地路径：/var/containers/Bundle/Application/.jbroot-4C230FDECB1D3D55/var/mobile/Documents/sevexs0513
# ==============================================

# 1. 配置区（你的路径+PAT，已填好，完全仿点点格式）
REPO_DIR="/var/containers/Bundle/Application/.jbroot-4C230FDECB1D3D55/var/mobile/Documents/sevexs0513"
GITHUB_PAT="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"
REPO_URL="https://${GITHUB_PAT}@github.com/sevexs/sevexs-0513.git"

# 2. 进入目录（仿点点格式，加退出判断）
cd "${REPO_DIR}" || exit 1

# 3. Git 基础配置（仿点点格式，大文件缓冲+关闭压缩）
git config --global http.postBuffer 524288000
git config --global core.compression 0
git config --global http.sslVerify false

# 4. 解决隐根权限问题（双路径白名单，彻底搞定dubious ownership）
git config --global --add safe.directory "${REPO_DIR}"
git config --global --add safe.directory "/rootfs/private/var/mobile/Containers/Shared/AppGroup/.jbroot-4C230FDECB1D3D55/var/mobile/Documents/sevexs0513"

# 5. 绑定远程仓库（PAT写死在URL里，彻底免手动输入，仿点点格式）
git remote set-url origin "${REPO_URL}"

# 6. 重新生成源索引文件（仿点点格式，多格式压缩，-f强制覆盖，免y输入）
echo "🔄 刷新 Packages 索引..."
dpkg-scanpackages debs /dev/null > Packages
gzip -kf Packages
bzip2 -kf Packages
xz -kf Packages
zstd -19 -f Packages > Packages.zst
echo "✅ Packages 索引刷新完成"

# 7. 添加所有修改到Git（仿点点格式，全量提交）
git add .

# 8. 提交更改（自动生成时间戳作为提交信息，仿点点格式）
git commit -m "更新内容 - $(date +"%Y-%m-%d %H:%M:%S")"

# 9. 推送到GitHub（仿点点格式，强制推送，覆盖远程）
echo "🚀 推送到 GitHub..."
git push origin main --force

echo "✅ 0513源推送完成！"