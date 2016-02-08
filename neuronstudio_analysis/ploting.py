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


## get relative distance to soma
d['SOMA-DISTANCE'] = d['SOMA-DISTANCE'].astype(float)
d['SECTION-LENGTH'] = d['SECTION-LENGTH'].astype(float)
d['RELATIVE_DIS_SOMA']=d['SOMA-DISTANCE']/d['SECTION-LENGTH']*100

## assaign Spine_Quadrant to each spine
d['X'] = d['X'].astype(float)
d['Y'] = d['Y'].astype(float)
d['ATTACH-X'] = d['ATTACH-X'].astype(float)
d['ATTACH-Y'] = d['ATTACH-Y'].astype(float)

d['delta_X']=d['X']-d['ATTACH-X']
d['delta_Y']=d['Y']-d['ATTACH-Y']

d['Spine_Quadrant'] = '1'
d['Spine_Quadrant'][(d['delta_X'] < 0) & (d['delta_Y'] > 0)] = '2'
d['Spine_Quadrant'][(d['delta_X'] < 0) & (d['delta_Y'] < 0)] = '3'
d['Spine_Quadrant'][(d['delta_X'] > 0) & (d['delta_Y'] < 0)] = '4'

d['MAX-DTS'] = d['MAX-DTS'].astype(float)
d['deltaMAX-DTS'] = d['MAX-DTS']
d['deltaMAX-DTS'][(d['Spine_Quadrant'] == '3') ^ (d['Spine_Quadrant'] == '4')] = -d['MAX-DTS']

d['HEAD-DIAMETER'] = d['HEAD-DIAMETER'].astype(float)


column = list(d.columns)
print column

#print d
ID = 'DIV25_12'

df = d.ix[d['NEURONID'] == ID]

print df

plt.figure(figsize=(20, 14))  
c = ['DarkBlue', 'DarkGreen', 'DarkRed']

plt.title(ID)

frame = range(1,22)
print frame

for i in frame:    
    if i < 10:
        F = '0'+str(i)
        print F
        df2 = df.ix[d['FRAME'] == F]
        print df2
        
        ax = plt.subplot(21, 1, i)
        plt.ylim(-10, 10)  
        plt.xlim(-5, 105)  
        
        x=0
        for name, group in df2.groupby('TYPE'):    
            group.plot(kind='scatter', x='RELATIVE_DIS_SOMA', y='deltaMAX-DTS', s=group['HEAD-DIAMETER']*50, color=c[x], ax=ax)
            plt.ylabel(str(i))
            plt.xlabel('')
            x+=1
    else:
        F = str(i)
        df2 =  df.ix[d['FRAME'] == F]
        print df2
        
        ax = plt.subplot(21, 1, i)
        plt.ylim(-10, 10)  
        plt.xlim(-5, 105)  
        x=0
        for name, group in df2.groupby('TYPE'):    
            group.plot(kind='scatter', x='RELATIVE_DIS_SOMA', y='deltaMAX-DTS', label=name, s=group['HEAD-DIAMETER']*50, color=c[x], ax=ax)
            plt.ylabel(str(i))
            plt.xlabel('')
            x+=1

#n = df.groupby(['FRAME', 'TYPE'])

'''
for name, group in n:
    print(name)
    print(group)


'''
plt.show() #This is necessary for canopy. 