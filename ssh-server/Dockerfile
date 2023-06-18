FROM alpine:3.18.2
MAINTAINER Michael Agun <mikeagun@gmail.com>

#image for running kerberos kdc and admin server

RUN \
  apk add --no-cache krb5 openssh-server-krb5 #install ssh server and kerberos client tools

COPY sshd_config /etc/ssh/sshd_config

#COPY resources/start.sh /usr/local/bin/start.sh
#COPY resources/known_hosts /root/.ssh/known_hosts

EXPOSE 22

ENTRYPOINT ["sshd.krb5","-D"]
#ENTRYPOINT ["/usr/sbin/sshd","-D"]

#CMD ["/bin/sh"]
