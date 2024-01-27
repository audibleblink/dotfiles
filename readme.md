```
# install to ~/.local/bin and apply main branch
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply audibleblink

# sync zsh history
bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)
atuin login
atuin import auto
atuin sync
```
