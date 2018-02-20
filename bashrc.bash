# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# User specific aliases and functions
alias llt='ls -rlt'
alias sxvgo1='ssh sxvgo1'


bind 'set completion-ignore-case on'

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1-/'
}

PS1=''
PS1=$PS1'$(echo $LD_LIBRARY_PATH | sed -e "s:^......\(.\).*$:\1:g")'
PS1=$PS1"\[\033[33m\]\$(parse_git_branch)\[\033[34m\]\t\[\033[m\]"
PS1=$PS1" \[\033[48;5;17m\]\[\033[38;5;11m\]\h\e[0m \[\033[39m\]"
PS1=$PS1'$(pwd -P | sed -e "s:/home/$USER:~:" -e "s:/mnt/nfs/d1/:/cnrm/:" -e "s:/mnt/lfs/d1/:/cnrm/:")'"\e[0m\n"

echo $DISPLAY > $HOME/.latest_display
alias f-display-reset='export DISPLAY=$(cat $HOME/.latest_display)'

echo "Run 'hdf-set-up-my-hdf5-lib-to-use-pinaultf-libraries' if you want to use the hdf library from Florian"
alias hdf-set-up-my-hdf5-lib-to-use-pinaultf-libraries="source $_PYTHON_TEAM_DIR/hdf-set-up-my-hdf5-lib-to-use-pinaultf-libraries.TODO.sh"

export PATH=$PATH:$_PYTHON_TEAM_DIR/bin
