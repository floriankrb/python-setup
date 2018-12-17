#!/bin/bash
set -e

export _PYTHON_TEAM_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "NOTE : Your installation will be linked to this directory : $_PYTHON_TEAM_DIR . If you move or delete it, the installation will not work properly anymore"
echo;read -p 'Type enter to continue'
echo


cat $_PYTHON_TEAM_DIR/README.md

echo '--------------------------------------'
echo 'Here is your initial installation of python'
echo 'Python search path'
python -c "import sys; print('\n'.join(sys.path))";
echo '------------';
echo 'python executable = ' $(which python)

echo;read -p 'Type enter to continue'
echo

if [ -z ${LD_LIBRARY_PATH+x} ]; then echo "LD_LIBRARY_PATH is unset: ok"; 
else
echo "LD_LIBRARY_PATH is set to '$LD_LIBRARY_PATH'. "; 
echo " Using LD_LIBRARY_PATH leads to issues difficult to debug/analyse.
    Using LD_LIBRARY_PATH is not easy to maintain.
    Using LD_LIBRARY_PATH will cause troubles later if not now.
    INSTALLATION FAILED : I recommend that you remove this LD_LIBRARY_PATH from your ~/.bashrc and open a new terminal before doing anything in python."
    exit 5
fi


if [ -z ${PYTHONHOME+x} ]; then echo "PYTHONHOME is unset: ok"; 
else
echo "PYTHONHOME is set to '$PYTHONHOME'. "; 
echo " Using PYTHONHOME leads to issues difficult to debug/analyse.
    Using PYTHONHOME is not easy to maintain.
    Using PYTHONHOME will cause troubles later if not now.
    INSTALLATION FAILED : I recommend that you remove this PYTHONHOME from your ~/.bashrc and open a new terminal before doing anything in python."
    exit 5
fi

if [ -z ${PYTHONPATH+x} ]; then echo "PYTHONPATH is unset: ok"; 
else
echo "PYTHONPATH is set to '$PYTHONPATH'. "; 
echo " Using PYTHONPATH leads to issues difficult to debug/analyse.
    Using PYTHONPATH is not easy to maintain.
    Using PYTHONPATH will cause troubles later if not now.
    INSTALLATION FAILED : I recommend that you remove this PYTHONPATH from your ~/.bashrc and open a new terminal before doing anything in python."
    exit 5
fi

for DIRECTORY in $HOME/.continuum $HOME/.conda* $HOME/miniconda3; do
    if [ -d "$DIRECTORY" ]; then
        echo "The directory $DIRECTORY exists.
        This may cause troubles with the installation
        INSTALLATION FAILED : Please move or delete $DIRECTORY"
        exit 6
    fi
done

#ls -rlt ~/.conda* ~/miniconda3
#echo;read -p 'Type enter to continue'


echo '--------------------------------------'
echo 'First, I will install conda, now. See https://conda.io/docs/install/quick.html#linux-miniconda-install, installer for python3 :'
echo;read -p 'Type enter to continue'
echo

bash $_PYTHON_TEAM_DIR/conda-install/Miniconda3-latest-Linux-x86_64.sh -b
echo 'The full installation is NOT finished'

echo '--------------------------------------'
echo 'I will now add some lines at the end of your .bashrc'
echo;read -p 'Type enter to continue'
echo
set -x
echo "# added by python-conda-environment-vegeo-install-script" >>  ~/.bashrc
echo "export _PYTHON_TEAM_DIR=$_PYTHON_TEAM_DIR" >>  ~/.bashrc
echo   'source "$_PYTHON_TEAM_DIR/bashrc.conda"' >>  ~/.bashrc
echo   'source "$_PYTHON_TEAM_DIR/bashrc.bash"' >>  ~/.bashrc
set +x
echo;read -p 'Type enter to continue'

echo "# reload ~/.bashrc again to make sure it still works"
. ~/.bashrc
echo "# read and reloaded ~/.bashrc ok"

# put conda in the path
export PATH="$HOME/miniconda3/bin:$PATH"
export PYTHONNOUSERSITE=1

echo '--------------------------------------'
echo 'The installation is not complete, you have now only your own conda root environment (do not use this one) : '
echo 'Python search path'
python -c "import sys; print('\n'.join(sys.path))";
echo '------------';
echo 'python executable = ' $(which python)

echo;read -p 'Type enter to continue'
echo

_PYTHON_TEAM_VARENV=`cat defaultenvname.txt`

conda env create -f $_PYTHON_TEAM_DIR/$_PYTHON_TEAM_VARENV.yml

export PATH="$HOME/miniconda3/bin:$PATH"
export PYTHONNOUSERSITE=1

source activate $_PYTHON_TEAM_VARENV

echo 'Now we would like to ask you few questions:'
echo 'What is your firstname (prénom) ?'
read firstname
echo 'What is your lastname (nom de famille) ?'
read lastname
echo '--------------------------------------'
echo "Finally I will create a default $HOME/.gitconfig for you (you will NEED to edit the file $HOME/.gitconfig afterwards to provide your name and email)."
echo;read -p 'Type enter to continue'

cat $_PYTHON_TEAM_DIR/gitconfig | sed -e 's/Lastname/'$lastname'/'| sed -e 's/lastname/'$lastname'/' | sed -e 's/firstname/'$firstname'/' | sed -e 's/Firstname/'$firstname'/' >> ~/.gitconfig

echo 

echo '--------------------------------------'
echo "Thank you "$firstname $lastname " Installation ready."
echo "You can now try in another terminal : the new environment is not active by default. To use it, you need to run 'setup-conda-team-python-env'."
echo "Yes, you need to run  'setup-conda-team-python-env' everytimes you want to use the environment. When you don't, you will have the default environment supported by your computer department"
