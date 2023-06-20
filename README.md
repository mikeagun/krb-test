# Kerberos docker test cluster

## Notes

Containers:
- krb-test-kdc-1 - Kerberos KDC
- krb-test-client-1 - Kerberos client (for testing e.g. kinit/kadmin)
- krb-test-ssh-server-1 - SSH server using kerberos for auth
- krb-test-ssh-client-1 - SSH client for testing against server

compose script:
- there are some commented out lines for mounting kdc logs and shell histories into the current directory
  - this can be very convient for repeated interactive testing (since compose down will delete the containers)
  - you probably want to `touch` the ash history files before enabling those lines otherwise docker will create a directory instead

Passwords:
- master key password: none
- kerberos passwords: pass
- local user account passwords: password

File Paths:
- /etc/krb5.conf - main kerberos conf
- /var/lib/krb5kdc/ - kdc conf and files


## Initialization Procedure

For now there are a couple manual steps to get the kerberos key files the right places


first start up the containers, and pregenerate some users and keys

```bash
sudo docker compose up -d
```


You can test basic kerberos auth using the client container
```
sudo docker exec -ti krb-test-ssh-server-1 /bin/sh
#from client:
kinit admin/admin@KRB-TEST
kadmin
```


Copy the keys the init scripts created to the ssh containers
```
sudo docker cp krb-test-kdc-1:/sshserver.keytab ./sshserver.keytab
sudo docker cp krb-test-kdc-1:/sshuser.keytab ./sshuser.keytab
sudo docker cp sshserver.keytab krb-test-ssh-server-1:/etc/krb5.keytab
sudo docker cp sshuser.keytab krb-test-ssh-client-1:/etc/krb5.keytab
```

After the ssh-server has its key, we can start sshd

```bash
sudo docker exec -ti krb-test-ssh-server-1 /bin/sh
#from ssh-server:
/usr/sbin/sshd.krb5
exit
```

Now we can test ssh to the ssh server (both using keyfiles and passwords)

```bash
sudo docker exec -ti krb-test-ssh-client-1 /bin/sh

#from ssh-client:
kinit sshuser -k
ssh sshuser@ssh-server.krb-test

kinit sshuserpass #enter "pass"
ssh sshuserpass@ssh-server.krb-test
```

