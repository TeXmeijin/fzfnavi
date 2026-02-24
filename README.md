# rgz

Search across multiple git repositories with [ripgrep](https://github.com/BurntSushi/ripgrep), pick results with [fzf](https://github.com/junegunn/fzf), and open in [Zed](https://zed.dev) at the matching line.

## The Problem

When working in a workspace that contains multiple git repositories side by side, `rg` only respects the top-level `.gitignore`. Sub-repositories' `.gitignore` files are ignored, flooding results with `node_modules`, `vendor`, build artifacts, etc.

Using `--no-ignore-vcs` disables **all** `.gitignore` files, which isn't what you want either.

## How rgz solves it

`rgz` runs ripgrep **inside each sub-repository independently**, so each repo's own `.gitignore` is properly respected. Results are piped through `fzf` for interactive selection, then opened in Zed at the exact matching line.

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

## Requirements

- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fzf](https://github.com/junegunn/fzf)
- [Zed](https://zed.dev)
- zsh

## Installation

### Source directly

```bash
# Add to your .zshrc
source /path/to/rgz.zsh
```

### Copy to your zsh functions directory

```bash
cp rgz.zsh ~/.zsh/functions/rgz
# Make sure your .zshrc sources files from that directory
```

## Usage

```bash
# Basic search
rgz "pattern"

# With ripgrep options
rgz "pattern" -g '*.tsx'    # only .tsx files
rgz "TODO" -i               # case insensitive
rgz "className" -t js       # only JavaScript files

# fzf will show results with a preview pane
# Select one or more results (Tab to multi-select), press Enter
# Zed opens each file at the matching line
```

## License

MIT
