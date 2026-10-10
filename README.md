# Swiftlin code companions

The source of truth for Swiftlin's downloadable exercises and project starters/finals. The React website lives separately in [swiftlin](https://github.com/Rajib-Sarwar/swiftlin).

| Chapter | Exercises | Project |
| --- | --- | --- |
| [02 · Types, Values & Mutation](02-types-values-mutation/) | Existing starter/final playgrounds | Not published; existing placeholder folders retained |
| [03 · Protocols](03-protocols/) | Three starter/final playground pairs | Continues into chapter 04 |
| [04 · Protocols in Practice](04-protocols-practice/) | — | Checkout Engine: starter and final |
| [05 · Generics](05-generics/) | Three starter/final playground pairs | Checkout continuation: starter and final |

## Project downloads

| Project | Starter | Final |
| --- | --- | --- |
| Checkout Engine | [Download](downloads/04-protocols-practice-starter.zip) | [Download](downloads/04-protocols-practice-final.zip) |
| Generics continuation | [Download](downloads/05-generics-starter.zip) | [Download](downloads/05-generics-final.zip) |

On GitHub, open the archive and choose Download raw file. Or clone/download this repository and navigate to the chapter. Each project README explains setup, milestones, and verification.

## Structure and maintenance

- Keep projects under `<chapter>/Projects/starter` and `<chapter>/Projects/final`.
- Keep short coding exercises under `<chapter>/Exercises`.
- Starter projects build but leave the learning work unfinished. Finals are working references.
- Keep shared support types consistent with the published lesson and browser exercises.
- Preserve existing chapter paths so published links continue to work.
- Run the final project's `swift test` on macOS and build each app with Xcode before publishing.
- Run `python3 scripts/package-downloads.py` after changing project source; commit the matching archives too.
- Website download links should point here. Do not maintain a separate website-only project archive.
- Do not include DerivedData, build caches, personal signing teams, user workspace state, credentials, or real payment data.
- Screenshot placeholders must be explicitly labeled and accompanied by `SCREENSHOT TODO` comments. Replace them with actual captures when ready.

The current projects contain simulated payments and follow the license included with each project.
