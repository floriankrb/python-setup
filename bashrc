# added by Miniconda2 4.3.11 installer

function _condasetup_root_env {
# added by Miniconda3 4.3.21 installer
echo "adding '$HOME/miniconda3/bin' to the PATH"
export PATH="/home/$USER/miniconda3/bin:$PATH"
export PYTHONNOUSERSITE=1
}
function condasetup_default_env {
    # added by Miniconda3 4.3.21 installer
    echo "adding '$HOME/miniconda3/bin' to the PATH"
    echo "Setting conda default environement"
    export PATH="/home/$USER/miniconda3/bin:$PATH"
    export PYTHONNOUSERSITE=1

    source activate defaultenv ;
}
#############END PYTHON CONFIG ##################
# User specific aliases and functions
alias llt='ls -rlt'
alias sxvgo1='ssh sxvgo1'
alias sshipma='ssh devmf@lsasafdev.ipma.pt'

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

bind 'set completion-ignore-case on'

parse_git_branch() {
         git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1-/'
}

PS1="\[\033[33m\]\$(parse_git_branch)\[\033[34m\]\t\[\033[m\] \[\033[44m\]\h\e[0m \[\033[36;1m\]"'$(pwd -P | sed -e "s:/home/$USER:~:" -e "s:/mnt/nfs/d1/:/cnrm/:" -e "s:/mnt/lfs/d1/:/cnrm/:")'"\e[0m\n"
#PS1="\[\033[35m\]\t\[\033[m\] \[\033[35m\]\h \[\033[36;1m\]"'$(pwd -P | sed -e "s:/home/$USER:~:" -e "s:/mnt/nfs/d1/:/cnrm/:")'"\n\[\033[0;33m\]"
#trap '[[ -t 1 ]] && tput sgr0' DEBUG

echo $DISPLAY > $HOME/.latest_display
alias f-display-reset='export DISPLAY=$(cat $HOME/.latest_display)'

