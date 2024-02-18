# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search
  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# Filter through multiple ssh config files and hosts
function get-ssh() {
  # read the selected Host entry
  IFS=: read host <<< $(grep '^Host [^*]' ${HOME}/.ssh/*config | sed 's/:Host//' | tr -d '"'| fzf)
  # set the local buffer to the new command
  LBUFFER="${LBUFFER} -F ${host}"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   get-ssh
bindkey '^S' get-ssh

# Creates a new tmux window with a floating terminal
function floats() {
  tmux popup -E 
}
zle     -N   floats
bindkey '^[i' floats

