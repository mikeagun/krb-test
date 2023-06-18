#!/bin/sh
ssh-keygen -A
adduser sshuser <<EOF
password
password
EOF

adduser sshuserpass <<EOF
password
password
EOF

#exec /usr/sbin/sshd.krb5 -D
#exec tail -f /dev/null
exec sleep infinity
