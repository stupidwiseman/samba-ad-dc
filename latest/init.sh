#!/bin/sh

# 変数定義
ADSSETUP=${ADSSETUP:-PRIMARY}
HOST_IP=${HOST_IP:-na}
UPASSWD=${UPASSWD:-$ADPASSWD}

if [ $ADSSETUP == "PRIMARY"]; then
    DOMAIN="--domain=${DOMAIN}"
    REALM="--realm=${REALM}"
    ADPASSWD="--adminpass=${ADPASSWD}"
    UPASSWD="--password=${UPASSWD}"
    if [ HOST_IP != "na" ]; then
        HOST_IP="--host-ip=${HOST_IP}"
    fi
fi

# ADのセットアップ内容に基づくコマンドオプションセット
if [ $ADSSETUP == "PRIMARY"]; then
    if [ -e /etc/samba/smb.conf ]; then
        rm /etc/samba/smb.conf
    fi
    opt1="domain provision --use-rfc2307 ${DOMAIN} ${REALM} --server-role=dc --dns-backend=SAMBA_INTERNAL ${ADPASSWD} ${HOST_IP}"
    else
        opt1="domain join ${REALM} DC -U ${ADMIN} ${UPASSWD}"
        opt2="drs replicate ${PDC} ${SDC} ${REALM}"
fi

# ADのセットアップ内容に基づく初期設定
samba-tool ${opt1}
service samba-ad-dc restart

if [ ${ADSSETUP} == "SECONDARY" ]; then
    samba-tool ${opt2}
fi