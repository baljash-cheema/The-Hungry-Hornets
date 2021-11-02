import pandas as pd

if __name__ == '__main__':
    file = 'csv/postgres_public_trr_trr_refresh.csv'
    df = pd.read_csv(file)

    pd.to_datetime(df['trr_datetime'])

    df["officer_on_duty"].replace({"Yes": True, "Y": True, "No": False, "N": False}, inplace=True)
    print(df["officer_on_duty"])
    print(df["officer_on_duty"].unique())