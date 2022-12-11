#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

## 解除系统限制
ulimit -u 10000
ulimit -n 4096
ulimit -d unlimited
ulimit -m unlimited
ulimit -s unlimited
ulimit -t unlimited
ulimit -v unlimited

sed -i "/exit 0/d" package/lean/default-settings/files/zzz-default-settings
echo "sed -i s/openwrt.org/www.baidu.com/g /etc/config/luci" >> package/lean/default-settings/files/zzz-default-settings
#echo "sed -i '2a /etc/init.d/odhcpd disable' /etc/rc.local" >> package/lean/default-settings/files/zzz-default-settings
#echo "sed -i '4a /etc/init.d/led disable' /etc/rc.local" >> package/lean/default-settings/files/zzz-default-settings
#echo "sed -i '4a /etc/init.d/hd-idle disable' /etc/rc.local" >> package/lean/default-settings/files/zzz-default-settings
#echo "sed -i '4a /etc/init.d/haproxy disable' /etc/rc.local" >> package/lean/default-settings/files/zzz-default-settings
#echo "sed -i '4a mount --make-shared /mnt/mmcblk2p4/' /etc/rc.local" >> package/lean/default-settings/files/zzz-default-settings
#echo "sed -i 's#/bin/login#/bin/login -f root#' /etc/config/ttyd" >> package/lean/default-settings/files/zzz-default-settings            # 设置ttyd免帐号登录，如若开启，进入OPENWRT后可能要重启一次才生效
#echo "[ -f /etc/docker/daemon.json ] && mv /etc/docker/daemon.json /etc/docker/daemon.json.bak" >> package/lean/default-settings/files/zzz-default-settings
echo "exit 0" >> package/lean/default-settings/files/zzz-default-settings

# Modify default PassWord
sed -i 's/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/root:$1$a87b3JDA$O5S5vtQFGIL9deGI2KeBg1:0:0:99999:7:::/g' package/lean/default-settings/files/zzz-default-settings
# Add ssh-rsa
sed -i '40a echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5mxNSzSRs61tdDIp2GfqQRcj/e3XoMA8gicBF5J3Bwa6XgIjU9z5psi4JA6HJ3XxiEX32LCeluIiyj37WyyvxS1JOJB0FOPQFQ49kwfE3v9agRCdmqlQWV1/QTTFRbWBznY4u575x9TLWfnPEXwvqmG/Y+4farcWHlEqzgND56lrFmn6b6iKik+xbWtuQFVIktsy9hOTeWXS7jM1iaBo6QgEitni7SNhOQ+c4127wKeTXvVwU+FfWAI7X7OZeIPpvt6Syb4pzIZcNHdiAYzeCVeaE+9Lp+byYEFtjUpIjtHvpV4wvrVHbOaIjfxQBZ4v41W5heS8G3ljzlkU+Wb7eq9htN48RsPObzkuhnPkQeiV5DOI1O+twuWJ07pj/z96iAIeZMBJY77ezZi+ufDTKq4+rxjyexExEWGFkLsIuLNyuvT4RIysxrcR0Uf/TT8Xm2e8Li+Fbn/kKbgAQ2PfZdgi+y03s6lPPoOh1dqVINj3cHzimsKNKL5Jw/vGPjFE= ye@MacBook-Pro.local" > /etc/dropbear/authorized_keys' package/lean/default-settings/files/zzz-default-settings


# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' ./feeds/luci/collections/luci/Makefile

# Modify default IP（FROM 192.168.1.1 CHANGE TO 10.10.10.1）
sed -i 's/192.168.1.1/10.10.10.100/g' package/base-files/files/bin/config_generate

# Modify system hostname（FROM OpenWrt CHANGE TO OpenWrt-N1）
# sed -i 's/OpenWrt/OpenWrt-N1/g' package/base-files/files/bin/config_generate

# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings

sed -i 's/invalid users = root/#invalid users = root/g' feeds/packages/net/samba4/files/smb.conf.template


# 拉取软件包

git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
git clone https://github.com/kenzok8/small-package package/small-package
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic
svn co https://github.com/kiddin9/openwrt-packages/trunk/UnblockNeteaseMusic-Go package/UnblockNeteaseMusic-Go
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-unblockneteasemusic-go package/luci-app-unblockneteasemusic-go


# 删除重复包

# rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf package/small-package/luci-app-openvpn-server
rm -rf package/small-package/openvpn-easy-rsa-whisky
rm -rf package/small-package/luci-app-koolproxyR
rm -rf package/small-package/luci-app-godproxy
rm -rf package/small-package/luci-app-argon*
rm -rf package/small-package/luci-theme-argon*
rm -rf package/small-package/luci-app-amlogic
rm -rf package/small-package/luci-app-unblockneteasemusic
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf package/feeds/packages/naiveproxy
rm -rf feeds/packages/net/naiveproxy


# 其他调整
NAME=$"package/luci-app-unblockneteasemusic/root/usr/share/unblockneteasemusic" && mkdir -p $NAME/core
curl 'https://api.github.com/repos/UnblockNeteaseMusic/server/commits?sha=enhanced&path=precompiled' -o commits.json
echo "$(grep sha commits.json | sed -n "1,1p" | cut -c 13-52)">"$NAME/core_local_ver"
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/app.js -o $NAME/core/app.js
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/bridge.js -o $NAME/core/bridge.js
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/ca.crt -o $NAME/core/ca.crt
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.crt -o $NAME/core/server.crt
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.key -o $NAME/core/server.key

sed -i 's#https://github.com/breakings/OpenWrt#https://github.com/quanjindeng/Actions_OpenWrt-Amlogic#g' package/luci-app-amlogic/luci-app-amlogic/root/etc/config/amlogic
sed -i 's#ARMv8#openwrt_armvirt#g' package/luci-app-amlogic/luci-app-amlogic/root/etc/config/amlogic
sed -i 's#opt/kernel#kernel#g' package/luci-app-amlogic/luci-app-amlogic/root/etc/config/amlogic

sed -i 's#mount -t cifs#mount.cifs#g' feeds/luci/applications/luci-app-cifs-mount/root/etc/init.d/cifs

#sed -i 's#<%+cbi/tabmenu%>##g' package/small-packages/luci-app-nginx-manager/luasrc/view/nginx-manager/index.htm

# 为alist插件更换最新的golang版本
# rm -rf feeds/packages/lang/golang
# svn export https://github.com/sbwml/packages_lang_golang/trunk feeds/packages/lang/golang

# mosdns
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f
git clone https://github.com/sbwml/luci-app-mosdns package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/geodata
