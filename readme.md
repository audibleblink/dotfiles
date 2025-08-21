```sh
# install to ~/.local/bin and apply main branch
sh -c "$(curl -fsLS get.chezmoi.io/lb)" --init --apply audibleblink

# sync zsh history
atuin login
atuin import auto
atuin sync
```
