#!/bin/bash
echo "Running IPTables Script from:"
pwd
sleep 1
iptables-save > b4script.iptables.bck
iptables -F
#
# IPv6 DROP POLICY
ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP
ip6tables -P FORWARD DROP
#
# Flush Input Drop Input Rule if it is shut:
iptables -A INPUT -f -j DROP
#
# OPEN INBOUND UNLIMITED:
iptables -A INPUT -p udp --match multiport --dports 53 -j ACCEPT
iptables -A INPUT -p tcp --match multiport --dports 53 -j ACCEPT
iptables -A INPUT -p udp --match multiport --dports 123 -j ACCEPT
iptables -A INPUT -p udp --match multiport --sports 123 -j ACCEPT
-A INPUT -p tcp --match multiport --dports 80,110,143 -j ACCEPT
-A INPUT -p tcp --match multiport --sports 80,110,143 -j ACCEPT
#
# DOS PREVENTION
iptables -A INPUT -p tcp ! --tcp-flags SYN,ACK SYN -m state --state NEW -j DROP
iptables -A INPUT -p udp -m state NEW -m recent --set --name DEFAULT --mask 255.255.255.255 --rsource -j DROP
iptables -A INPUT -p udp -m state NEW -m recent --update -- seconds 10 --hitcount 50 --name DEFAULT --mask 255.255.255.255 --rsource
iptables -A INPUT -p tcp -m state NEW -m recent --set --name DEFAULT --mask 255.255.255.255 --rsource -j DROP
iptables -A INPUT -p tcp -m state NEW -m recent --update -- seconds 10 --hitcount 50 --name DEFAULT --mask 255.255.255.255 --rsource
#
# RATE LIMITED OPEN INBOUND:
iptables -A INPUT -p tcp --match multiport --dports 25,80,443 -j ACCEPT
iptables -A INPUT -p tcp --match multiport --sports 25,80,443 -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
#
# OPEN OUTBOUND
iptables -A OUTPUT -f -j DROP
iptables -A OUTPUT -p tcp ! --tcp-flags SYN,ACK SYN -m state --state NEW -j DROP
iptables -A OUTPUT -p udp --match multiport --dports 53,123 -j ACCEPT
#
#
iptables -A OUTPUT -p udp --match multiport --sports 53,123 -j ACCEPT
iptables -A OUTPUT -p tcp --match multiport --dports 53 -j ACCEPT
iptables -A OUTPUT -p tcp --match multiport --sports 53 -j ACCEPT
iptables -A INPUT -p tcp ! --tcp-flags SYN,ACK SYN -m state --state NEW -j DROP
iptables -A OUTPUT -p tcp --match multiport --dports 80,443,25,80,110,143 -j ACCEPT
iptables -A OUTPUT -p tcp --match multiport --sports 80,443,25,80,110,143 -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT
#
# IPv4 DROP POLICY
iptables -P FORWARD DROP
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables-save > my.iptables.bck
#
#
if ! grep -q "net.ipv6.conf.all.disable_ipv6 = 1" /etc/sysctl.conf; then
  echo "#Disable IPv6
  net.ipv6.conf.all.disable_ipv6 = 1
  net.ipv6.conf.default.disable_ipv6 = 1
  net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf  
  sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
  sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
  sleep 1
fi

iptables -L
