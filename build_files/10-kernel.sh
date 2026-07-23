#!/usr/bin/bash
set -euxo pipefail
source "${BUILD_DIR}/lib.sh"

log "Removing stock Fedora kernel packages"
mapfile -t STOCK < <(rpm -qa \
    kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra \
    kernel-uki-virt 2>/dev/null || true)
if [ "${#STOCK[@]}" -gt 0 ]; then
    dnf5 -y remove "${STOCK[@]}"
fi

log "Installing kernel-p03 + matched headers (initramfs deferred)"
KERNEL_INSTALL_BYPASS=1 dnf5i kernel-p03 kernel-p03-devel-matched

KVER="$(p03_kver)"
log "Installed P03 kernel: ${KVER}"

setsebool -P domain_kernel_load_modules on || true

log "Running depmod + generating initramfs for ${KVER}"
depmod -a "${KVER}"
if ! kernel-install add "${KVER}" "/usr/lib/modules/${KVER}/vmlinuz"; then
    dracut --no-hostonly --reproducible --add ostree --force \
        --kver "${KVER}" "/usr/lib/modules/${KVER}/initramfs.img"
fi

[ -f "/usr/lib/modules/${KVER}/initramfs.img" ] \
    || { echo "ERROR: initramfs not generated for ${KVER}" >&2; exit 1; }

echo "${KVER}" > /usr/share/bootc-p03/kernel-version
