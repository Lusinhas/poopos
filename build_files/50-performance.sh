#!/usr/bin/bash
set -euxo pipefail
source "${BUILD_DIR}/lib.sh"

log "Performance: scx + ananicy + cachyos-settings"

dnf5i scx-scheds scx-tools

dnf5try ananicy-cpp cachyos-ananicy-rules

dnf5try cachyos-settings

log "Performance: gaming stack"
dnf5try gamemode mangohud gamescope mangohud.i686

log "Performance: power + thermal"
dnf5try power-profiles-daemon thermald irqbalance
enable_unit power-profiles-daemon.service || true
enable_unit thermald.service || true
enable_unit irqbalance.service || true

enable_unit scx_loader.service || true
enable_unit ananicy-cpp.service || true

log "Performance stage done"
