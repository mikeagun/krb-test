#!/bin/sh

#start kdc and kerberos admin daemons
# we need a sigterm handler to handle docker stop in a timely manner

kill_handler() {
  kdcpid="$(tail -1 /var/run/krb5kdc.pid)"
  echo "SIGTERM Received: killing krb5kdc (pid=$kdcpid) and kadmind (pid=$kadminpid)"
  kill $kadminpid "$kdcpid"
}
trap kill_handler SIGINT SIGTERM

krb5kdc -P /var/run/krb5kdc.pid
kadmind -nofork &
kadminpid=$!

wait $kadminpid
