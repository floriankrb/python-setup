# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#limit memory usage per process to 30G
ulimit -v 40000000

# User specific aliases and functions
alias llt='ls -rlt'
alias sxvgo1='ssh sxvgo1'

mmake() {
  pathpat="(/[^/]*)+:[0-9]+"
  ccred=$(echo -e "\033[0;31m")
  ccyellow=$(echo -e "\033[0;33m")
  ccblue=$(echo -e "\033[34m")
  cccyan=$(echo -e "\033[36m")
  ccend=$(echo -e "\033[0m")
  make "$@" 2>&1 | sed -E -e "s/[Ee]rror/${ccred}Error${ccend}/gi" -e "s/[Ee]rreur/${ccred}Erreur${ccend}/gi"  -e "s/[Ww]arning/${ccyellow}Warning${ccend}/gi" -e "s/[Aa]vertissement/${ccyellow}Avertissement${ccend}/gi" -e "s/^(f2py .*)/${cccyan}\1${ccend}/g" -e "s/^(gfortran .*)/${cccyan}\1${ccend}/g" 
  return ${PIPESTATUS[0]}
}


bind 'set completion-ignore-case on'

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1-/'
}

PS1=''
PS1=$PS1'$(echo $LD_LIBRARY_PATH | sed -e "s:^......\(.\).*$:\1:g")'
PS1=$PS1"\[\033[33m\]\$(parse_git_branch)\[\033[34m\]\t\[\033[m\]"
PS1=$PS1" \[\033[48;5;17m\]\[\033[38;5;11m\]\h\e[0m \[\033[39m\]"
PS1=$PS1'$(pwd -P | sed -e "s:/home/$USER:~:" -e "s:/mnt/lfs/d30/:/cnrm/:" -e "s:/mnt/lfs/d30/:/cnrm/:")'"\e[0m\n"

echo $DISPLAY > $HOME/.latest_display
alias f-display-reset='export DISPLAY=$(cat $HOME/.latest_display)'

echo "Run 'hdf-set-up-my-hdf5-lib-to-use-pinaultf-libraries' if you want to use the hdf library from Florian"
alias hdf-set-up-my-hdf5-lib-to-use-pinaultf-libraries="source $_PYTHON_TEAM_DIR/hdf-set-up-my-hdf5-lib-to-use-pinaultf-libraries.TODO.sh"

export PATH=$_PYTHON_TEAM_DIR/bin:$PATH
export PYTHONPATH=$_PYTHON_TEAM_DIR/custom-python-libraries:$PYTHONPATH
