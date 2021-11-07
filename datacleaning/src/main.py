import csv
import datetime
import numpy as np
import re
import datetime
import pandas as pd


def convert_bool(df, list):

    for each in list:
        df[each].replace({"Yes": True, "Y": True, "No": False, "N": False}, inplace=True)

    return None

def convert_time(df, list):

    for each in list:
        df[each] = pd.to_datetime(df[each], utc=True)

    return None

def typecorrection(List):
    df1 = pd.read_csv(List[0])
    df2 = pd.read_csv(List[1])
    df3 = pd.read_csv(List[2])

    to_bool1 = ["officer_on_duty", "officer_injured", "officer_in_uniform", "subject_armed", "subject_injured",
                "subject_alleged_injury", "notify_oemc", "notify_district_sergeant", "notify_op_command",
                "notify_det_division"]
    to_bool2 = ['firearm_reloaded', 'sight_used']

    to_timestamp1 = ['trr_datetime', 'trr_created']
    to_timestamp3 = ['status_datetime']

    convert_bool(df1, to_bool1)
    convert_bool(df2, to_bool2)

    convert_time(df1, to_timestamp1)
    convert_time(df3, to_timestamp3)

    df1.to_csv('csv/after_typecorrection/postgres_public_trr_trr_refresh.csv')
    df2.to_csv('csv/after_typecorrection/postgres_public_trr_weapondischarge_refresh.csv')
    df3.to_csv('csv/after_typecorrection/postgres_public_trr_trrstatus_refresh.csv')

def reconciliation(List):
    df = pd.read_csv(List[0])

    def p(x):
        print(df[x].unique())
        print(df[x].isna().sum())

    for x in df['officer_first_name']:
        y = x.split(" ")[0].capitalize()
        df['officer_first_name'] = df['officer_first_name'].replace([x], y)

    for x in df['officer_last_name']:
        y = x.split(" ")[0].capitalize()
        df['officer_last_name'] = df['officer_last_name'].replace([x], y)

    for x in df['officer_birth_year']:
        if not np.isnan(x):
            df['officer_last_name'] = df['officer_last_name'].replace([x], int(x))

    for x in df['officer_race']:
        if x == 'UNKNOWN':
            df['officer_race'] = df['officer_race'].replace([x], np.nan)
        if x == 'AMER IND/ALASKAN NATIVE':
            df['officer_race'] = df['officer_race'].replace([x], 'NATIVE AMERICAN/ALASKAN NATIVE')

    for x in df['subject_race']:
        if x == 'UNKNOWN':
            df['subject_race'] = df['subject_race'].replace([x], np.nan)
        if x == 'UNKNOWN / REFUSED':
            df['subject_race'] = df['subject_race'].replace([x], np.nan)
        if x == 'AMER IND/ALASKAN NATIVE':
            df['subject_race'] = df['subject_race'].replace([x], 'NATIVE AMERICAN/ALASKAN NATIVE')
        if x == 'AMER INDIAN / ALASKAN NATIVE':
            df['subject_race'] = df['subject_race'].replace([x], 'NATIVE AMERICAN/ALASKAN NATIVE')
        if x == 'ASIAN / PACIFIC ISLANDER':
            df['subject_race'] = df['subject_race'].replace([x], 'ASIAN/PACIFIC ISLANDER')

    for x in df['subject_gender']:
        if x == 'MALE':
            df['subject_gender'] = df['subject_gender'].replace([x], 'M')
        if x == 'FEMALE':
            df['subject_gender'] = df['subject_gender'].replace([x], 'F')

    p('officer_appointed_date')
    for x in df['officer_appointed_date']:
        if x != 'REDACTED':
            print(x)
            if x.split("-")[1].isnumeric() and len(str(x.split("-")[0])) != 4:
                d = datetime.datetime.strptime(x, "%m-%d-%y")
                df['officer_appointed_date'] = df['officer_appointed_date'].replace([x], (
                            str(d.year) + '-' + str(d.month) + '-' + str(d.day)))
            elif x.split("-")[1].isnumeric() and len(str(x.split("-")[0])) == 4:
                d = datetime.datetime.strptime(x, "%Y-%m-%d")
                df['officer_appointed_date'] = df['officer_appointed_date'].replace([x], (
                            str(d.year) + '-' + str(d.month) + '-' + str(d.day)))
            elif not x.split("-")[1].isnumeric():
                d = datetime.datetime.strptime(x, "%Y-%b-%d")
                df['officer_appointed_date'] = df['officer_appointed_date'].replace([x], (
                            str(d.year) + '-' + str(d.month) + '-' + str(d.day)))

    for x in df['officer_appointed_date']:
        if x != 'REDACTED':
            if int(x.split("-")[0]) > 2021:
                d = datetime.datetime.strptime(x, "%Y-%m-%d")
                df['officer_appointed_date'] = df['officer_appointed_date'].replace([x], (
                            str(d.year - 100) + '-' + str(d.month) + '-' + str(d.day)))

    p('subject_birth_year')
    for x in df['subject_birth_year']:
        if len(str(x)) == 2:
            if x > 5 and x < 100:
                y = int('19' + str(x))
            df['subject_birth_year'] = df['subject_birth_year'].replace([int(x)], int(y))
        if len(str(x)) == 1:
            x = '0' + str(x)
            d = datetime.datetime.strptime(x, "%y")
            df['subject_birth_year'] = df['subject_birth_year'].replace([int(x)], int(d.year))
        if len(str(x)) == 3:
            y = '1' + str(x)
            df['subject_birth_year'] = df['subject_birth_year'].replace([int(x)], int(y))

    p('indoor_or_outdoor')
    for x in df['indoor_or_outdoor']:
        if x == 'OUTDOOR':
            df['indoor_or_outdoor'] = df['indoor_or_outdoor'].replace([x], 'Outdoor')
        if x == 'INDOOR':
            df['indoor_or_outdoor'] = df['indoor_or_outdoor'].replace([x], 'Indoor')
    p('indoor_or_outdoor')

    df.to_csv('csv/after_recon/postgres_public_trr_trr_refresh.csv')

    df = pd.read_csv(List[1])

    for x in df['officer_first_name']:
        y = x.split(" ")[0].capitalize()
        df['officer_first_name'] = df['officer_first_name'].replace([x], y)

    for x in df['officer_last_name']:
        y = x.split(" ")[0].capitalize()
        df['officer_last_name'] = df['officer_last_name'].replace([x], y)

    for x in df['officer_birth_year']:
        if not np.isnan(x):
            df['officer_birth_year'] = df['officer_birth_year'].replace([x], int(x))

    for x in df['officer_race']:
        if x == 'UNKNOWN':
            df['officer_race'] = df['officer_race'].replace([x], np.nan)
        if x == 'AMER IND/ALASKAN NATIVE':
            df['officer_race'] = df['officer_race'].replace([x], 'NATIVE AMERICAN/ALASKAN NATIVE')

    for x in df['officer_gender']:
        if x == 'MALE':
            df['officer_gender'] = df['officer_gender'].replace([x], 'M')
        if x == 'FEMALE':
            df['officer_gender'] = df['officer_gender'].replace([x], 'F')

    for x in df['officer_appointed_date']:
        if x != 'REDACTED':
            if x.split("-")[1].isnumeric() and len(str(x.split("-")[0])) != 4:
                d = datetime.datetime.strptime(x, "%m-%d-%y")
                df['officer_appointed_date'] = df['officer_appointed_date'].replace([x], (
                            str(d.year) + '-' + str(d.month) + '-' + str(d.day)))
            elif x.split("-")[1].isnumeric() and len(str(x.split("-")[0])) == 4:
                d = datetime.datetime.strptime(x, "%Y-%m-%d")
                df['officer_appointed_date'] = df['officer_appointed_date'].replace([x], (
                            str(d.year) + '-' + str(d.month) + '-' + str(d.day)))
            elif not x.split("-")[1].isnumeric():
                d = datetime.datetime.strptime(x, "%Y-%b-%d")
                df['officer_appointed_date'] = df['officer_appointed_date'].replace([x], (
                            str(d.year) + '-' + str(d.month) + '-' + str(d.day)))

    for x in df['officer_appointed_date']:
        if x != 'REDACTED':
            if int(x.split("-")[0]) > 2021:
                d = datetime.datetime.strptime(x, "%Y-%m-%d")
                print(1)
                print(x, str(d.year - 100) + '-' + str(d.month) + '-' + str(d.day))
                df['officer_appointed_date'] = df['officer_appointed_date'].replace([x], (
                            str(d.year - 100) + '-' + str(d.month) + '-' + str(d.day)))

    df.to_csv('csv/after_recon/postgres_public_trr_trrstatus_refresh.csv')
    df = pd.read_csv("csv/original/postgres_public_trr_trrstatus_refresh.csv")

    for x in df['officer_first_name']:
      y=x.split(" ")[0].capitalize()
      df['officer_first_name'] = df['officer_first_name'].replace([x],y)
    print(df['officer_first_name'])

    for x in df['officer_last_name']:
      y=x.split(" ")[0].capitalize()
      df['officer_last_name'] = df['officer_last_name'].replace([x],y)
    print(df['officer_last_name'])

    for x in df['officer_race']:
      y=x.split(" ")[0].capitalize()
      df['officer_race'] = df['officer_race'].replace([x],y)
    print(df['officer_last_name'])

    for x in df['officer_appointed_date']:
        if x!='REDACTED':
            print(x)
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

    for x in df['officer_race']:
      if x=='UNKNOWN':
        df['officer_race'] = df['officer_race'].replace([x], np.nan)
      if x=='AMER IND/ALASKAN NATIVE':
        df['officer_race'] = df['officer_race'].replace([x], 'Native American/alaskan Native')
      y=x.split(" ")[0].capitalize()
      df['officer_race'] = df['officer_race'].replace([x],y)

    df.to_csv('csv/after_recon/trr_status_0.csv')


def integration(List):
    trr_df = pd.read_csv(List[2]) #status refresh
    officer_df = pd.read_csv(List[1])

    trr_df['officer_appointed_date'].replace({'REDACTED': None},inplace =True)

    df = pd.merge(trr_df, officer_df,  how='left', left_on=['officer_first_name', 'officer_last_name'],
                       right_on=['first_name', 'last_name']).fillna("None")

    df8 = df[df['id'] != 'None'].reset_index(drop=True)
    df4 = df[df['id'] == 'None'][trr_df.columns.values.tolist()].reset_index(drop=True)
    df4['officer_birth_year'] = df4['officer_birth_year'].apply(pd.to_numeric, errors='coerce')

    df1 = pd.merge(df4, officer_df, how='left',
                       left_on=['officer_first_name', 'officer_race', 'officer_last_name', 'officer_appointed_date', 'officer_birth_year', 'officer_gender'],
                       right_on=['first_name', 'race', 'last_name', 'appointed_date', 'birth_year',
                                 'gender']).fillna("None")

    df6 = df1[df1['id'] != 'None'].reset_index(drop=True)
    df4 = df1[df1['id'] == 'None'][trr_df.columns.values.tolist()].reset_index(drop=True)

    df4['officer_birth_year'] = df4['officer_birth_year'].apply(pd.to_numeric, errors='coerce')

    df2 = pd.merge(df4, officer_df, how='left',
                       left_on=['officer_first_name', 'officer_race', 'officer_last_name', 'officer_birth_year', 'officer_gender'],
                       right_on=['first_name', 'race', 'last_name', 'birth_year', 'gender']).fillna("None")
    p3 = df2[df2['id'] != 'None'].reset_index(drop=True)
    no_p3 = df2[df2['id'] == 'None'][trr_df.columns.values.tolist()].reset_index(drop=True)

    no_p3['officer_birth_year'] = no_p3['officer_birth_year'].apply(pd.to_numeric, errors='coerce')

    df3 = pd.merge(no_p3, officer_df, how='left', left_on=['officer_first_name', 'officer_race', 'officer_last_name', 'officer_gender'],
                       right_on=['first_name', 'race', 'last_name', 'gender']).fillna("None")

    p4 = df3[df3['id'] != 'None'].reset_index(drop=True)
    p5 = df3[df3['id'] == 'None'].reset_index(drop=True)

    final_trr_status_cleaned = pd.concat([df8, df6, p3, p4, p5])
    final_trr_status_cleaned = final_trr_status_cleaned[['officer_rank', 'officer_star', 'status', 'status_datetime', 'officer_age', 'officer_unit_at_incident',
         'trr_report_id','id']]

    final_trr_status_cleaned.to_csv('csv/after_integration/postgres_public_trr_trrstatus_refresh.csv') #trr_trrstatus

    trr_df = pd.read_csv(List[0])
    officer_df = pd.read_csv(List[1])
    trr_df = trr_df.rename(columns={'id': 'trr_id'})

    trr_df['officer_appointed_date'].replace({'REDACTED': None}, inplace=True)
    #'officer_first_name', 'officer_middle_initial', 'officer_last_name', 'officer_middle_initial', 'officer_appointed_date', 'officer_birth_year', 'officer_gender', 'officer_race'],
    #'first_name','middle_initial','last_name','suffix_name','appointed_date','birth_year','gender','race'])

    df = pd.merge(trr_df, officer_df, how='left',
                  left_on=['officer_first_name','officer_last_name'
                           ],
                  right_on=['first_name','last_name']).fillna("None")
    df9 = df[df['id'] != 'None'].reset_index(drop=True)
    df4 = df[df['id'] == 'None'][trr_df.columns.values.tolist()].reset_index(drop=True)
    df4['officer_birth_year'] = df4['officer_birth_year'].apply(pd.to_numeric, errors='coerce')

    df1 = pd.merge(df4, officer_df, how='left',
                   left_on=['officer_first_name', 'officer_race', 'officer_last_name', 'officer_appointed_date',
                            'officer_birth_year', 'officer_gender'],
                   right_on=['first_name', 'race', 'last_name', 'appointed_date', 'birth_year',
                             'gender']).fillna("None")

    df6 = df1[df1['id'] != 'None'].reset_index(drop=True)
    df4 = df1[df1['id'] == 'None'][trr_df.columns.values.tolist()].reset_index(drop=True)

    df4['officer_birth_year'] = df4['officer_birth_year'].apply(pd.to_numeric, errors='coerce')

    df2 = pd.merge(df4, officer_df, how='left',
                   left_on=['officer_first_name', 'officer_race', 'officer_last_name', 'officer_birth_year',
                            'officer_gender'],
                   right_on=['first_name', 'race', 'last_name', 'birth_year', 'gender']).fillna("None")
    p3 = df2[df2['id'] != 'None'].reset_index(drop=True)
    no_p3 = df2[df2['id'] == 'None'][trr_df.columns.values.tolist()].reset_index(drop=True)

    no_p3['officer_birth_year'] = no_p3['officer_birth_year'].apply(pd.to_numeric, errors='coerce')

    df3 = pd.merge(no_p3, officer_df, how='left',
                   left_on=['officer_first_name', 'officer_race', 'officer_last_name', 'officer_gender'],
                   right_on=['first_name', 'race', 'last_name', 'gender']).fillna("None")

    p4 = df3[df3['id'] != 'None'].reset_index(drop=True)
    p5 = df3[df3['id'] == 'None'].reset_index(drop=True)

    final_trr_cleaned = pd.concat([df9, df6, p3, p4, p5])
    final_trr_cleaned = final_trr_cleaned[['trr_id','id', 'event_number', 'cr_number', 'beat', 'block', 'direction',
                                           'street', 'location', 'trr_datetime',
                                           'indoor_or_outdoor', 'lighting_condition', 'weather_condition',
                                           'notify_oemc', 'notify_district_sergeant', 'notify_op_command',
                                           'notify_det_division', 'party_fired_first', 'officer_assigned_beat',
                                           'officer_on_duty', 'officer_in_uniform', 'officer_injured',
                                           'officer_rank', 'subject_armed', 'subject_injured',
                                           'subject_alleged_injury', 'subject_age', 'subject_birth_year',
                                           'subject_gender', 'subject_race', 'officer_age',
                                           'officer_unit_name', 'officer_unit_detail',
                                           'trr_created', 'latitude', 'longitude', 'point']]
    final_trr_cleaned = final_trr_cleaned.reset_index(drop=True)
    final_trr_cleaned.to_csv('csv/after_integration/postgres_public_trr_trr_refresh.csv') #trr_refresh

    unit_info=pd.read_csv('csv/original/postgres_public_data_policeunit.csv')

    for i in range(len(final_trr_cleaned['officer_unit_name'])):
        print("Working")
        if len(final_trr_cleaned['officer_unit_name'][i]) == 3:
            final_trr_cleaned['officer_unit_name'][i] = int(final_trr_cleaned['officer_unit_name'][i])
        elif len(final_trr_cleaned['officer_unit_name'][i]) == 2:
            final_trr_cleaned['officer_unit_name'][i] = int('0' + final_trr_cleaned['officer_unit_name'][i])
        elif len(final_trr_cleaned['officer_unit_name'][i]) == 1:
            final_trr_cleaned['officer_unit_name'][i] = int('00' + final_trr_cleaned['officer_unit_name'][i])

    new_df_unit_id = pd.merge(final_trr_cleaned, unit_info, how='left', left_on='officer_unit_name',
                              right_on='unit_name').fillna("None")
    print(new_df_unit_id.columns)
    new_df_unit_id = new_df_unit_id[['trr_id', 'event_number', 'cr_number', 'beat', 'block', 'direction',
                                     'street', 'location', 'trr_datetime', 'indoor_or_outdoor',
                                     'lighting_condition', 'weather_condition', 'notify_oemc',
                                     'notify_district_sergeant', 'notify_op_command', 'notify_det_division',
                                     'party_fired_first', 'officer_assigned_beat', 'officer_on_duty',
                                     'officer_in_uniform', 'officer_injured', 'officer_rank',
                                     'subject_armed', 'subject_injured', 'subject_alleged_injury',
                                     'subject_age', 'subject_birth_year', 'subject_gender', 'subject_race',
                                     'officer_age', 'officer_unit_name', 'officer_unit_detail',
                                     'trr_created', 'latitude', 'longitude', 'point', 'id_y', 'description']]
    new_df_unit_id = new_df_unit_id.rename(columns={'id': 'officer_unit_id', 'description': 'officer_unit_detail_id'})
    new_df_unit_id.to_csv('csv/after_integration/postgres_public_data_policeunit.csv')

def redact(List):

    df1 = pd.read_csv(List[0])
    df2 = pd.read_csv(List[1])
    df3 = pd.read_csv(List[2])

    to_null1 = ['trr_datetime', 'beat', 'officer_appointed_date', 'officer_birth_year', 'officer_age',
                'officer_on_duty',
                'officer_injured', 'officer_in_uniform', 'subject_birth_year', 'subject_age', 'subject_armed',
                'subject_injured',
                'subject_alleged_injury', 'notify_oemc', 'notify_district_sergeant', 'notify_op_command',
                'notify_det_division',
                'trr_created']
    to_null2 = ['firearm_reloaded', 'sight_used']
    to_null3 = ['officer_appointed_date', 'officer_birth_year', 'status_datetime']

    for each in to_null1:
        df1[each].replace({"REDACTED": None}, inplace=True)

    for each in to_null2:
        df2[each].replace({"REDACTED": None}, inplace=True)

    for each in to_null3:
        df3[each].replace({"REDACTED": None}, inplace=True)

    df1.to_csv('src/csv/after_redact/postgres_public_trr_trr_refresh.csv')
    df2.to_csv('src/csv/after_redact/postgres_public_trr_weapondischarge_refresh.csv')
    df3.to_csv('src/csv/after_redact/postgres_public_trr_trrstatus_refresh.csv')

if __name__ == '__main__':
    #Type correct after OpenRefine
    file1 = 'csv/after_openrefine/postgres_public_trr_trr_refresh.csv'
    file2 = 'csv/original/postgres_public_trr_weapondischarge_refresh.csv'
    file3 = 'csv/after_openrefine/postgres_public_trr_trrstatus_refresh.csv'
    type_correct_list = [file1, file2, file3]

    # typecorrection(type_correct_list)

    #Reconciliation next
    file1 = 'csv/after_typecorrection/postgres_public_trr_trr_refresh.csv' # changed to original files
    file2 = 'csv/after_typecorrection/postgres_public_trr_trrstatus_refresh.csv' # changed to original files
    recon_list = [file1, file2]

    # reconciliation(recon_list)

    # #Redact correction -> when to do this? perhaps this needs to get at the very end?
    # file1 = 'src/csv/after_recon/postgres_public_trr_trr_refresh.csv'
    # file2 = 'src/csv/after_typecorrection/postgres_public_trr_weapondischarge_refresh.csv'
    # file3 = 'src/csv/after_recon/postgres_public_trr_trrstatus_refresh.csv'
    # redact_list = [file1,file2,file3]

    #Integration next
    file1 = 'csv/after_recon/postgres_public_trr_trr_refresh.csv'
    file2 = 'csv/original/postgres_public_data_officer.csv'
    file3 = 'csv/after_recon/postgres_public_trr_trrstatus_refresh.csv'

    integration_list = [file1,file2,file3]

    integration(integration_list)


# need to do redact
# need to rename and reorder dataframes
# put in output
# readme

'''
trr_trr(id, crid, event_id, beat, block, direction, street, location, trr_datetime, indoor_or_outdoor, lighting_condition, weather_condition, notify_OEMC, notify_district_sergeant, notify_OP_command, notify_DET_division, party_fired_first, officer_assigned_beat, officer_on_duty, officer_in_uniform, officer_injured, officer_rank, subject_armed, subject_injured, subject_alleged_injury, subject_age, subject_birth_year, subject_gender, subject_race, officer_id, officer_unit_id, officer_unit_detail_id, point)


trr_trrstatus(rank, star, status, status_datetime, officer_id, trr_id);

trr_actionresponse(person, resistance_type, action, other_description, trr_id);
-trr_report_id -> trr_id

trr_charge(statute, description, subject_no, trr_id);
-drop trr_rd_no
-trr_report_id -> trr_id

trr_weapondischarge(weapon_type,weapon_type_description,firearm_make,firearm_model,firearm_barrel_length,firearm_caliber,total_number_of_shots,firearm_reloaded,number_of_cartridge_reloaded,handgun_worn_type,handgun_drawn_type,method_used_to_reload,sight_used,protective_cover_used,discharge_distance,object_struck_of_discharge,discharge_position,trr_id);
-drop unnamed 
-trr_report_id -> trr_id

trr_subjectweapon(weapon_type, firearm_caliber, weapon_description, trr_id);
trr_report_id -> trr_id
'''