FROM alpine:3.18.2
MAINTAINER Michael Agun <mikeagun@gmail.com>

#image for running kerberos kdc and admin server

RUN \
  apk add --no-cache krb5 #install kerberos client tools

#COPY resources/start.sh /usr/local/bin/start.sh
#COPY resources/known_hosts /root/.ssh/known_hosts

#ENTRYPOINT ["start.sh"]
#CMD ["/bin/sh"]
