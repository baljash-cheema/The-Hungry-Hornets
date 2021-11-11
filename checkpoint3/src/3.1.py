import numpy as np
import pandas as pd
import datetime

location = []

import json
f = open('Boundaries.geojson',)
df0 = json.load(f)

df1 = pd.read_csv("Result_63.csv")

for x in range(len(df0['features'])):
    y = df0['features'][x]['properties']['pri_neigh']
    for z in range(len(df1['area_name'])):
        if y==str(df1['area_name'][z]):
            df0['features'][x]['properties']['pri_neigh'] = y + ', Number of allegation with Drug and alcohol abuse - ' +str(df1['count'][z])

print(df0['features'][0]['properties']['pri_neigh'])
print(df0['features'][1]['properties']['pri_neigh'])

#dfx=df0.to_json("R.geojson")
with open('R.geojson', 'w') as json_file:
  json.dump(df0, json_file)