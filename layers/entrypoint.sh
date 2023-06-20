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

/usr/sbin/nginx -g "daemon off;"
echo "nginx started"
