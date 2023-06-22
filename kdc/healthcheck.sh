#!/bin/sh
#[ -f /healthcheck.keytab ] || { echo "Missing healtchcheck.keytab" >&2; exit 1; }
kinit -kt /healthcheck.keytab healthcheck
