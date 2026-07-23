#!/usr/bin/bash
set -euxo pipefail
source "${BUILD_DIR}/lib.sh"

dnf5i dnf5-plugins

FED=$(rpm -E %fedora)

dnf5 -y copr enable catpieleaf/kernel-p03

dnf5 -y copr enable bieszczaders/kernel-cachyos-addons

dnf5i \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FED}.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FED}.noarch.rpm"

dnf5 -y makecache
