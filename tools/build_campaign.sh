#!/bin/sh
set -ex

cp _server.pbl.in _server.pbl
sed -i "s/@PASSPHRASE@/$(cat secrets/passphrase.ign)/g" _server.pbl
sed -i "s/@EMAIL@/$(cat secrets/email.ign)/g" _server.pbl
sed -i "s/@VERSION@/$(cat VERSION)/g" _server.pbl

if [ -e description.txt ]; then
	sed -i "s#@DESCRIPTION@#$(cat description.txt)#g" _server.pbl
fi

if [ -e icon.png ]; then
	set +x
	echo "Inserting @ICON@"
	sed -i "s#@ICON@#data:image/png;base64,$(base64 -w 0 icon.png)#g" _server.pbl
	set -x
fi
