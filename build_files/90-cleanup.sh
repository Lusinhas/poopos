#!/usr/bin/bash
set -euxo pipefail
source "${BUILD_DIR}/lib.sh"

log "Cleanup"

dnf5 clean all || true
rm -rf /var/cache/dnf /var/cache/libdnf5 || true

rm -rf /var/log/* || true
rm -f /etc/machine-id || true
:> /etc/machine-id || true

ls -1 /usr/lib/modules | sed 's/^/kernel-modules: /' || true

log "Cleanup done"
