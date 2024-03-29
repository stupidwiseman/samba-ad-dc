FROM debian:stable-slim

COPY init.sh /init.sh

RUN apt-get update && apt-get -y upgrade && apt-get -y install \
    acl attr \
    krb5-user \
    ldap-utils ldb-tools libnss-winbind libpam-winbind \
    samba smbclient \
    winbind \
&&  apt-get clean autoclean \
&&  apt-get autoremove --yes \
&&  rm -rf /var/lib/{apt,dpkg,cache,log}/ \
&&  rm -fr /tmp/* /var/tmp/*

CMD [ "/bin/sh", "/init.sh" ]