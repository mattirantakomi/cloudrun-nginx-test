#!/bin/bash

if [ ! -z "${TAILSCALE_AUTHKEY}" ]; then
    tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
    tailscale up --ssh=true --authkey=${TAILSCALE_AUTHKEY} --hostname=cloudrun-testi
    echo "tailscale started"
fi

if [ ! -z "${AUTHORIZED_KEYS}" ]; then
  mkdir -p /root/.ssh
  chmod 700 /root/.ssh
  echo "${AUTHORIZED_KEYS}" > /root/.ssh/authorized_keys
  chmod 600 /root/.ssh/authorized_keys
fi

ssh-keygen -q -N "" -t dsa -f /ssh/ssh_host_dsa_key
ssh-keygen -q -N "" -t rsa -b 4096 -f /ssh/ssh_host_rsa_key
ssh-keygen -q -N "" -t ecdsa -f /ssh/ssh_host_ecdsa_key
ssh-keygen -q -N "" -t ed25519 -f /ssh/ssh_host_ed25519_key

mkdir -p /run/sshd
chmod 700 /run/sshd
/usr/sbin/sshd -f /ssh/sshd_config -e
echo "sshd started"

netstat -aepn

ifconfig -a

whoami

/usr/sbin/nginx -g "daemon off;"
echo "nginx started"

# tail -f /dev/null