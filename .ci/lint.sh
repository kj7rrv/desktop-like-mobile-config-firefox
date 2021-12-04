#!/bin/sh -e
# Copyright 2021 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later
#
# As of writing, it seems that every existing CSS linter is either written in
# JS or ruby and has tons of dependencies... so instead of that let's use this
# simple shell script for now. This script needs find and GNU grep (for -P) and
# a shell that knows "local".

TOPDIR="$(realpath "$(dirname "$(realpath "$0")")/..")"
CURRENT_FILE=""
EXIT_CODE=0

# $1: error message
# $2-n: arguments for grep
lint() {
	# shellcheck disable=SC3043
	local msg="$1"
	shift

	if grep -q "$@" "$CURRENT_FILE"; then
		echo "ERROR: $msg"
		echo "$CURRENT_FILE:"
		grep -n "$@" "$CURRENT_FILE"
		echo
		EXIT_CODE=1
	fi
}

lint_spdx() {
	if ! grep -q "SPDX-License-Identifier" "$CURRENT_FILE"; then
		echo "ERROR: missing SPDX-License-Identifier in $CURRENT_FILE"
		echo
		EXIT_CODE=1
	fi
}

lint_spaces() {
	lint \
		"tabs found, indent with 4 spaces instead" \
		-P '\t'

	lint \
		"indent with 4 spaces" \
		-P '^([ ]{1,3}|[ ]{5,7})[a-zA-Z\[\.\/]'

	lint \
		"spaces at the end of lines are not allowed" \
		-E ' $'
}

lint_files() {
	# shellcheck disable=SC3043
	local files="$(find src -name '*.css' -o -name '*.js' -o -name '*.json')"

	if [ -z "$files" ]; then
		echo "ERROR: no files to lint found in current work dir"
		exit 1
	fi

	for CURRENT_FILE in $files; do
		case ${CURRENT_FILE##*.} in
			css)
				lint_spaces
				lint_spdx
				;;
			js)
				lint_spaces
				lint_spdx
				;;
			json)
				lint_spaces
				;;
		esac
	done
}

cd "$TOPDIR"
lint_files

if [ "$EXIT_CODE" -eq 0 ]; then
	echo "No linting errors found :)"
else
	echo "Please fix the linting errors above and consider configuring your"
	echo "editor to use the .editorconfig file."
fi

exit $EXIT_CODE
