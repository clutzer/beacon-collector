#!/bin/bash
# boot-beacon.sh
# Sends a one-time GET beacon to your collector URL.

PUBLIC_IP=$(ip -4 addr show eth0 | grep -P 'inet\b\s+(?!(10\.|192\.168\.|172\.(1[6-9]|2[0-9]|3[0-1])\.))' | awk '{print $2}' | cut -d/ -f1 | grep -v 192.168)
PUBLIC_IPV6=$(ip -6 addr show eth0 | grep "inet6 " | grep -v "inet6 fe80" | awk '{print $2}' | cut -d/ -f1)

BEACON_URL="https://beacons.devqa.gecko.linode.com/beacon?id=$(hostname)&ts=$(date +%s)"

# retry a few times in case networking isn’t immediately ready
for i in {1..10}; do
    curl -s -o /dev/null -H "Akamai-IPv4: $PUBLIC_IP" -H "Akamai-IPv6: $PUBLIC_IPV6" "$BEACON_URL" && exit 0
    sleep 5
done

# if all retries fail, log but don’t block boot
logger -t boot-beacon "Failed to send beacon after 10 tries"
exit 0
