# Local Dev Proxy

The local dev proxy allows you to access your various docker-compose projects via a uniform dev domain (currently *.local.tote.rocks and *.local.tote.co.uk) and provides local ssl termination using [mkcert](https://github.com/FiloSottile/mkcert)

## Installation

```bash
chmod +x ./install.sh && sudo ./install.sh
```

_This will install dnsmasq on your host system, add local dns resolvers for local.tote.co.uk and local.tote.rocks and will run traefik, dnsmasq, and mysql via docker-compose._

### Verifying your installation

To verify your installation, visit https://whoami.local.tote.rocks. You should see a dump of the containers OS information, and your http request.

You should also see a valid certificate which was created by mkcert.

## How to add a project to the proxy

Add the following labels and network to the service in your docker-compose file which you want to connect to the proxy.

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.<foo>.rule=Host(`<foo>.local.tote.rocks`)"
  - "traefik.http.routers.<foo>.tls=true" # Optional
networks:
  - traefik
```

You'll also need to tell docker-compose about an external network called traefik (Which was created for you when you ran the installation script).

```yaml
networks:
  traefik:
    external: true
```

For a full example, take a look in the examples directory for this repo.
