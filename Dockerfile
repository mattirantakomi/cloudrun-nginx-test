FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list

RUN apt-get update && apt-get install -y wget screen git dnsutils iputils-ping traceroute nano tailscale nginx net-tools strace 

COPY layers/ /

RUN sed -i -e 's/80 d/8080 d/g' /etc/nginx/sites-available/default

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir -p /var/lib/nginx /var/run/tailscale

USER root

ENTRYPOINT ["/entrypoint.sh"]