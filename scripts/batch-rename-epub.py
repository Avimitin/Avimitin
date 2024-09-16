import json
import shutil
import sys
import os
import subprocess
import tempfile


def find_tool(tool):
    if shutil.which(tool) is None:
        sys.exit(f"{tool} not found")


find_tool("exiftool")

epub_files = []

for root, dirs, files in os.walk("."):
    for file in files:
        if file.endswith(".epub"):
            epub_files.append(os.path.join(root, file))

result = subprocess.run(
    ["exiftool", "-j", "-Title", "-Creator", "-Series"] + epub_files,
    capture_output=True,
    text=True,
    check=True,
)

ROOT_DIR = tempfile.mkdtemp(prefix="batch-epub-rename-result-")

data = json.loads(result.stdout.strip())
for item in data:
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

    os.makedirs(f"{ROOT_DIR}/{dir_name}", exist_ok=True)
    shutil.copyfile(source_file, f"{ROOT_DIR}/{dir_name}/{title}.epub")
    print(f"  > cp {source_file} to '{ROOT_DIR}/{dir_name}/{title}.epub'")

print(f">> Output store in {ROOT_DIR}")
