# mobile-config-firefox

An attempt at creating a distro-independent mobile and privacy friendly configuration for Firefox ESR 78 *(supported by Mozilla until ~2021-04)* and newer versions. As of writing, these configs work with Phosh and Firefox 78 (ESR) and 82.0.3.

This does not replace a proper implementation in [Firefox upstream](https://bugzilla.mozilla.org/show_bug.cgi?id=1579348) *(interesting stuff happens in issues linked in "References")*. Some dialogs are still hard to use or look a bit awkward. But overall, it makes the browser usable on mobile.

## What this config does
### Visual
*Starting with version 2.0.0, the visual tweaks only get activated if you have a small window width. **It works nicely with convergence.***

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

## Contributing changes to userChrome
Firefox' developer tools include a [remote debugger](https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging), which even has the "pick an element" feature. You will be able to click that button on your PC, then tap on an element of the Firefox UI on your phone, and then you will see the HTML code and CSS properties on your PC just as if it was a website. So this is highly recommended when contributing changes to `userChrome.css`.

* Connect your phone and your PC to the same network (Wi-Fi or USB network)
* On your phone, open Firefox and `about:config`:
  * Change `devtools.chrome.enabled` to `true`
  * Change `devtools.debugger.remote-enabled` to `true`
  * The debugger will only listen on localhost by default. If you know what you are doing, you may set `devtools.debugger.force-local` to `false`, so it listens on all interfaces. Otherwise you'll need something like an SSH tunnel.
  * Close firefox
* Connect to your phone via SSH
  * Set up environment variables properly, so you can start programs (one lazy way to do it, is `tmux` on your phone in the terminal, then `tmux a` in SSH)
  * Run `firefox --start-debugger-server 6000` (or another port if you desire)
* Run Firefox on your PC
  * Go to `about:debugging`
  * Add your phone as "network location"
  * Press the connect button on the left
* On your phone
  * Confirm the connection on your phone's screen
    * If the button is not visible on the screen, try switching to a terminal virtual keyboard, hit "tab" three times and then return
* On your PC
  * Scroll down to Processes, Main Process, and click "Inspect"
  * Now use the "Pick an element" button as described in the introduction. Find the `userChrome.css` file in the "Style editor" tab and edit it as you like.
  * Consider copy pasting the contents to a text editor every now and then, so you don't lose it when closing Firefox by accident.
