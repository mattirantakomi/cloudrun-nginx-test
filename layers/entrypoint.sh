#!/bin/bash

if [ ! -z "${TAILSCALE_AUTHKEY}" ]; then
    tailscaled --tun=userspace-networking &
    tailscale up --ssh=true --authkey=${TAILSCALE_AUTHKEY}
    echo "tailscale started"

    echo -n "tailscale ip is "
    tailscale ip
    echo
else
    echo "TAILSCALE_AUTHKEY not available. Not starting tailscale."
    echo
fi

if [ ! -z "${AUTHORIZED_KEYS}" ]; then
    mkdir -p /var/lib/nginx/.ssh
    echo "${AUTHORIZED_KEYS}" > /var/lib/nginx/.ssh/authorized_keys
    chmod 700 /var/lib/nginx/.ssh
    chmod 600 /var/lib/nginx/.ssh/authorized_keys
    echo "wrote \$AUTHORIZED_KEYS to /var/lib/nginx/.ssh/authorized_keys"
    cat /var/lib/nginx/.ssh/authorized_keys
fi

dropbearkey -t dss -f /tmp/dropbear_dss_host_key
dropbearkey -t rsa -f /tmp/dropbear_rsa_host_key
dropbearkey -t ecdsa -f /tmp/dropbear_ecdsa_host_key
dropbearkey -t ed25519 -f /tmp/dropbear_ed25519_host_key
echo "generated dropbears ssh host keys"
dropbear -B -E -r /tmp/dropbear_dss_host_key -r /tmp/dropbear_rsa_host_key -r /tmp/dropbear_ecdsa_host_key -r /tmp/dropbear_ed25519_host_key -s -p 2222
echo "started dropbear"

/usr/sbin/nginx -g "daemon off;"
echo "nginx started"
