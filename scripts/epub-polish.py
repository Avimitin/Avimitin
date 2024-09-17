import json
import shutil
import sys
import os
import subprocess
import tempfile


def find_tool(tool: str, help: str):
    if shutil.which(tool) is None:
        sys.exit(help)


find_tool("exiftool", "exiftool not install")
find_tool("ebook-polish", "calibre not install")

EPUB_FILES = []

for root, dirs, files in os.walk("."):
    for file in files:
        if file.endswith(".epub"):
            EPUB_FILES.append(os.path.join(root, file))

METADATA_RAW = subprocess.check_output(
    ["exiftool", "-j", "-Title", "-Creator", "-Series"] + EPUB_FILES,
)

ROOT_DIR = tempfile.mkdtemp(prefix="batch-epub-rename-result-")

EPUB_DATA = json.loads(METADATA_RAW)
for item in EPUB_DATA:
    source_file = item["SourceFile"]
    title = item["Title"]
    series = item.get("Series")
    creator = item.get("Creator")

    dir_name = ""
    if series is not None:
        dir_name += series
    else:
        dir_name += title

    if creator is not None:
        dir_name += f"-{creator}"

    series_dir = os.path.join(ROOT_DIR, dir_name)
    os.makedirs(series_dir, exist_ok=True)
    final_output_path = os.path.join(series_dir, f"{title}.epub")
    subprocess.check_call(
        [
            "ebook-polish",
            "--embed-fonts",
            "--subset-fonts",
            "--smarten-punctuation",
            "--add-soft-hyphens",
            source_file,
            final_output_path,
        ]
    )

    print(f"  > {final_output_path} Polished")

print(f">> Output store in {ROOT_DIR}")
