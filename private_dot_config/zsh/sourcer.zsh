# PLUGINS=$ZDOTDIR/plugins/
ZSH=${ZDG_STATE_HOME}/zsh
mkdir $ZSH &>/dev/null

# Load all stock functions (from $fpath files) called below.
autoload -U compaudit compinit

# Set ZSH_CACHE_DIR to the path where cache files should
#  be created or else we will use the default cache/
if [[ -z "$ZSH_CACHE_DIR" ]]; then
  ZSH_CACHE_DIR="$ZSH/cache/"
fi

# Reset fpath and add functions and completions
fpath=($(zsh -l -c 'echo $fpath'))
fpath=($ZDOTDIR/{completions,functions} $fpath)
autoload -Uz $ZDOTDIR/functions/**/* # Sources custom functions

# Save the location of the current completion dump file.
ZSH_COMPDUMP="${ZSH}/zcompdump-${ZSH_VERSION}"
compinit -i -d "${ZSH_COMPDUMP}"

# Source the plugins declared in .zshrc
for plugin in $plugins; do
  thing=$ZDOTDIR/plugins/$plugin/$plugin.plugin.zsh
  [ -f $thing ] && source $thing
done
