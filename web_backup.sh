#!/bin/sh
cd /web/
backup_dir="/mnt/shells/backups"
today=$(date "+%Y%m%d%H")
filename="backup-web-${today}.tar.gz"
password="(U74EJzxy3CN%r8(uUr^hvgz9nF(1N5Y"
tg_token="11111111:aaaaaaaaaaaaa"
tg_chat_id=111111

# 加密打包备份
echo "Packing backup $filename"
tar -czf -  .[!.]* * --exclude=vendor --exclude=.git | openssl des3 -salt -k "$password" -out $backup_dir/$filename

cd -

# 备份文件
./backup.sh "upload" "$backup_dir/$filename"

# 推送元数据文件到TG
curl -F document=@"$filename.fbi" -F "caption=#free_backups $filename.fbi" "https://api.telegram.org/bot$tg_token/sendDocument?chat_id=$tg_chat_id"
rm -f "$backup_dir/$filename" "$filename.fbi"


# 解密参考
#  mkdir test
#  openssl des3 -d -k "$password" -salt -in backups/backup-web-202200000000.tar.gz | tar zxvf - -C test