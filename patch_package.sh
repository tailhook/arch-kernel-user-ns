#!/bin/sh -ex
CONTRIBUTOR="Paul Colomiets <paul@colomiets.name>"
OVERLAYFS_PATCH="http:\\/\\/people.canonical.com\\/~apw\\/lp1377025-utopic\\/0001-UBUNTU-SAUCE-Overlayfs-allow-unprivileged-mounts.patch"

sed -i.bak "s/# CONFIG_USER_NS is not set/CONFIG_USER_NS=y/" config.i686
sed -i.bak "s/# CONFIG_USER_NS is not set/CONFIG_USER_NS=y/" config.x86_64

sed -i.bak "/source=/,/)/s/)$/\n$OVERLAYFS_PATCH)/" PKGBUILD
sed -i "s/\# add upstream patch/\# add upstream patch\n  patch \-p1 \-i \"\$\{srcdir\}\/`basename $OVERLAYFS_PATCH`\"/" PKGBUILD
sed -i 's/^pkgbase=linux.*$/pkgbase=linux-user-ns-enabled/' PKGBUILD
sed -i "2i# Contributor: ${CONTRIBUTOR}" PKGBUILD
sed -i '/pkgdesc=/{s/"$/ with CONFIG_USER_NS enabled"/}' PKGBUILD
# Everything is owned by root
sed -i '/chown/{s/^/#/}' PKGBUILD
sed -i 's/cp -a /cp -a --no-preserve=ownership /' PKGBUILD
sed -i 's/cp -al /cp -al --no-preserve=ownership /' PKGBUILD

updpkgsums
makepkg --source --skippgpcheck
