#!/bin/sh -e
set -o pipefail
DL="https://ghproxy.com"
[ -d /etc/chinadns-ng ] || mkdir /etc/chinadns-ng

#chnroute
wget-ssl --no-check-certificate -t 2 -T 20 $DL/https://raw.githubusercontent.com/pexcn/daily/gh-pages/chnroute/chnroute.txt -O /tmp/chnroute.txt.tmp
if [ -f /tmp/chnroute.txt.tmp ];then
mv -f /tmp/chnroute.txt.tmp /etc/chinadns-ng/chnroute.txt
logger "update chnroute success"
else
logger "update chnroute error"
fi

#chnroute6
wget-ssl --no-check-certificate -t 2 -T 20 $DL/https://raw.githubusercontent.com/pexcn/daily/gh-pages/chnroute/chnroute-v6.txt -O /tmp/chnroute-v6.txt.tmp
if [ -f /tmp/chnroute-v6.txt.tmp ];then
mv -f /tmp/chnroute-v6.txt.tmp /etc/chinadns-ng/chnroute6.txt
logger "update chnroute6 success"
else
logger "update chnroute6 error"
fi

#gfwlist
wget-ssl --no-check-certificate -t 2 -T 20 $DL/https://raw.githubusercontent.com/pexcn/daily/gh-pages/gfwlist/gfwlist.txt -O /tmp/gfwlist.txt.tmp
if [ -f /tmp/gfwlist.txt.tmp ];then
mv -f /tmp/gfwlist.txt.tmp /etc/chinadns-ng/gfwlist.txt
logger "update gfwlist success"
else
logger "update gfwlist error"
fi

#chinalist
wget-ssl --no-check-certificate -t 2 -T 20 $DL/https://raw.githubusercontent.com/pexcn/daily/gh-pages/chinalist/chinalist.txt -O /tmp/chinalist.txt.tmp
if [ -f /tmp/chinalist.txt.tmp ];then
mv -f /tmp/chinalist.txt.tmp /etc/chinadns-ng/chinalist.txt
logger "update chinalist success"
else
logger "update chinalist error"
fi
/etc/init.d/chinadns-ng restart
