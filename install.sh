#!/bin/bash
if ! [ "$(id -u)" = 0 ]; then
  echo "You are not root, run this target as root please"
  exit 1
 fi

# Install mkcert
brew install mkcert
brew install nss
brew install dnsmasq

# Local ssl certificates
mkcert -cert-file ./etc/traefik/certs/tote.crt -key-file ./etc/traefik/certs/tote.pem  "localhost" "*.ide.local.tote.co.uk" "*.local.tote.rocks"

# Add new dns resolvers for our tote domains
mkdir -v /etc/resolver
bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/local.tote.co.uk'
bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/local.tote.rocks'

# Create a network for our proxy and containers to communicate via
docker network create traefik 2> /dev/null

# And start the proxy
docker-compose up -d && echo "Visit https://whoami.local.tote.rocks to verify your installation."