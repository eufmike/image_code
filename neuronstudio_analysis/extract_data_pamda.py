# -*- coding: utf-8 -*-
### This is a spine data processor for data compiled by spine_processor_pickle.py

# -*- coding: utf-8 -*-
import pickle 
import pylab
import numpy as np
import pandas as pd
import openpyxl as op
import matplotlib.pyplot as plt
from scipy import stats  

path = '/Volumes/Mac_Pro_SSD_2/dropbox/Dropbox/Python/neurostudio_data/spine_data/'

### import dictionary from *.p file
data_name = pickle.load(open(path+'data_17.p', 'rb' ))
data17 = data_name['17']

data_name = pickle.load(open(path+'data_25.p', 'rb' ))
data25 = data_name['25']

data = data17+data25

d = pd.DataFrame(data) ##convert the dictionary to dateframe


print d['DIV']

d['HEAD-DIAMETER'] = d['HEAD-DIAMETER'].astype(float)
d['SECTION-LENGTH'] = d['SECTION-LENGTH'].astype(float)
d['MAX-DTS'] = d['MAX-DTS'].astype(float)
div1718 = np.array(['17', '18'])
headdia_mean = d['HEAD-DIAMETER'].groupby([d['DIV'], d['NEURONID'], d['FRAME']]).mean().unstack()
headdia_size = d.groupby([d['DIV'], d['NEURONID'], d['FRAME']]).size().unstack()
section = d['SECTION-LENGTH'].groupby([d['DIV'], d['NEURONID']]).mean()
spinelen_mean = d['MAX-DTS'].groupby([d['DIV'], d['NEURONID'], d['FRAME']]).mean().unstack()

### change per frame

def change_frame(data_frame):
    new_f = data_frame.copy()
    frame = list(data_frame.columns.values)
    x = 0
    for frame_no in frame:
        if x +1 < len(frame):
            new_f[frame_no] = data_frame[frame[x+1]] - data_frame[frame_no]
            x += 1
    new_f = new_f.drop([frame[-1]], axis = 1)
    return new_f

def per_den(data_frame):
    new_f = data_frame.copy()
    frame = list(data_frame.columns.values)
    for frame_no in frame:
        new_f[frame_no] = data_frame[frame_no] / section      
    return new_f
        
c = change_frame(headdia_size)

print headdia_mean
print headdia_size
print c
print per_den(c)

type_size = d.groupby([d['DIV'], d['TYPE'], d['FRAME']]).size().unstack()
type_size = type_size.fillna(0)

print type_size

with pd.ExcelWriter('/Users/mikeshih/Desktop/ttt.xlsx') as writer:
    c.to_excel(writer, sheet_name='Sheet1')
    per_den(c).to_excel(writer, sheet_name='Sheet2')
    headdia_mean.to_excel(writer, sheet_name='Sheet3')
    spinelen_mean.to_excel(writer, sheet_name='Sheet4')
    type_size.to_excel(writer, sheet_name='Sheet5')            
    headdia_size.to_excel(writer, sheet_name='Sheet6')  


