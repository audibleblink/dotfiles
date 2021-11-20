###############
# Ruby
###############
alias be='bundle exec'
type rbenv &>/dev/null && eval "$(rbenv init --no-rehash - zsh)"

###############
# JavaScript
###############
alias asi='find . -not -iwholename "*node_modules*" -type f -name *.js | xargs fixmyjs --legacy'

###############
# Go
###############
if [ -f "${XDG_DATA_HOME}"/gvm/scripts/gvm-default ]; then
  GVM_ROOT="${XDG_DATA_HOME}/gvm"
  source "${XDG_DATA_HOME}"/gvm/scripts/gvm-default
  typeset -U PATH path
fi
