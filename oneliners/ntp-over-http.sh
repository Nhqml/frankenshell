#!/bin/sh

## Sync the system time from a call to the worldtimeapi.org API.

curl -fsSL "http://worldtimeapi.org/api/ip.txt" | grep '^datetime' | sed -E 's/.*: (.*)\..*/\1/' | tr T ' ' | xargs -i sudo timedatectl set-time '{}'
