# Swiftlin code companions

The source of truth for Swiftlin's downloadable exercises and project starters/finals. The React website lives separately in [swiftlin](https://github.com/Rajib-Sarwar/swiftlin).

| Chapter | Exercises | Project |
| --- | --- | --- |
| [02 · Types, Values & Mutation](02-types-values-mutation/) | Existing starter/final playgrounds | Not published; existing placeholder folders retained |
| [03 · Protocols](03-protocols/) | Three starter/final playground pairs | Continues into chapter 04 |
| [04 · Protocols in Practice](04-protocols-practice/) | — | Checkout Engine: starter and final |
| [05 · Generics](05-generics/) | Three starter/final playground pairs | Checkout continuation: starter and final |
| [06 · Numerics & Ranges](06-numerics-ranges/) | Three playground pairs | Download Lab |
| [07 · Sequences & Collections](07-sequences-collections/) | Three playground pairs | Offline Library |
| [08 · Strings](08-strings/) | Three playground pairs | Search & Rename |
| [09 · Codable](09-codable/) | Three playground pairs | Library Sync |
| [10 · Unsafe](10-unsafe/) | Three playground pairs | Packet Lab |
| [11 · Higher-Order Functions](11-higher-order-functions/) | Three playground pairs | Inbox Lab |
| [12 · Functional Reactive Programming](12-functional-reactive-programming/) | Three state exercises + a Combine lab | Live Search Lab |

## Project downloads

| Project | Starter | Final |
| --- | --- | --- |
| Checkout Engine | [Download](downloads/04-protocols-practice-starter.zip) | [Download](downloads/04-protocols-practice-final.zip) |
| Generics continuation | [Download](downloads/05-generics-starter.zip) | [Download](downloads/05-generics-final.zip) |
| Inbox Lab | [Download](downloads/11-higher-order-functions-starter.zip) | [Download](downloads/11-higher-order-functions-final.zip) |
| Live Search Lab | [Download](downloads/12-functional-reactive-programming-starter.zip) | [Download](downloads/12-functional-reactive-programming-final.zip) |

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

All fixtures are synthetic. Projects are learning examples rather than production integrations.

## Objective-C Interoperability

[Legacy Notes Lab](13-objective-c-interoperability): typed legacy contracts, Swift snapshots, error translation, and calls in both directions. Includes three starter/final exercises, a mixed-language Xcode app, and 17 boundary checks. [Starter download](downloads/13-objective-c-interoperability-starter.zip) · [Final download](downloads/13-objective-c-interoperability-final.zip).

## Instrumentation

[Catalog Performance Lab](14-instrumentation) includes a preserved CPU baseline, a candidate to improve, image downsampling, callback lifetime checks, and signposted intervals. Three starter/final exercises and twelve deterministic tests accompany an unfilled profiling report. [Starter](downloads/14-instrumentation-starter.zip) · [Final](downloads/14-instrumentation-final.zip).
