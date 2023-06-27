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

#setup steps:
#  - create realm with empty master key password
#  - create principles and keytabs
#  - we do this as soon as we have the configs copied to minimize key regen (and avoid rebuilding sshd/ssh-client)
RUN \
  echo -e '\n' | kdb5_util create -r KRB-TEST -s \
  && kadmin.local -q "addprinc -pw pass admin/admin" \
  && kadmin.local -q "addprinc -randkey healthcheck" \
  && kadmin.local -q "ktadd -k /healthcheck.keytab healthcheck" \
  && kadmin.local -q "addprinc -randkey host/sshd.krb-test" \
  && kadmin.local -q "ktadd -k /sshd.keytab host/sshd.krb-test" \
  && kadmin.local -q "addprinc -randkey ldap/ldap.krb-test" \
  && kadmin.local -q "ktadd -k /ldap.keytab host/ldap.krb-test" \
  && kadmin.local -q "addprinc -randkey sshuser" \
  && kadmin.local -q "ktadd -k /sshuser.keytab sshuser" \
  && kadmin.local -q "addprinc -pw pass sshuserpass"

COPY --chown=root:root --chmod=500 kdc/entrypoint.sh /entrypoint.sh
COPY --chown=root:root --chmod=500 kdc/healthcheck.sh /healthcheck.sh

HEALTHCHECK --interval=30s --timeout=3s --start-period=3s --retries=2 CMD ["/healthcheck.sh"]

EXPOSE 749 88/udp

ENTRYPOINT ["/entrypoint.sh"]
#CMD ["/bin/sh"]
