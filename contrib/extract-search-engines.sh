#!/bin/sh -e
# Copyright 2021 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Extract the search engine names found in your current Firefox installation,
# and create a list suitable for policies.json that removes all of them except
# for what's in remove_allowed_dirs(). Note that SearchEngines can only be
# configured via policies.json in the ESR version of firefox.
# Related: https://github.com/mozilla/policy-templates/blob/master/README.md

remove_allowed_dirs() {
	rm -rf \
		ddg \
		wikipedia
}

get_names() {
	grep \
		'"name":' \
		*/manifest.json \
		| cut -d '"' -f 4 \
		| grep -v '__MSG_extensionName__' \
		| grep -v '^form$'
}

get_names_localized() {
	grep \
		-A1 \
		'"extensionName":' \
		*/_locales/*/messages.json \
		| grep '"message":' \
		| cut -d '"' -f 4
}

get_names_all_sorted() {
	(get_names; get_names_localized) | sort -u
}

print_json() {
	local first=1

	echo '        "SearchEngines": {'
	echo '            "Default": "DuckDuckGo",'
	echo '            "Remove": ['

	get_names_all_sorted | while IFS= read -r i; do
		if [ "$first" -eq 1 ]; then
			first=0
		else
			echo ","
		fi
		printf "                \"$i\""
	done

	echo ''
	echo '            ]'
	echo '        },'
}


OMNI="/usr/lib/firefox/browser/omni.ja"
TMPDIR="$(mktemp -d "/tmp/extract-search-engines-XXXXXX")"
cd "$TMPDIR"

unzip -q "$OMNI"
cd "chrome/browser/search-extensions"

remove_allowed_dirs
print_json

cd ~
rm -r "$TMPDIR"
