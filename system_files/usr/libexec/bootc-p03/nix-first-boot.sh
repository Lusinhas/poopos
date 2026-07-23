#!/usr/bin/bash
set -euo pipefail

STAMP=/var/lib/bootc-p03/first-boot.done
STAGED_INSTALLER=/usr/libexec/bootc-p03/nix-installer

log() { printf '\n\033[1;32m[first-boot]\033[0m %s\n' "$*"; }

mkdir -p "$(dirname "$STAMP")"

if [ ! -e /nix/var/nix/profiles/default/bin/nix ] && ! command -v nix >/dev/null 2>&1; then
    log "Installing Determinate Nix (ostree planner -> persistent /nix)"
    if [ -x "$STAGED_INSTALLER" ]; then
        "$STAGED_INSTALLER" install ostree --no-confirm --determinate \
            || "$STAGED_INSTALLER" install --no-confirm --determinate
    else
        curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
            | sh -s -- install --no-confirm --determinate
    fi
fi

if command -v flatpak >/dev/null 2>&1; then
    flatpak remote-add --if-not-exists flathub \
        https://flathub.org/repo/flathub.flatpakrepo || true
fi

date -u +%Y-%m-%dT%H:%M:%SZ > "$STAMP"
log "Nix ready. No applications are installed by default — add them with 'nixpkg add <pkg>'."
