import csv
import datetime

import pandas as pd

def convert_bool(df,list):
    '''
    Takes a list of strings that are column headers, iterates through them and converts it to bool.
    '''

    for each in list:
        df[each].replace({"Yes": True, "Y": True, "No": False, "N": False}, inplace=True)

    return None

def convert_time(df,list):
    '''
    Takes a list of strings that are column headers, iterates through them and converts it to timestamp.
    '''

    for each in list:
        df[each] = pd.to_datetime(df[each],utc=True)

    return None

def convert_redact(df,list):
    '''
    Takes a list of strings that are column headers, iterates through them and converts any "redacted" entries to null.
    '''
    
    for each in list:
        df[each].replace({"REDACTED": None}, inplace=True)
    
    return None


def typecorrection():
    file = 'csv/postgres_public_trr_trr_refresh.csv'
    file2 = 'csv/postgres_public_trr_weapondischarge_refresh.csv'
    file3 = 'csv/postgres_public_trr_trrstatus_refresh.csv'

    df1 = pd.read_csv(file)
    df2 = pd.read_csv(file2)
    df3 = pd.read_csv(file3)

    to_bool1 = ["officer_on_duty","officer_injured", "officer_in_uniform", "subject_armed", "subject_injured",
                       "subject_alleged_injury","notify_oemc","notify_district_sergeant","notify_op_command",
                       "notify_det_division"]
    to_bool2 = ['firearm_reloaded', 'sight_used']

    to_timestamp1 = ['trr_datetime', 'officer_appointed_date', 'trr_created']
    to_timestamp3 = ['status_datetime']

    to_null1 = ['trr_datetime', 'beat', 'officer_appointed_date', 'officer_birth_year', 'officer_age',
                'officer_on_duty',
                'officer_injured', 'officer_in_uniform', 'subject_birth_year', 'subject_age', 'subject_armed',
                'subject_injured',
                'subject_alleged_injury', 'notify_oemc', 'notify_district_sergeant', 'notify_op_command',
                'notify_det_division',
                'trr_created']
    to_null2 = ['firearm_reloaded', 'sight_used']
    to_null3 = ['officer_appointed_date', 'officer_birth_year', 'status_datetime']

    convert_redact(df1,to_null1)
    convert_redact(df2,to_null2)
    convert_redact(df3,to_null3)

    convert_bool(df1,to_bool1)
    convert_bool(df2,to_bool2)

    convert_time(df1,to_timestamp1)
    convert_time(df3,to_timestamp3)

# need to convert to csv
# still with time issue

def integration():
    trr_refresh = 'csv/postgres_public_trr_trr_refresh.csv'
    data_officer = 'csv/postgres_public_data_officer.csv'

    trr_df = pd.read_csv(trr_refresh)
    officer_df = pd.read_csv(data_officer)

    for x in trr_df['officer_appointed_date']:
        if type(x) != float:
            x = x.split(' ')[0]
            if x!='REDACTED':
                if x.split("-")[1].isnumeric() and len(str(x.split("-")[0]))!=4:
                    d=datetime.datetime.strptime(x,"%m-%d-%y")
                    trr_df['officer_appointed_date'] = trr_df['officer_appointed_date'].replace([x], (str(d.year)+'-'+str(d.month)+'-'+str(d.day)))
                elif x.split("-")[1].isnumeric() and len(str(x.split("-")[0]))==4:
                    d=datetime.datetime.strptime(x,"%Y-%m-%d")
                    trr_df['officer_appointed_date'] = trr_df['officer_appointed_date'].replace([x], (str(d.year)+'-'+str(d.month)+'-'+str(d.day)))
                elif not x.split("-")[1].isnumeric():
                    d = datetime.datetime.strptime(x, "%Y-%b-%d")
                    trr_df['officer_appointed_date'] = trr_df['officer_appointed_date'].replace([x], (str(d.year)+'-'+str(d.month)+'-'+str(d.day)))
    for x in trr_df['officer_appointed_date']:
        if type(x) != float:
            if x!='REDACTED':
                # print(x)
                if int(x.split("-")[0])>2021:
                    d = datetime.datetime.strptime(x, "%Y-%m-%d")
                    trr_df['officer_appointed_date'] = trr_df['officer_appointed_date'].replace([x], (str(d.year-100)+'-'+str(d.month)+'-'+str(d.day)))

    trr_df.rename(columns={'officer_last_name' : 'last_name','officer_first_name' : 'first_name', 'officer_middle_initial' : 'middle_initial',
                           'officer_appointed_date' : 'appointed_date'},inplace=True)

    trr_df['last_name'] = trr_df['last_name'].str.lower()
    trr_df['first_name'] = trr_df['first_name'].str.lower()
    trr_df['middle_initial'] = trr_df['middle_initial'].str.lower()

    officer_df['last_name'] = officer_df['last_name'].str.lower()
    officer_df['first_name'] = officer_df['first_name'].str.lower()
    officer_df['middle_initial'] = officer_df['middle_initial'].str.lower()


    trr_df.drop(['id'],axis=1,inplace=True)

    df3 = trr_df.merge(officer_df, how="left",on=['last_name', 'appointed_date', 'first_name'])

    print(df3['id'])

if __name__ == '__main__':
    # typecorrection()
    integration()








