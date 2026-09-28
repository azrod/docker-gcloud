# Stage 1: pull gcloud SDK from the official Alpine image
FROM google/cloud-sdk:alpine AS gcloud

# Stage 2: lean Docker-in-Docker image with gcloud copied in
FROM docker:dind

COPY --from=gcloud /google-cloud-sdk /google-cloud-sdk

# Runtime dependencies required by gcloud (Python) and common tooling
RUN apk add --no-cache \
    python3 \
    libc6-compat \
    bash \
    curl \
    openssh-client \
    git

ENV PATH="/google-cloud-sdk/bin:${PATH}"
