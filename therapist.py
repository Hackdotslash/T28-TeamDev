from mpl_toolkits.mplot3d import Axes3D
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt 
import numpy as np 
import os # accessing directory structure
import pandas as pd 

nRowsRead = 1000 
df1 = pd.read_csv('Psych_data.csv', delimiter=',', nrows = nRowsRead)
df1.dataframeName = 'Psych_data.csv'
nRow, nCol = df1.shape
print(f'There are {nRow} rows and {nCol} columns')

df1.head(5)



plotPerColumnDistribution(df1, 10, 5)


plotCorrelationMatrix(df1, 8)
