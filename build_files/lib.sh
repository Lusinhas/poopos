#!/usr/bin/bash
log() { printf '\n\033[1;36m==>\033[0m %s\n' "$*"; }

run_stage() {
    local stage="$1"
    log "Stage: ${stage}"
    bash "${BUILD_DIR}/${stage}"
}

dnf5i() { dnf5 -y --setopt=install_weak_deps=False install "$@"; }
dnf5rm() { dnf5 -y remove "$@"; }

dnf5try() {
    local p
    for p in "$@"; do
        if dnf5 -y --setopt=install_weak_deps=False install "$p"; then
            :
        else
            echo "WARNING: optional package not installed: $p" >&2
        fi
    done
}

enable_unit() { systemctl enable "$@"; }

p03_kver() {
    rpm -q kernel-p03-core --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}\n' | tail -1
}
