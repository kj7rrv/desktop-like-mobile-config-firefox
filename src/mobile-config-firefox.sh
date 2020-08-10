#!/bin/sh
# Copyright 2020 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later

# Create chrome/userChrome.css symlink in a firefox profile dir
# $1: path to profile dir, e.g. "/home/user/.mozilla/firefox/asdf.default"
prepare_profile() {
	mkdir -p "$1/chrome"
	if ! [ -e "$1/chrome/userChrome.css" ]; then
		ln -sv /etc/mobile-config-firefox/userChrome.css \
			"$1/chrome/userChrome.css"
	fi
}

if [ -e ~/.mozilla/firefox/profiles.ini ]; then
	# Firefox was started without this wrapper and created profiles.ini.
	# Add the userChrome.css symlink to all existing profiles, then let
	# firefox run with the default profile.

	for profiledir in ~/.mozilla/firefox/*/; do
		if ! [ -e "$profiledir/prefs.js" ]; then
			continue
		fi

		prepare_profile "$profiledir"
	done

	exec /usr/bin/firefox "$@"
else
	# Firefox was not started without this wrapper. Create a profile dir
	# called "firefox.default" if it does not exist yet, and add the
	# userChrome.css symlink. Let firefox use this profile. It will not
	# create the profiles.ini file.

	profiledir=~/.mozilla/firefox/firefox.default
	prepare_profile "$profiledir"

	exec /usr/bin/firefox --profile "$profiledir" "$@"
fi
