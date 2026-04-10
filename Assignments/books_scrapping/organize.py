import os , shutil, pandas

df = pandas.read_csv('data/raw/books.csv')

rating_dic = {"One": 1, "Two": 2, "Three": 3, "Four": 4, "Five": 5}

for i in range(1, 6):
    os.makedirs(f'images/{i}stars', exist_ok=True)

for index, row in df.iterrows():
    src = row['img_path']
    rating = rating_dic.get(row['rating'])
    dst = f'images/{rating}stars/{os.path.basename(src)}'
    
    if os.path.exists(src):
        shutil.move(src, dst)
    else:
        print(f"Image not found: {src}")
        
print("Images are organized")