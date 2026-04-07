#!/bin/bash
# 1. 重新生成源索引文件（若有deb包更新）
dpkg-scanpackages debs /dev/null > Packages
gzip -kf Packages
bzip2 -kf Packages
xz -kf Packages
zstd -kf Packages

# 2. 添加所有修改到Git
git add .

# 3. 提交更改（自动生成时间戳作为提交信息）
COMMIT_MSG="更新内容 - $(date "+%Y-%m-%d %H:%M:%S")"
git commit -m "$COMMIT_MSG"

# 4. 推送到GitHub
git push origin main
