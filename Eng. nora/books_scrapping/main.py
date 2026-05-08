import os

print("Starting the scraping process...")
os.system("python scraper.py")

print("Organizing images...")
os.system("python organize.py") 

print("Processing data...")
os.system("python processor.py")

print("Pipeline completed")