FROM alpine:3.18.2
MAINTAINER Michael Agun <mikeagun@gmail.com>

#runs ssh server authenticated with kerberos

# BUILD FROM PARENT DIRECTORY
# build command: $ sudo docker build -t krb-test-ssh-server:latest -f ssh-server/Dockerfile .

RUN \
  apk add --no-cache krb5 openssh-server-krb5 #install ssh server and kerberos client tools


#we build from parent directory (to share global confs), so paths are relative to that
COPY --chown=root:root --chmod=444 krb5.conf /etc/krb5.conf
COPY --chown=root:root --chmod=500 ssh-server/init.sh /init.sh
COPY --chown=root:root --chmod=400 ssh-server/sshd_config /etc/ssh/sshd_config
COPY --chown=root:root --chmod=500 ssh-server/healthcheck.sh /healthcheck.sh

HEALTHCHECK --interval=30s --timeout=3s --start-period=3s --retries=2 CMD ["/healthcheck.sh"]

EXPOSE 22

ENTRYPOINT ["sshd.krb5","-D"]
#ENTRYPOINT ["/usr/sbin/sshd","-D"]

#CMD ["/bin/sh"]
