# Directories [[[
alias d='dirs -v'
alias 1='cd -'
for index ({2..9}) alias "$index"="cd -${index}"; unset index
alias -- -='cd -'
alias -g ..='cd ..'
alias -g ...='cd ../..'
alias -g ....='cd ../../..'
alias -g .....='cd ../../../..'
alias l='ls -lthr'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -FGh'
alias lsa='ls -lah'

# ]]]
# Kubernetes [[[
alias k=kubectl
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
alias cme="cm edit --apply"
alias cmcd="cd $(chezmoi source-path)"
alias aedit="chezmoi edit --apply ${ZDOTDIR}/aliases.zsh"
alias tedit="chezmoi edit --apply ${XDG_CONFIG_HOME}/tmux/tmux.conf"
alias zedit="chezmoi edit --apply ${ZDOTDIR}/.zshrc"
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
alias gpo="git push origin"
alias gr='git remote -v'
alias gst='git status'
alias gt='git tag'
alias fml='e -O $( git diff --name-only | uniq )' # Open all merge conflicts
# ]]]
# Tmux [[[
alias tls='tmux ls'
alias tma='tmux attach -t'
alias tmn='tmux new -s'
# ]]]
# Grep [[[
# is x grep argument available?
function grep-flag-available() {
    echo | grep $1 "" >/dev/null 2>&1
}

GREP_OPTIONS=""

# color grep results
if grep-flag-available --color=auto; then
    GREP_OPTIONS+=" --color=auto"
fi

# ignore VCS folders (if the necessary grep flags are available)
VCS_FOLDERS="{.bzr,CVS,.git,.hg,.svn}"

if grep-flag-available --exclude-dir=.cvs; then
    GREP_OPTIONS+=" --exclude-dir=$VCS_FOLDERS"
elif grep-flag-available --exclude=.cvs; then
    GREP_OPTIONS+=" --exclude=$VCS_FOLDERS"
fi

# export grep settings
alias grep="grep $GREP_OPTIONS"

# clean up
unset GREP_OPTIONS
unset VCS_FOLDERS
unfunction grep-flag-available

# ]]]

alias -g e="${EDITOR}"
alias reload="source ${ZDOTDIR}/.zshrc"
type tree &>/dev/null && alias tree='LS_COLORS="di=34:ln=35:so=32;40:ex=31" tree'
alias view='nvim -R'
alias theme='kitty +kitten themes' 

# vim: ft=zsh foldmarker=[[[,]]] foldlevelstart=0 foldmethod=marker spell:
