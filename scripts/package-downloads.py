"""Rebuild project downloads from tracked source, excluding local build products."""
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
root = Path(__file__).resolve().parents[1]
out = root / 'downloads'
out.mkdir(exist_ok=True)
for chapter in ['04-protocols-practice', '05-generics', '06-numerics-ranges', '07-sequences-collections', '08-strings', '09-codable', '10-unsafe']:
    for variant in ['starter', 'final']:
        source = root / chapter / 'Projects' / variant
        with ZipFile(out / f'{chapter}-{variant}.zip', 'w', ZIP_DEFLATED) as archive:
            for path in sorted(source.rglob('*')):
                relative = path.relative_to(source)
                if any(part in {'.build', '.swiftpm', 'xcuserdata', 'DerivedData', '.DS_Store'} for part in relative.parts):
                    continue
                if path.is_file():
                    archive.write(path, Path(f'{chapter}-{variant}') / relative)
