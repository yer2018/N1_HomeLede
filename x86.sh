#!/bin/bash

#DIY
## 解除系统限制
ulimit -u 10000
ulimit -n 4096
ulimit -d unlimited
ulimit -m unlimited
ulimit -s unlimited
ulimit -t unlimited
ulimit -v unlimited

# Modify default IP
sed -i 's/192.168.1.1/10.10.10.253/g' package/base-files/files/bin/config_generate

# Modify default Theme
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile 
#\cp -rf ../bg1.jpg feeds/xiaoqingfeng/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
sed -i 's/width: 420px;/width: 330px;/g' feeds/xiaoqingfeng/luci-theme-argon/htdocs/luci-static/argon/css/cascade.css
sed -i 's/margin-left: 5%;/margin-left: 0%;/g' feeds/xiaoqingfeng/luci-theme-argon/htdocs/luci-static/argon/css/cascade.css
sed -i 's/  --blur-radius-dark: 10px;/  --blur-radius-dark: 0px;/g' feeds/xiaoqingfeng/luci-theme-argon/htdocs/luci-static/argon/css/cascade.css
sed -i 's/  --blur-opacity-dark: 0.5;/  --blur-opacity-dark: 0;/g' feeds/xiaoqingfeng/luci-theme-argon/htdocs/luci-static/argon/css/cascade.css

# Modify default Time zone
sed -i "s/'UTC'/'CST-8'\n   set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

# firewall custom
echo "#iptables -t nat -I POSTROUTING -o br-lan -j MASQUERADE" >> package/network/config/firewall/files/firewall.user
# Modify default HostName
sed -i 's/OpenWrt/HomeLede/g' package/base-files/files/bin/config_generate
# Modify default PassWord
sed -i 's/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/root:$1$a87b3JDA$O5S5vtQFGIL9deGI2KeBg1:0:0:99999:7:::/g' package/lean/default-settings/files/zzz-default-settings
# Add ssh-rsa
#sed -i '40a echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQClNPo83GB5AiEmDTvY4gQEuTHVQ5qqDyRIa8RIus6D/UL5CNWx6+0JO2Vtigsxiq5Y8JyoLBW0Cs2oTWGLOQmGOf6S2suRzTv+UZotvCzFqnWHa6uwdQnEuYPLhR4jQs1rr+reBIHX8fZPda5KUBzfyFwHqANMfCLi3+KC3SY+BxcqmWY0d73oXriKUaKsBUC0cO58k5MbUuXQUdhd4K+MbEkJesO5vlOxQ0GA3JGiGYiZhv6M3f6cRDKTpralcFAbuvjwuk7+wM5hWTO2pFxk6He+W1bY7qrn2QNvIPwQv95aQQp/NekbGscJHSJrj5vTIewkOwdTDjUkeEoRevsV9LlJfQmfHcAlgdDRFQ+SUdjbanrKlq8DNMqYqw8si0EiIbIoftn/2ST9shV/CWImb/SV7zUk2fKcvPUfP6OId3KmG7eaVRB9g3O2sF13PvUQuyaiX+nvZtWBoxBMtbZ58P+2RVM7iYLI2llBTWtdXSzen5LoqS4rLP65x+j2VZc= ye@YedeMacBook-Pro.local" > /etc/dropbear/authorized_keys' package/lean/default-settings/files/zzz-default-settings
# Modify default Shell
#sed -i '43a sed -i "s/\\\/bin\\\/ash/\\\/usr\\\/bin\\\/zsh/g" /etc/passwd' package/lean/default-settings/files/zzz-default-settings
# Modify build date
# sed -i '56a echo "v`date +%Y.%m.%d`" > /etc/buildmark' package/lean/default-settings/files/zzz-default-settings
#echo '修改WIFI为开启'
#sed -i 's/disabled=1/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
#echo '修改默认WIFI名称'
#sed -i 's/ssid=OpenWrt/ssid=Phicomm_n1/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# Disable

sed -i "/exit 0/d" package/lean/default-settings/files/zzz-default-settings
echo "sed -i s/openwrt.org/www.baidu.com/g /etc/config/luci" >> package/lean/default-settings/files/zzz-default-settings
echo "sed -i '3a /etc/init.d/odhcpd disable' /etc/rc.local" >> package/lean/default-settings/files/zzz-default-settings
echo "sed -i '3a /etc/init.d/led disable' /etc/rc.local" >> package/lean/default-settings/files/zzz-default-settings
echo "sed -i '3a /etc/init.d/hd-idle disable' /etc/rc.local" >> package/lean/default-settings/files/zzz-default-settings
echo "sed -i '3a /etc/init.d/haproxy disable' /etc/rc.local" >> package/lean/default-settings/files/zzz-default-settings
#echo "sed -i '7a mount --make-shared /mnt/mmcblk2p4/' /etc/rc.local" >> package/lean/default-settings/files/zzz-default-settings
echo "sed -i 's/\/bin\/login/\/bin\/login -f root/' /etc/config/ttyd" >> package/lean/default-settings/files/zzz-default-settings            # 设置ttyd免帐号登录，如若开启，进入OPENWRT后可能要重启一次才生效
echo "exit 0" >> package/lean/default-settings/files/zzz-default-settings

#crontabs
mkdir -p package/base-files/files/etc/crontabs/
echo "0 6 1 * * /etc/AdGuardHome/update.sh &> /dev/null" >> package/base-files/files/etc/crontabs/root


