PLUGINS=$ZSH_CUSTOM/plugins/
mkdir $ZSH &>/dev/null

function is_plugin {
  local base_dir=$1
  local name=$2
  test -f $base_dir/plugins/$name/$name.plugin.zsh || test -f $base_dir/plugins/$name/_$name
}

# Load all stock functions (from $fpath files) called below.
autoload -U compaudit compinit

# Set ZSH_CACHE_DIR to the path where cache files should
#  be created or else we will use the default cache/
if [[ -z "$ZSH_CACHE_DIR" ]]; then
  ZSH_CACHE_DIR="$ZSH/cache/"
fi

# Reset fpath and add all defined plugins
fpath=($(zsh -l -c 'echo $fpath'))
for plugin in $plugins; do
  if is_plugin $ZSH_CUSTOM $plugin; then
    fpath=($ZSH_CUSTOM/plugins/$plugin $fpath)
  fi
done
fpath=($ZSH_CUSTOM/completions $fpath)

# Save the location of the current completion dump file.
ZSH_COMPDUMP="${ZSH}/zcompdump-${ZSH_VERSION}"
compinit -i -d "${ZSH_COMPDUMP}"

# Source the plugins declared in .zshrc
for plugin in $plugins; do
  thing=$ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh
  [ -f $thing ] && source $thing
done