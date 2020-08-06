USERCHROME_FILES := root.css urlbar.css appMenu.css
HOMEPAGE_FILES := head.html distro_links.html bottom.html
DISTRO := postmarketOS
DESTDIR :=

all: out/home.html out/userChrome.css

clean:
	rm -rf out
out:
	mkdir out

out/home.html: src/homepage/*.html out
	( cd src/homepage; cat $(HOMEPAGE_FILES) ) > $@.temp
	sed "s/@DISTRO@/$(DISTRO)/g" "$@.temp" > "$@"
	rm "$@.temp"

out/userChrome.css: out src/userChrome/*.css
	( cd src/userChrome; cat $(USERCHROME_FILES) ) > $@

install:
	install -Dm644 src/policies.json \
		"$(DESTDIR)/etc/firefox/policies/policies.json"
	install -Dm644 out/prefs.js \
		"$(DESTDIR)/usr/lib/firefox/defaults/pref/mobile-config.js"
	install -Dm644 "out/home.html" \
		"$(DESTDIR)/usr/share/mobile-config-firefox/home.html"
	install -Dm644 "out/userChrome.css" \
		"$(DESTDIR)/etc/mobile-config-firefox/userChrome.css"

.PHONY: all clean install
