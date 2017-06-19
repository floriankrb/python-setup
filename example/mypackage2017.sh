# test to illustrate the use of the package:

#
conda create -n tt
conda install pip   # VERY IMPORTANT !!!!!!
conda install example/mypackage2017
python -c 'import myfunctions; print(myfunctions.add(4,5))'
