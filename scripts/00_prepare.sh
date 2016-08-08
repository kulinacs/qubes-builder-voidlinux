#!/bin/bash -e
### 00_prepare.sh : Download and extract the staticly linked xbps binaries

echo "--> Void Linux 00_prepare.sh"

VOIDLINUX_PLUGIN_DIR="${VOIDLINUX_PLUGIN_DIR:-"${SCRIPTSDIR}/.."}"

VOIDLINUX_SRC_PREFIX="${VOIDLINX_SRC_PREFIX:-http://repo.voidlinux.eu/static}"

BINARY_TARBALL="xbps-static-latest.x86_64-musl.tar.xz"
BINARY_CHECKSUM="sha256sums.txt"
GPG_ENV="GNUPGHOME=${CACHEDIR}/gpghome"

[ "$VERBOSE" -ge 2 -o "$DEBUG" -gt 0 ] && set -x

mkdir -p "${CACHEDIR}/xbps_cache"

echo "  --> Downloading XBPS statically linked binaries"

http_proxy="$REPO_PROXY" wget -N -P "$CACHEDIR" "${VOIDLINUX_SRC_PREFIX}/${BINARY_TARBALL}"
http_proxy="$REPO_PROXY" wget -N -P "$CACHEDIR" "${VOIDLINUX_SRC_PREFIX}/${BINARY_CHECKSUM}"
http_proxy="$REPO_PROXY" wget -N -P "$CACHEDIR" "${VOIDLINUX_SRC_PREFIX}/${BINARY_CHECKSUM}.asc"

echo "  --> Preparing GnuPG to verify checksum..."
mkdir -p "${CACHEDIR}/gpghome"
chmod -R go-rwx "${CACHEDIR}/gpghome"
env $GPG_ENV gpg --import "${ARCHLINUX_PLUGIN_DIR}/keys/xtraeme.asc" || exit

echo "  --> Verifying checksum..."
env $GPG_ENV gpg --verify "${CACHEDIR}/${BINARY_CHECKSUM}.asc" "${CACHEDIR}/${BINARY_CHECKSUM}" || exit

if [ "${CACHEDIR}/${BINARY_TARBALL}" -nt "${CACHEDIR}/binary/.extracted" ]; then
    echo "  --> Extracting binary tarball (nuking previous directory)..."
    rm -rf "${CACHEDIR}/binary/"
    mkdir -p "${CACHEDIR}/binary"
    # By default will extract to a "root.x86_64" directory; strip that off
    tar xzC "${CACHEDIR}/binary" -f "${CACHEDIR}/${BINARY_TARBALL}"
    # Copy the distribution-provided version to be rewritten based on the
    # value of $PACMAN_MIRROR each run (by the Makefile)
    #cp -a "${CACHEDIR}/bootstrap/etc/pacman.d/mirrorlist" "${CACHEDIR}/bootstrap/etc/pacman.d/mirrorlist.dist"
    touch "${CACHEDIR}/binary/.extracted"
else
    echo "  --> NB: Binary tarball not newer than binary directory, will use existing!"
fi
