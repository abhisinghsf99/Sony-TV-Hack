# BRAVIA VU1 Cheat Sheet

Sony BRAVIA VU1 (BRAVIA_VU1_UC), Android TV 11, ADB at `192.168.86.90:5555`. Run everything from this folder on the Mac.
Full history with every change and its undo: `DEBLOAT-LOG.md`. Original state: `backup/`.

## Everyday commands

| What | Command |
|---|---|
| Connect | `adb connect 192.168.86.90:5555` |
| Live monitor (run in a second terminal first) | `scripts/monitor.sh` |
| Monitor with less noise | `LOGCAT_FILTER='*:W' scripts/monitor.sh` |
| What's disabled right now | `adb shell pm list packages -d` |
| Who owns the Home button | `adb shell cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME` |
| Add or remove a wallpaper | Put JPGs (1920×1080, letters/digits/`-`/`_` in the name) in `themes/lockscreen/wallpapers/`, then `scripts/theme-push.sh themes/lockscreen` |
| Change how often they rotate | `wallpaper_rotation_minutes` in `themes/lockscreen/config.json` (0 = off), then push |
| Switch Home theme | `scripts/theme-push.sh themes/lockscreen` or `scripts/theme-push.sh themes/appletv` |
| Launcher's built-in look | `scripts/theme-push.sh --reset` |

**Big clock behind the mountain** (shelved; only if you turn `lock_clock` back on, and it needs a single wallpaper, not the rotation: a photo with a clear sky over hills or mountains):
1. Copy `themes/lockscreen` to a new folder.
2. If the subject sits too high for the clock, `bin/sky-shift photo.jpg <folder>/wallpaper.jpg 80` moves it down and extends the sky.
3. `bin/depth-mask <folder>/wallpaper.jpg <folder>/wallpaper_front.png 0.06 2` cuts the foreground out of the sky. It prints the skyline.
4. Set `lock_clock_top` (dp) and `lock_clock_size` (sp) in `config.json` so the summit overlaps only the bottom of the digits.
5. Push it with `scripts/theme-push.sh <folder>`.

**Monitor:** prints `▶ time START <command>` / `■ time END rc=…` for every command the scripts send, with the TV's logcat in between, only while that command runs.

## What changed on the TV

| Area | Change |
|---|---|
| Disabled (22 packages, never uninstalled) | Batch 1: Sony auto-installs, recommendations, feedback, demo, Play Games, Play Movies. Batch 2: print, gallery, camera, 2 Sony help apps, Ambient screensaver, YouTube Music, Spotify, Peacock, NFL. Launcher swap: stock launcher, partner customizer. Batch 3: onetimeinitializer, live wallpaper picker, HTML viewer, calendar sync |
| Restricted in background | ESPN, Paramount+ (they still open and play normally) |
| Settings | Animations 0.5×; Private DNS `dns.adguard-dns.com`; screensaver = Colors (`com.android.dreams.basic`) |
| Installed | TV Bro 2.1.6 (`com.phlox.tvwebbrowser`, GitHub release); cleanyourtv launcher 3.0 (`com.gathin.tvhome`, built from source) |
| Home | cleanyourtv launcher, **lock-screen fork** (`../cleanyourtv`, branch `lock-screen`, 348b7118) with `themes/lockscreen`: 13 wallpapers (yours, from `Images/`) that crossfade every 2 minutes in random order (`themes/lockscreen/wallpapers/`), small clock and date top-left (`lock_clock` is off, so no big clock), one row of 6 large app tiles. UP from the row reaches the round Inputs/network/Settings buttons. The Inputs menu lists HDMI 1–3 only; the remote's **Input** key still opens Sony's menu with antenna (Analog/Digital) too |
| Other themes | `themes/appletv` (frosted dock, no cinematic shelf) works on both the fork and the original build |
| YouTube | Using **Watch as guest** (signed out). Sign in yourself anytime from YouTube's menu |

## Undo

Each script puts back exactly what it names. To undo everything, run them top to bottom. Always restore the stock launcher before uninstalling the new one:

| Undo | Command |
|---|---|
| Lock-screen fork (back to the original launcher build + Apple TV theme) | `sh backup/UNDO-lockscreen.sh` |
| Any theme (launcher's built-in look) | `sh backup/UNDO-theme.sh` |
| Batch 3 | `sh backup/UNDO-batch3.sh` |
| Launcher swap (stock launcher back as Home) | `sh backup/UNDO-launcher.sh` |
| Remove the new launcher (after the line above) | `adb uninstall com.gathin.tvhome` |
| ESPN/Paramount+ background restriction | `sh backup/UNDO-appops.sh` |
| Animations, Private DNS, screensaver | `sh backup/UNDO-settings.sh` |
| Batch 1 | `sh backup/UNDO-batch1.sh` |
| Batch 2 | `sh backup/UNDO-batch2.sh` |
| TV Bro | `adb uninstall com.phlox.tvwebbrowser` |

**If Home ever breaks:** run `sh backup/UNDO-launcher.sh`. It re-enables the stock launcher and makes it Home again. ADB works no matter what's on screen.

**If ADB can't reach the TV:**
- **Asleep:** wake the TV with the remote. With the Colors screensaver on, it stays awake when idle.
- **"No route to host" on macOS:** allow the terminal under Local Network in System Settings, then retry.
- **Connection refused:** re-pair under Developer options → Wireless debugging.

## Bringing an app back

Nothing was uninstalled. Disabled apps are still on the TV, just switched off. There are three ways to get one back:

1. **From the TV, no computer needed:** Settings (the gear on Home) → Apps → See all apps → Show system apps → pick the app → **Enable**.
2. **Play Store (only for apps listed there):** search for the app. Its page shows **Enable** instead of Install. Press it.
3. **ADB:** `adb shell pm enable --user 0 <package>`

| App | Package | In Play Store? |
|---|---|---|
| YouTube Music | `com.google.android.youtube.tvmusic` | Yes, search "YouTube Music" |
| Spotify | `com.spotify.tv.android` | Yes, search "Spotify" |
| Peacock | `com.peacocktv.peacockandroid` | Yes, search "Peacock" |
| NFL (lite) | `com.gotv.nflgamecenter.us.lite` | Yes, search "NFL" |
| Google TV / Play Movies | `com.google.android.videos` | Yes, search "Google TV" |
| Play Games | `com.google.android.play.games` | Yes, search "Google Play Games" |
| Ambient mode screensaver | `com.google.android.backdrop` | No. Also run `adb shell settings put secure screensaver_components com.google.android.backdrop/.Backdrop` |
| Stock launcher | `com.google.android.tvlauncher` | No. Use `sh backup/UNDO-launcher.sh` so it also becomes Home |
| Partner customizer | `com.google.android.tvsetup.partnercustomizer` | No |
| Launcher recommendations | `com.google.android.tvrecommendations` | No |
| Sony auto-installs | `android.autoinstalls.config.Sony.BRAVIA_VU1` | No |
| Google feedback | `com.google.android.feedback` | No |
| Sony demo mode | `com.sony.dtv.demo` | No |
| Sony Help Guide | `com.sony.dtv.helpguidecontents` | No |
| Sony Smart Help | `com.sony.dtv.smarthelp` | No |
| Print service | `com.android.printspooler` | No |
| Gallery | `com.android.gallery3d` | No |
| Camera | `com.android.camera2` | No |
| One-time initializer | `com.google.android.onetimeinitializer` | No |
| Live wallpaper picker | `com.android.wallpaper.livepicker` | No |
| HTML viewer | `com.android.htmlviewer` | No |
| Calendar sync | `com.google.android.syncadapters.calendar` | No |
