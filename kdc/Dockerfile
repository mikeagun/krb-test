FROM alpine:3.18.2
MAINTAINER Michael Agun <mikeagun@gmail.com>

#image for running kerberos kdc and admin server

# BUILD FROM PARENT DIRECTORY
# build command: $ sudo docker build -t krb-test-kdc:latest -f kdc/Dockerfile .

#FIXME: only need krb5 for initial testing, after that just krb5-server
RUN \
  apk add --no-cache krb5-server krb5 #install kerberos kdc and admin server

#we build from parent directory (to share global confs), so paths are relative to that
COPY --chown=root:root --chmod=444 krb5.conf /etc/krb5.conf
COPY --chown=root:root --chmod=400 kdc/kdc.conf /var/lib/krb5kdc/kdc.conf
COPY --chown=root:root --chmod=400 kdc/kadm5.acl /var/lib/krb5kdc/kadm5.acl
COPY --chown=root:root --chmod=500 kdc/init.sh /init.sh
COPY --chown=root:root --chmod=500 kdc/healthcheck.sh /healthcheck.sh

HEALTHCHECK --interval=30s --timeout=3s --start-period=3s --retries=2 CMD ["/healthcheck.sh"]

EXPOSE 749 88/udp

ENTRYPOINT ["init.sh"]
#CMD ["/bin/sh"]
