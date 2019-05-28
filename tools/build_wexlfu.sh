#!/bin/sh
set -ex

cp loader.cfg.in loader.cfg
sed -i "s/@VERSION@/$(cat VERSION)/g" loader.cfg
