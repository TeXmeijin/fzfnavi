# rgo

ripgrep + fzf + **open** — search across multi-repo workspaces, pick with fzf, and open in your editor at the matching line.

## The Problem

When working in a workspace that contains multiple git repositories side by side, `rg` only respects the top-level `.gitignore`. Sub-repositories' `.gitignore` files are ignored, flooding results with `node_modules`, `vendor`, build artifacts, etc.

Using `--no-ignore-vcs` disables **all** `.gitignore` files, which isn't what you want either.

## How rgo solves it

rgo runs ripgrep **inside each sub-repository independently**, so each repo's own `.gitignore` is properly respected. Results are piped through fzf for interactive selection, then opened in your editor at the exact matching line.

It also works inside a single repo — it auto-detects the workspace structure.

```
workspace/
├── repo-a/          # ← rg runs here (repo-a/.gitignore respected)
│   ├── .git/
│   ├── .gitignore
│   └── src/
├── repo-b/          # ← rg runs here (repo-b/.gitignore respected)
│   ├── .git/
│   ├── .gitignore
│   └── src/
└── notes.md         # ← also searched (top-level files)
```

## Included Commands

| Command | Editor | Open style |
|---------|--------|------------|
| `rgz`   | [Zed](https://zed.dev) | Each selected file opens at `file:line` |
| `rgv`   | [Neovim](https://neovim.io) | All selected files open in tabs (`nvim -p`) |

## Requirements

- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fzf](https://github.com/junegunn/fzf)
- [Zed](https://zed.dev) and/or [Neovim](https://neovim.io)
- zsh

## Installation

Source only the ones you need:

```bash
# Add to your .zshrc
source /path/to/rgo/rgz.zsh   # for Zed
source /path/to/rgo/rgv.zsh   # for Neovim
```

Or copy to your zsh functions directory:

```bash
cp rgz.zsh rgv.zsh ~/.zsh/functions/
```

## Usage

```bash
# Basic search
rgz "pattern"          # search → fzf → Zed
rgv "pattern"          # search → fzf → Neovim

# With ripgrep options (passed through as-is)
rgz "pattern" -g '*.tsx'    # only .tsx files
rgv "TODO" -i               # case insensitive
rgz "className" -t js       # only JavaScript files

# fzf controls
# - Enter: open selected
# - Tab: toggle multi-select (rgz/rgv both support multi-select)
# - Preview pane shows matches highlighted in context
```

## License

MIT
