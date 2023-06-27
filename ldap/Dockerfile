FROM alpine:3.18.2
MAINTAINER Michael Agun <mikeagun@gmail.com>

#image for running ldap server with kerberos auth

# BUILD FROM PARENT DIRECTORY
# build command: $ sudo docker build -t krb-test-ldap:latest -f ldap/Dockerfile .

#Install kerberos and ldap tools and do some initial configuration
#FIXME: don't need -clients after initial testing
#
#setup steps:
# - install kerberos,ldap
# - create slapd.d directory
# - rename default slapd.conf
RUN \
  apk add --no-cache krb5 openldap openldap-back-mdb openldap-clients \
  && install -m 755 -o ldap -g ldap -d /etc/openldap/slapd.d \
  && mv /etc/openldap/slapd.conf /etc/openldap/slapd.conf_default

#we build from parent directory (to share global confs), so paths are relative to that
COPY --chown=root:root --chmod=444 krb5.conf /etc/krb5.conf
COPY --chown=root:root --chmod=400 ldap/slapd.ldif /etc/openldap/slapd.ldif



COPY --chown=root:root --chmod=500 ldap/entrypoint.sh /entrypoint.sh
COPY --chown=root:root --chmod=500 ldap/healthcheck.sh /healthcheck.sh
#ports:
# - 389 - LDAP (plain channel, can still use starttls)
# - 636 - LDAPS (encrypted channel)
EXPOSE 389
EXPOSE 636

#ENTRYPOINT ["sleep","infinity"]
ENTRYPOINT ["/entrypoint.sh"]

#CMD ["/bin/sh"]

COPY --from=krb-test-kdc:latest /ldap.keytab /etc/krb5.keytab
