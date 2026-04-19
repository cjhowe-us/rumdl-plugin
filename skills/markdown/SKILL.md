---
name: markdown
description: >
  Markdown coding standard for the Harmonius project. Use this skill
  whenever reading, writing, editing, reviewing, or creating any `.md`
  file. Also use when discussing documentation formatting, rumdl linting,
  Mermaid diagrams, or Markdown style rules. Trigger on any interaction
  with Markdown files — even quick prose edits must follow this standard.
---

# Markdown Coding Standard

## Scope

All documentation in the Harmonius project. Markdown files are linted and formatted by rumdl with
GFM (GitHub Flavored Markdown) flavor.

## Naming Conventions

| Element      | Convention          | Example              |
| ------------ | ------------------- | -------------------- |
| File name    | `kebab-case.md`     | `core-rendering.md`  |
| Heading      | Sentence case       | `## API design`      |
| ID reference | `X-N.N.N` format    | `R-1.2.3`, `F-4.5.6` |
| Test case ID | `TC-X.Y.Z.N` format | `TC-1.2.3.1`         |

## File Organization

- All docs in `docs/` directory tree
- Group by domain and subdomain
- One topic per file; split large topics
- README.md at each directory level for navigation

## Formatting Rules

- 120-character line limit (tables exempt)
- GFM flavor (GitHub Flavored Markdown)
- Mermaid diagrams only — no ASCII art
- Paragraphs under 5 sentences and 50 words
- Single blank line between sections
- No trailing whitespace

## Linting Rules

- rumdl enforces all formatting rules
- Configuration in `.rumdl.toml`
- Code blocks exempt from line length
- Tables exempt from line length

## Type Checking

Not applicable for Markdown.

## How to Check and Fix

| Validation | Check command | Fix command |
| ---------- | ------------ | ----------- |
| Lint + Format | `rumdl check .` | `rumdl fmt .` |

## Project-Specific Rules

1. **Mermaid only** — never create ASCII diagrams; always render with MCP to verify
2. **Structured prose** — use headings, lists, tables; minimize long paragraphs
3. **ID references** — use specific IDs (R-X.Y.Z, F-X.Y.Z, US-X.Y.Z, TC-X.Y.Z.N); never "see
   requirements" or "as specified"
4. **rumdl fmt** — use exclusively for line length fixes; do not manually rewrap

## Cache-Friendly Patterns

Not applicable for Markdown.

## Testing

1. **CI validation** — `.github/workflows/markdown.yml` runs `rumdl check` on every push and PR
2. **Auto-fix** — CI runs `rumdl fmt` and commits fixes when violations are found
3. **Mermaid rendering** — verify all diagrams render correctly via MCP

## Best Practices

1. Start every document with a level-1 heading
2. Use tables for structured data and comparisons
3. Use numbered lists for sequences and priorities
4. Use bulleted lists for unordered items
5. Use code blocks with language tags for examples
6. Cross-reference other docs with relative links
7. Keep headings hierarchical (no skipping levels)
8. Use bold for emphasis, not ALL CAPS
9. One sentence per line for clean diffs
10. End files with a single newline

## Anti-Patterns

1. **ASCII art** — use Mermaid diagrams
2. **Long paragraphs** — split at 5 sentences / 50 words
3. **Vague references** — always use specific IDs
4. **Manual line wrapping** — let rumdl handle it
5. **Deeply nested lists** — flatten to 2 levels max
6. **Inline HTML** — use standard Markdown syntax
7. **Broken links** — verify all relative paths
8. **Missing headings** — every section needs a heading
9. **Inconsistent heading levels** — maintain hierarchy
10. **Trailing whitespace** — remove all trailing spaces
