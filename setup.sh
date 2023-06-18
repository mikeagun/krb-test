#master key password: none
#kerberos passwords: pass
#local user account passwords: password

#file locations:
# /etc/krb5.conf - main kerberos conf
# /var/lib/krb5kdc/ - kdc conf and files


sudo docker compose up -d

sudo docker cp krb-test-kdc-1:/sshserver.keytab ./sshserver.keytab
sudo docker cp krb-test-kdc-1:/sshuser.keytab ./sshuser.keytab
sudo docker cp sshserver.keytab krb-test-ssh-server-1:/etc/krb5.keytab
sudo docker cp sshuser.keytab krb-test-ssh-client-1:/etc/krb5.keytab


sudo docker exec -ti krb-test-ssh-server-1 /bin/sh
#from ssh-server:
/usr/sbin/sshd.krb5
exit


sudo docker exec -ti krb-test-ssh-client-1 /bin/sh

#from ssh-client:
kinit sshuser -k
ssh sshuser@ssh-server.krb-test

kinit sshuserpass #enter "pass"
ssh sshuserpass@ssh-server.krb-test
