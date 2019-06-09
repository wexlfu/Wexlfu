#!/bin/bash
set -e

wx="$(realpath "$(dirname $0)/..")"
wmlparser() {
	$(wesnoth --data-path 2>/dev/null)/data/tools/wesnoth/wmlparser3.py "$@"
	return $?
}

sedquote() {
	IFS= read -d '' -r < <(sed -e ':a' -e '$!{N;ba' -e '}' -e 's/[&/\]/\\&/g; s/\n/\\&/g' <<<"$1")
	printf %s "${REPLY%$'\n'}"
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

# Clear variable.
clearvar() {
	wvar "$1" ""
}

# Variable from file.
fvar() {
	wvar "$1" "$(cat "$2")"
}

varlist() {
	find "$td" -type f -name '*.var.default' | xargs basename -a -- | cut -d. -f1 | sort
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
	varlist | while read n; do
		sed -i "s/@$n@/$(sedquote "$(rvar "$n")")/g" $1
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
wvar DESCRIPTION "$(rvar DESCRIPTION | head -n1)"

if [ -e icon.png ]; then
	wvar ICON "data:image/png;base64,$(base64 -w 0 icon.png)"
else
	wmlvar ICON icon
fi

mcvar GLOBAL_WEXLFU_BINARY_PATH
mcvar GLOBAL_WEXLFU_PREFIX
mcvar LOCAL_WEXLFU
mcvar MACRO
mcvar META_MEDALS
mcvar META_SCENARIOS
mcvar META_SCENARIOS_DONE
mcvar NAME
mcvar PARENT_DATA
mcvar PARENT_LOAD
mcvar WEXLFU
mcvar WEXLFU_SUB

wvar TEXTDOMAIN "$(head -n1 _main.cfg | cut -d' ' -f2)"

echo "---"
varlist | while read n; do
	echo "$n: $(rvar "$n")"
done
echo "---"

template "$wx"/templates/campaign_stats.md "$td"/campaign_stats.md
template "$wx"/templates/campaign_stats.txt "$td"/campaign_stats.txt

if [[ "$(rvar META_SCENARIOS_DONE)" = "1" ]]; then
	sed -i "s/scenarios/scenario/g" -i "$td"/campaign_stats.txt "$td"/campaign_stats.md
fi

if [[ "$(rvar META_MEDALS)" = "1" ]]; then
	sed -i "s/medals/medal/g" -i "$td"/campaign_stats.txt "$td"/campaign_stats.md
fi

fvar CAMPAIGN_STATS "$td"/campaign_stats.md
fvar CAMPAIGN_STATS_PLAIN "$td"/campaign_stats.txt

template _server.pbl.in _server.pbl
clearvar PASSPHRASE
clearvar EMAIL

echo "#textdomain $(rvar TEXTDOMAIN)" > dist/wexlfu_macros.cfg
varlist | while read n; do
	echo "#define $(rvar MACRO)_WVAR_$n" >> dist/wexlfu_macros.cfg
	echo "$(rvar "$n")#enddef" >> dist/wexlfu_macros.cfg
done

for n in CAMPAIGN_STATS_PLAIN; do
	echo "#define $(rvar MACRO)_WVART_$n" >> dist/wexlfu_macros.cfg
	echo "_ <<$(rvar "$n")>>#enddef" >> dist/wexlfu_macros.cfg
done

template "$wx"/templates/load.cfg dist/wexlfu_load.cfg
template "$wx"/templates/preload.cfg dist/wexlfu_preload.cfg

template README.md.in README.md
if which markdown2bbcode > /dev/null; then
	markdown2bbcode < README.md > README.bbcode
fi
