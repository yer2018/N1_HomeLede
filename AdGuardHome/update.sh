#!/bin/sh

#获取当前系统架构
os="`uname -m`"
if [ $os == "aarch64" ];then
     os="arm64"
fi

if [ $os == "x86_64" ];then
     os="amd64"
fi

#下载最新版本
download="wget-ssl --no-check-certificate -t 2 -T 20 https://static.adguard.com/adguardhome/release/AdGuardHome_linux_$os.tar.gz -O /usr/bin/AdGuardHome/AdGuardHome_linux_$os.tar.gz"

#获取当前版本
now_ver="$(/usr/bin/AdGuardHome/AdGuardHome --version|awk {'print $4'})"

#获取最新版本
latest_ver="$(curl -L -k --retry 2 --connect-timeout 20 -o - https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest 2>/dev/null|grep -E 'tag_name' |grep -E 'v[0-9.]+' -o 2>/dev/null)"
if [ "${latest_ver}"x != "${now_ver}"x ];then
    cp -f /usr/bin/AdGuardHome/AdGuardHome /usr/bin/AdGuardHome/AdGuardHome.old
    $download
    if [ -f /usr/bin/AdGuardHome/AdGuardHome_linux_$os.tar.gz ];then
    cd /usr/bin/
    tar -zxf /usr/bin/AdGuardHome/AdGuardHome_linux_$os.tar.gz ./AdGuardHome/AdGuardHome
    rm -f /usr/bin/AdGuardHome/AdGuardHome_linux_$os.tar.gz
    else
    rm -f /usr/bin/AdGuardHome/AdGuardHome_linux_$os.tar.gz
    /usr/bin/logger "下载失败 请重试"
    exit
    fi
    /etc/init.d/AdGuardHome reload
    /usr/bin/logger "AdGuardHome $latest_ver 更新最新版本"
    else
    /usr/bin/logger "AdGuardHome $now_ver 已是最新版本"
fi

