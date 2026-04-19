# rumdl Plugin

Markdown linting and formatting for Claude Code, powered by [rumdl](https://github.com/rvben/rumdl).

Provides:

- **LSP server** — live diagnostics in supported editors via `rumdl server --stdio`
- **PostToolUse hook** — runs `rumdl fmt` on every `.md` file after `Write` or `Edit`
- **`markdown` skill** — Markdown coding standard (naming, formatting, linting rules)

## Prerequisites

Install the `rumdl` binary on your `PATH`:

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/rvben/rumdl/main/install.sh | sh

# or via cargo
cargo install rumdl

# or via uv / pipx (Python distribution)
uv tool install rumdl
```

Verify:

```bash
rumdl --version
```

The hook silently no-ops if `rumdl` is not on `PATH`, so missing binary never breaks edits.

## Install

```bash
claude plugin marketplace add cjhowe-us/workflow
claude plugin install rumdl@cjhowe-us-workflow
```

## Configuration

Each project that uses this plugin should have a `.rumdl.toml` at its repo root. Example:

```toml
[global]
exclude = [".git", ".github", "build", "node_modules", "vendor"]
flavor = "gfm"

[MD013]
code-blocks = true
headings = true
line-length = 100
paragraphs = true
reflow = true
reflow-mode = "normalize"
strict = false
tables = false

[MD033]
allowed-elements = ["br"]
```

The LSP server loads this config via `--config .rumdl.toml`. The hook runs `rumdl fmt <file>`, which
also reads `.rumdl.toml` from the file's parent tree.

## How the hook works

After any `Write` or `Edit` tool call, Claude Code runs `hooks/rumdl-fmt.sh`:

1. Reads the `tool_input.file_path` from stdin JSON
2. Skips anything that is not `*.md`
3. Skips if `rumdl` is not installed
4. Runs `rumdl fmt <file>` — on non-zero exit, forwards output back to Claude so the model sees the
   error and can react

This means every Markdown file Claude writes is normalized to the project's rumdl style as soon as
the write completes.

## Skill

The `markdown` skill documents the coding standard the formatter enforces: line length, GFM flavor,
heading case, naming conventions, ID references, Mermaid-only diagrams, anti-patterns. Claude loads
it automatically whenever it reads, writes, or reviews `.md` files.

## License

Apache-2.0
