#!/usr/bin/env python

import xarray as xr
import numpy as np
import cartopy.crs as ccrs
import matplotlib.pyplot as plt
import matplotlib.lines as mlines
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
def get_r2(x,y):
    """ input is two numpy array, any size, but identical size. Nan are removed, the linear model is fitted. Output is [r2_score, linreg] """
    ok = np.logical_and(~np.isnan(x), ~np.isnan(y))
    x,y = x[ok], y[ok]
    x, y  = x.reshape(-1, 1),y.reshape(-1, 1)
    linreg = LinearRegression()
    linreg.fit(x,y)
    y_pred = linreg.predict(x)
    return r2_score(y, y_pred), linreg

def compute_crit(candidate, ref, candidatename,refname):
    """ use get_r2 to print nicely different criterion """
    import warnings
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")

        delta = candidate - ref
        bias = delta.mean(['time'])
        rmsd = np.sqrt((delta**2).mean(['time']))

        r2, linreg = get_r2(candidate.values.flatten(), ref.values.flatten())
    bias_ = round(float(bias.mean().values),5)
    rmsd_ = round(float(rmsd.mean().values),4)
    r2_ = round(float(r2),4)
    a_ = round(float(linreg.coef_[0]),4)
    b_ = round(float(linreg.intercept_[0]),4)
    print(f'{candidatename} vs {refname} & {bias_} & {rmsd_} & {r2_} & {a_} * x + {b_} \\\\')

def plot_scatterplot(candidate, ref, candidatename,refname, hexbin_kwargs=None, xmin=0., xmax=0.7,ymin=0., ymax=0.7, figsize=4, ax=None, weights=None):
    """ Create hexbin between candidate and reference """
    from palettable.cubehelix import Cubehelix
    palette = Cubehelix.make(start=0.3, rotation=-0.5, n=16, reverse=True)
    import palettable
    cmap = palette.get_mpl_colormap()
    #cmap = palettable.matplotlib.Inferno_20.get_mpl_colormap()
    cmap=plt.cm.jet
    cmap=plt.cm.cubehelix_r
    if hexbin_kwargs is None:
        hexbin_kwargs = {}
    if ax is None:
        f,ax = plt.subplots(1,1,figsize=(figsize,figsize))
        myax = ax
        outvar = f
    else:
        outvar = ax
        myax = ax
    x = ref.values.flatten()
    y = candidate.values.flatten()
    if not weights is None:
        broadcasted_weigths = xr.where(ref, weights, weights)
        #addweights = {'C':np.ones(len(x)),'reduce_C_function':np.sum}
        addweights = {'C': broadcasted_weigths.values.flatten(),'reduce_C_function':np.sum}
    else:
        addweights = {}
    im = myax.hexbin(x,y,
            cmap=cmap, bins='log',
            **addweights, **hexbin_kwargs );
    myax.set_xlim(xmin,xmax); myax.set_ylim(xmin,ymax); myax.add_line(mlines.Line2D([0.,1.],  [0.,1.],color='k'))
    myax.set_ylabel(candidatename); myax.set_xlabel(refname)



    f.subplots_adjust(right=0.8)
    cbar_ax = f.add_axes([0.85, 0.15, 0.05, 0.7])
    f.colorbar(im, cax=cbar_ax)
    return outvar
