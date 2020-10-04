#!/usr/bin/env python
# coding: utf-8

# In[10]:


import dask
import dask.array as da
import dask.bag as db
import dask.dataframe as dd
from dask import delayed
import json
import glob
import tensorflow as tf
import matplotlib.pyplot as plt
import pandas as pd
import time
beg = time.time()
import numpy as np
from string import punctuation
from tqdm import tqdm
from tqdm.auto import tqdm
from tqdm import tqdm_notebook
from dask.diagnostics import ProgressBar
tqdm.pandas(desc="progress-bar")
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

cols_to_remove = ['review_id', 'user_id', 'business_id', 'useful', 'funny', 'cool', 'date']
gpath='E:/slicedata/s*.json'
filenames=glob.glob(gpath)
with ProgressBar():
    dfs = [delayed(pd.read_json)(fn, 'records') for fn in filenames]
    ddf = dd.from_delayed(dfs)
    ddf = ddf.reset_index(drop=True)    
    ddf = ddf.drop(cols_to_remove, axis=1)
    ddf = ddf.compute()
    ddf = ddf[ddf.stars.isnull() == False]     # convert null values to False
    ddf = ddf[ddf.text.isnull() == False]     # convert null values to False          
    ddf1 = pd.DataFrame(ddf, columns=['stars','text'])
    ddf1 = ddf1.reset_index(drop=True)
    ddf1 = ddf1.drop('stars', axis=1)    

ddf1.head(5)


# In[ ]:




