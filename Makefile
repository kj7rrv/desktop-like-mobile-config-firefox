# Copyright 2020 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later

USERCHROME_FILES := $(sort $(wildcard src/userChrome/*.css))
HOMEPAGE_FILES := head.html distro_links.html bottom.html
DISTRO := postmarketOS
DESTDIR :=
FIREFOX_DIR := /usr/lib/firefox

all: out/home.html out/userChrome.css

clean:
	rm -rf out
out:
	mkdir out

out/home.html: src/homepage/*.html out
	( cd src/homepage; cat $(HOMEPAGE_FILES) ) > $@.temp
	sed "s/@DISTRO@/$(DISTRO)/g" "$@.temp" > "$@"
	rm "$@.temp"

out/userChrome.css: $(USERCHROME_FILES) out
	cat $(USERCHROME_FILES) > $@

install: all
	install -Dm644 src/policies.json \
		"$(DESTDIR)/etc/firefox/policies/policies.json"
	install -Dm644 src/prefs.js \
		"$(DESTDIR)/$(FIREFOX_DIR)/defaults/pref/mobile-config.js"
	install -Dm644 "out/home.html" \
		"$(DESTDIR)/usr/share/mobile-config-firefox/home.html"
	install -Dm644 "out/userChrome.css" \
		"$(DESTDIR)/etc/mobile-config-firefox/userChrome.css"
	install -Dm755 "src/mobile-config-firefox.sh" \
		"$(DESTDIR)/usr/mobile-config/bin/firefox"
	install -Dm755 "src/mobile-config-path.sh" \
		"$(DESTDIR)/etc/profile.d/mobile-config-path.sh"

.PHONY: all clean install
