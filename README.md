# fzfnavi

Navigate your codebase with fzf. Search files, content, and git history across multi-repo workspaces — pick with fzf, open in your editor at the matching line.

## Commands

### `rgz` / `rgv` — Search by content (ripgrep)

Search file contents across repositories, pick with fzf, open at the matching line.

```bash
rgz "pattern"              # search → fzf → Zed (at matching line)
rgv "pattern"              # search → fzf → Neovim (tabs, at matching line)

rgz "TODO" -i              # case insensitive
rgz "pattern" -g '*.tsx'   # only .tsx files
rgv "className" -t js      # only JavaScript files
```

**Multi-repo aware**: In a workspace with multiple git repos side by side, `rg` ignores sub-repositories' `.gitignore` files. `rgz`/`rgv` run ripgrep inside each sub-repo independently, so each repo's own `.gitignore` is properly respected.

```
workspace/
├── repo-a/       # ← searched independently (.gitignore respected)
├── repo-b/       # ← searched independently (.gitignore respected)
└── notes.md      # ← also searched
```

### `fdz` / `fdv` — Search by filename (fd)

Search filenames across repositories, pick with fzf, open in your editor.

```bash
fdz                        # all files → fzf → Zed
fdv                        # all files → fzf → Neovim (tabs)

fdz tsx                    # only filenames matching "tsx"
fdz -e tsx                 # only .tsx extension
fdz component -e tsx       # filenames matching "component" with .tsx extension
```

**Multi-repo aware**: Same as `rgz`/`rgv` — runs `fd` inside each sub-repo independently so each repo's `.gitignore` is respected. Solves the problem where plain `fd` skips sub-repositories due to `.git/info/exclude` or nested `.git` directories.

### `glz` / `glv` — Browse by git log

Browse recent commits, select changed files, and open them in your editor.

```bash
glz                        # commits → files → Zed
glv                        # commits → files → Neovim (tabs)
```

**Flow:**

1. Recent 20 commits are shown (plus a "branch diff" option at the top)
2. Select one or more commits with `Tab`, or pick the branch option to get all changes since the base branch
3. Changed files from those commits are shown
4. Select files with `Tab` (or `Ctrl-A` to select all)
5. `Enter` to open in your editor

The base branch (`main`, `master`, or `develop`) is auto-detected.

## Summary

| Command | Source  | Editor | Open style |
|---------|---------|--------|------------|
| `rgz`   | ripgrep | Zed    | Each file at `file:line` |
| `rgv`   | ripgrep | Neovim | All files in tabs |
| `fdz`   | fd      | Zed    | Each file |
| `fdv`   | fd      | Neovim | All files in tabs |
| `glz`   | git log | Zed    | All files |
| `glv`   | git log | Neovim | All files in tabs |

## Requirements

- [fzf](https://github.com/junegunn/fzf)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (for `rgz`/`rgv`)
- [fd](https://github.com/sharkdp/fd) (for `fdz`/`fdv`)
- [Zed](https://zed.dev) and/or [Neovim](https://neovim.io)
- zsh
- [bat](https://github.com/sharkdp/bat) (optional, for file preview in `fdz`/`fdv`/`glz`/`glv`)

## Installation

Source only the ones you need:

```bash
# Add to your .zshrc
source /path/to/fzfnavi/rgz.zsh   # ripgrep → Zed
source /path/to/fzfnavi/rgv.zsh   # ripgrep → Neovim
source /path/to/fzfnavi/fdz.zsh   # fd → Zed
source /path/to/fzfnavi/fdv.zsh   # fd → Neovim
source /path/to/fzfnavi/glz.zsh   # git log → Zed (also provides glv's dependency)
source /path/to/fzfnavi/glv.zsh   # git log → Neovim
```

Or copy to your zsh functions directory:

```bash
cp *.zsh ~/.zsh/functions/
```

> **Note:** `glv.zsh` depends on `_gl_select_files` defined in `glz.zsh`. Make sure `glz.zsh` is loaded first.

## fzf Controls

| Key     | Action |
|---------|--------|
| `Enter` | Confirm selection |
| `Tab`   | Toggle multi-select |
| `Ctrl-A`| Select all (in file selection) |

## License

MIT
