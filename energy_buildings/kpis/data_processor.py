"""This is for customized data processing.

Author: Yangyang Fu
Email: yangyang.fu@tamu.edu
"""
import pandas as pd
import scipy.interpolate as interpolate

def interpolate_dataframe(data,index_new):
    """
    Interpolate a given dataframe over the given new index.

    Return the interpolated dataframe
    """
    index_old = data.index
    data_new = pd.DataFrame(index=index_new)
    for column in data.columns():
        intp = interpolate.interp1d(index_old, data[column], kind='linear')
        data_new[column] = intp(index_new)

    return data_new
