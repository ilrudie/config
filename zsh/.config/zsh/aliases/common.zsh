## Cross-platform aliases — sourced by ~/.zsh_aliases on every OS.
##
## Anything that differs per-OS (currently just the clipboard) is abstracted
## behind `clip` / `clip-paste`, which are defined in darwin.zsh / linux.zsh.
## Keep this file free of platform-specific commands.

alias k=kubectl
export KUBE_EDITOR=nvim
# Load kubectl's completion, then make `k<tab>` complete like kubectl.
# Guarded so it's a no-op on hosts without kubectl. Requires compinit to have
# already run (see ~/.zshrc).
if (( $+commands[kubectl] )); then
  source <(kubectl completion zsh)
  compdef k=kubectl
fi

# git
alias gst="git status"
alias gls="git log --show-signature"
alias glo="git log --pretty=oneline"
alias gss="git stash"
alias gsp="git stash pop"
alias gca="git commit --amend --no-edit"
alias gcs="git commit -s -m"
alias gdf="git diff"
alias gdx="git diff | clip"
alias gitsoloize="git config --add url.'git@github.com:'.insteadOf 'https://github.com/'"

# editor / tmux
alias vhs="nvim -R ~/Documents/migrate/history"
alias view="nvim -R"
alias tma="tmux attach || tmux"

# misc
alias clc="claude"
alias xc="clip"
