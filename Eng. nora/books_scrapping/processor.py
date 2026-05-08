import pandas, os

os.makedirs('data/processed', exist_ok=True)

df = pandas.read_csv('data/raw/books.csv')

df= df.drop_duplicates()

df['price'] = df['price'].fillna(df['price'].mean())

summary = df.groupby('rating')['price'].agg(['mean', 'count'])

df.to_csv('data/processed/cleaned_books.csv', index=False)
summary.to_csv('data/processed/summary.csv')

print("Data is processed and saved")