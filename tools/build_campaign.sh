#!/bin/sh
set -ex

wx="$(realpath "$(dirname $0)/..")"

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

cp "$wx"/templates/load.cfg wexlfu_load.cfg
cp "$wx"/templates/preload.cfg wexlfu_preload.cfg

for f in wexlfu_load.cfg wexlfu_preload.cfg; do
	set +x
	echo "Inserting templates: $f"
	sed -i "s/@NAME@/$(grep "#NAME:" _main.cfg | head -n1 | cut -d' ' -f2-)/g" $f
	sed -i "s/@MACRO@/$(grep "#MACRO:" _main.cfg | head -n1 | cut -d' ' -f2-)/g" $f
	sed -i "s/@WEXLFU@/$(grep "#WEXLFU:" _main.cfg | head -n1 | cut -d' ' -f2-)/g" $f
	set -x
done
