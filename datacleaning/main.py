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
        pd.to_datetime(df[each])

    return None

def convert_redact(df,list):
    '''
    Takes a list of strings that are column headers, iterates through them and converts any "redacted" entries to null.
    '''
    
    for each in list:
        df[each].replace({"REDACTED": None}, inplace=True)
    
    return None


def main():
    file = 'csv/postgres_public_trr_trr_refresh.csv'
    file2 = 'csv/postgres_public_trr_weapondischarge_refresh.csv'

    df1 = pd.read_csv(file)
    df2 = pd.read_csv(file2)

    to_bool1 = ["officer_on_duty","officer_injured", "officer_in_uniform", "subject_armed", "subject_injured",
                       "subject_alleged_injury","notify_oemc","notify_district_sergeant","notify_op_command",
                       "notify_det_division"]

    to_timestamp1 = ['trr_datetime', 'trr_created']

    to_bool2 = ['firearm_reloaded', 'sight_used']

    convert_bool(df1,to_bool1)
    convert_time(df1,to_timestamp1)
    convert_bool(df2,to_bool2)
    print(df1,df2)

if __name__ == '__main__':
    main()

# redacted function only needs to run on the columns listed
