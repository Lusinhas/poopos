FROM scratch AS ctx
COPY build_files /build_files
COPY system_files /system_files

FROM quay.io/fedora/fedora-bootc:44

ARG INCLUDE_NVIDIA=1

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    INCLUDE_NVIDIA=${INCLUDE_NVIDIA} /ctx/build_files/build.sh

RUN bootc container lint
