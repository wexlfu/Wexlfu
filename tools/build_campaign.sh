#!/bin/sh
set -e

wx="$(realpath "$(dirname $0)/..")"
wmlparser() {
	$(wesnoth --data-path 2>/dev/null)/data/tools/wesnoth/wmlparser3.py "$@"
	return $?
}

td="$(mktemp -d)"

trap "echo Removing temporary directory: "$td"; rm -r "$td"" INT QUIT TERM EXIT

# Write variable.
wvar() {
	echo "$2" > "$td/$1".var
}

# Read variable.
rvar() {
	if [ -e "$td/$1".var ]; then
		cat "$td/$1".var
	else
		cat "$td/$1".var.default
	fi
}

# Default variable.
dvar() {
	echo "$2" > "$td/$1".var.default
}

# Variable from file.
fvar() {
	wvar "$1" "$(cat "$2")"
}

# Variable from campaign WML.
wmlvar() {
	wvar "$1" "$(wmlparser -j -i _main.cfg 2>/dev/null | jq .campaign\[0\]."$2" -r)"
}

# Variable from _main.cfg tags.
mcvar() {
	if grep "^#$1:" _main.cfg > /dev/null; then
		wvar "$1" "$(grep "^#$1:" _main.cfg | head -n1 | cut -d' ' -f2-)"
	fi
}

# Apply variables to file.
apply() {
	find "$td" -type f -name '*.var.default' | xargs basename -a -- | cut -d. -f1 | while read n; do
		sed -i "s#@$n@#$(rvar "$n")#g" $1
	done
}

# Create and apply file from template.
template() {
	if [ -e "$1" ]; then
		cp "$1" "$2"
		apply "$2"
	fi
}

if [ ! -e _main.cfg ]; then
	echo "No _main.cfg found!"
	exit 1
fi

mkdir -p dist

. "$wx"/tools/campaign_variables.sh

fvar PASSPHRASE secrets/passphrase.ign
fvar EMAIL secrets/email.ign
fvar VERSION VERSION

wmlvar DESCRIPTION description

if [ -e icon.png ]; then
	wvar ICON "data:image/png;base64,$(base64 -w 0 icon.png)"
else
	wmlvar ICON icon
fi

mcvar GLOBAL_WEXLFU_BINARY_PATH
mcvar GLOBAL_WEXLFU_PREFIX
mcvar LOCAL_WEXLFU
mcvar MACRO
mcvar META_SCENARIOS
mcvar META_MEDALS
mcvar NAME
mcvar PARENT_DATA
mcvar PARENT_LOAD
mcvar WEXLFU
mcvar WEXLFU_SUB

echo "---"
find "$td" -type f -name '*.var.default' | xargs basename -a -- | cut -d. -f1 | sort | while read n; do
	echo "$n: $(rvar "$n")"
done
echo "---"

template "$wx"/templates/load.cfg dist/wexlfu_load.cfg
template "$wx"/templates/preload.cfg dist/wexlfu_preload.cfg
template _server.pbl.in _server.pbl
template README.md.in README.md
