#!/bin/sh
set -ex

cp version.cfg.in version.cfg
sed -i "s/@VERSION@/$(cat VERSION)/g" version.cfg
sed -i "s/@MAJOR@/$(cat VERSION | cut -d. -f1)/g" version.cfg
