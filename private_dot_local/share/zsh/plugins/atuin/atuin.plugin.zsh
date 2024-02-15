# atuin-popup spawns atuin in a tmux floating window and writes selected item to a file
# the LBUFFER then gets set to the contects of that file.
function atuin-popup() {
  cp /dev/null /tmp/tmux-atuin
  tmux popup -d "${PWD}" -E "\$(atuin search $* -i -- $BUFFER 3>/tmp/tmux-atuin 1>&2 2>&3)" 
  LBUFFER="$(cat /tmp/tmux-atuin)"
}

# bind ^R only if we're in a tmux terminal
if [[ -v TMUX ]]; then
  zle     -N   atuin-popup
  bindkey '^R' atuin-popup $LBUFFER
fi

# initialize atuin based on environment
if [[ -v TMUX ]]; then
  eval "$(atuin init zsh --disable-up-arrow --disable-ctrl-r)"
else
  eval "$(atuin init zsh --disable-up-arrow)"
fi

