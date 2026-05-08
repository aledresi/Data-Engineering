import pandas as pd
from sqlalchemy import text
from .connection import source_engine, target_engine

def load_all_dimensions():
    print("Truncating Dimensions...")
    with target_engine.connect() as conn:
        conn.execute(text("TRUNCATE dim_date, dim_customer, dim_seller, dim_product RESTART IDENTITY CASCADE;"))
        conn.commit()

    # Date 
    print("Loading Date Dimension...")
    df_date = pd.DataFrame({"full_date": pd.date_range('2016-01-01', '2020-12-31')})
    df_date["date_key"] = df_date["full_date"].dt.strftime('%Y%m%d').astype(int)
    df_date["day"] = df_date["full_date"].dt.day
    df_date["day_name"] = df_date["full_date"].dt.day_name()
    df_date["month"] = df_date["full_date"].dt.month
    df_date["month_name"] = df_date["full_date"].dt.month_name()
    df_date["quarter"] = df_date["full_date"].dt.quarter
    df_date["year"] = df_date["full_date"].dt.year
    df_date["is_weekend"] = df_date["full_date"].dt.weekday >= 5
    df_date.to_sql('dim_date', target_engine, if_exists='append', index=False)

    # Customers
    print("Loading Customers...")
    df_cust = pd.read_sql("SELECT customer_id, customer_unique_id, customer_city as city, customer_state as state FROM customers", source_engine)
    df_cust.to_sql('dim_customer', target_engine, if_exists='append', index=False)

    # Sellers
    print("Loading Sellers...")
    df_sell = pd.read_sql("SELECT seller_id, seller_city as city, seller_state as state FROM sellers", source_engine)
    df_sell.to_sql('dim_seller', target_engine, if_exists='append', index=False)

    # Products
    print("Loading Products...")
    prod_q = """SELECT p.product_id, t.product_category_name_english as category_name_english, p.product_weight_g 
                FROM products p LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name"""
    pd.read_sql(prod_q, source_engine).to_sql('dim_product', target_engine, if_exists='append', index=False)
    
    print("✅ All Dimensions Truncated and Reloaded.")