import csv
import datetime
import numpy as np
import re
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

def reconciliation():
    trr_refresh = 'csv/postgres_public_trr_trr_refresh.csv'
    df = pd.read_csv(trr_refresh)

    def p(x):
      print(df[x].unique())
      print(df[x].isna().sum())
    for x in df['officer_first_name']:
      y=x.split(" ")[0].capitalize()
      df['officer_first_name'] = df['officer_first_name'].replace([x],y)

    for x in df['officer_last_name']:
      y=x.split(" ")[0].capitalize()
      df['officer_last_name'] = df['officer_last_name'].replace([x],y)

    for x in df['officer_birth_year']:
      if not np.isnan(x):
        df['officer_last_name'] = df['officer_last_name'].replace([x], int(x))

    for x in df['officer_race']:
      if x=='UNKNOWN':
        df['officer_race'] = df['officer_race'].replace([x], np.nan)
      if x=='AMER IND/ALASKAN NATIVE':
        df['officer_race'] = df['officer_race'].replace([x], 'NATIVE AMERICAN/ALASKAN NATIVE')

    for x in df['subject_race']:
      if x=='UNKNOWN':
        df['subject_race'] = df['subject_race'].replace([x], np.nan)
      if x=='UNKNOWN / REFUSED':
        df['subject_race'] = df['subject_race'].replace([x], np.nan)
      if x=='AMER IND/ALASKAN NATIVE':
        df['subject_race'] = df['subject_race'].replace([x], 'NATIVE AMERICAN/ALASKAN NATIVE')
      if x=='AMER INDIAN / ALASKAN NATIVE':
        df['subject_race'] = df['subject_race'].replace([x], 'NATIVE AMERICAN/ALASKAN NATIVE')
      if x=='ASIAN / PACIFIC ISLANDER':
        df['subject_race'] = df['subject_race'].replace([x], 'ASIAN/PACIFIC ISLANDER')

    #pd=pd.to_numeric(df['subject_gender'], errors='coerce')
    for x in df['subject_gender']:
      if x=='MALE':
        df['subject_gender'] = df['subject_gender'].replace([x], 'M')
      if x=='FEMALE':
        df['subject_gender'] = df['subject_gender'].replace([x], 'F')

    p('officer_appointed_date')
    for x in df['officer_appointed_date']:
        if x!='REDACTED':
            if x.split("-")[1].isnumeric() and len(str(x.split("-")[0]))!=4:
                d=datetime.datetime.strptime(x,"%m-%d-%y")
                df['officer_appointed_date'] = df['officer_appointed_date'].replace([x], (str(d.year)+'-'+str(d.month)+'-'+str(d.day)))
            elif x.split("-")[1].isnumeric() and len(str(x.split("-")[0]))==4:
                d=datetime.datetime.strptime(x,"%Y-%m-%d")
                df['officer_appointed_date'] = df['officer_appointed_date'].replace([x], (str(d.year)+'-'+str(d.month)+'-'+str(d.day)))
            elif not x.split("-")[1].isnumeric():
                d = datetime.datetime.strptime(x, "%Y-%b-%d")
                df['officer_appointed_date'] = df['officer_appointed_date'].replace([x], (str(d.year)+'-'+str(d.month)+'-'+str(d.day)))
    for x in df['officer_appointed_date']:
        if x!='REDACTED':
            if int(x.split("-")[0])>2021:
                d = datetime.datetime.strptime(x, "%Y-%m-%d")
                df['officer_appointed_date'] = df['officer_appointed_date'].replace([x], (str(d.year-100)+'-'+str(d.month)+'-'+str(d.day)))
    p('subject_birth_year')
    for x in df['subject_birth_year']:
        if len(str(x))==2:
            if x>5 and x<100:
                y=int('19'+str(x))
            df['subject_birth_year'] = df['subject_birth_year'].replace([int(x)], int(y))
        if len(str(x))==1:
            x='0'+str(x)
            d = datetime.datetime.strptime(x, "%y")
            df['subject_birth_year'] = df['subject_birth_year'].replace([int(x)],int(d.year))
        if len(str(x))==3:
            y='1'+str(x)
            df['subject_birth_year'] = df['subject_birth_year'].replace([int(x)],int(y))

    p('indoor_or_outdoor')
    for x in df['indoor_or_outdoor']:
        if x=='OUTDOOR':
            df['indoor_or_outdoor'] = df['indoor_or_outdoor'].replace([x], 'Outdoor')
        if x=='INDOOR':
            df['indoor_or_outdoor'] = df['indoor_or_outdoor'].replace([x], 'Indoor')
    p('indoor_or_outdoor')

    df.to_csv('recon_output.csv')

def integration():
    trr_refresh = 'recon_output.csv'
    data_officer = 'csv/postgres_public_data_officer.csv'

    trr_df = pd.read_csv(trr_refresh)
    officer_df = pd.read_csv(data_officer)

    # trr_df.rename(columns={'officer_last_name' : 'last_name','officer_first_name' : 'first_name', 'officer_middle_initial' : 'middle_initial',
    #                        'officer_appointed_date' : 'appointed_date'},inplace=True)
    #
    # trr_df.drop(['id'],axis=1,inplace=True)
    #
    # df3 = trr_df.merge(officer_df, how="left",on=['last_name', 'middle_initial', 'first_name'])
    #
    # print(df3.head())

    trr_df.drop(['id'],axis=1,inplace=True)

    trr_list = list()
    officer_list = list()

    for index,row in trr_df.iterrows():
        ident = row['officer_first_name'] + row['officer_last_name'] + row['officer_appointed_date']
        trr_list.append(ident)

    for index,row in officer_df.iterrows():
        ident = str(row['first_name']) + str(row['last_name']) + str(row['appointed_date'])
        officer_list.append(ident)

    trr_df['ident'] = trr_list
    officer_df['ident'] = officer_list

    df3 = trr_df.merge(officer_df, how="left",on=['ident'])

    print(df3['id'].isnull().sum())

    print(trr_df['officer_first_name'].isnull().sum())
    print(trr_df['officer_last_name'].isnull().sum())
    print(trr_df['officer_appointed_date'].isnull().sum())
    print(trr_df['officer_birth_year'].isnull().sum())

    print(officer_df['first_name'].isnull().sum())
    print(officer_df['last_name'].isnull().sum())
    print(officer_df['appointed_date'].isnull().sum())
    print(officer_df['birth_year'].isnull().sum())

    # print(df3['id'].isnull().sum())
    # print(officer_df['appointed_date'].isnull().sum())
    #
    # df3.to_csv('integration.csv')

if __name__ == '__main__':
    # typecorrection()
    integration()
    # reconciliation()









