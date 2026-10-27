# Downloads

APKs aren't committed. Put them here at these paths so the undo scripts and docs line up, and check the SHA-256 before installing.

| File | Source | SHA-256 |
|---|---|---|
| `tvbro/tvbro-2.1.6-generic-geckoExcluded.apk` | [TV Bro v2.1.6 release](https://github.com/truefedex/tv-bro/releases/tag/v2.1.6) | `d8634edfe8d94b4fb9a52005d68a090a7f1e85b7f39c2cf01a25dc9dd60942b2` |
| `cleanyourtv/tvhome-3.0-76a9312.apk` | Built from [Gathin23/cleanyourtv](https://github.com/Gathin23/cleanyourtv) @ `76a9312` with `./gradlew assembleRelease` | `a7776fd9ab8c9e48b64fe55cdd21ac2e297a2e369dbe7721fd5dfcb798a3b003` |
| `cleanyourtv/tvhome-3.0-lockscreen-ce671ffc.apk` | Local `lock-screen` fork of cleanyourtv (big clock, depth effect) | `a7b1ab58850fbd0f1b80dc2d9ce3e6bf9bf719342c9efa3dfff969199632b4ec` |
| `cleanyourtv/tvhome-3.0-lockscreen-348b7118.apk` | Same fork plus wallpaper crossfade | `218297842024528ef1796bfa25c0100d282d665bdc9a56cef44ad10929dbbcae` |

Your own builds of cleanyourtv will have different hashes, because each debug signing key is unique.

```sh
shasum -a 256 downloads/*/*.apk
```
