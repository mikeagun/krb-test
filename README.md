# Kerberos docker test cluster

## Notes

Containers:
- kdc - Kerberos KDC
- client - Kerberos client (for testing e.g. kinit/kadmin)
- sshd - SSH server using kerberos for auth
- ssh-client - SSH client for testing against server

compose script:
- there are some commented out lines for mounting kdc logs and shell histories into the current directory
  - this can be very convient for repeated interactive testing (since compose down will delete the containers)
  - you probably want to `touch` the ash history files before enabling those lines otherwise docker will create a directory instead

Passwords:
- master key password: none
- kerberos passwords: pass

Kerberos principles:
- these are in addition to the ones created automatically
- all created in KRB-TEST realm
- **admin/admin** - kerberos admin user
  - password is "pass"
- **healthcheck** - used in docker healthcheck to verify kdc is working
- **host/sshd.krb-test** - ssh server kerberos key
  - kdc init script creates key at `krb-test-kdc:/sshserver.keytab`
- **sshuser** - ssh user for testing key file auth (has local account on sshd)
  - kdc init script creates key at `krb-test-kdc:/sshuser.keytab`
- **sshuserpass** - ssh user for testing password auth (has local account on sshd)
  - principle password is "pass"

File Paths:
- /etc/krb5.conf - main kerberos conf
- /var/lib/krb5kdc/ - kdc conf and files


## Initialization Procedure

The setup is now fully automated, but you do need to make sure imags get built in the right order.

Steps:
- First make sure the kdc is built and up-to-date, since we have the other Dockerfiles copy the keytabs from the kdc image.
- Next build the rest of the images
  - may need to build individual containers with --no-cache in the second step if the Dockerfile keeps stale keytabs from the image cache
- Finally start the cluster

```bash
sudo docker compose build kdc
sudo docker compose build
sudo docker compose up -d
```

You can test basic kerberos auth and kadmin using the client container
```
sudo docker compose exec -ti client /bin/sh
#from client:
kinit admin/admin
kadmin
#try listprincs in kadmin to list principles
exit #from kadmin
exit #from sh
```

Now we can test ssh to the ssh server (both using keyfiles and passwords)

```bash
sudo docker compose exec -ti ssh-client /bin/sh

#from ssh-client:
kinit sshuser -k
ssh sshuser@sshd.krb-test

kinit sshuserpass #enter "pass"
ssh sshuserpass@sshd.krb-test
```

If you create additional/new keys in the kdc during run, you can use this pattern to copy them to the containers that need them

```bash
sudo docker compose cp kdc:/sshserver.keytab ./sshserver.keytab
sudo docker compose cp kdc:/sshuser.keytab ./sshuser.keytab

sudo docker compose cp sshserver.keytab sshd:/etc/krb5.keytab
sudo docker compose cp sshuser.keytab ssh-client:/etc/krb5.keytab
```


