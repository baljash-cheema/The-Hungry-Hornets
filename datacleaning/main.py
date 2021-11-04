import csv

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

    officer_list=[]
    refresh_list=[]

    with open(trr_refresh) as csvfile:
        refresh_reader = csv.DictReader(csvfile)

        count = 0

        for row in refresh_reader:
            refresh_tuple = tuple()
            year = row['officer_birth_year'][0:4]
            refresh_tuple = (row['officer_last_name'].lower().strip(), row['officer_first_name'].lower().strip())
            refresh_list.append(refresh_tuple)

            # if count < 10:
            #     print('refresh tuple',refresh_tuple)
            #
            # count += 1

    with open(data_officer) as csvfile2:
        officer_reader = csv.DictReader(csvfile2)

        count = 0

        for all in officer_reader:
            officer_tuple = tuple()
            officer_tuple = ((all['last_name'].lower().strip(), all['first_name'].lower().strip()),all['id'])
            officer_list.append(officer_tuple)

            # if count < 10:
            #     print('officer_tuple',officer_tuple)
            #
            # count += 1

        id_list = list()

        for each in refresh_list:
            for all in officer_list:
                if each == all[0]:
                    id_list.append((each,all[1]))

        print(id_list)




    # for x in range(0, len(df1)):
    #     for y in range(0, len(df2)):
    #         if (df1['officer_first_name'][x] == df2['officer_first_name'][y] and df1['officer_middle_initial'][x] ==
    #                 df2['officer_middle_initial'][y]
    #                 and df1['officer_last_name'][x] == df2['officer_last_name'][y] and df1['officer_age'][x] ==
    #                 df2['officer_age'][y] and
    #                 df1['officer_race'][x] == df2['officer_race'][y]):
    #             new_id = df3['id']  # data_officer id corresponding to given first and last name?
    #             new_officer_id.append(df3['id'])  # generate column of ids which we can then merge with trr_trr_refresh

if __name__ == '__main__':
    # typecorrection()
    integration()
#Lili starter code
#For creating a new column of officer ids to link the TRR filing officers with the TRR updating officers:




