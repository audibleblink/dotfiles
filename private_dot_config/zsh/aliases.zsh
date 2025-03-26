# Directories [[[
alias d='dirs -v'
alias 1='cd -'
for index ({2..9}) alias "$index"="cd -${index}"; unset index
alias -- -='cd -'
alias ..='cd ..'
alias -g ...='cd ../..'
alias -g ....='cd ../../..'
alias -g .....='cd ../../../..'
alias l='ls -lthr'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -FGh'
alias lsa='ls -lah'
alias cd='unset stacklevel; cd'

# ]]]
# Kubernetes [[[
alias -g k=kubectl
alias ka='k apply'
alias kaf='ka -f'
alias kak='ka -k'
alias kd='k delete'
alias kdf='kd -f'
alias kg='k get'
alias kga='kg --all-namespaces'
alias kgap='kga pods'
alias kgas='kga svc'
alias kgp='kg pod'
alias kgs='kg svc'
alias kns='k config set-context --current --namespace'
# ]]]
# Chezmoi [[[
alias -g cm="chezmoi"
alias cme="cm edit --watch"
alias cmcd="cd $(chezmoi source-path 2>/dev/null)"
alias aedit="cme ${ZDOTDIR}/aliases.zsh"
alias tedit="cme ${XDG_CONFIG_HOME}/tmux/tmux.conf"
alias zedit="cme ${ZDOTDIR}/.zshrc"
# ]]]
# Coding [[[
alias asi='find . -not -iwholename "*node_modules*" -type f -name *.js | xargs fixmyjs --legacy'
alias be='bundle exec'
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
# ]]]
# Git [[[
alias ga='git add'
alias gb='git branch -v'
alias gc='git commit -v'
alias gcam='git commit -am'
alias gcm='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gp="git push"
alias gpo="git push origin"
alias gr='git remote -v'
alias gst='git status'
alias gt='git tag'
alias fml='e -O $( git diff --name-only | uniq )' # Open all merge conflicts
# ]]]
# Obsidian [[[
alias ot="nvim +ObsidianToday"
alias ow="nvim +ObsidianWorkspace"
alias on="nvim +ObsidianNew"
# ]]]

(( $+commands[tree] )) && alias tree='LS_COLORS="di=34:ln=35:so=32;40:ex=31" tree'

alias -g e="${EDITOR}"
alias reload="source ${ZDOTDIR}/.zshrc"
alias view='nvim -R'
alias theme='kitty +kitten themes' 
alias zl="e ~/.zshrc_local"

# vim: ft=zsh foldmarker=[[[,]]] foldlevelstart=0 foldmethod=marker spell:
