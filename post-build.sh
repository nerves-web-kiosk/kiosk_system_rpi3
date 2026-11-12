#!/bin/sh

set -e

# Trim down staging so that the artifacts can be hosted on GitHub releases
rm -fr $STAGING_DIR/usr/lib/dri $STAGING_DIR/usr/lib/libWPEWebKit-2.0.so* $STAGING_DIR/usr/lib/wpe-webkit-2.0

# Create the fwup ops script to handling MicroSD/eMMC operations at runtime
# NOTE: revert.fw is the previous, more limited version of this. ops.fw is
#       backwards compatible.
mkdir -p $TARGET_DIR/usr/share/fwup
$HOST_DIR/usr/bin/fwup -c -f $NERVES_DEFCONFIG_DIR/fwup-ops.conf -o $TARGET_DIR/usr/share/fwup/ops.fw
ln -sf ops.fw $TARGET_DIR/usr/share/fwup/revert.fw

# Copy the fwup includes to the images dir
cp -rf $NERVES_DEFCONFIG_DIR/fwup_include $BINARIES_DIR
