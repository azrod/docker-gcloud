# docker-gcloud

[![Build and Push Docker Image](https://github.com/azrod/docker-gcloud/actions/workflows/build.yml/badge.svg)](https://github.com/azrod/docker-gcloud/actions/workflows/build.yml)

Docker image combining [Docker-in-Docker](https://hub.docker.com/_/docker) (`docker:dind`) with the [Google Cloud SDK](https://cloud.google.com/sdk). Useful for CI pipelines that need both the Docker daemon and `gcloud` CLI in the same container — without juggling multiple service containers or sidecar hacks.

## Quick start

```bash
docker pull ghcr.io/azrod/docker-gcloud:latest
```

Run interactively:

```bash
docker run --privileged -it ghcr.io/azrod/docker-gcloud:latest bash
```

The `--privileged` flag is required for Docker-in-Docker to function.

### Example: GitHub Actions

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/azrod/docker-gcloud:latest
      options: --privileged
    steps:
      - run: docker version
      - run: gcloud version
```

## What's inside

| Tool | Source |
|------|--------|
| Docker (daemon + CLI) | `docker:dind` base image |
| Google Cloud SDK (`gcloud`) | `google/cloud-sdk:alpine` |
| Python 3 | Alpine package |
| bash, curl, git, openssh-client | Alpine packages |
| `libc6-compat` | glibc compatibility shim |

Versions track upstream: the image is rebuilt every Monday at 04:00 UTC so it stays current.

## Multi-arch

Built for `linux/amd64` and `linux/arm64` via Docker Buildx + QEMU. Pulling the image on either architecture will get the right variant automatically.

## Building locally

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t docker-gcloud:local \
  --load \
  .
```

> Note: `--load` only works for single-platform builds. Drop `--platform` or use `--push` for multi-arch.

## CI

The workflow runs on:
- Every push to `main`
- Every Monday at 04:00 UTC (scheduled rebuild to pick up upstream updates)
- Manual trigger via `workflow_dispatch`

Images are published to `ghcr.io/azrod/docker-gcloud:latest`.

## Contributing

PRs welcome. Keep it minimal — the point of this image is to be a thin, always-fresh combination of two upstream images with no unnecessary extras.
