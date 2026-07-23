#!/usr/bin/bash
set -euxo pipefail
source "${BUILD_DIR}/lib.sh"

log "Enabling core services"

enable_unit NetworkManager.service
enable_unit systemd-resolved.service
ln -sf ../run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

enable_unit chronyd.service

enable_unit firewalld.service

enable_unit fwupd.service || true
enable_unit smartd.service || true
enable_unit systemd-oomd.service || true

systemctl enable systemd-zram-setup@zram0.service 2>/dev/null || true

flatpak remote-add --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo || true

enable_unit bootc-fetch-apply-updates.timer || true

log "Applying locale, keymap, timezone"
cat > /etc/locale.conf <<'EOF'
LANG=en_US.UTF-8
LC_ADDRESS=en_US.UTF-8
LC_IDENTIFICATION=en_US.UTF-8
LC_MEASUREMENT=en_US.UTF-8
LC_MONETARY=en_US.UTF-8
LC_NAME=en_US.UTF-8
LC_NUMERIC=en_US.UTF-8
LC_PAPER=en_US.UTF-8
LC_TELEPHONE=en_US.UTF-8
LC_TIME=en_US.UTF-8
EOF

cat > /etc/vconsole.conf <<'EOF'
KEYMAP=br-abnt2
FONT=eurlatgr
EOF

ln -sf ../usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

log "Services stage done"
