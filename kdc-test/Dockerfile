FROM alpine:3.18.2
MAINTAINER Michael Agun <mikeagun@gmail.com>

#image for running kerberos kdc and admin server

#FIXME: only need krb5 for initial testing, after that just krb5-server
RUN \
  apk add --no-cache krb5-server krb5 #install kerberos kdc and admin server

#COPY resources/start.sh /usr/local/bin/start.sh
#COPY resources/known_hosts /root/.ssh/known_hosts

EXPOSE 749 88/udp

#ENTRYPOINT ["start.sh"]
#CMD ["/bin/sh"]
