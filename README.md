# Overview :

The install.sh script is installing a "standard" python3 environment for scientific purposes.

More precisely it installs conda (with python3) with its root environment, then it creates a default environment named "defaultenv" where it installs a local pip and many packages.

The check.sh script detect usual errors before/after installation.

# Usage :

cd ~
git clone /cnrm/vegeo/LSA_SAF/tools/python-team
cd python-team
./install.sh

** READ carefully the output, type enter when needed **

# Another way to install
0 - Create a new env : conda create -n myenv ; conda activate myenv
1 - Install conda packages that are in packages-list.conda.txt : conda install -c conda-forge ....
2 - Install pip packages that are in packages-list.pip.txt
3 - Finalise jupyterlab packages : jupyter.labextension.install.sh  (this is not included in the automatic install.sh script)

# How to add a package :
- for one user :
conda install mynewpackage
or
pip install mynewpackage

- for the team
Install it in your environment :
$ conda install mynewpackage
or
$ pip install mynewpackage

Then, update the environment description (environment.yml).  From the directory where you see this README.md.
$ conda env export > environment.yml
$ git diff
$ gedit environment.yml
See which package was installed and add what should be added :
git add -p
git commit -m'added package mynewpackage'
