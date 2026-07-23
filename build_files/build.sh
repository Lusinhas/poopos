#!/usr/bin/bash
set -euxo pipefail

export BUILD_DIR="/ctx/build_files"
export SYSTEM_FILES="/ctx/system_files"

source "${BUILD_DIR}/lib.sh"

log "Staging system_files -> /"
cp -avf "${SYSTEM_FILES}/." /

run_stage 00-repos.sh
run_stage 10-kernel.sh
run_stage 20-desktop.sh
run_stage 30-packages.sh
run_stage 40-hardening.sh
run_stage 50-performance.sh
run_stage 60-nvidia.sh
run_stage 70-nix.sh
run_stage 80-services.sh
run_stage 90-cleanup.sh

log "Build complete."
