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


function atuin-popup() {
  cp /dev/null /tmp/tmux-atuin
  tmux popup -d "${PWD}" -E "\$(atuin search $* -i -- $BUFFER 3>/tmp/tmux-atuin 1>&2 2>&3)" 
  LBUFFER="$(cat /tmp/tmux-atuin)"
}


if [[ -v TMUX ]]; then
  zle     -N   atuin-popup
  bindkey '^R' atuin-popup $LBUFFER
fi
