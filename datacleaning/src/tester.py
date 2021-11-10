import pandas as pd

file1 = 'test/after_recon/postgres_public_trr_trr_refresh.csv'
file2 = 'csv/after_recon/postgres_public_trr_trr_refresh.csv'

df1 = pd.read_csv(file1)
df2 = pd.read_csv(file2)



print(df1['Unnamed: 0'].equals(df2['Unnamed: 0']))

print(df1.columns == df2.columns)