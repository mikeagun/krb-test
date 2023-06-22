FROM alpine:3.18.2
MAINTAINER Michael Agun <mikeagun@gmail.com>

#runs ssh server authenticated with kerberos

# BUILD FROM PARENT DIRECTORY
# build command: $ sudo docker build -t krb-test-sshd:latest -f sshd/Dockerfile .

RUN \
  apk add --no-cache krb5 openssh-server-krb5 #install ssh server and kerberos client tools


#we build from parent directory (to share global confs), so paths are relative to that
COPY --chown=root:root --chmod=444 krb5.conf /etc/krb5.conf
COPY --chown=root:root --chmod=400 sshd/sshd_config /etc/ssh/sshd_config
COPY --chown=root:root --chmod=500 sshd/init.sh /init.sh
COPY --chown=root:root --chmod=500 sshd/healthcheck.sh /healthcheck.sh

#setup steps:
#  - generate ssh host keys
#  - create users for ssh login (with disabled passwords)
#  - change disabled passwords from ! to * (this version of ssh-server treats ! as disabled account)
RUN \
  ssh-keygen -A \
  && adduser --disabled-password sshuser \
  && adduser --disabled-password sshuserpass \
  && sed -i -e 's/^\(sshuser\(pass\)\?:\)[^:]*/\1*/' /etc/shadow


HEALTHCHECK --interval=30s --timeout=3s --start-period=3s --retries=2 CMD ["/healthcheck.sh"]

EXPOSE 22

ENTRYPOINT ["/init.sh"]
#ENTRYPOINT ["sshd.krb5","-D"]
#ENTRYPOINT ["/usr/sbin/sshd","-D"]

#CMD ["/bin/sh"]

COPY --from=krb-test-kdc:latest /sshd.keytab /etc/krb5.keytab
