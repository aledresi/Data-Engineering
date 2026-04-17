import requests
from bs4 import BeautifulSoup
from datetime import datetime
import pandas


URL = "https://news.ycombinator.com/"


def scrape():
    news_data = []

    response = requests.get(URL)
    soup = BeautifulSoup(response.text, "html.parser")
    titles = soup.select(".titleline > a")
    subtexts = soup.select(".subtext")

    for i in range(len(titles)):
        title = titles[i].text
        link = titles[i]["href"]
        points = subtexts[i].select_one(".score").text.replace(" points", "") if subtexts[i].select_one(".score") else ""
        comments = subtexts[i].find_all("a")[-1].text.replace("comments", "")
        time = subtexts[i].select_one(".age").text

        news_data.append({
            "Title": title,
            "Link": link,
            "Points": points if points else "",
            "Comments": comments if comments else "",
            "Publish time": time if time else "",
            "Scraped at": datetime.now().isoformat()
        })
    df = pandas.DataFrame(news_data)
    df.to_csv("data/raw_data.csv", index=False)

    print("Data scraped and saved!")


if __name__ == "__main__":
    scrape()
