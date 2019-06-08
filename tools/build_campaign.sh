#!/bin/sh
set -ex

wx="$(realpath "$(dirname $0)/..")"

cp _server.pbl.in _server.pbl
sed -i "s/@PASSPHRASE@/$(cat secrets/passphrase.ign)/g" _server.pbl
sed -i "s/@EMAIL@/$(cat secrets/email.ign)/g" _server.pbl
sed -i "s/@VERSION@/$(cat VERSION)/g" _server.pbl

DESCRIPTION=""
if [ -e description.txt ]; then
	DESCRIPTION="$(cat description.txt)"
elif which wesnoth > /dev/null; then
	DESCRIPTION="$($(wesnoth --data-path 2>/dev/null)/data/tools/wesnoth/wmlparser3.py -j -i _main.cfg 2>/dev/null | jq .campaign\[0\].description -r)"
fi
sed -i "s#@DESCRIPTION@#$DESCRIPTION#g" _server.pbl

if [ -e icon.png ]; then
	set +x
	echo "Inserting @ICON@"
	sed -i "s#@ICON@#data:image/png;base64,$(base64 -w 0 icon.png)#g" _server.pbl
	set -x
elif which wesnoth > /dev/null; then
	sed -i "s#@ICON@#$($(wesnoth --data-path 2>/dev/null)/data/tools/wesnoth/wmlparser3.py -j -i _main.cfg 2>/dev/null | jq .campaign\[0\].icon -r)#g" _server.pbl
fi

cp "$wx"/templates/load.cfg wexlfu_load.cfg
cp "$wx"/templates/preload.cfg wexlfu_preload.cfg

mcvar() {
	if grep "^#$1:" _main.cfg > /dev/null; then
		grep "^#$1:" _main.cfg | head -n1 | cut -d' ' -f2-
	else
		echo "$2"
	fi
}

for f in wexlfu_load.cfg wexlfu_preload.cfg; do
	set +x
	svar() {
		sed -i "s#@$1@#$(mcvar $1 $2)#g" $f
	}
	echo "Inserting templates: $f"
	svar NAME No_Name
	svar MACRO NN
	svar WEXLFU "$(cat "$wx"/VERSION | cut -d. -f1)"
	svar WEXLFU_SUB "$(cat "$wx"/VERSION | cut -d. -f2-)"
	svar GLOBAL_WEXLFU_BINARY_PATH "data/add-ons/Wexlfu"
	svar GLOBAL_WEXLFU_PREFIX "~add-ons/Wexlfu"
	svar LOCAL_WEXLFU "Wexlfu"
	svar PARENT_DATA "data/add-ons"
	svar PARENT_LOAD "~add-ons"
	set -x
done

if [ -e README.md.in ]; then
	cp README.md.in README.md

	sed -i "s#@VERSION@#$(cat VERSION)#g" README.md
	sed -i "s#@DESCRIPTION@#$DESCRIPTION#g" README.md
fi
