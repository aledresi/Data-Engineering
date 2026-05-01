import pandas as pd
from .connection import source_engine, target_engine

def load_fact():
    print("Preparing Fact Table...")
    # Extract
    query = """
    SELECT i.order_id, i.order_item_id, i.product_id, i.seller_id, o.customer_id, 
           o.order_purchase_timestamp, o.order_delivered_customer_date,
           o.order_estimated_delivery_date, i.shipping_limit_date, i.price, i.freight_value
    FROM order_items i JOIN orders o ON i.order_id = o.order_id
    """
    df = pd.read_sql(query, source_engine)

    # Transform
    df['order_purchase_timestamp'] = pd.to_datetime(df['order_purchase_timestamp'])
    df['order_delivered_customer_date'] = pd.to_datetime(df['order_delivered_customer_date'])
    df['order_estimated_delivery_date'] = pd.to_datetime(df['order_estimated_delivery_date'])
    
    df['total_item_revenue'] = df['price'] + df['freight_value']
    # If delivery_date is null, delay remains null
    df['delay_days'] = (df['order_delivered_customer_date'] - df['order_estimated_delivery_date']).dt.days
    df['date_key'] = df['order_purchase_timestamp'].dt.strftime('%Y%m%d').fillna(0).astype(int)

    # Lookup Keys from PG (Essential for Star Schema)
    d_cust = pd.read_sql("SELECT customer_key, customer_id FROM dim_customer", target_engine)
    d_sell = pd.read_sql("SELECT seller_key, seller_id FROM dim_seller", target_engine)
    d_prod = pd.read_sql("SELECT product_key, product_id FROM dim_product", target_engine)

    df = df.merge(d_cust, on='customer_id').merge(d_sell, on='seller_id').merge(d_prod, on='product_id')

    # Column Mapping to match DW
    final_cols = {
        'order_purchase_timestamp': 'purchase_date',
        'order_delivered_customer_date': 'delivery_date',
        'order_estimated_delivery_date': 'estimated_delivery_date',
        'price': 'item_price'
    }
    
    df_final = df.rename(columns=final_cols)[[
        'order_id', 'order_item_id', 'purchase_date', 'delivery_date', 
        'estimated_delivery_date', 'date_key', 'customer_key', 'seller_key', 
        'product_key', 'item_price', 'freight_value', 'total_item_revenue', 'delay_days'
    ]]

    # Load
    df_final.to_sql('fact_sales_details', target_engine, if_exists='append', index=False, chunksize=1000)
    print(f"✅ Fact Table Loaded ({len(df_final)} rows).")