#!/usr/bin/bash
set -euxo pipefail
source "${BUILD_DIR}/lib.sh"

log "Staging Determinate Nix"

install -d -m 0755 /nix

install -d -m 0755 /usr/libexec/bootc-p03

ARCH="$(uname -m)"
INSTALLER_URL="https://install.determinate.systems/nix/nix-installer-${ARCH}-linux"
if curl -fSL -o /usr/libexec/bootc-p03/nix-installer "${INSTALLER_URL}"; then
    chmod +x /usr/libexec/bootc-p03/nix-installer
    log "Staged nix-installer for ${ARCH}"
else
    echo "WARNING: could not pre-stage nix-installer; first boot will fetch it." >&2
fi

enable_unit nix-first-boot.service

chmod +x /usr/bin/nixpkg /usr/bin/p03ctl /usr/bin/doctor

log "Nix staging done"
