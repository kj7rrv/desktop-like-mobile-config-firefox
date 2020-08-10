# mobile-config-firefox

An attempt at creating a distro-independent mobile and privacy friendly configuration for Firefox ESR 68 *(last planned release before EOL: [2020-08-25](https://wiki.mozilla.org/Release_Management/Calendar))*, ESR 78 *(supported by Mozilla until ~2021-04)* and newer versions. As of writing, these configs work with Phosh and Firefox 68 (ESR), 78 (ESR) and 79.

This does not replace a proper implementation in [Firefox upstream](https://bugzilla.mozilla.org/show_bug.cgi?id=1579348). Some dialogs are still hard to use or look a bit awkward. But overall, it makes the browser usable on mobile.

## What this config does
### Visual
`mobile-config-firefox` installs a `userChrome.css` file to reduce the minimum width of the main window, so it fits the screen without scaling it down. The content of popup windows (settings menu, install add-on confirmation, ...) would be cut off with the default configuration, so as workaround the content is reduced to make it fit the windows again. (It was not possible to increase the size of these windows merely with CSS). The find bar (appears with `^F` on your PC, can be toggled from the menu too) is tweaked to fit the mobile screen as well.

The visible width of the URL is increased by hiding buttons around the urlbar (most features behind those buttons can be accessed through other menus), and by decreasing the font size. Furthermore, the urlbar will float above buttons on the left and right when focused, to leave even more space for typing the URL or search query.

![Before and after screenshots](https://postmarketos.org/static/img/2020-08/mobile-config-firefox-esr78.jpg)

### Other Mobile Related
* Enable zooming with fingers <small>(Change in about:config; apz.allow_zooming, apz.allow_double_tap_zooming, dom.w3c.touch_events.enabled)</small>
* Mobile user agent (from TOR browser for Android) <small>(Change in about:config; general.useragent.override)</small>

### Privacy
* Disable search suggestions, so URLs do not get sent to search engines as they are getting typed <small>(Change in Preferences)</small>
* Disable Firefox studies <small>(Change in Preferences)</small>
* Disable Telemetry <small>(Change in Preferences)</small>
* Set DuckDuckGo as default search engine <small>(Change in Preferences)</small>

### Uncluttering
To save screen space, remove broken features, and have less distractions in the browser in general:
* Custom start page (loads faster, explains mobile config and how to use settings, links to addons)
* Empty "new tab" page (loads faster, no annoying "top sites" etc.) <small>(Change in Preferences)</small>
* Disable "Firefox Screenshots": the feature did not work with the mobile resolution in Phosh. <small>(Change in /etc/firefox/policies/policies.json)</small>
* No default bookmarks from Firefox <small>(Change in /etc/firefox/policies/policies.json)</small>
* Disable First Run Page <small>(Change in /etc/firefox/policies/policies.json)</small>
* Disable Post Update Page <small>(Change in /etc/firefox/policies/policies.json)</small>
* Disable "User Messaging" (What's new, Extension/Feature Recommendations, Urlbar Interventions) <small>(Change in /etc/firefox/policies/policies.json)</small>

## How to build and package

* Replace `src/homepage/distro_links.html`
* Build with `make DISTRO=yourdistroname`
* In your packaging recipie, run something like `make DESTDIR=$pkgdir install`
