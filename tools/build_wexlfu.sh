#!/bin/sh
cp loader.cfg.in loader.cfg || exit 1
sed -i "s/@VERSION@/$(cat VERSION)/g" loader.cfg || exit 1
