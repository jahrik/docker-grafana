# Grafana

[![Build](https://github.com/jahrik/docker-grafana/actions/workflows/build.yml/badge.svg)](https://github.com/jahrik/docker-grafana/actions/workflows/build.yml)

Multi-arch (amd64/arm64) [Grafana](https://grafana.com/) OSS image with a baked-in config for homelab Docker Swarm deployments. Stores the SQLite database, logs, and plugins under a single `/data` volume.

```bash
docker pull jahrik/grafana
```

## Build

```bash
make build
```

Or directly:

```bash
docker build -t jahrik/grafana:latest .
```

The Grafana version is pinned via `ENV VERSION=` in the Dockerfile. Multi-arch images are built in CI with buildx; the `TARGETARCH` build arg picks the right `.deb` per platform.

## Run

```bash
docker run -d -p 3000:3000 -v grafana-data:/data jahrik/grafana
```

Default config lives at `/grafana/conf/config.ini` (data/logs/plugins under `/data`, basic and anonymous auth disabled). Override Grafana settings with `GF_*` environment variables, e.g.:

```bash
docker run -d -p 3000:3000 \
  -e GF_SECURITY_ADMIN_USER=admin \
  -e GF_SECURITY_ADMIN_PASSWORD=secret \
  jahrik/grafana
```

## Deploy to Docker Swarm

`docker-compose.yml` defines a replicated service on the external `monitor` overlay network, configured through `GF_*` env vars (database, SMTP, admin credentials):

```bash
make deploy
```

## CI

GitHub Actions builds the image on every push and PR, waits for `GET /api/health` to return healthy, and on `master` pushes a multi-arch (amd64 + arm64) image to Docker Hub.
