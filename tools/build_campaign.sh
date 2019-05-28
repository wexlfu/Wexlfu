#!/bin/sh
cp _server.pbl.in _server.pbl || exit 1
sed -i "s/@PASSPHRASE@/$(cat secrets/passphrase.ign)/g" _server.pbl || exit 1
sed -i "s/@EMAIL@/$(cat secrets/email.ign)/g" _server.pbl || exit 1
sed -i "s/@VERSION@/$(cat VERSION)/g" _server.pbl || exit 1

if [ -e description.txt ]; then
	sed -i "s#@DESCRIPTION@#$(cat description.txt)#g" _server.pbl || exit 1
fi

if [ -e icon.png ]; then
	sed -i "s#@ICON@#data:image/png;base64,$(base64 -w 0 icon.png)#g" _server.pbl || exit 1
fi
