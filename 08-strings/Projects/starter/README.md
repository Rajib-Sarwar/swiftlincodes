# Search & Rename — starter

Continue Offline Library with multilingual search, title previews, and renaming. Open `LibrarySearch/LibrarySearch.xcodeproj` in Xcode 27 or newer and choose an iOS simulator. No external package or network is required.

The starter compiles but preview, title validation, and matching contain TODOs. Tests intentionally fail until these are implemented. The palindrome and frequency helpers are supplied from the exercises.

## Milestones
1. Implement titlePreview with an ellipsis included inside its Character budget.
2. Implement validateTitle: reject whitespace-only input, over 30 Characters, then over 60 UTF-8 bytes. Preserve original text on save.
3. Implement titleMatch with explicit locale and case/diacritic-insensitive options. Return indices in the original title; empty query returns nil and the caller shows all items.
4. Run `swift test` from this folder. Check composed/decomposed accents, family emoji, exact palindrome policy, source-order uniqueness, and UTF-16 range conversion.
5. Run the simulator: search cafe, rename a selected title, cancel another edit, try an invalid byte-heavy title, and compare Lesson 2/Lesson 11 ordering. The locale picker makes search/sort policy explicit.

LibraryCore.swift continues the previous chapter's model helpers. Video.title is now mutable for renaming. This is a focused next-stage screen, not a production media player or persisted library. Original title spelling is retained. Highlighting uses the returned original range. Changing text invalidates the usefulness of old ranges; recompute them.

<!-- SCREENSHOT TODO: Capture cafe matching Café/Café while preserving accents, then the rename field rejecting a three-family-emoji title by byte budget. -->
> Screenshot placeholder: genuine simulator captures will be inserted here.

Highlighting detail: an accent-insensitive match can exclude a combining mark. Expand the original match using NSString.rangeOfComposedCharacterSequences(for:), then convert that UTF-16 range back with Range(_:in:) before highlighting.
