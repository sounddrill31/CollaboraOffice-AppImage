#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION="$(cat ~/version)"
CODA_PATH="$(cat ~/CODA_PATH)"

export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON="https://raw.githubusercontent.com/CollaboraOnline/online/refs/heads/distro/collabora/coda-$VERSION/qt/hicolor/scalable/apps/com.collabora.Office.startcenter.svg"
export OUTNAME=CODA-"$VERSION"-anylinux-"$ARCH".AppImage
export ANYLINUX_LIB=1
export DESKTOP="https://raw.githubusercontent.com/CollaboraOnline/online/refs/heads/distro/collabora/coda-$VERSION/qt/com.collabora.Office.desktop"
export OPTIMIZE_LAUNCH=1

# Deploy dependencies
quick-sharun /usr/bin/coda-qt \
    /usr/share/coda-qt \
    /usr/share/coolwsd \
    "$CODA_PATH"/core

#cp -r "$CODA_PATH"/browser ./AppDir
#cp -r "$CODA_PATH"/core ./AppDir

# This environment variable ensures we don't need the hack to link the browser directory during runtime. 
# Fedora version also uses this: https://github.com/CollaboraOnline/online/blob/dc6f03d68c3b57b8f7423caf0b0acdc9e2c3dd45/qt/flatpak/com.collabora.Office.json#L29
echo 'COOL_TOPSRCDIR=${SHARUN_DIR}/share/coolwsd' >> ./AppDir/.env

echo '#!/bin/sh
mkdir -p /tmp/CODA
ln -sfn "$APPDIR"/lib/tmp/CODA/core/instdir /tmp/CODA/core/instdir
' > ./AppDir/bin/fix-bruhmoment.hook

chmod +x ./AppDir/bin/fix-bruhmoment.hook

# debloat
#rm -rf \
#    ./AppDir/core/include #        \
#    ./AppDir/browser/po           \
#    ./AppDir/browser/node_modules \
#    ./AppDir/browser/archived-packages

# Turn AppDir into AppImage
quick-sharun --make-appimage