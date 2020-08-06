USERCHROME_FILES := root.css urlbar.css appMenu.css
HOMEPAGE_FILES := head.html distro_links.html bottom.html
DISTRO := postmarketOS

all: out/home.html out/policies.json out/prefs.js out/userChrome.css

clean:
	rm -rf out
out:
	mkdir out

out/home.html: src/homepage/*.html out
	( cd src/homepage; cat $(HOMEPAGE_FILES) ) > $@.temp
	sed "s/@DISTRO@/$(DISTRO)/g" "$@.temp" > "$@"
	rm "$@.temp"

out/policies.json: src/policies.json out
	cat $< > $@

out/prefs.js: src/prefs.js out
	cat $< > $@

out/userChrome.css: out src/userChrome/*.css
	( cd src/userChrome; cat $(USERCHROME_FILES) ) > $@

.PHONY: all clean
