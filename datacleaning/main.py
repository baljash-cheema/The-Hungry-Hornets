import pandas as pd

df = pd.read_csv('postgres_public_trr_trr_refresh.csv')

#for x in df['officer_on_duty']:
    #if x == "Yes" or x == "Y":
        #x.replace = True

df["officer_on_duty"].replace({"Yes": True, "Y": True, "No": False, "N": False}, inplace=True)
print df["officer_on_duty"]
print df["officer_on_duty"].unique()