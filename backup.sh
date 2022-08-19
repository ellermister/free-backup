#!/bin/bash
# author: ellermister
# Backup files to the cloud for free

chunkBytesSize=$(expr 1024 \* 5) # KB
outPath=outs
realImage=bbb.jpg
action=$1
filePath=$2

# 上传图片
upload_image(){
    local img_path=$1
    a9ih0st="YUhSMGNITTZMeTlpWVdscWFXRm9ZVzh1WW1GcFpIVXVZMjl0TDJKMWFXeGtaWEpwYm01bGNpOWhjR2t2WTI5dWRHVnVkQzltYVd4bApMM1Z3Ykc5aFpBbz0K"
    curl -s $(echo "$a9ih0st"|base64 -d|base64 -d) \
    -H 'Accept: application/json' \
    -H 'Accept-Language: en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/533.37' \
    -H 'Cache-Control: no-cache' \
    -H 'Connection: keep-alive' \
    -F 'no_compress=1' \
    -F 'id=WU_FILE_0' \
    -F 'is_avatar=0' \
    -F "media=@$img_path" \
    | grep -o -P '(?<="org_url":").*?(?=")'
}


# 伪装为图片
disguised_as_image(){
    cat $realImage $1 > "$1.jpg"
    echo "$1.jpg"
}

# 分割到文件块
split_to_chunk_file(){
    echo "chunk file : $1"
    local filePath=$1
    local fileName=$(basename "$filePath")
    
    if [[ -z $filePath || ! -f $filePath ]];then
        echo "filePath not found!"
        exit
    fi
    
    fileSize=$(du -b $filePath | awk '{print $1}')
    echo "The filesize is:$fileSize"
    echo "chunk size is: $chunkBytesSize"
    
    subFileNum=$(expr $fileSize / $(expr $chunkBytesSize \* 1024 ))
    if [ $(expr $fileSize % $chunkBytesSize) -ne 0 ];then
        subFileNum=$(expr $subFileNum + 1)
    fi
    echo "sub file number: $subFileNum"
    
    echo "$fileName will be divided into $subFileNum"
    local i=1
    local skipnum=0
    while [ $i -le $subFileNum ]
    do
        echo "$fileName$i"
        dd if=$filePath of="$outPath/$fileName.$i" bs=1024 count=$chunkBytesSize skip=$skipnum
        i=$(expr $i + 1)
        skipnum=$(expr $skipnum + $chunkBytesSize)
    done
    echo "$fileName has been divided into $subFileNum"
    
    i=1
    echo -e "fileName=$fileName\nfileSize=$fileSize\nchunkBytesSize=$chunkBytesSize\nsubFileNum=$subFileNum" > "$fileName.fbi"
    while [ $i -le $subFileNum ]
    do
        echo "disguised as a image: $outPath/$fileName.$i"
        fakeImage=$(disguised_as_image "$outPath/$fileName.$i")
        
        fakeImageUrl=$(upload_image "$fakeImage")
        echo "splitFiles[$i]=$fakeImageUrl" >> "$fileName.fbi"
        
        # delete temp file
        rm -f "$fakeImage" "$outPath/$fileName.$i"
        i=$(expr $i + 1)
    done
    
    echo "Done !"
}

# 恢复备份文件
recover_backup_file(){
    fbHeadFile=$1
    source $fbHeadFile
    if [ -z $fileName ];then
        echo "Invalid meta information file!"
        exit 1
    fi
    echo $fileName;
    
    realfileSize=$(du -b $realImage | awk '{print $1}')
    
    i=1
    rm -f "$outPath/finish.tmp"
    touch "$outPath/finish.tmp"
    while [ $i -le $subFileNum ]
    do
        packFileUrl=${splitFiles[$i]}
        echo $packFileUrl
        wget $packFileUrl -O "$outPath/tmp.$i"
        dd if="$outPath/tmp.$i" of="$outPath/tmp.output.$i" bs=$realfileSize skip=1
        cat "$outPath/finish.tmp" "$outPath/tmp.output.$i" > "$outPath/finish.tmp2"
        mv  "$outPath/finish.tmp2"  "$outPath/finish.tmp"
        rm -f "$outPath/tmp.output.$i"  "$outPath/tmp.$i"
        i=$(expr $i + 1)
    done
    
    mv "$outPath/finish.tmp" "$outPath/$fileName"
}

if [[ -z $action || -z $filePath ]];then
    echo "Usage: ./backup.sh [ACTION] [FILENAME]"
    echo ""
    echo -e "./backup.sh upload pyinstall.exe \t backup file to cloud"
    echo -e "./backup.sh download pyinstall.exe.fbi \t recover backup file from cloud"
    exit 1
fi

if [ ! -f $filePath ];then
    echo 'The file not exist!'
    exit 1
fi

if [ ! -d $outPath ];then
    mkdir $outPath
fi

if [ $action == "upload" ];then
    split_to_chunk_file $filePath
elif [ $action == "download" ];then
    recover_backup_file $filePath
fi

# 备份文件
# ./backup.sh upload pyinstall.exe

# 恢复文件
# ./backup.sh download pyinstall.exe.fbi
