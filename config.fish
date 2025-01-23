set -gx PATH /opt/homebrew/bin $PATH
if status is-interactive
    alias vi="nvim"
    alias vim="nvim"
    alias k="kubectl"
    alias ls="lsd"
    alias grep="rg "
    alias du="gdu"
    alias ga="git add ."
    # Commands to run in interactive sessions can go here
end
