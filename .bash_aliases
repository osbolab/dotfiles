alias :q=exit

# some more ls aliases
alias ls='ls --color'
alias ll='ls -alF'
alias la='ls -A'
alias l=$'ls -lF | awk \'{print $6, $7, $5, $9}\' | column -t'

alias get='sudo apt-get install'
alias udb='sudo updatedb'

alias qlip='clip > /dev/null'

alias lay='~/.tmux/layout'
alias killw='tmux kill-window'
