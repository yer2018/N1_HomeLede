#!/bin/sh
if [ ! -L /usr/bin/AdGuardHome ];then
rm -rf /usr/bin/AdGuardHome
ln -sf /mnt/mmcblk2p4/AdGuardHome/ /usr/bin/
fi
ifconfig br-lan &> /dev/null
if [ $? -eq 0 ];then
ROUTER_IP=$(ifconfig br-lan | grep 'inet addr' | sed 's/^.*addr://g' | cut -d ' ' -f 1)
else
ROUTER_IP=$(ifconfig eth0 | grep 'inet addr' | sed 's/^.*addr://g' | cut -d ' ' -f 1)
fi
IP_INCONFIG=$ROUTER_IP

if [ -f "/etc/AdGuardHome/AdGuardHome.yaml" ];
then
IP_IN_CONFIG=$(cat /etc/AdGuardHome/AdGuardHome.yaml | grep "bind_host:" | sed -n 1p | cut -d ' ' -f 2)
fi

if [ ! -f "/etc/AdGuardHome/AdGuardHome.yaml" ];
then
        /etc/AdGuardHome/initConfig.sh
fi

if [ "$IP_IN_CONFIG" != "$ROUTER_IP" ];
then
echo "Router lan ip changed. Automatic change ip address in /etc/AdGuardHome/AdGuardHome.yaml."
echo "Change bind_host form "$IP_IN_CONFIG" to "$ROUTER_IP"."
sed -i "s/^bind_host: .*$/bind_host: "$ROUTER_IP"/" /etc/AdGuardHome/AdGuardHome.yaml
echo "Bind address in /etc/AdGuardHome/AdGuardHome.yaml has been changed to "$ROUTER_IP"."
fi

/usr/bin/AdGuardHome/AdGuardHome -c /etc/AdGuardHome/AdGuardHome.yaml --no-check-update
