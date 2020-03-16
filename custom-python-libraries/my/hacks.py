def hackfiledate(dataid,year,month,day):
    """ This bad hack is because the data for MDAL are not well organised, the folder name 'AL2-20161231' are not consistent with the convention 'AL2/2016/12/31/'
    """
    if dataid == 'MDAL': return    f'AL2-{year}{month}{day}/'

    return f'{year}/{month}/{day}/'

