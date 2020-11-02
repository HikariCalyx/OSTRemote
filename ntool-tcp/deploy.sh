#!/bin/bash
#
# This script is meant for deploying NTool TCP Reverse Proxy
# Server.
#
# For further details, please contact HCTSW Care.
#
# Created by Hikari Calyx <hikaricalyx@hikaricalyx.com>
#
# May be freely distributed and modified as needed,
# as long as proper attribution is given.
#

NginxUrlPrefix="https://nginx.org/download/"
NginxVersion="1.19.4"
ConfigurationUrlPrefix="https://raw.githubusercontent.com/HikariCalyx/OSTRemote/master/ntool-tcp/"

check-if-root()
{
    if [ `whoami` = "root" ]; then
        echo "Please run this script under root account!"
        echo "请在 root 账户下执行此脚本！"
        exit
    fi
}

hctsw-care-install-prerequisite()
{
	if [ -f "/usr/bin/dnf" ] && [ -d "/etc/yum.repos.d" ]; then
		PM="dnf"
	elif [ -f "/usr/bin/yum" ] && [ -d "/etc/yum.repos.d" ]; then
		PM="yum"
	elif [ -f "/usr/bin/apt" ] && [ -f "/usr/bin/dpkg" ]; then
		PM="apt"	
    else
        echo "Unsupported Linux distro!"
        echo "不支持该 Linux 发行版！"
        exit
	fi

	if [ "${PM}" = "dnf" ];then
		dnf install -y make gcc zlib zlib-devel openssl openssl-devel pcre pcre-devel wget
	elif [ "${PM}" = "yum" ];then
		yum install -y make gcc zlib zlib-devel openssl openssl-devel pcre pcre-devel wget
	elif [ "${PM}" = "apt" ];then
		apt install -y make gcc zlib1g zlib1g-dev openssl libssl-dev libpcre3 libpcre3-dev wget
	fi
}

hctsw-care-compile-nginx()
{
    cd
    wget --no-check-certificate -t 5 $NginxUrlPrefix/nginx-$NginxVersion.tar.gz
    tar xvf nginx-$NginxVersion.tar.gz
    cd nginx-$NginxVersion
    ./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module  --with-http_realip_module --with-http_gzip_static_module --with-stream --with-stream_ssl_module
    make
    make install
}

hctsw-care-nginx-config()
{
    rm -f /usr/local/nginx/conf/nginx.conf
    wget --no-check-certificate -t 5 -O /usr/local/nginx/conf/nginx.conf $ConfigurationUrlPrefix/conf/nginx.conf
}

hctsw-care-nginx-service()
{
    wget --no-check-certificate -t 5 -O /etc/systemd/system/nginx.service $ConfigurationUrlPrefix/conf/nginx.service
    systemctl daemon-reload
    systemctl enable nginx
    systemctl start nginx
}

hctsw-care-firewall()
{
	if [ -f "/usr/sbin/iptables" ]; then
		iptables -A INPUT -p tcp --dport 8814 -j ACCEPT
        iptables -A OUTPUT -p tcp --dport 8814 -j ACCEPT
        service iptables save
        systemctl restart iptables.service
	elif [ -f "/usr/sbin/firewall-cmd" ]; then
		firewall-cmd --zone=public --add-port=8814/tcp --permanent
		firewall-cmd --reload
		systemctl restart firewalld.service
    fi
}

hctsw-finish()
{
    echo "Finished. Once you enabled the port 8814 on firewall"
    echo "configuration panel of your hosting provider, you"
    echo "can now input your server IP address into SERVER IP"
    echo "box of Easy-Box Nokia Tool."
    echo "Thanks for supporting Hikari Calyx Tech."
    echo "配置完成。如果您已经在您的主机提供商的防火墙配置开启了"
    echo "8814 端口，您就可以在 Easy-Box Nokia Tool 的 SERVER IP"
    echo "输入框内输入您的服务器的 IP 地址来使用。"
    echo "感谢您对光卡科技的支持。"
}

check-if-root
hctsw-care-install-prerequisite
hctsw-care-compile-nginx
hctsw-care-nginx-config
hctsw-care-nginx-service
hctsw-care-firewall
hctsw-finish
