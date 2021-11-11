import numpy as np
import pandas as pd
import datetime

location = []

import json
f = open('Boundaries.geojson',)
df0 = json.load(f)

df1 = pd.read_csv("Result_85.csv")

lt=[]
#print(df1.head())
for x in range(len(df1['race'])-4):
    lt.append(str(df1['race'][x])+' - '+str(df1['people_count'][x])+', '+str(df1['race'][x+1])+' - '+str(df1['people_count'][x+1])+', '+str(df1['race'][x+2])+' - '+str(df1['people_count'][x+2])+', '+str(df1['race'][x+3])+' - '+str(df1['people_count'][x+3]))

lt.append(' 1')
lt.append(' 1')
lt.append(' 1')
lt.append(' 1')

df1['racex']=lt
df1 = df1.drop_duplicates(subset=['area_name'])
df1 = df1.reset_index()

for x in range(len(df0['features'])):
    y = df0['features'][x]['properties']['pri_neigh']
    for z in range(len(df1['area_name'])):

        if y==str(df1['area_name'][z]):
            df0['features'][x]['properties']['pri_neigh']=(y + ': Number of allegations with drug and alcohol abuse - ' +str(df1['count'][z])+ '; Demographics: ' +str(df1['racex'][z]))

print(df0)
#dfx=df0.to_json("R.geojson")
with open('R.geojson', 'w') as json_file:
  json.dump(df0, json_file)

