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
