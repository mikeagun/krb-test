#!/bin/sh

#generate ssh host keys
ssh-keygen -A

#create local accounts corresponding to kerberos principles for ssh login
# - local account passwords are "password"
adduser sshuser <<EOF
password
password
EOF

adduser sshuserpass <<EOF
password
password
EOF

#before we can start sshd we need the kerberos host keys
# - see README for examples copying the keys from kdc container
#exec /usr/sbin/sshd.krb5 -D

#keep container running
exec sleep infinity
