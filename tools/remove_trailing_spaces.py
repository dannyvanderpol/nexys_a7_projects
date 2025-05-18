"""
Remove trailing spacces on the files given on the command line.

To add as git pre commit hook:

cd .git/hooks
create file: pre-commit

add the lines:
---
#!/bin/sh
FILES=$(git diff --cached --name-only --diff-filter=ACMR)

if [ -n "$FILES" ]; then
    python tools/remove_trailing_spaces.py $FILES > .git/hooks/pre-commit.log 2>&1
    git add $FILES >> .git/hooks/pre-commit.log 2>&1
fi

if [ $? -ne 0 ]; then
    echo "Pre-commit check failed!"
    exit 1
fi
---

Make it executable: chmod +x pre-commit

"""

import sys

for filename in sys.argv[1:]:
    print(f"Remove trailing spaces in file: {filename}")
    with open(filename, "r") as f:
        lines = f.readlines()
    for i in range(len(lines)):
        lines[i] = lines[i].rstrip() + "\n"
    with open(filename, "w") as f:
        f.writelines(lines)
