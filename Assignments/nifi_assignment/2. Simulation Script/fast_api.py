from fastapi import FastAPI
import random
import time

app = FastAPI()

@app.get("/items")
def get_items():
    return [
        {
            "transaction_id": random.randint(1000, 9999),
            "product": "API_Item",
            "category": "Electronics",
            "price": random.choice([round(random.uniform(10, 1000), 2),None]),
            # "updated_at": time.strftime('%Y-%m-%d %H:%M:%S')
        } for _ in range(5)
    ]

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=5000)



   