# cleanyourtv vs. this TV — 2026-10-26

Source: https://github.com/Gathin23/cleanyourtv @ 76a9312 (cloned read-only to ../cleanyourtv; nothing run).
Lists compared: examples/sony-bravia-vu1 (same model: BRAVIA_VU1_UC, Android TV 11, Realtek) and examples/sony-bravia-tl2 (Sony on Android TV 11, but a TPV/MediaTek platform).
TV state: compare/tv-enabled-now.txt (101 enabled) and compare/tv-disabled-now.txt (16 disabled).

Already disabled here and also in their VU1 list (10): demo, smarthelp, helpguidecontents, feedback, printspooler, camera2, gallery3d, videos, backdrop, tvrecommendations.
Still enabled here but disabled in their lists (12):

| Group | Package | Source |
|---|---|---|
| SAFE | com.google.android.onetimeinitializer | VU1 |
| SAFE | com.android.wallpaper.livepicker | VU1 |
| SAFE | com.android.htmlviewer | VU1 |
| SAFE | com.google.android.syncadapters.calendar | VU1 |
| ASK ME | com.google.android.tts | VU1 |
| ASK ME | com.google.android.partnersetup | VU1 |
| ASK ME | com.amazon.amazonvideo.livingroom | TL2 |
| NEVER | com.android.providers.calendar | VU1 (provider) |
| NEVER | com.google.android.katniss | VU1 (remote mic / voice) |
| NEVER | com.google.android.tungsten.setupwraith | VU1 (breaks casting after reboot) |
| NEVER | com.google.android.tvlauncher | VU1 (commented) + TL2 (launcher) |
