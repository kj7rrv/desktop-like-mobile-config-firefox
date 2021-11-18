#!/bin/sh -e
# Copyright 2021 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later
#
# As of writing, it seems that every existing CSS linter is either written in
# JS or ruby and has tons of dependencies... so instead of that let's use this
# simple shell script for now. This script needs find and GNU grep (for -P) and
# a shell that knows "local".

TOPDIR="$(realpath "$(dirname "$0")/..")"
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

lint_file() {
	lint \
		"tabs found, indent with 4 spaces instead" \
		-P '\t'

	lint \
		"indent with 4 spaces" \
		-P '^([ ]{1,3}|[ ]{5,7})[a-zA-Z\[\.\/]'

	lint \
		"spaces at the end of lines are not allowed" \
		-E ' $'

	lint_spdx
}

lint_files() {
	# shellcheck disable=SC2044
	for CURRENT_FILE in $(find . -name '*.css'); do
		if ! [ -e "$CURRENT_FILE" ]; then
			echo "ERROR: no CSS files found in current work dir"
			exit 1
		fi
		lint_file
	done
}

cd "$TOPDIR/src"
lint_files

if [ "$EXIT_CODE" -eq 0 ]; then
	echo "No linting errors found :)"
else
	echo "Please fix the linting errors above and consider configuring your"
	echo "editor to use the .editorconfig file."
fi

exit $EXIT_CODE
