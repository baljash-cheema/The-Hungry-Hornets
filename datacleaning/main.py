import pandas as pd

df = pd.read_csv('postgres_public_trr_trr_refresh.csv')

#for x in df['officer_on_duty']:
    #if x == "Yes" or x == "Y":
        #x.replace = True

df["officer_on_duty"].replace({"Yes": True, "Y": True, "No": False, "N": False}, inplace=True)
df["officer_injured"].replace({"Yes": True, "Y": True, "No": False, "N": False}, inplace=True)
df["officer_in_uniform"].replace({"Yes": True, "Y": True, "No": False, "N": False}, inplace=True)
df["subject_armed"].replace({"Yes": True, "Y": True, "No": False, "N": False}, inplace=True)
df["subject_injured"].replace({"Yes": True, "Y": True, "No": False, "N": False}, inplace=True)
df["subject_alleged_injury"].replace({"Yes": True, "Y": True, "No": False, "N": False}, inplace=True)
df["notify_oemc"].replace({"Yes": True, "Y": True, "No": False, "N": False}, inplace=True)
df["notify_district_sergeant"].replace({"Yes": True, "Y": True, "No": False, "N": False}, inplace=True)
df["notify_op_command"].replace({"Yes": True, "Y": True, "No": False, "N": False}, inplace=True)
df["notify_det_division"].replace({"Yes": True, "Y": True, "No": False, "N": False}, inplace=True)

df["firearm_reloaded"].replace({"Yes": True, "Y": True, "No": False, "N": False}, inplace=True)
df["sight_used"].replace({"Yes": True, "Y": True, "No": False, "N": False}, inplace=True)
