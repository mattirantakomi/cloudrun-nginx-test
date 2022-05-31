#!/bin/bash

if [ ! -z "${TAILSCALE_AUTHKEY}" ]; then
    tailscaled --tun=userspace-networking --socks5-server=localhost:1055 --debug 0.0.0.0:8081 &
    tailscale up --ssh=true --authkey=${TAILSCALE_AUTHKEY} --hostname=cloudrun-testi
    echo "tailscale started"
fi

CONF_DIR="/etc/dropbear"
SSH_KEY_DSS="${CONF_DIR}/dropbear_dss_host_key"
SSH_KEY_RSA="${CONF_DIR}/dropbear_rsa_host_key"

# Check if conf dir exists
if [ ! -d ${CONF_DIR} ]; then
    mkdir -p ${CONF_DIR}
fi
chown root:root ${CONF_DIR}
chmod 755 ${CONF_DIR}

# Check if keys exists
if [ ! -f ${SSH_KEY_DSS} ]; then
    dropbearkey  -t dss -f ${SSH_KEY_DSS}
fi
chown root:root ${SSH_KEY_DSS}
chmod 600 ${SSH_KEY_DSS}

if [ ! -f ${SSH_KEY_RSA} ]; then
    dropbearkey  -t rsa -f ${SSH_KEY_RSA} -s 2048
fi
chown root:root ${SSH_KEY_RSA}
chmod 600 ${SSH_KEY_RSA}

if [ ! -z "${AUTHORIZED_KEYS}" ]; then
  mkdir -p /root/.ssh
  echo "${AUTHORIZED_KEYS}" > /root/.ssh/authorized_keys
  chmod 700 /root/.ssh
  chmod 600 /root/.ssh/authorized_keys
fi

/usr/sbin/dropbear -j -k -s -p 2222 -E
echo "dropbear started"

echo -n "tailscale ip is "
tailscale ip

chisel client -v --auth "$CHISEL_USER:$CHISEL_PASS" "$CHISEL_SERVER" R:2222:localhost:2222 &
#chisel client "$CHISEL_SERVER" R:2222:localhost:2222 &

/usr/sbin/nginx -g "daemon off;"
echo "nginx started"

#tail -f /dev/null