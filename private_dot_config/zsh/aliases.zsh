# Directories [[[
alias d='dirs -v'
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
alias clear='clear -x'

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
# ]]]
# Chezmoi [[[
alias -g cm="chezmoi"
alias cme="cm edit --hardlink=false"
alias cmcd="cd $(chezmoi source-path 2>/dev/null)"
alias aedit="nvim '+ChezmoiEdit ${ZDOTDIR}/aliases.zsh'"
alias tedit="nvim '+ChezmoiEdit ${XDG_CONFIG_HOME}/tmux/tmux.conf'"
alias zedit="nvim '+ChezmoiEdit ${ZDOTDIR}/.zshrc'"
alias dots="nvim -c 'Telescope chezmoi find_files'"
# ]]]
# Coding [[[
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
# alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gl='git log --graph --decorate --all --pretty=format:"%C(cyan)%h%Creset %C()%s%Creset%n%C(dim italic white)      └─ %ar by %an %C(auto)  %D%n"'
alias gp="git push"
alias gpo="git push origin"
alias gr='git remote -v'
alias gst='git status'
alias gt='git tag'
alias gri='git rebase -i'                                                  
alias grc='git rebase --continue'                                          
alias gra='git rebase --abort'                                             
alias fml='e -O $( git diff --name-only | uniq )' # Open all merge conflicts
# ]]]

(( $+commands[tree] )) && alias tree='LS_COLORS="di=34:ln=35:so=32;40:ex=31" tree --charset utf-8'

export FZF_PREVIEW_COMMAND="bat --style=numbers,changes --wrap never --color always {}"
export FZF_DEFAULT_OPTS=' --color=bg:-1,bg+:-1
  --border="none" --border-label="" --preview-window="border-rounded" --padding="1"
  --margin="1" --prompt="❯ " --marker="+" --pointer="◆"
  --separator="─" --scrollbar="│" --info="right"'

export PATH=$PATH:$HOME/.cargo/bin

alias -g e="${EDITOR}"
alias reload="source ${ZDOTDIR}/.zshrc"
alias view='nvim -R'
alias zl="e ~/.zshrc_local"

alias cat='bat --paging=never'                                     
alias less='bat --paging=always'                                       

# vim: ft=zsh foldmarker=[[[,]]] foldlevelstart=0 foldmethod=marker spell:
