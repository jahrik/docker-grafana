# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Purpose

Produces `jahrik/grafana` — a multi-arch (amd64/arm64) Grafana OSS image for homelab Docker Swarm use. Config is baked in at `/grafana/conf/config.ini`; database, logs, and plugins all live under the `/data` volume.

## Build & Push

```bash
make build   # build locally as jahrik/grafana:latest
make push    # push to Docker Hub
make deploy  # docker stack deploy -c docker-compose.yml monitor
```

## CI

`.github/workflows/build.yml` runs on every push to `master`, every PR, and manual dispatch:
1. Builds the image, runs it with port 3000 published, and polls `http://localhost:3000/api/health` until healthy (60s budget).
2. On `master` only, pushes a multi-arch (amd64 + arm64) image to Docker Hub using the `DOCKERHUB_USERNAME` / `DOCKERHUB_TOKEN` secrets.

## Image internals

- Base: `ubuntu:24.04`
- Grafana installed from the official `.deb` (`dl.grafana.com/oss/release`); version pinned via `ENV VERSION=` in the Dockerfile — bump it there to upgrade
- `ARG TARGETARCH` (set automatically by buildx) selects the `amd64`/`arm64` deb; defaults to `amd64` for plain local builds
- Runs as the `grafana` user; `ENTRYPOINT` is `grafana-server` with `-config=/grafana/conf/config.ini`
- `config.ini` puts data/logs/plugins under `/data` and disables basic + anonymous auth
- Runtime settings are overridden with `GF_*` environment variables (see `docker-compose.yml` for the Swarm wiring: MySQL backend, SMTP, admin creds)

## Local testing

Docker is not installed on this machine — `docker` is a Podman shim, so `make build` works as-is. Verify with:

```bash
docker run --rm -d -p 3000:3000 --name grafana-test jahrik/grafana:latest
curl -sf http://localhost:3000/api/health
docker rm -f grafana-test
```
