#!/usr/bin/env bash
set -euo pipefail

# MIDNIGHT RESEARCH / HANDBOOK UNIFIED SEARCH
# Search topics, commands and shortcuts without executing them.

script_path="$(readlink -f -- "${BASH_SOURCE[0]}")"
repo="$(cd -- "$(dirname -- "$script_path")/.." && pwd -P)"

topics="$repo/handbook/topics"
indexer="$repo/scripts/handbook-index.py"

# -------------------------------------------------
# Markdown renderer
# -------------------------------------------------

render_entry() {
    local source="$1"
    local selected_line="$2"
    local entry_type="$3"

    local resolved
    resolved="$(readlink -f -- "$source")"

    # Only render handbook Markdown files.
    case "$resolved" in
        "$topics/"*.md) ;;
        *)
            echo "Invalid handbook source." >&2
            return 1
            ;;
    esac

    if [[ ! "$selected_line" =~ ^[0-9]+$ ]]; then
        echo "Invalid source line." >&2
        return 1
    fi

    case "$entry_type" in
        TOPIC|COMMAND|SHORTCUT) ;;
        *)
            echo "Invalid entry type." >&2
            return 1
            ;;
    esac

    local width="${FZF_PREVIEW_COLUMNS:-${COLUMNS:-100}}"

    if [[ ! "$width" =~ ^[0-9]+$ ]]; then
        width=100
    fi

    if (( width < 40 )); then
        width=40
    fi

    # Extract relevant Markdown, then render without a pager.
    python3 - "$resolved" "$selected_line" "$entry_type" <<'PYTHON_RENDER' |
import re
import sys
from pathlib import Path

source = Path(sys.argv[1])
selected_line = int(sys.argv[2])
entry_type = sys.argv[3]

lines = source.read_text(encoding="utf-8").splitlines()

if not lines:
    sys.exit(0)

# Preserve original line numbers before removing metadata.
title = lines[0].removeprefix("# ").strip()

if entry_type == "TOPIC":
    content = [
        line for line in lines
        if not line.startswith("<!-- search:")
    ]
    print("\n".join(content))
    sys.exit(0)

selected_index = selected_line - 1

if not 0 <= selected_index < len(lines):
    print("Selected entry is no longer available.")
    sys.exit(1)

# Locate the nearest enclosing Markdown section.
heading_pattern = re.compile(r"^(#{2,6})\s+(.+)$")

section_start = 0
section_level = 1
section_title = title

for index in range(selected_index + 1):
    match = heading_pattern.match(lines[index])

    if match:
        section_start = index
        section_level = len(match.group(1))
        section_title = match.group(2)

section_end = len(lines)

for index in range(section_start + 1, len(lines)):
    match = heading_pattern.match(lines[index])

    if match and len(match.group(1)) <= section_level:
        section_end = index
        break

# Display the topic and relevant section.
print(f"# {title}")

if section_start > 0:
    print(f"\n## {section_title}\n")

selected_text = lines[selected_index].strip()

# -------------------------------------------------
# Markdown table entries
# -------------------------------------------------

if selected_text.startswith("|"):
    table_start = selected_index

    while (
        table_start > section_start
        and lines[table_start - 1].strip().startswith("|")
    ):
        table_start -= 1

    table_end = selected_index + 1

    while (
        table_end < section_end
        and lines[table_end].strip().startswith("|")
    ):
        table_end += 1

    table_lines = lines[table_start:table_end]

    # Preserve table headers and show the selected entry.
    if len(table_lines) >= 3:
        print(table_lines[0])
        print(table_lines[1])
        print(lines[selected_index])
    else:
        print("\n".join(table_lines))

    sys.exit(0)

# -------------------------------------------------
# Shell examples inside fenced code blocks
# -------------------------------------------------

inside_fence = False

for index in range(section_start, selected_index):
    text = lines[index].strip()

    if re.match(r"^(`{3,}|~{3,})", text):
        inside_fence = not inside_fence

if inside_fence:
    print("~~~bash")
    print(lines[selected_index])
    print("~~~")
    sys.exit(0)

# -------------------------------------------------
# Fallback: render the containing section
# -------------------------------------------------

content = [
    line for line in lines[section_start:section_end]
    if not line.startswith("<!-- search:")
]

print("\n".join(content))
PYTHON_RENDER
    GLOW_PAGER=false PAGER=cat \
        glow -s dark -w "$width" -
}

# -------------------------------------------------
# Preview mode (called by fzf)
# -------------------------------------------------

if [[ "${1:-}" == "--render" ]]; then
    if [[ $# -ne 4 ]]; then
        echo "Invalid renderer arguments." >&2
        exit 2
    fi

    render_entry "$2" "$3" "$4"
    exit 0
fi

# -------------------------------------------------
# Dependencies
# -------------------------------------------------

for tool in python3 fzf glow; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "Missing dependency: $tool" >&2
        exit 1
    fi
done

if [[ ! -f "$indexer" ]]; then
    echo "Command indexer not found." >&2
    exit 1
fi

# -------------------------------------------------
# Midnight Research colours
# -------------------------------------------------

colours='bg:#0B1220,bg+:#172337,fg:#DCE6F2,fg+:#E6EEF8'
colours+=',hl:#76C7D4,hl+:#B4A7F5'
colours+=',info:#8295AD,prompt:#76C7D4'
colours+=',pointer:#B4A7F5,marker:#9ECEA6,border:#29384D'

# Build the search catalogue dynamically.
catalogue="$(python3 "$indexer")"

if [[ -z "$catalogue" ]]; then
    echo "No handbook entries found."
    exit 1
fi

# Allow the preview process to locate this launcher.
export HANDBOOK_LAUNCHER="$script_path"

# -------------------------------------------------
# Unified search interface
# -------------------------------------------------

if selected="$(
    printf '%s\n' "$catalogue" |
        fzf \
            --height=90% \
            --layout=reverse \
            --border=rounded \
            --border-label=' MIDNIGHT RESEARCH / HANDBOOK ' \
            --prompt='Search > ' \
            --delimiter=$'\t' \
            --with-nth=1,2 \
            --nth=1,2 \
            --color="$colours" \
            --preview='bash "$HANDBOOK_LAUNCHER" --render {3} {4} {5}' \
            --preview-window='right,55%,wrap,<72(down,55%,border-top)' \
            --bind='ctrl-o:toggle-preview' \
            --bind='ctrl-g:change-preview-window(right,55%|down,55%)' \
            --header='ENTER: Read | ESC: Quit | Ctrl+O: Preview | Ctrl+G: Layout'
)"; then

    IFS=$'\t' read -r display section source line entry_type \
        <<< "$selected"

    printf '\n'

    render_entry "$source" "$line" "$entry_type"
fi
