from __future__ import annotations

import struct
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE_DIR = ROOT / "addons" / "main"
PBO_PREFIX_FILE = SOURCE_DIR / "$PBOPREFIX$"
OUTPUT_PBO = ROOT / "@TRF_UKAF_ACE_Sleeves_Gloves" / "addons" / "trf_ukaf_ace_sleeves_gloves_main.pbo"
MOD_CPP = ROOT / "@TRF_UKAF_ACE_Sleeves_Gloves" / "mod.cpp"


def iter_source_files() -> list[tuple[str, bytes, int]]:
    files: list[tuple[str, bytes, int]] = []

    for path in sorted(SOURCE_DIR.rglob("*")):
        if not path.is_file() or path.name == "$PBOPREFIX$":
            continue

        relative_name = path.relative_to(SOURCE_DIR).as_posix().replace("/", "\\")
        files.append((relative_name, path.read_bytes(), int(path.stat().st_mtime)))

    return files


def write_pbo(output_path: Path, prefix: str, files: list[tuple[str, bytes, int]]) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)

    with output_path.open("wb") as handle:
        handle.write(b"\x00")
        handle.write(struct.pack("<IIIII", 0x56657273, 0, 0, 0, 0))
        handle.write(b"prefix\x00")
        handle.write(prefix.encode("utf-8") + b"\x00")
        handle.write(b"\x00")

        for relative_name, data, timestamp in files:
            handle.write(relative_name.encode("utf-8") + b"\x00")
            handle.write(struct.pack("<IIIII", 0, len(data), 0, timestamp, len(data)))

        handle.write(b"\x00")
        handle.write(struct.pack("<IIIII", 0, 0, 0, 0, 0))

        for _, data, _ in files:
            handle.write(data)


def ensure_mod_cpp() -> None:
    if MOD_CPP.exists():
        return

    MOD_CPP.parent.mkdir(parents=True, exist_ok=True)
    MOD_CPP.write_text(
        "\n".join(
            [
                'name = "[TRF] UKAF ACE Sleeves & Gloves";',
                'author = "OpenAI Codex";',
                'tooltip = "[TRF] UKAF ACE Sleeves & Gloves";',
                'tooltipOwned = "[TRF] UKAF ACE Sleeves & Gloves";',
                'overview = "ACE self-interaction addon for the [TRF] United Kingdom Armed Forces - Equipment Mod.";',
                'overviewText = "Adds ACE self-interactions for supported TRF UKAF uniforms so players can adjust sleeve and glove variants locally in game.";',
                'overviewFootnote = "Requires CBA_A3, ACE3, and [TRF] United Kingdom Armed Forces - Equipment Mod.";',
                "hideName = 0;",
                "hidePicture = 1;",
                "",
            ]
        ),
        encoding="utf-8",
    )


def main() -> None:
    prefix = PBO_PREFIX_FILE.read_text(encoding="ascii").strip()
    files = iter_source_files()
    ensure_mod_cpp()
    write_pbo(OUTPUT_PBO, prefix, files)

    print(f"Built {OUTPUT_PBO}")
    print(f"Packed {len(files)} files with prefix {prefix}")


if __name__ == "__main__":
    main()
