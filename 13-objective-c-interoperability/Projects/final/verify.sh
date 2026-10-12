#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
# Uses a disposable build directory; no package downloads or external services.
work_dir="$(mktemp -d "${TMPDIR:-/tmp}/swiftlin-interop.XXXXXX")"
sdk_path="$(xcrun --sdk macosx --show-sdk-path)"
source_dir="LegacyNotesLab/LegacyNotesLab"
optimization="-Onone"
if [[ "${1:-}" == "release" ]]; then optimization="-O"; fi
xcrun clang -fobjc-arc -isysroot "$sdk_path" -I "$source_dir" -c "$source_dir/SLNoteStore.m" -o "$work_dir/store.o"
xcrun swiftc -swift-version 6 "$optimization" -sdk "$sdk_path" -module-name LegacyNotesLab -import-objc-header "$source_dir/LegacyNotesLab-Bridging-Header.h" -emit-objc-header -emit-objc-header-path "$work_dir/LegacyNotesLab-Swift.h" -typecheck "$source_dir/NotesAdapter.swift"
xcrun clang -fobjc-arc -isysroot "$sdk_path" -I "$source_dir" -I "$work_dir" -c "$source_dir/SLLegacyPresenter.m" -o "$work_dir/presenter.o"
xcrun swiftc -swift-version 6 "$optimization" -sdk "$sdk_path" -module-name LegacyNotesLab -import-objc-header "$source_dir/LegacyNotesLab-Bridging-Header.h" "$source_dir/NotesAdapter.swift" Tests/main.swift "$work_dir/store.o" "$work_dir/presenter.o" -o "$work_dir/checks"
"$work_dir/checks"
printf 'Generated header and verification artifacts: %s\n' "$work_dir"
