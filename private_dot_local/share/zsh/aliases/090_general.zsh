if type nvim > /dev/null; then
  export EDITOR="$(which nvim)"
else
  export EDITOR="$(which vim)"
fi

alias e="${EDITOR}"
alias cm="chezmoi"
alias reload="source ~/.zshrc"

alias k=kubectl

alias kg='k get'
alias kgs='kg svc'
alias kgp='kg pod'

alias kga='kg --all-namespaces'
alias kgas='kga svc'
alias kgap='kga pods'
