#!/bin/bash

if [ ! -z "${TAILSCALE_AUTHKEY}" ]; then
    tailscaled --tun=userspace-networking &
    tailscale up --ssh=true --authkey=${TAILSCALE_AUTHKEY}
    echo "tailscale started"
fi

echo -n "tailscale ip is "
tailscale ip

/usr/sbin/nginx -g "daemon off;"
echo "nginx started"
