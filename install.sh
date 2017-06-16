export _PYTHON_TEAM_DIR=/cnrm/vegeo/pinaultf/python-team

set -e


cat README.md


echo 'Here is your initial installation of python'
echo 'Python search path'
python -c "import sys; print('\n'.join(sys.path))";
echo '------------';
echo 'python executable = ' $(which python)

read -p 'Type enter to continue'

if [ -z ${PYTHONPATH+x} ]; then echo "PYTHONPATH is unset: ok"; 
else
echo "PYTHONPATH is set to '$PYTHONPATH'. "; 
echo " Using PYTHONPATH leads to issues difficult to debug/analyse.
    Using PYTHONPATH is not easy to maintain.
    Using PYTHONPATH will cause troubles later if not now.
    I recommend that you remove this PYTHONPATH from your ~/.bashrc and open a new terminal before doing anything in python.

    INSTALLATION FAILED"
    exit 5
fi

for DIRECTORY in $HOME/.continuum $HOME/.local $HOME/.conda* $HOME/miniconda3; do
    if [ -d "$DIRECTORY" ]; then
        echo "The directory $DIRECTORY exists.
        This may cause troubles with the installation
        Please move/delete $DIRECTORY

        INSTALLATION FAILED"
        exit 6
    fi
done

#ls -rlt ~/.conda* ~/miniconda3
#read -p 'Type enter to continue'


echo 'First, I will install conda, now. See https://conda.io/docs/install/quick.html#linux-miniconda-install, installer for python3 :'
read -p 'Type enter to continue'

bash $_PYTHON_TEAM_DIR/conda-install/Miniconda3-latest-Linux-x86_64.sh -b

echo 'conda installed'

echo 'I will now add some lines at the end of your .bashrc'
read -p 'Type enter to continue'
echo "# added by python-conda-environment-vegeo-install-script" >>  ~/.bashrc
echo "export _PYTHON_TEAM_DIR=$_PYTHON_TEAM_DIR" >>  ~/.bashrc
echo   'source "$_PYTHON_TEAM_DIR/bashrc.conda"' >>  ~/.bashrc
echo   'source "$_PYTHON_TEAM_DIR/bashrc.prompt"' >>  ~/.bashrc

echo "Source ~/.bashrc again"
. ~/.bashrc

# put conda in the path
export PATH="$HOME/miniconda3/bin:$PATH"
export PYTHONNOUSERSITE=1

echo '--------------------------------------'
echo 'Now you have your own personal conda root environment (do not use it) : '
echo 'Python search path'
python -c "import sys; print('\n'.join(sys.path))";
echo '------------';
echo 'python executable = ' $(which python)

read -p 'Type enter to continue'


conda  create -n defaultenv
 echo "adding '$HOME/miniconda3/bin' to the PATH"
 export PATH="$HOME/miniconda3/bin:$PATH"
 export PYTHONNOUSERSITE=1
 source activate defaultenv 
#setup-conda-team-python-env
conda install pip  # VERY important to use pip in the environment and not the global system pip and not the conda root pip
echo '--------------------------------------'
echo 'Now you have your own personal conda default environment (use it) : '
echo 'Python search path'
python -c "import sys; print('\n'.join(sys.path))";
echo '------------';
echo 'python executable = ' $(which python)



echo '--------------------------------------'
echo 'I will now install many packages (from the anaconda distribution)'
read -p 'Type enter to continue'
conda install anaconda

echo '--------------------------------------'

echo "Additionnaly I will create a default $HOME/.gitconfig for you (you should edit the file $HOME/.gitconfig afterwards to provide you name and email)."
read -p 'Type enter to continue'
cp $_PYTHON_TEAM_DIR/gitconfig ~/.gitconfig


echo "Installation done. Please open a new terminal and run the check_install.sh script"
