# Changing/making/removing directory
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
setopt AUTO_CD


type tree &>/dev/null && alias tree='LS_COLORS="di=34:ln=35:so=32;40:ex=31" tree'

# mkdir, cd into it
mkcd () {
  mkdir -p "$1"
  cd "$1"
}
