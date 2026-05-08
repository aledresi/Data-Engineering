import pandas as pd
from datetime import datetime, timedelta

def clean():
    df = pd.read_csv("data/raw_data.csv")

    df["Title"].drop_duplicates()
    df["Link"].drop_duplicates()
    df.dropna()

    df["Points"] = df["Points"].fillna(0).astype(int)
    df["Comments"] = (
        df["Comments"]
        .fillna("0")
        .replace("hide", "0")
        .str.replace("\xa0", " ", regex=False)  
        .str.extract(r"(\d+)")                 
        .fillna(0)
        .astype(int)
    )

    def convert_relative_time(text):
        now = datetime.now()

        if "minute" in text:
            value = int(text.split()[0])
            return now - timedelta(minutes=value)

        elif "hour" in text:
            value = int(text.split()[0])
            return now - timedelta(hours=value)

        elif "day" in text:
            value = int(text.split()[0])
            return now - timedelta(days=value)

        return now
    df["Publish time"] = df["Publish time"].apply(convert_relative_time).dt.floor("s")
    df["Scraped at"] = pd.to_datetime(df["Scraped at"]).dt.floor("s")

    df.to_csv("data/cleaned_data.csv", index=False)
    print("Data cleaned and processed!")


if __name__ == "__main__":
    clean()
    