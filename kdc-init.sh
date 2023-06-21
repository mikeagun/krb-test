#!/bin/sh

#create master key for realm with empty password
kdb5_util create -r KRB-TEST -s <<EOF


EOF
#now create principles and key files
kadmin.local -q "addprinc -pw pass admin/admin"
kadmin.local -q "addprinc -randkey host/ssh-server.krb-test"
kadmin.local -q "ktadd -k /sshserver.keytab host/ssh-server.krb-test"
kadmin.local -q "addprinc -randkey sshuser"
kadmin.local -q "ktadd -k /sshuser.keytab sshuser"
kadmin.local -q "addprinc -pw pass sshuserpass"
#start kdc and kerberos admin daemons
kadmind
krb5kdc

#keep container running (alternative is running kdc/kadmind blocking)
#exec tail -f /dev/null
exec sleep infinity
