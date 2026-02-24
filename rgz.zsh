# rgz - ripgrep + fzf + zed
# Search across sub-repositories (respecting each repo's .gitignore), pick with fzf, open in Zed at the matching line.
# Usage: rgz "pattern" [rg options...]
rgz() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: rgz <pattern> [rg options...]"
    return 1
  fi

  local results=()

  # Search in sub-repos (directories with their own .git) — output file:line
  for d in */; do
    [[ -d "$d/.git" ]] && results+=(${(f)"$(rg -n "$@" "$d" 2>/dev/null | awk -F: '{print $1":"$2}' | sort -t: -k1,1 -u)"})
  done

  # Also search current directory's own files (depth 1)
  results+=(${(f)"$(rg -n --max-depth 1 "$@" 2>/dev/null | awk -F: '{print $1":"$2}' | sort -t: -k1,1 -u)"})

  if [[ ${#results[@]} -eq 0 ]]; then
    echo "No matches found."
    return 1
  fi

  local selected
  selected=$(printf '%s\n' "${results[@]}" | fzf --multi \
    --delimiter=: \
    --preview="rg -n --color=always ${(q)1} {1}" \
    --preview-window=right:60%)

  # Open each selected file:line in Zed
  if [[ -n "$selected" ]]; then
    echo "$selected" | while read -r item; do
      zed "$item"
    done
  fi
}
