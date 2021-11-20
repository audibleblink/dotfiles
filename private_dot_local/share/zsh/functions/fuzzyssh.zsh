function get-ssh() {
  # read the selected Host entry
  IFS=: read host <<< $(grep '^Host' ${HOME}/.ssh/config | sed 's/Host //'| fzf)
  # set the local buffer to the new command
  LBUFFER="${LBUFFER} ${host}"
  local ret=$?
  zle reset-prompt
  return $ret
}

zle     -N   get-ssh
bindkey '^S' get-ssh
