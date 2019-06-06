#!/bin/sh
set -ex

cp version.cfg.in version.cfg
sed -i "s/@VERSION@/$(cat VERSION)/g" version.cfg
sed -i "s/@MAJOR@/$(cat VERSION | cut -d. -f1)/g" version.cfg

find -name '*.cfg' | xargs sed -i "s/^#textdomain wesnoth-Wexlfu-.*$/#textdomain wesnoth-Wexlfu-$(cat VERSION)/g"
