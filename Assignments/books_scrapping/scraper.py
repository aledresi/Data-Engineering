import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin
import os
import re 
import pandas as pd

os.makedirs('data/raw', exist_ok=True)
os.makedirs('images', exist_ok=True)
raw_books = []
base_url = "https://books.toscrape.com/catalogue/page-1.html"
url = base_url

while url :
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    books = soup.find_all('article', class_ = 'product_pod')



    for book in books:
        title = book.h3.a['title']
        price = book.find('p', attrs={'class': 'price_color'}).text
        rating = book.find('p', class_ = 'star-rating')['class'][1]
  

        img_src = book.find('img')['src']
        img_url = urljoin(url, img_src)
        img_content = requests.get(img_url).content
        
        clean_title = re.sub(r'[\\/*?:"<>|]', "", title)[:50]
        img_path = f'images/{clean_title}.png'
        
        with open (img_path, 'wb') as img_file:
            img_file.write(img_content)

        raw_books.append({
            'title': title,
            'price': float(re.sub(r'[^0-9.]', '', price)),
            'rating': rating,
            'img_path': img_path
        })

    print(raw_books)

    next_btn = soup.find('li', class_ = 'next')
    if next_btn :
        url = urljoin(url, next_btn.a['href'])
    else:
        break


df = pd.DataFrame(raw_books)
df.to_csv('data/raw/books.csv', index=False)

print("Scraping completed and data saved")