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

######## 备用（暂不生效） ########
# 修改IP项的EOF于EOF之间请不要插入其他扩展代码，可以删除或注释里面原本的代码
# 如果你的OP是当主路由的话，网关、DNS、广播都不需要，代码前面加 # 注释掉，只保留后台地址和子网掩码就可以
# 如果你有编译ipv6的话，‘去掉LAN口使用内置的 IPv6 管理’代码前面也加 # 注释掉

#cat >package/base-files/files/etc/networkip <<-EOF
#uci set network.lan.ipaddr='10.10.10.100'                                    # IPv4 地址(openwrt后台地址)
#uci set network.lan.netmask='255.255.255.0'                                 # IPv4 子网掩码
#uci set network.lan.gateway='10.10.10.2'                                   # IPv4 网关
#uci set network.lan.broadcast='10.10.10.255'                               # IPv4 广播
#uci set network.lan.dns='127.0.0.1'                         # DNS(多个DNS要用空格分开)
#uci set network.lan.delegate='0'                                            # 去掉LAN口使用内置的 IPv6 管理
#uci commit network                                                          # 不要删除跟注释,除非上面全部删除或注释掉了
#uci set dhcp.lan.ignore='1'                                                 # 关闭DHCP功能
#uci commit dhcp                                                             # 跟‘关闭DHCP功能’联动,同时启用或者删除跟注释
#uci set system.@system[0].hostname='Phicomm-N1'                             # 修改主机名称为OpenWrt-N1
#EOF
######## 备用（暂不生效） ########


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
sed -i 's/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/root:$1$.QWp3Sfb$BqubwqydcdzGBiOiwnHk/1:19419:0:99999:7:::/g' package/lean/default-settings/files/zzz-default-settings
# Add ssh-rsa
sed -i '40a echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDaC94zpxOIDSvXSYnZvxxBWB/Iw4LDL7jo6guAFKFJu+0oPJ73tdVoDf7szFZoqyLmmVQ/3dsa3BFyMM4dB5C51oK6TsHYwGh4m/0mfF4Rp7IFiaENijWdvkhZ9j4WSqonoKdyPzz0c3pycI53AdvgZFdM4EGrMrxMQmf/eXaRM75rrsTbWjkmVraPAiQ1m4hSePgq0kK9rh1qdg2P7TiTPiUH+UrG1WYdXq3taSTq1lY+ND5NgLxkmj6esZZzPH/4ddZIAlo7GvUBSIUDzeo7SKdThzdS4l/kIXBkrfvi1Pn3Cr+JP2DDbwsNFjV1ifeu8xLu56l0gPUP5/24HZm28UDSElBRX/uYmPtXt3eOArme/O/Zp61GKKbv2qirzctboZn7eteXqmKaXlBbsI9p3MjyfclFPQikdyUbVoT6XT4rU3XfprQYg9oZTJ8Grca2M1NrUHxnYSlhoEfD7gxSFwIzgkaOiaGcH9v1CKmNWVopbXFFsclJ1FhjjEB3wEM= ye@MacBook-Pro.local" > /etc/dropbear/authorized_keys' package/lean/default-settings/files/zzz-default-settings

# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' ./feeds/luci/collections/luci/Makefile
#\cp -rf ../bg1.jpg feeds/xiaoqingfeng/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
sed -i 's/width: 420px;/width: 250px;/g' feeds/xiaoqingfeng/luci-theme-argon/htdocs/luci-static/argon/css/cascade.css
sed -i 's/margin-left: 5%;/margin-left: 0%;/g' feeds/xiaoqingfeng/luci-theme-argon/htdocs/luci-static/argon/css/cascade.css
sed -i 's/  --blur-radius-dark: 10px;/  --blur-radius-dark: 0px;/g' feeds/xiaoqingfeng/luci-theme-argon/htdocs/luci-static/argon/css/cascade.css
sed -i 's/  --blur-opacity-dark: 0.5;/  --blur-opacity-dark: 0;/g' feeds/xiaoqingfeng/luci-theme-argon/htdocs/luci-static/argon/css/cascade.css

# Modify some code adaptation
# sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' feeds/luci/applications/luci-app-cpufreq/Makefile

# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Set DISTRIB_REVISION
# sed -i "s/OpenWrt /Deng Build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

# Modify default IP（FROM 192.168.1.1 CHANGE TO 10.10.10.1）
sed -i 's/192.168.1.1/10.10.10.100/g' package/base-files/files/bin/config_generate

# Modify system hostname（FROM OpenWrt CHANGE TO OpenWrt-N1）
sed -i 's/OpenWrt/Phicomm-N1/g' package/base-files/files/bin/config_generate

# Modify default Time zone
sed -i "s/'UTC'/'CST-8'\n   set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

# firewall custom
echo "#iptables -t nat -I POSTROUTING -o br-lan -j MASQUERADE" >> package/network/config/firewall/files/firewall.user

# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings

# sed -i 's/invalid users = root/#invalid users = root/g' feeds/packages/net/samba4/files/smb.conf.template


# 拉取软件包

#git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
#git clone https://github.com/kenzok8/small-package package/small-package
#git clone -b luci https://github.com/pexcn/openwrt-chinadns-ng.git package/luci-app-chinadns-ng
#svn co https://github.com/immortalwrt-collections/openwrt-gowebdav/trunk/luci-app-gowebdav package/luci-app-gowebdav
#svn co https://github.com/immortalwrt-collections/openwrt-gowebdav/trunk/gowebdav package/gowebdav
#git clone https://github.com/small-5/luci-app-adblock-plus.git package/luci-app-adblock-plus
#git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
#svn co https://github.com/kenzok8/small-package/trunk/luci-app-openclash package/feeds/luci/luci-app-openclash
#git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/feeds/luci/luci-app-unblockneteasemusic
#svn co https://github.com/kiddin9/openwrt-packages/trunk/UnblockNeteaseMusic-Go package/feeds/luci/UnblockNeteaseMusic-Go
#svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-unblockneteasemusic-go package/feeds/luci/luci-app-unblockneteasemusic-go

# 删除重复包

# rm -rf feeds/luci/applications/luci-app-netdata
# rm -rf feeds/luci/themes/luci-theme-argon
# rm -rf package/small-package/luci-app-openvpn-server
# rm -rf package/small-package/openvpn-easy-rsa-whisky
# rm -rf package/small-package/luci-app-wrtbwmon
# rm -rf package/small-package/wrtbwmon
# rm -rf package/small-package/luci-app-koolproxyR
# rm -rf package/small-package/luci-app-godproxy
# rm -rf package/small-package/luci-app-argon-config
# rm -rf package/feeds/luci/luci-app-unblockmusic

# 其他调整

#wget https://raw.githubusercontent.com/NobyDa/Script/master/JD-DailyBonus/JD_DailyBonus.js -O feeds/xiaoqingfeng/luci-app-jd-dailybonus/root/usr/share/jd-dailybonus/JD_DailyBonus.js


#NAME=$"package/luci-app-unblockneteasemusic/root/usr/share/unblockneteasemusic" && mkdir -p $NAME/core
#curl 'https://api.github.com/repos/UnblockNeteaseMusic/server/commits?sha=enhanced&path=precompiled' -o commits.json
#echo "$(grep sha commits.json | sed -n "1,1p" | cut -c 13-52)">"$NAME/core_local_ver"
#curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/app.js -o $NAME/core/app.js
#curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/bridge.js -o $NAME/core/bridge.js
#curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/ca.crt -o $NAME/core/ca.crt
#curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.crt -o $NAME/core/server.crt
#curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.key -o $NAME/core/server.key

#sed -i 's#https://github.com/breakings/OpenWrt#https://github.com/yer2018/Actions_OpenWrt-Amlogic#g' package/feeds/amlogic/luci-app-amlogic/root/etc/config/amlogic
#sed -i 's#ARMv8#openwrt_armvirt#g' package/feeds/amlogic/luci-app-amlogic/root/etc/config/amlogic

#sed -i 's#https://github.com/breakings/OpenWrt#https://github.com/yer2018/Actions_OpenWrt-Amlogic#g' package/feeds/amlogic/luci-app-amlogic/root/etc/config/amlogic
#sed -i 's#ARMv8#openwrt_armvirt#g' package/feeds/amlogic/luci-app-amlogic/root/etc/config/amlogic
#sed -i 's#opt/kernel#kernel#g' package/feeds/amlogic/luci-app-amlogic/root/etc/config/amlogic
#sed -i 's#5.4#5.15#g' package/feeds/amlogic/luci-app-amlogic/root/etc/config/amlogic

#bash.bashrc
#echo 'alias ql="docker exec -it qinglong /bin/sh"' >> package/base-files/files/etc/bash.bashrc
#echo 'alias ll="ls -lhA"' >> package/base-files/files/etc/bash.bashrc

#crontabs
mkdir -p package/base-files/files/etc/crontabs/
echo "0 6 1 * * /etc/AdGuardHome/update.sh &> /dev/null" >> package/base-files/files/etc/crontabs/root
echo "0 0 * * 0 /etc/init.d/smartdns restart &> /dev/null" >> package/base-files/files/etc/crontabs/root
echo "0 0 * * 0 /usr/bin/chinadns-ng-daily.sh &> /dev/null" >> package/base-files/files/etc/crontabs/root
#echo "0 */6 * * * [ -f /mnt/mmcblk2p4/AdGuardHome/data/querylog.json.1 ] && rm -rf /mnt/mmcblk2p4/AdGuardHome/data/querylog.json.1" >> package/base-files/files/etc/crontabs/root
#echo "0 0 * * * sh /usr/share/jd-dailybonus/newapp.sh -s" >> package/base-files/files/etc/crontabs/root



