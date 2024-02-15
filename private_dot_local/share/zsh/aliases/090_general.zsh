if type nvim > /dev/null; then
  export EDITOR="$(which nvim)"
else
  export EDITOR="$(which vim)"
fi

alias e="${EDITOR}"
alias cm="chezmoi"
alias reload="source ~/.zshrc"

############
# kubectl
############

function kstatus() {
  if [[ -n RPROMPT ]] 
  then
    unset RPROMPT
  else
    echo RPROMPT='$(kube_ps)'
  fi
}

alias k=kubectl

alias kg='k get'
alias kgs='kg svc'
alias kgp='kg pod'

alias kga='kg --all-namespaces'
alias kgas='kga svc'
alias kgap='kga pods'

alias kd='k delete'
alias kdf='kd -f'
alias ka='k apply'
alias kaf='ka -f'
alias kak='ka -k'
alias kns='k config set-context --current --namespace'


