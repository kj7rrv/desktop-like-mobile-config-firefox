USERCHROME_FILES := root.css urlbar.css appMenu.css

all: out/home.html out/policies.json out/prefs.js out/userChrome.css

clean:
	rm -rf out
out:
	mkdir out

out/home.html: src/home.html out
	cat $< > $@

out/policies.json: src/policies.json out
	cat $< > $@

out/prefs.js: src/prefs.js out
	cat $< > $@

out/userChrome.css: out src/userChrome/*.css
	( cd src/userChrome; cat $(USERCHROME_FILES) ) > $@

.PHONY: all clean
