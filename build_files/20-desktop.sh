#!/usr/bin/bash
set -euxo pipefail
source "${BUILD_DIR}/lib.sh"

log "Installing minimal KDE Plasma 6 session"
dnf5i \
    plasma-workspace \
    plasma-desktop \
    sddm \
    xdg-desktop-portal xdg-desktop-portal-kde \
    pipewire pipewire-pulseaudio wireplumber \
    rtkit

dnf5try \
    plasma-workspace-wayland \
    sddm-breeze sddm-kcm \
    plasma-nm plasma-pa \
    kscreen powerdevil kscreenlocker \
    kde-cli-tools kde-gtk-config breeze-gtk \
    polkit-kde kwallet-pam \
    plasma-systemmonitor \
    dconf gnupg2 pinentry-qt \
    plymouth plymouth-system-theme \
    qt6-qtwayland qt5-qtwayland \
    pipewire-alsa pipewire-alsa.i686

log "Installing essential desktop applications"
dnf5try \
    kate \
    ark \
    spectacle \
    dolphin \
    kpmcore partitionmanager \
    haruna \
    gwenview

dnf5try \
    google-noto-sans-fonts \
    google-noto-serif-fonts \
    google-noto-emoji-fonts \
    google-noto-color-emoji-fonts \
    google-noto-sans-cjk-fonts \
    liberation-fonts \
    jetbrains-mono-fonts-all

log "Setting graphical boot target + enabling SDDM"
systemctl set-default graphical.target
enable_unit sddm.service
