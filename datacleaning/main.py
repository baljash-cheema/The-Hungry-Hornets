import pandas as pd

file = 'postgres_public_trr_trr_refresh.csv'

df_trr_trr = pd.read_csv(file)

df["officer_on_duty"].replace({"Yes": True, "Y": True, "No": False, "N": False}, inplace=True)
print df["officer_on_duty"]
print df["officer_on_duty"].unique()