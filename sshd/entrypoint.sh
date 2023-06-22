#!/bin/sh


#before we can start sshd we need to be able to auth with KDC
COUNT=0
until kinit -k; do
  if [ $COUNT -ge 10 ]; then
    break
  else
    echo "Couldn't reach KDC. waiting..." >&2
    sleep 2
  fi
done

#keep container running
#exec sleep infinity

exec /usr/sbin/sshd.krb5 -D
