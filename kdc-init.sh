#!/bin/sh
kdb5_util create -r KRB-TEST -s <<EOF


EOF
kadmin.local -q "addprinc -pw pass admin/admin"
kadmin.local -q "addprinc -randkey host/ssh-server.krb-test"
kadmin.local -q "ktadd -k /sshserver.keytab host/ssh-server.krb-test"
kadmin.local -q "addprinc -randkey sshuser"
kadmin.local -q "ktadd -k /sshuser.keytab sshuser"
kadmin.local -q "addprinc -pw pass sshuserpass"
kadmind
krb5kdc
#exec tail -f /dev/null
exec sleep infinity
