# fzf shortcuts
if [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ]]; then

  # source fzf if it's installed
  export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

  # fe [FUZZY PATTERN] - Open the selected file with the default editor
  #   - Bypass fuzzy finder if there's only one match (--select-1)
  #   - Exit if there's no match (--exit-0)
  function fe() {
    IFS='
    '
    local declare files=($(fzf-tmux --query="$1" --select-1 --exit-0))
    [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
    unset IFS
  }

  function sn() {
    local file="$HOME/.snippets"
    sed -e '/^#/d' -e '/^$/d' $file | fzf-tmux | cut -d '!' -f 2 | ccopy
  }

  # Modified version of fe() where you can press
  #   - CTRL-O to open with `xdg-open` command,
  #   - CTRL-E or Enter key to open with the $EDITOR
  function fo() {
    local out file key
    out=$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)
    key=$(head -1 <<< "$out")
    file=$(head -2 <<< "$out" | tail -1)
    if [ -n "$file" ]; then
      [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
    fi
  }

  # cdf - cd into the directory of the selected file
  function cdf() {
    local file
    local dir
    file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
  }

  # fkill - kill process
  function fkill() {
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    if [ "x$pid" != "x" ]; then
      echo $pid | xargs kill -${1:-9}
    fi
  }

  # fcoc - checkout git commit
  function fco() {
    local commits commit
    commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
      commit=$(echo "$commits" | fzf --tac +s +m -e) &&
      git checkout $(echo "$commit" | sed "s/ .*//")
  }

  # fshow - git commit browser
  function fshow() {
    git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
    (grep -o '[a-f0-9]\{7\}' | head -1 |
    xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
    {}
    FZF-EOF"
  }

  # fcs - get git commit sha
  # example usage: git rebase -i `fcs`
  function fcs() {
    local commits commit
    commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
      commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
      echo -n $(echo "$commit" | sed "s/ .*//")
  }

  # ftpane - switch pane (@george-b)
  function ftpane() {
    local panes current_window current_pane target target_window target_pane
    panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
    current_pane=$(tmux display-message -p '#I:#P')
    current_window=$(tmux display-message -p '#I')

    target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse) || return

    target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
    target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

    if [[ $current_window -eq $target_window ]]; then
      tmux select-pane -t ${target_window}.${target_pane}
    else
      tmux select-pane -t ${target_window}.${target_pane} &&
	tmux select-window -t $target_window
    fi
  }

  # v - open files in ~/.viminfo
  function v() {
    local files
    files=$(grep '^>' ~/.viminfo | cut -c3- |
    while read line; do
      [ -f "${line/\~/$HOME}" ] && echo "$line"
    done | fzf-tmux -d -m -q "$*" -1) && vim ${files//\~/$HOME}
  }

fi
