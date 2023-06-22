#!/bin/sh
nc -z 127.0.0.1 22 || { echo "Couldn't connect to 127.0.0.1 on port 22" >&2; exit 1; }
