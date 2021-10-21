import pandas as pd

df1 = pd.read_csv ('year_drugalcmed.csv')
df2 = pd.read_csv ('year_other.csv')
df1 = df1['year1'].value_counts()
df1 = df1.sort_index()
df2 = df2['year2'].value_counts()
df2 = df2.sort_index()
result = pd.concat([df1, df2], axis=1, join="outer").fillna(0)
result['year2'] = result['year2'] - result['year1']
result.to_csv('output.csv')
