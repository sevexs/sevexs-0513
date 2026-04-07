#!/bin/bash

# ==============================================
# 0513 源 终极免交互推送脚本（彻底解决y输入+免输密码）
# 本地路径：/var/containers/Bundle/Application/.jbroot-4C230FDECB1D3D55/var/mobile/Documents/sevexs0513
# ==============================================

# 1. 配置信息（已填好，无需修改）
REPO_DIR="/var/containers/Bundle/Application/.jbroot-4C230FDECB1D3D55/var/mobile/Documents/sevexs0513"
GITHUB_PAT="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"
REPO_URL="https://${GITHUB_PAT}@github.com/sevexs/sevexs-0513.git"

# 2. 解决隐根权限问题（双路径白名单）
git config --global --add safe.directory "${REPO_DIR}"
git config --global --add safe.directory "/rootfs/private/var/mobile/Containers/Shared/AppGroup/.jbroot-4C230FDECB1D3D55/var/mobile/Documents/sevexs0513"

# 3. 进入目录
cd "${REPO_DIR}" || exit 1

# 4. Git 配置（大文件缓冲+关闭压缩+跳过证书验证）
git config --global http.postBuffer 524288000
git config --global core.compression 0
git config --global http.sslVerify false

# 5. 绑定远程仓库（PAT写死在地址里，彻底免输密码）
git remote set-url origin "${REPO_URL}"

# 6. 【关键】强制覆盖生成Packages，彻底解决y输入
echo "🔄 正在刷新 Packages 索引..."
dpkg-scanpackages debs /dev/null > Packages
gzip -kf Packages    # -f 强制覆盖
bzip2 -kf Packages  # -f 强制覆盖
xz -kf Packages     # -f 强制覆盖
zstd -19 -f Packages > Packages.zst  # 加-f强制覆盖，不再问y/n
echo "✅ Packages 索引刷新完成"

# 7. 提交与推送（全量提交+强制推送，免交互）
echo "🚀 正在推送到 GitHub..."
git add .
# 强制提交，跳过编辑器，直接用时间戳
git commit -m "0513源更新：$(date +"%Y-%m-%d %H:%M:%S")" --no-edit
# 强制推送，免交互
git push origin main --force

echo "✅ 0513源推送完成！全程零手动输入！"