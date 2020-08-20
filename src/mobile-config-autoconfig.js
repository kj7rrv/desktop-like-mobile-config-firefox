// Copyright 2020 Arnaud Ferraris, Oliver Smith
// SPDX-License-Identifier: GPL-3.0-or-later

// This is a Firefox autoconfig file:
// https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig

// Import custom userChrome.css on startup or new profile creation
const {classes: Cc, interfaces: Ci, utils: Cu} = Components;
Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/FileUtils.jsm");

// Create <profile>/chrome/ directory if not already present
var chromeDir = Services.dirsvc.get("ProfD", Ci.nsIFile);
chromeDir.append("chrome");
if (!chromeDir.exists()) {
  chromeDir.create(Ci.nsIFile.DIRECTORY_TYPE, FileUtils.PERMS_DIRECTORY);
}

// Create nsIFile objects for userChrome.css in <profile>/chrome/ and in /etc/
var chromeFile = chromeDir.clone();
chromeFile.append("userChrome.css");
var defaultChrome = new FileUtils.File("/etc/mobile-config-firefox/userChrome.css");

// Remove the existing userChrome.css if older than the installed one
if (chromeFile.exists() && defaultChrome.exists() &&
    chromeFile.lastModifiedTime < defaultChrome.lastModifiedTime) {
  chromeFile.remove(false);
}

// Copy userChrome.css to <profile>/chrome/
if (!chromeFile.exists()) {
  defaultChrome.copyTo(chromeDir, "userChrome.css");
}
