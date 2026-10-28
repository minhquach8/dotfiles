# Glow — Markdown Rendering
<!-- search: glow markdown renderer preview terminal dark theme pager README handbook -->

Glow renders Markdown directly in the terminal. It supports headings,
tables, lists, syntax-highlighted code blocks and terminal-friendly styling.

## Basic commands

| Command | Description |
| --- | --- |
| `glow --version` | Show the installed Glow version |
| `glow --help` | Show available options |
| `glow -s dark README.md` | Render a Markdown file with the dark theme |
| `glow -s dark -w 90 README.md` | Render Markdown with a width of 90 columns |
| `GLOW_PAGER=false PAGER=cat glow -s dark README.md` | Render without an interactive pager |

## Recommended non-interactive rendering

On this server, use the following pattern when you want Markdown to
remain visible in the current terminal rather than opening a pager.

~~bash
GLOW_PAGER=false PAGER=cat glow -s dark -w 90 README.md
~~

Here, `-s dark` selects the dark theme and `-w 90` sets the rendering width.

The environment variables apply only to this command.

## Render Markdown from standard input

Glow can also read Markdown from a pipeline.

~~bash
printf '# Hello from Glow\n\nThis is **Markdown**.\n' | GLOW_PAGER=false PAGER=cat glow -s dark -
~~

The final `-` tells Glow to read from standard input.

## Use Glow with the Midnight Research Handbook

The `guide` command combines fzf search with Glow rendering.

~~bash
guide
~~

The handbook uses Glow to render the selected topic or command.
fzf handles searching, while Glow handles the Markdown presentation.

## Troubleshooting

### Output disappears after rendering

Glow may open an interactive pager, depending on its invocation.

Use `GLOW_PAGER=false PAGER=cat` for non-interactive output.

### Unexpected input is displayed

When using Glow in a script, check whether standard input has been
redirected from a heredoc or pipeline.

If standard input contains script text, Glow may render that text
instead of the intended Markdown file.

### A command is missing from guide

The handbook searches documented topics, commands and shortcuts.
It does not automatically index every executable installed on the server.

Add the relevant command to a handbook Markdown topic, then reopen `guide`.
