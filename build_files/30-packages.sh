#!/usr/bin/bash
set -euxo pipefail
source "${BUILD_DIR}/lib.sh"

log "Installing base system packages (essential)"
dnf5i \
    fish \
    git \
    curl \
    rsync \
    tar xz zstd unzip zip \
    tree file \
    NetworkManager \
    systemd-resolved \
    chrony \
    firewalld \
    fwupd \
    tpm2-tools \
    usbguard \
    fuse fuse-libs \
    flatpak \
    podman \
    jq

log "Installing base system packages (best-effort)"
dnf5try \
    git-lfs \
    NetworkManager-wifi \
    smartmontools \
    usbguard-notifier \
    distrobox \
    toolbox
dnf5try wget2-wget wget2

if ! grep -q '/usr/bin/fish' /etc/shells 2>/dev/null; then
    echo /usr/bin/fish >> /etc/shells
fi

getent group gamemode >/dev/null || groupadd -r gamemode

log "Base packages installed"
