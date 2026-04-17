from fastapi import FastAPI
import pandas as pd

app = FastAPI()

df = pd.read_csv("data/cleaned_data.csv")

def load_news():
   return df.to_dict(orient="records")
    

@app.get("/")
def home():
    return {"message": "Welcome to the Hacking & Programming News"}

@app.get("/news")
def get_news():
    return load_news()

@app.get("/news/top")
def get_top_news():
    top_news = df.sort_values(by="Points", ascending=False).head(5)
    return top_news.to_dict(orient="records")