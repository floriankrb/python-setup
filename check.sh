#!/bin/bash
if [ -z ${PYTHONPATH+x} ]; then echo "PYTHONPATH is unset: ok"; 
else 
echo "PYTHONPATH is set to '$PYTHONPATH'. "; 
echo " Using PYTHONPATH leads to issues difficult to debug/analyse.
    Using PYTHONPATH is not easy to maintain.
    Using PYTHONPATH will cause troubles later if not now.
    I recommend that you remove this PYTHONPATH from your ~/.bashrc and open a new terminal before doing anything in python.

    CHECK FAILS"
    exit 5
fi

if [ -z ${PYTHONHOME+x} ]; then echo "PYTHONHOME is unset: ok"; 
else 
echo "PYTHONHOME is set to '$PYTHONHOME'. "; 
echo " Using PYTHONHOME leads to issues difficult to debug/analyse.
    Using PYTHONHOME is not easy to maintain.
    Using PYTHONHOME will cause troubles later if not now.
    I recommend that you remove this PYTHONHOME from your ~/.bashrc and open a new terminal before doing anything in python.

    CHECK FAILS"
    exit 5
fi


python -c "import sys; print('\n'.join(sys.path))";
echo '------------';
echo 'python executable = ' $(which python)
echo
echo "CHECK OK"

