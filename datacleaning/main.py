import pandas as pd

def convert_bool(df,list):
    '''
    Takes a list of strings that are column headers, iterates through them and converts it to bool
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

if __name__ == '__main__':
    file = 'csv/postgres_public_trr_trr_refresh.csv'

    df = pd.read_csv(file)

    to_bool = ["officer_on_duty","officer_injured", "officer_in_uniform", "subject_armed", "subject_injured",
                       "subject_alleged_injury","notify_oemc","notify_district_sergeant","notify_op_command",
                       "notify_det_division"]

    to_timestamp = ['trr_datetime', 'trr_created']

    convert_bool(df,to_bool)
    convert_time(df,to_timestamp)

    print(df)