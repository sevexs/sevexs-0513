#!/bin/bash

# ==============================================
# 0513 源 最终免密推送脚本（新PAT+彻底免输+免y输入）
# 本地路径：/var/containers/Bundle/Application/.jbroot-4C230FDECB1D3D55/var/mobile/Documents/sevexs0513
# ==============================================

# 1. 配置（你的新PAT已写死）
REPO_DIR="/var/containers/Bundle/Application/.jbroot-4C230FDECB1D3D55/var/mobile/Documents/sevexs0513"
GITHUB_PAT="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"
REPO_URL="https://${GITHUB_PAT}@github.com/sevexs/sevexs-0513.git"

# 2. 解决隐根权限问题（双路径白名单，彻底搞定dubious ownership）
git config --global --add safe.directory "${REPO_DIR}"
git config --global --add safe.directory "/rootfs/private/var/mobile/Containers/Shared/AppGroup/.jbroot-4C230FDECB1D3D55/var/mobile/Documents/sevexs0513"

# 3. 进入本地仓库目录
cd "${REPO_DIR}" || exit 1

# 4. Git 基础配置（大文件传输+免证书校验）
git config --global http.postBuffer 524288000
git config --global core.compression 0
git config --global http.sslVerify false

# 5. 绑定远程（PAT写死在URL里，彻底免手动输入密码）
git remote set-url origin "${REPO_URL}"

# 6. 强制刷新Packages（-f强制覆盖，再也不问y/n）
echo "🔄 刷新 Packages 索引..."
dpkg-scanpackages debs /dev/null > Packages
gzip -kf Packages
bzip2 -kf Packages
xz -kf Packages
zstd -19 -f Packages > Packages.zst
echo "✅ Packages 索引刷新完成"

# 7. 全量提交+强制推送（覆盖远程所有文件，包含你编辑的界面）
echo "🚀 推送到 GitHub..."
git add .
git commit -m "0513源更新：$(date +"%Y-%m-%d %H:%M:%S")"
git push origin main --force

echo "✅ 0513源推送完成！"