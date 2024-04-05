# atuin-popup spawns atuin in a tmux floating window and writes selected item to a file
# the LBUFFER then gets set to the contects of that file.
function atuin-popup() {
  local umask=117
  local out=$(mktemp -t atuin.XXX -p $XDG_RUNTIME_DIR)
  trap "rm -- ${out} 2>/dev/null" EXIT
  tmux popup -S fg=black -b rounded -d "${PWD}" -E "\$(ATUIN_SESSION=$ATUIN_SESSION atuin search $* -i -- $BUFFER 3>$out 1>&2 2>&3)" 
  LBUFFER="$(sed 1q $out)"
}

# bind ^R only if we're in a tmux terminal
if [[ -v TMUX ]]; then
  zle     -N   atuin-popup
  bindkey '^R' atuin-popup $LBUFFER
  eval "$(atuin init zsh --disable-up-arrow --disable-ctrl-r)"
else
  eval "$(atuin init zsh --disable-up-arrow)"
fi
