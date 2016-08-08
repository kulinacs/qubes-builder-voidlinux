#!/bin/bash -e
### 01_install-core.sh : Create build chroot install of Void Linux using XBPS
echo "--> Void Linux 01_install_core.sh"

VOIDLINUX_PLUGIN_DIR="${VOIDLINUX_PLUGIN_DIR:-"${SCRIPTSDIR}/.."}"

set -e
[ "$VERBOSE" -ge 2 -o "$DEBUG" -gt 0] && set -x

"${VOIDLINUX_PLUGIN_DIR}/prepare-chroot-base" "$INSTALLDIR" "$DIST"
