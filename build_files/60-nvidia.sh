#!/usr/bin/bash
set -euxo pipefail
source "${BUILD_DIR}/lib.sh"

if [ "${INCLUDE_NVIDIA:-1}" != "1" ]; then
    log "NVIDIA disabled (INCLUDE_NVIDIA=${INCLUDE_NVIDIA:-}); skipping"
    exit 0
fi

log "Installing kernel-matched NVIDIA open module (kernel-p03-nvidia-open)"
dnf5i kernel-p03-nvidia-open

NV_VER="${NVIDIA_DRIVER_VERSION:-$(rpm -q --queryformat '%{SUMMARY}\n' kernel-p03-nvidia-open \
    | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)}"
if [ -z "${NV_VER}" ]; then
    echo "WARNING: could not determine NVIDIA userspace version; skipping userspace." >&2
    exit 0
fi
echo "${NV_VER}" > /usr/share/bootc-p03/nvidia-version
log "NVIDIA userspace target version: ${NV_VER}"

log "Installing NVIDIA userspace ${NV_VER} from NVIDIA (.run, --no-kernel-modules)"
RUN="/tmp/NVIDIA-Linux-x86_64-${NV_VER}.run"
URL="https://us.download.nvidia.com/XFree86/Linux-x86_64/${NV_VER}/NVIDIA-Linux-x86_64-${NV_VER}.run"
if curl -fSL -o "${RUN}" "${URL}"; then
    sh "${RUN}" \
        --silent \
        --no-kernel-modules \
        --no-dkms \
        --no-nouveau-check \
        --no-backup \
        --install-libglvnd \
        --x-prefix=/usr \
        --x-module-path=/usr/lib64/xorg/modules \
        --x-library-path=/usr/lib64 \
        || echo "WARNING: NVIDIA userspace install returned non-zero; review above." >&2
    rm -f "${RUN}"
else
    echo "WARNING: could not download ${URL}." >&2
    echo "         The module is installed; add matching userspace later, or use Negativo17." >&2
fi

log "NVIDIA stage done"
