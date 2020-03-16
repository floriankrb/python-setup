#!/usr/bin/env python

import logging
import xarray as xr
import numpy as np
import cartopy.crs as ccrs
import matplotlib.pyplot as plt
import matplotlib.lines as mlines
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
import my.io

def get_r2(x,y, sample_weight=None):
    """ input is two numpy array, any size, but identical size. Nan are removed, the linear model is fitted. Output is [r2_score, linreg] """
    # remove nan data
    ok = np.logical_and(~np.isnan(x), ~np.isnan(y))
    x,y = x[ok], y[ok]
    if not sample_weight is None: sample_weight = sample_weight[ok]

    # reshape
    x, y  = x.reshape(-1, 1),y.reshape(-1, 1)
    #if not sample_weight is None: sample_weight = sample_weight.reshape(-1, 1)

    # perform regression
    linreg = LinearRegression()
    if not sample_weight is None: linreg.fit(x,y,sample_weight)
    else: linreg.fit(x,y)

    # compute r2_score
    y_pred = linreg.predict(x)
    if not sample_weight is None: r2 = r2_score(y, y_pred, sample_weight)
    else: r2 = r2_score(y, y_pred)

    return r2, linreg


from collections import namedtuple
Criteria = namedtuple('Criteria', 'candidatename refname bias rmsd r2 equation cbig csmall')

def compute_crit(candidate, ref, candidatename,refname, multiplied=1.,weights=None, threshold=None):
    """ use get_r2() to print nicely different criterion """
    cbig = None
    csmall = None
    if threshold:
        big = ref > threshold
        cbig = compute_crit(candidate.where(big), ref.where(big), candidatename,refname, multiplied=multiplied,weights=weights, threshold=None)
        csmall = compute_crit(candidate.where(~big), ref.where(~big), candidatename,refname, multiplied=multiplied,weights=weights, threshold=None)
    # Note that the averaging with weights along the 'time' dimension is tricky
    if weights is None:
        weights = ref * 0. + 1.
    weights = xr.where(np.logical_and(~np.isnan(ref),~np.isnan(ref)), weights, 0.)
    if 'time' in weights.dims:
        weights2d = weights.mean(['time'])
    else:
        weights2d = weights
    import warnings
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")

        delta = candidate - ref

        if not weights is None: delta = delta * weights
        delta = delta * multiplied

        if not weights is None and 'time' in weights.dims:
            bias = delta.mean(['time'])
            rmsd = np.sqrt((delta**2).mean(['time']))
        else:
            bias = delta
            rmsd = np.sqrt(delta**2)


        if not weights is None: weights = weights.values.flatten()
        r2, linreg = get_r2(candidate.values.flatten(), ref.values.flatten(), sample_weight = weights)

    # Note : compute sum of weights only where the data exists. If we do not do this, the missing data will count as zero
    # and the final weighted average will be biased towards zero
    if not weights is None:
        sumweights = float(xr.where(~np.isnan(bias),weights2d, np.nan).sum().values)
    else:
        sumweights = 1.

    bias_ = round(float(bias.sum().values)/sumweights,5)
    rmsd_ = round(float(rmsd.sum().values)/sumweights,4)
    r2_ = round(float(r2),4)
    a_ = round(float(linreg.coef_[0]),4)
    b_ = round(float(linreg.intercept_[0]),4)
    return Criteria(refname=refname, candidatename=candidatename,
            bias=bias_, rmsd=rmsd_, r2=r2_, equation=[a_, b_], cbig=cbig, csmall=csmall)

def plot_scatterplot(candidate, ref, candidatename,refname, hexbin_kwargs=None,
        xmin=0., xmax=0.7,ymin=0., ymax=0.7, figsize=4, ax=None,f=None, weights=None,
        add_criterion_text = False, criterion_text_threshold = None,
        filename=None, logmessage=True):
    """ Create hexbin between candidate and reference """
    try:
        from palettable.cubehelix import Cubehelix
        palette = Cubehelix.make(start=0.3, rotation=-0.5, n=16, reverse=True)
        import palettable
        cmap = palette.get_mpl_colormap()
        #cmap = palettable.matplotlib.Inferno_20.get_mpl_colormap()
        cmap=plt.cm.jet
        cmap=plt.cm.cubehelix_r
    except ImportError:
        cmap = 'cubehelix_r'
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
        broadcasted_weights = xr.where(ref, weights, weights)
        #addweights = {'C':np.ones(len(x)),'reduce_C_function':np.sum}
        addweights = {'C': broadcasted_weights.values.flatten(),'reduce_C_function':np.sum}
    else:
        addweights = {}
    if not 'gridsize' in hexbin_kwargs: hexbin_kwargs['gridsize'] = 200
    if not 'bins' in hexbin_kwargs: hexbin_kwargs['bins'] = 'log'
    if not 'cmap' in hexbin_kwargs: hexbin_kwargs['cmap'] = cmap
    im = myax.hexbin(x,y, **addweights, **hexbin_kwargs );
    myax.set_xlim(xmin,xmax); myax.set_ylim(xmin,ymax); myax.add_line(mlines.Line2D([0.,1.],  [0.,1.],color='k'))
    myax.set_ylabel(candidatename); myax.set_xlabel(refname)

    f.subplots_adjust(right=0.8)
    cbar_ax = f.add_axes([0.85, 0.15, 0.05, 0.7])
    f.colorbar(im, cax=cbar_ax)

    if add_criterion_text:
        c = my.stats.compute_crit(candidate, ref, candidatename, refname, multiplied=1.,weights=weights)
        text = f'{c.candidatename} vs {c.refname} :\nBias={c.bias} RMSE={c.rmsd}\n' # & {c.r2} & {c.equation[0]} * x + {c.equation[1]}'

        text = f'{c.candidatename} vs {c.refname} :\nBias={c.bias} RMSE={c.rmsd}\n' # & {c.r2} & {c.equation[0]} * x + {c.equation[1]}'

        if criterion_text_threshold:
            def t(x):
                if x is None: return None
                return x.where(ref<criterion_text_threshold)
            c1 = my.stats.compute_crit(t(candidate), t(ref), candidatename, refname, multiplied=1.,weights=t(weights))
            text += f'Bias={c1.bias} RMSE={c1.rmsd} (<{criterion_text_threshold})\n' # & {c.r2} & {c.equation[0]} * x + {c.equation[1]}'

            def t(x):
                if x is None: return None
                return x.where(ref>=criterion_text_threshold)
            c1 = my.stats.compute_crit(t(candidate), t(ref), candidatename, refname, multiplied=1.,weights=t(weights))
            text += f'Bias={c1.bias} RMSE={c1.rmsd} (>{criterion_text_threshold})\n' # & {c.r2} & {c.equation[0]} * x + {c.equation[1]}'

        try:
            ax.text(0.02,0.75,text, transform=ax.transAxes)
        except:
            f.text(0.02,0.75,text, transform=ax.transFigure) # may work, or may not, if f is figure or ax, maybe
    if filename:
        my.io.ensure_dir(filename)
        f.savefig(filename)
        if logmessage:
            logging.info(f'Saved plot in {filename}')
    return outvar
