## Linux-specific aliases — sourced after common.zsh when $OSTYPE == linux*.

# Clipboard primitives used by the cross-platform aliases (gdx, xc, ...).
# Requires xclip (apt/dnf install xclip).
alias clip='xclip -selection clipboard'
alias clip-paste='xclip -selection clipboard -o'
