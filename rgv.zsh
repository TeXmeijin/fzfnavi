# rgv - ripgrep + fzf + nvim
# Search across sub-repositories (respecting each repo's .gitignore), pick with fzf, open in nvim tabs at the matching line.
# Works both in multi-repo workspaces and inside a single repo.
# Usage: rgv "pattern" [rg options...]
rgv() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: rgv <pattern> [rg options...]"
    return 1
  fi

  local results=()
  local has_subrepos=false

  # Search in sub-repos (directories with their own .git)
  for d in */; do
    if [[ -d "$d/.git" ]]; then
      has_subrepos=true
      results+=(${(f)"$(rg -n "$@" "$d" 2>/dev/null | awk -F: '{print $1":"$2}' | sort -t: -k1,1 -u)"})
    fi
  done

  if $has_subrepos; then
    # Also search current directory's own files (depth 1)
    results+=(${(f)"$(rg -n --max-depth 1 "$@" 2>/dev/null | awk -F: '{print $1":"$2}' | sort -t: -k1,1 -u)"})
  else
    # Single repo — just run rg normally
    results+=(${(f)"$(rg -n "$@" 2>/dev/null | awk -F: '{print $1":"$2}' | sort -t: -k1,1 -u)"})
  fi

  if [[ ${#results[@]} -eq 0 ]]; then
    echo "No matches found."
    return 1
  fi

  local selected
  selected=$(printf '%s\n' "${results[@]}" | fzf --multi \
    --delimiter=: \
    --preview="rg -n --color=always ${(q)1} {1}" \
    --preview-window=right:60%)

  if [[ -n "$selected" ]]; then
    local files=()
    local first_line=""

    while read -r item; do
      local file="${item%%:*}"
      local line="${item##*:}"
      files+=("$file")
      [[ -z "$first_line" ]] && first_line="$line"
    done <<< "$selected"

    # Open all files in tabs, jump to first file's matching line
    nvim -p "${files[@]}" "+${first_line}"
  fi
}
