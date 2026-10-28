#!/usr/bin/env python3
"""Build a searchable index of Midnight Research Handbook entries."""

from pathlib import Path
import re
import sys


REPOSITORY = Path(__file__).resolve().parent.parent
TOPICS = REPOSITORY / "handbook" / "topics"


def clean(text: str) -> str:
    """Normalise Markdown text for terminal search."""
    return " ".join(text.replace("`", "").split())


def emit(
    kind: str,
    label: str,
    description: str,
    section: str,
    source: Path,
    line_number: int,
) -> None:
    """Print one tab-separated record for fzf."""
    display = f"{kind:<8} {label}  —  {description}"

    print(
        "\t".join(
            (
                clean(display),
                clean(section),
                str(source),
                str(line_number),
                kind,
            )
        )
    )


def index_topic(source: Path) -> None:
    """Extract topics, commands and shortcuts from Markdown."""

    lines = source.read_text(encoding="utf-8").splitlines()

    if not lines:
        return

    title_match = re.match(r"^#\s+(.+)$", lines[0])

    if not title_match:
        return

    title = clean(title_match.group(1))

    keywords = ""
    if len(lines) > 1:
        match = re.match(
            r"^<!-- search:\s*(.*?)\s*-->$",
            lines[1],
        )
        if match:
            keywords = match.group(1)

    emit("TOPIC", title, keywords, title, source, 0)

    section = title
    inside_code = False
    fence_character = ""

    for line_number, raw_line in enumerate(lines, start=1):
        line = raw_line.strip()

        # Detect Markdown headings.
        heading = re.match(r"^#{2,6}\s+(.+)$", line)

        if heading and not inside_code:
            section = clean(heading.group(1))
            continue

        # Support both backtick and tilde code fences.
        fence = re.match(r"^(`{3,}|~{3,})", line)

        if fence:
            character = fence.group(1)[0]

            if not inside_code:
                inside_code = True
                fence_character = character
            elif character == fence_character:
                inside_code = False

            continue

        # Index individual shell commands from fenced blocks.
        if inside_code:
            if not line or line.startswith("#"):
                continue

            emit(
                "COMMAND",
                line,
                "Shell example",
                f"{title} / {section}",
                source,
                line_number,
            )
            continue

        # Extract Markdown table rows.
        if not (line.startswith("|") and line.endswith("|")):
            continue

        cells = [
            clean(cell)
            for cell in line.strip("|").split("|")
        ]

        if len(cells) < 2:
            continue

        label, description = cells[:2]

        if not label or not description:
            continue

        # Skip headers and separator rows.
        if label.lower() in {
            "command",
            "shortcut",
            "key",
            "tool",
        }:
            continue

        if re.fullmatch(r"[-:\s]+", label):
            continue

        # Distinguish keyboard shortcuts from commands.
        is_shortcut = bool(
            re.match(
                r"(?i)^(ctrl[+\s]|alt[+\s]|prefix\b|esc$)",
                label,
            )
        )

        kind = "SHORTCUT" if is_shortcut else "COMMAND"

        emit(
            kind,
            label,
            description,
            f"{title} / {section}",
            source,
            line_number,
        )


def main() -> int:
    """Index every Markdown topic without modifying any files."""

    if not TOPICS.is_dir():
        print("Handbook topics directory not found.", file=sys.stderr)
        return 1

    for source in sorted(TOPICS.glob("*.md")):
        if source.is_file() and not source.is_symlink():
            index_topic(source)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
