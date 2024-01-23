# Kerberos docker test cluster

local kerberos cluster in docker compose for testing.

Includes ssh server and client which authenticate using kerberos.

## Notes

Containers:
- kdc - Kerberos KDC
- client - Kerberos client (for testing e.g. kinit/kadmin)
- sshd - SSH server using kerberos for auth
- ssh-client - SSH client for testing against server
- ldap - WIP ldap server

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

Startup is now fully automated, but you do need to make sure imags get built in the right order.
- we generate the KDC and principle keys at build time, so need to (re)build kdc before sshd/ssh-client which copy those keys
- this is BAD practive for production use (mount/copy the keys into containers at run time instead),
but convenient to make `docker compose up` fully automatic

Steps:
- First make sure the kdc is built and up-to-date, since we have the other Dockerfiles copy the keytabs from the kdc image.
- Next build the rest of the images
  - need to build images which pull keytabs from kdc with --no-cache after kdc rebuild to ensure we don't use stale keytab from image cache
- Finally start the cluster

```bash
sudo docker compose build kdc
sudo docker compose build
#need to bypass image cache after kdc rebuilds (since kdc key will be new)
#sudo docker compose build --no-cache sshd ssh-client
sudo docker compose up -d
```

You can test basic kerberos auth and kadmin using the client container
```bash
sudo docker compose exec -ti client /bin/sh
#from client:
kinit admin/admin
kadmin
#try listprincs in kadmin to list principles
exit #from kadmin
exit #from sh
```

ssh-client can be used to test kerberos auth for ssh (both using keytabs and passwords)

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


