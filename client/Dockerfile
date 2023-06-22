FROM alpine:3.18.2
MAINTAINER Michael Agun <mikeagun@gmail.com>

#image for running kerberos kdc and admin server

# BUILD FROM PARENT DIRECTORY
# build command: $ sudo docker build -t krb-test-client:latest -f ssh-client/Dockerfile .

RUN \
  apk add --no-cache krb5 #install kerberos client tools

#we build from parent directory (to share global confs), so paths are relative to that
COPY --chown=root:root --chmod=444 krb5.conf /etc/krb5.conf

#ENTRYPOINT ["start.sh"]
#CMD ["/bin/sh"]
