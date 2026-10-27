# Sony BRAVIA VU1 Debloat Log

TV: Sony BRAVIA VU1 (BRAVIA_VU1_UC), Android TV 11, ADB at 192.168.86.90:5555.
Pre-change backup: `backup/` (package lists, meminfo, settings, undo scripts).
Every change is `pm disable-user --user 0` (no uninstalls) or a `settings put`; each row lists its exact undo.

## Batch 2 — 2026-10-26 12:46:57

Undo whole batch: `sh backup/UNDO-batch2.sh`

| Time | Package | Result | Undo |
|---|---|---|---|
| 12:46:57 | `com.android.printspooler` | Package com.android.printspooler new state: disabled-user | `adb shell pm enable --user 0 com.android.printspooler` |
| 12:46:57 | `com.android.gallery3d` | Package com.android.gallery3d new state: disabled-user | `adb shell pm enable --user 0 com.android.gallery3d` |
| 12:46:58 | `com.android.camera2` | Package com.android.camera2 new state: disabled-user | `adb shell pm enable --user 0 com.android.camera2` |
| 12:46:58 | `com.sony.dtv.helpguidecontents` | Package com.sony.dtv.helpguidecontents new state: disabled-user | `adb shell pm enable --user 0 com.sony.dtv.helpguidecontents` |
| 12:46:58 | `com.sony.dtv.smarthelp` | Package com.sony.dtv.smarthelp new state: disabled-user | `adb shell pm enable --user 0 com.sony.dtv.smarthelp` |
| 12:46:58 | `com.google.android.backdrop` | Package com.google.android.backdrop new state: disabled-user | `adb shell pm enable --user 0 com.google.android.backdrop` |
| 12:46:59 | `com.google.android.youtube.tvmusic` | Package com.google.android.youtube.tvmusic new state: disabled-user | `adb shell pm enable --user 0 com.google.android.youtube.tvmusic` |
| 12:46:59 | `com.spotify.tv.android` | Package com.spotify.tv.android new state: disabled-user | `adb shell pm enable --user 0 com.spotify.tv.android` |
| 12:47:00 | `com.peacocktv.peacockandroid` | Package com.peacocktv.peacockandroid new state: disabled-user | `adb shell pm enable --user 0 com.peacocktv.peacockandroid` |
| 12:47:00 | `com.gotv.nflgamecenter.us.lite` | Package com.gotv.nflgamecenter.us.lite new state: disabled-user | `adb shell pm enable --user 0 com.gotv.nflgamecenter.us.lite` |
Note: Backdrop was the active screensaver (secure screensaver_components=com.google.android.backdrop/.Backdrop). Setting left unchanged; ambient mode returns when Backdrop is re-enabled.

Post-batch check 12:47:38: Play Store, Play Services (gms, gsf), launcher, partnercustomizer, mediashell all still enabled. Play Store opened to TvMainActivity and loaded its home page (screenshot: `backup/screens/playstore-after-batch2.png`).

## Batch 1 — 2026-10-26 12:51:24

Undo whole batch: `sh backup/UNDO-batch1.sh`

| Time | Package | Result | Undo |
|---|---|---|---|
| 12:51:24 | `android.autoinstalls.config.Sony.BRAVIA_VU1` | Package android.autoinstalls.config.Sony.BRAVIA_VU1 new state: disabled-user | `adb shell pm enable --user 0 android.autoinstalls.config.Sony.BRAVIA_VU1` |
| 12:51:24 | `com.google.android.tvrecommendations` | Package com.google.android.tvrecommendations new state: disabled-user | `adb shell pm enable --user 0 com.google.android.tvrecommendations` |
| 12:51:25 | `com.google.android.feedback` | Package com.google.android.feedback new state: disabled-user | `adb shell pm enable --user 0 com.google.android.feedback` |
| 12:51:25 | `com.sony.dtv.demo` | Package com.sony.dtv.demo new state: disabled-user | `adb shell pm enable --user 0 com.sony.dtv.demo` |
| 12:51:25 | `com.google.android.play.games` | Package com.google.android.play.games new state: disabled-user | `adb shell pm enable --user 0 com.google.android.play.games` |
| 12:51:25 | `com.google.android.videos` | Package com.google.android.videos new state: disabled-user | `adb shell pm enable --user 0 com.google.android.videos` |

## Settings — 2026-10-26 12:51:34

Undo all: `sh backup/UNDO-settings.sh`

| Setting | Before | After | Undo |
|---|---|---|---|
| global `window_animation_scale` | 1.0 | 0.5 | `adb shell settings put global window_animation_scale 1.0` |
| global `transition_animation_scale` | 1.0 | 0.5 | `adb shell settings put global transition_animation_scale 1.0` |
| global `animator_duration_scale` | null | 0.5 | `adb shell settings delete global animator_duration_scale` |
| global `private_dns_mode` | null | hostname | `adb shell settings delete global private_dns_mode` |
| global `private_dns_specifier` | null | dns.adguard-dns.com | `adb shell settings delete global private_dns_specifier` |

## Cache trim + reboot — 2026-10-26 12:51:50

- `pm trim-caches 999G`: clears all app caches. No undo needed; apps rebuild caches on use.
- `adb reboot`: plain restart.

## Post-reboot check

- Reconnected 25 s after reboot. All 16 packages are still disabled; the animation and Private DNS settings persisted. Private DNS validated against AdGuard (94.140.14.14, 94.140.15.15).
- `backup/meminfo-after.txt` was captured at ~4 min uptime, while the TV was still warming up. Used RAM was 1,048,708K, versus 896,333K at baseline. The launcher (173 MB) and TTS (166 MB) were mid-initialization, so this is not a like-for-like comparison. A settled re-measure is still pending.
- None of the 16 disabled packages is running. At baseline, Spotify (22 MB) and tvrecommendations (18 MB) were resident.

## Background restriction (appops) — 2026-10-26 12:58:56

Undo all: `sh backup/UNDO-appops.sh`

| Package | Op | Before | After | Undo |
|---|---|---|---|---|
| `com.espn.score_center` | RUN_ANY_IN_BACKGROUND | default (allow) | RUN_ANY_IN_BACKGROUND: ignore | `adb shell cmd appops set com.espn.score_center RUN_ANY_IN_BACKGROUND allow` |
| `com.cbs.ott` | RUN_ANY_IN_BACKGROUND | default (allow) | RUN_ANY_IN_BACKGROUND: ignore | `adb shell cmd appops set com.cbs.ott RUN_ANY_IN_BACKGROUND allow` |

Post-restriction check:
- ESPN: opened normally. I skipped the optional login and played a free Highlights clip; media session state=3 (PLAYING) and the app had an active audio track. Screenshots are black because ESPN uses FLAG_SECURE.
- Paramount+: opened normally to the Get Started / Sign in screen. It is not signed in on this TV (no Paramount account on the device, no usage before today), so playback could not be tested without a login. I did not sign in.

## 15-min idle re-measure — 2026-10-26 13:17 (uptime ~26 min)

`backup/meminfo-idle15.txt`: Used RAM 1,023,778K and Free RAM 505,319K, versus a baseline of 896,333K / 622,597K.
Skewed by my test: Paramount+ was still in the "Previous app" slot (90 MB, counted as used) and ESPN was cached (152 MB). Both were left over from the playback check.
13:18: I force-stopped both (equivalent to closing them, not a setting change) for a clean re-measure. The ADB connection then dropped, and the TV stopped answering pings and port 5555. Clean re-measure pending.

## Why the TV went offline — 13:20

`dumpsys power`: mLastSleepReason=timeout, screen_off_timeout=900000 (15 min), sleep_timeout=-1, screensaver_components=com.google.android.backdrop/.Backdrop. The TV did not reboot.
Cause: Backdrop (Ambient mode) is the screensaver, and it is disabled in batch 2. At the 15-min timeout there is no screensaver to start, so the TV sleeps; sleep drops the network and ADB. Before batch 2, Backdrop ran indefinitely instead.
No change made yet — waiting for the owner's decision.

## Clean memory reading — 13:26 (ESPN and Paramount+ closed, launcher on screen)

`backup/meminfo-idle-clean.txt`: Used RAM 979,203K and Free RAM 537,919K, 117 processes (baseline: 896,333K / 622,597K, 123 processes).

## App install — 2026-10-26 13:27:15

| App | Package | Source | SHA-256 (matches GitHub digest) | Undo |
|---|---|---|---|---|
| TV Bro 2.1.6 (geckoExcluded, uses system WebView) | `com.phlox.tvwebbrowser` | https://github.com/truefedex/tv-bro/releases/tag/v2.1.6 | d8634edf…60942b2 | `adb uninstall com.phlox.tvwebbrowser` |

TV Bro launched OK (MainActivity, home page rendered, ad blocker ON) — 13:27:39

## Launcher swap — 2026-10-26 13:56:57

Undo all: `sh backup/UNDO-launcher.sh` (Home state before: `backup/home-before.txt`)

| Time | Change | Result | Undo |
|---|---|---|---|
| 13:56 | Installed cleanyourtv launcher `com.gathin.tvhome` 3.0, built from Gathin23/cleanyourtv @ 76a9312 (APK sha256 a7776fd9…98a3b003) | Success | `adb uninstall com.gathin.tvhome` |
| 13:56 | `cmd package set-home-activity --user 0 com.gathin.tvhome/.MainActivity` | Success, but HOME still resolved to tvlauncher (stock launcher has priority 2) | `adb shell cmd package set-home-activity --user 0 com.google.android.tvlauncher/.MainActivity` |
| 13:57 | Pre-check: `am start -W` HOME intent → com.gathin.tvhome | Status: ok, cold start 1439 ms, home screen rendered (`backup/screens/tvhome-first-start.png`) | — |
| 13:56 | `com.google.android.tvlauncher` | Package com.google.android.tvlauncher new state: disabled-user | `adb shell pm enable --user 0 com.google.android.tvlauncher` |
| 13:56 | `com.google.android.tvsetup.partnercustomizer` | Package com.google.android.tvsetup.partnercustomizer new state: disabled-user | `adb shell pm enable --user 0 com.google.android.tvsetup.partnercustomizer` |
| 13:57 | HOME resolves to com.gathin.tvhome/.MainActivity; `sync`, 15 s wait, `adb reboot` | — | — |

Post-reboot (13:58): HOME still resolves to com.gathin.tvhome/.MainActivity, the Home key shows the new launcher (`backup/screens/home-after-reboot.png`), and 18 packages are disabled including tvlauncher and partnercustomizer.

### App and input checks from the new launcher (14:00–14:06, real key presses, title read before each OK)
| Test | Result |
|---|---|
| Netflix tile (dock, col 1) | Opened com.netflix.ninja/.MainActivity |
| YouTube tile (dock, col 3) | Opened YouTube; it shows its signed-out "Get started" welcome screen |
| Paramount+ tile (row 2, col 4) | Opened; Get Started / Sign in screen (not signed in on this TV) |
| ESPN tile (row 2, col 1) | Opened to the ESPN home page |
| Launcher Inputs button | Popup lists HDMI 1, HDMI 2, HDMI 3/ARC only (no antenna or AV) |
| Remote Input key (KEYCODE_TV_INPUT) | Sony's input menu (com.sony.dtv.smartui) opens with Analog, Digital and HDMI 1–3 |

## Batch 3 (cleanyourtv VU1 SAFE items) — 2026-10-26 14:05:20

Undo whole batch: `sh backup/UNDO-batch3.sh`

| Time | Package | Result | Undo |
|---|---|---|---|
| 14:05:21 | `com.google.android.onetimeinitializer` | Package com.google.android.onetimeinitializer new state: disabled-user | `adb shell pm enable --user 0 com.google.android.onetimeinitializer` |
| 14:05:21 | `com.android.wallpaper.livepicker` | Package com.android.wallpaper.livepicker new state: disabled-user | `adb shell pm enable --user 0 com.android.wallpaper.livepicker` |
| 14:05:21 | `com.android.htmlviewer` | Package com.android.htmlviewer new state: disabled-user | `adb shell pm enable --user 0 com.android.htmlviewer` |
| 14:05:21 | `com.google.android.syncadapters.calendar` | Package com.google.android.syncadapters.calendar new state: disabled-user | `adb shell pm enable --user 0 com.google.android.syncadapters.calendar` |

## Screensaver — 2026-10-26 14:05:37

| Setting | Before | After | Undo |
|---|---|---|---|
| secure `screensaver_components` | com.google.android.backdrop/.Backdrop | com.android.dreams.basic/.Colors | `adb shell settings put secure screensaver_components com.google.android.backdrop/.Backdrop` |

Why: with Backdrop disabled (batch 2), the 15-min idle timeout had no screensaver to start, so the TV slept and dropped ADB. Colors keeps it awake and reachable, and sleep_timeout=-1 is unchanged.

## Mac-side toolchain for building the launcher — 2026-10-26 13:50

Changes this Mac, not the TV.
| Installed | How | Undo |
|---|---|---|
| JDK 17.0.21 | `brew install openjdk@17` | `brew uninstall openjdk@17` |
| Android command-line tools (sdkmanager) | `brew install --cask android-commandlinetools` (Android SDK license accepted via `sdkmanager --licenses`) | `brew uninstall --cask android-commandlinetools` |
| SDK platform 34, build-tools 34.0.0 | `sdkmanager "platforms;android-34" "build-tools;34.0.0"` | removed with the cask above |
| SDK platform-tools 37.0.1 | auto-installed into the SDK by the Gradle build | removed with the cask above (Homebrew's own `adb` is unaffected) |
| Gradle 8.9 (SHA-pinned) and AndroidX build deps | `./gradlew` download into `~/.gradle` | `rm -rf ~/.gradle` |

Repo: `../cleanyourtv` @ 76a9312 (remote verified as github.com/Gathin23/cleanyourtv). Only `./gradlew assembleRelease` was run; no repo script (build-and-install.sh, disable.sh, venv/pip) was run.

## YouTube — 2026-10-26 14:09

YouTube was signed out (welcome screen). On its sign-in screen I chose **Watch as guest**, with no account and no sign-in. Undo: none needed; sign in from YouTube's left menu → Sign in at any time.

## Tools added (Mac only, nothing installed on the TV)

- `scripts/tvlib.sh`: shared helpers. Every TV command is written to `logs/commands.log` with START/END timestamps.
- `scripts/monitor.sh`: live monitor. Prints each command with a timestamp and streams logcat only while that command runs.



## Apple TV style theme — 2026-10-26 14:48

`themes/appletv/` (config.json, plus wallpaper.jpg from cleanyourtv's MIT `glass` theme) was pushed with `scripts/theme-push.sh`, which follows cleanyourtv's tools/theme.sh but uses plain adb. Files were written through the launcher's ThemeProvider into /sdcard/Android/data/com.gathin.tvhome/files; that folder was empty before (`backup/theme-before.txt`).
Undo: `sh backup/UNDO-theme.sh` (`scripts/theme-push.sh --reset`: deletes the theme files, writes a new revision, restarts Home).

Look: glass base, cinematic top shelf, white focus, frosted dock of 5 (Netflix, YouTube, Apple TV, Prime Video, ESPN), 5 columns, icon-only header, no greeting. Screenshot: `backup/screens/home-appletv-theme.png`.

Frame cost (`dumpsys gfxinfo`, same 10-key sequence, 2 runs each):
| Variant | GPU median per frame | Janky frames |
|---|---|---|
| Built-in look | 13–14 ms | 11–42% (noisy) |
| Theme without cinematic shelf | 13 ms | 27–28% |
| Full theme (live now) | 19 ms | 33–34% |
The cinematic top shelf is what takes the GPU past the 16.7 ms frame budget; turning off advanced_effects and fade_rows did not help.

16:24: the owner chose to drop the shelf. `themes/appletv/config.json` now has `cinematic_home: false` (and `cinematic_white_focus` removed) and was re-pushed. Measured GPU median 13 ms (janky 14–46%, noisy), the same as the built-in look. Screenshot: `backup/screens/home-appletv-theme-noshelf.png`. Undo unchanged: `sh backup/UNDO-theme.sh`.


## Lock-screen Home (launcher fork) — 2026-10-26 16:30–16:46

The owner's reference was an iPhone-style lock screen: a big centred clock with the picture's subject in front of it, the date above, and one row of apps at the bottom.

**Fork:** branch `lock-screen` in `../cleanyourtv` (local only, not pushed), 5 commits on 76a9312:
| Commit | Change |
|---|---|
| 9986dcf | `lock_clock` theme key: centred date and large clock instead of the header clock. Theme file `wallpaper_front.png` (the picture's foreground on transparency) is drawn over the clock; ThemeProvider accepts the name |
| 251d3df | `lock_clock_top` (dp) and `lock_clock_size` (sp) theme keys, to fit the clock to each picture |
| a2264c6 | Clock pulled up to the date (Outfit's ascent gap) |
| f005538 | Clock block drawn in a hardware layer (see measurements) |
| ce671ff | A tile whose label is hidden gets the app name as its content description (TalkBack had nothing to read in a single row; the scripts use it too) |
All 274 launcher unit tests pass. Installed APK: `downloads/cleanyourtv/tvhome-3.0-lockscreen-ce671ffc.apk` (`adb install -r`, same debug key, so tile order and settings carried over). HOME still resolves to com.gathin.tvhome/.MainActivity.

**Theme:** `themes/lockscreen/`. The photo is cleanyourtv nature-calm 004, Lake Mystery NZ by Michal Klajban, CC BY-SA 4.0 (see its CREDITS.md). `scripts/sky-shift.swift` moved it down 80 px and continued the sky gradient upward. `scripts/depth-mask.swift` (threshold 0.06, inset 2) cut the mountain and lake out of the sky to make `wallpaper_front.png`. Config: `lock_clock`, top 24 dp, size 130 sp, single row of 8, no band/title/glow, icon-only buttons. Pushed with `scripts/theme-push.sh`, which now also pushes and resets `wallpaper_front.png`.

**Frame cost** (`dumpsys gfxinfo`, 8 key presses along the row):
| Variant | Janky | Frame median | GPU median |
|---|---|---|---|
| First build, full theme | 89–93% | 22–26 ms | 7 ms |
| Without front layer | 88% | 20 ms | 5 ms |
| RGB_565 wallpaper | 92% | 23 ms | 7 ms |
| advanced_effects off | 86% | 20 ms | 7 ms |
| lock_clock off | 3% | 7 ms | 12 ms |
| **Clock in a hardware layer (installed)** | **12–21%** | **8 ms** | **12–13 ms** |
The cost was redrawing the large shadowed digits every frame, not the extra image.

**Checks:** UP from the row reaches the Inputs button and its menu opens. `scripts/tvlib.sh` launcher_title falls back to the focused card's content-desc. Screenshot: `backup/screens/home-lockscreen-3.png`.

**Undo:** `sh backup/UNDO-lockscreen.sh` reinstalls the unmodified launcher (76a9312), re-pushes `themes/appletv` and sets Home. Launcher data is kept.

17:52: `themes/lockscreen` set to `columns: 6` (was 8) and re-pushed. Tiles are 229 px wide (was ~166) with a 47 px gap. Six fit on screen; ESPN and Media Player scroll in from the right. Screenshot: `backup/screens/home-lockscreen-6col.png`. Undo: set `columns` back to 8 and run `scripts/theme-push.sh themes/lockscreen`.

18:10: Lock-screen look dropped at the user's request. Ran `sh backup/UNDO-lockscreen.sh`: reinstalled the unmodified launcher build (tvhome-3.0-76a9312.apk), set it as Home and pushed `themes/appletv`. Screenshot: `backup/screens/home-reverted-appletv.png`. `themes/lockscreen` and the `lock-screen` fork branch are kept but unused. **Undo** (to get the lock screen back): `adb install -r downloads/cleanyourtv/tvhome-3.0-lockscreen-ce671ffc.apk && scripts/theme-push.sh themes/lockscreen`.

18:12: Correction to 18:10. The user wanted only the big clock gone, not the whole look. Reinstalled the fork (`downloads/cleanyourtv/tvhome-3.0-lockscreen-ce671ffc.apk`), set it as Home, set `"lock_clock": false` in `themes/lockscreen/config.json` and pushed it. Same wallpaper and 6-tile row; the launcher's normal small clock and date sit top-left. Screenshot: `backup/screens/home-lockscreen-noclock.png`. Undo: set `lock_clock` back to `true` and run `scripts/theme-push.sh themes/lockscreen`.

18:26: Rotating wallpapers on `themes/lockscreen`. The user's 13 pictures in `Images/` (all 1920×1080) were copied to `themes/lockscreen/wallpapers/` as JPGs with plain names (the one PNG converted), plus the lake photo, 14 in all (7.4 MB). `config.json` gained `"wallpaper_rotation_minutes": 2` and `"wallpaper_order": "shuffle"` (random pick each time, never the same picture twice in a row). The mountain cut-out `wallpaper_front.png` was moved to `backup/shelved/lockscreen-wallpaper_front.png`, since it would sit over every other picture. `scripts/theme-push.sh` now also syncs a theme's `wallpapers/` folder, replacing the collection on the TV as a whole (and `--reset` clears it). Undo: delete the two keys from `config.json` and run `scripts/theme-push.sh themes/lockscreen`; to remove the pictures too, delete `themes/lockscreen/wallpapers/` before pushing.

18:31: Smoother wallpaper changes. Fork commit 348b7118 (`../cleanyourtv`, branch `lock-screen`): `WallpaperPlayer` now fades the next picture in over the current one for 1.5 s instead of cutting. The fade runs on a second ImageView created on the first change; the first picture when Home opens still appears at once. 274 unit tests pass. Installed `downloads/cleanyourtv/tvhome-3.0-lockscreen-348b7118.apk` with `adb install -r` (launcher data kept) and set Home again. Undo: `adb install -r downloads/cleanyourtv/tvhome-3.0-lockscreen-ce671ffc.apk` (hard cut between pictures again), then `adb shell cmd package set-home-activity --user 0 com.gathin.tvhome/.MainActivity`.

18:34: Lake photo removed at the user's request. `themes/lockscreen/wallpapers/lake-mystery-nz.jpg` and the old single `wallpaper.jpg` (same lake) moved to `backup/shelved/`; `wallpaper.jpg` is now a copy of the aurora picture (only used if the rotation is off). 13 pictures rotate, all from the user's `Images/` folder. Undo: move `backup/shelved/lake-mystery-nz.jpg` back into `themes/lockscreen/wallpapers/` and push the theme.
