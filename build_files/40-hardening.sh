#!/usr/bin/bash
set -euxo pipefail
source "${BUILD_DIR}/lib.sh"

log "Hardening: packages + services"

dnf5i audit || true
enable_unit auditd.service || true

dnf5i rng-tools || true
enable_unit rngd.service || true

enable_unit usbguard.service || true
enable_unit usbguard-dbus.service || true

dnf5i selinux-policy-targeted || true

log "Hardening stage done"
