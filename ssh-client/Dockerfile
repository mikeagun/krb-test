FROM alpine:3.18.2
MAINTAINER Michael Agun <mikeagun@gmail.com>

#ssh client for testing kerberos auth

# BUILD FROM PARENT DIRECTORY
# build command: $ sudo docker build -t krb-test-ssh-client:latest -f ssh-client/Dockerfile .

RUN \
  apk add --no-cache krb5 openssh-client-krb5 #install ssh and kerberos client tools

#we build from parent directory (to share global confs), so paths are relative to that
COPY --chown=root:root --chmod=444 krb5.conf /etc/krb5.conf
COPY --chown=root:root --chmod=400 ssh-client/ssh_config /etc/ssh/ssh_config


#ENTRYPOINT ["start.sh"]
#CMD ["/bin/sh"]

COPY --from=krb-test-kdc:latest /sshuser.keytab /etc/krb5.keytab
