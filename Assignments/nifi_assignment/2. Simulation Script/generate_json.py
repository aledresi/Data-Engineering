from datetime import datetime
import json
import random
import time
import os

os.makedirs("./transactions", exist_ok=True)

products = ["Laptop", "Phone", "Headphones", "Keyboard", "Mouse", ""]
categories = ["Electronics", "Accessories", "Computers", ""]

while True:
    price = random.choice([round(random.uniform(10, 1000), 2),None])

    data = {
        "transaction_id": random.choice([random.randint(100, 1000)]),
        "product": random.choice(products),
        "category": random.choice(categories),
        "price": price
    }
    filename = f"./transactions/transaction_{datetime.now().strftime('%Y%m%d_%H%M%S_%f')}.json"

    with open(filename, "w") as f:
        json.dump(data, f)

    print("Generated:", filename, data)
    time.sleep(2)