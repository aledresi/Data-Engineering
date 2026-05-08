import uvicorn
from news_scraper.scraper import scrape
from news_scraper.cleaner import clean

def main():
    print("Starting the news scraper project...")
   
    print("\n--- Step 1: Scraping Data ---")
    scrape()

    print("\n--- Step 2: Cleaning Data ---")
    clean()

    print("\n--- Step 3: Starting FastAPI Server ---")
    print("Server will be available at http://127.0.0.1:8000")
    uvicorn.run("news_scraper.fast_api:app", host="127.0.0.1", port=8000, reload=True)

if __name__ == "__main__":
    main()
