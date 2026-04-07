#!/bin/bash

# ==============================================
# 0513 源 终极免密推送脚本（彻底免输PAT+免y输入）
# 本地路径：/var/containers/Bundle/Application/.jbroot-4C230FDECB1D3D55/var/mobile/Documents/sevexs0513
# ==============================================

# 1. 配置区（你的真实路径+PAT，已填好）
REPO_DIR="/var/containers/Bundle/Application/.jbroot-4C230FDECB1D3D55/var/mobile/Documents/sevexs0513"
GITHUB_PAT="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"
# 【关键】把PAT直接拼进远程地址，Git自动用它认证，彻底免输密码
REPO_URL="https://${GITHUB_PAT}@github.com/sevexs/sevexs-0513.git"

# 2. 解决隐根权限问题（双路径白名单，彻底搞定dubious ownership）
git config --global --add safe.directory "${REPO_DIR}"
git config --global --add safe.directory "/rootfs/private/var/mobile/Containers/Shared/AppGroup/.jbroot-4C230FDECB1D3D55/var/mobile/Documents/sevexs0513"

# 3. 进入本地仓库目录
cd "${REPO_DIR}" || exit 1

# 4. Git 基础配置（大文件缓冲+关闭压缩+跳过证书验证）
git config --global http.postBuffer 524288000
git config --global core.compression 0
git config --global http.sslVerify false

# 5. 【关键】强制绑定远程仓库（PAT写死在地址里，Git自动认证）
git remote set-url origin "${REPO_URL}"

# 6. 强制刷新Packages索引（-f强制覆盖，彻底免y输入）
echo "🔄 正在刷新 Packages 索引..."
dpkg-scanpackages debs /dev/null > Packages
gzip -kf Packages
bzip2 -kf Packages
xz -kf Packages
zstd -19 -f Packages > Packages.zst
echo "✅ Packages 索引刷新完成"

# 7. 提交与推送（全量提交+强制推送，免交互）
echo "🚀 正在推送到 GitHub..."
git add .
git commit -m "0513源更新：$(date +"%Y-%m-%d %H:%M:%S")"
git push origin main --force

echo "✅ 0513源推送完成！全程零手动输入！"