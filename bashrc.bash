# User specific aliases and functions
alias llt='ls -rlt'
alias sxvgo1='ssh sxvgo1'

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

bind 'set completion-ignore-case on'

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1-/'
}

PS1="\[\033[33m\]\$(parse_git_branch)\[\033[34m\]\t\[\033[m\] \[\033[44m\]\h\e[0m \[\033[36;1m\]"'$(pwd -P | sed -e "s:/home/$USER:~:" -e "s:/mnt/nfs/d1/:/cnrm/:" -e "s:/mnt/lfs/d1/:/cnrm/:")'"\e[0m\n"

echo $DISPLAY > $HOME/.latest_display
alias f-display-reset='export DISPLAY=$(cat $HOME/.latest_display)'
