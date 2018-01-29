#!/bin/bash
set -e

echo 'To remove your conda environment'
echo
echo "1 - Delete your conda folders :"
echo "   rm -rf $HOME/miniconda3"
echo "   rm -rf $HOME/.conda"
echo
echo "2 - Edit your file $HOME/.bashrc to remove the following lines: "
grep _PYTHON_TEAM_DIR $HOME/.bashrc
