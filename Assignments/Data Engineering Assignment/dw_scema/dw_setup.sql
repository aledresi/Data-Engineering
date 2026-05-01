-- 1. DIMENSIONS
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL,
    day INT NOT NULL,
    day_name VARCHAR(20),
    month INT NOT NULL,
    month_name VARCHAR(20),
    quarter INT NOT NULL,
    year INT NOT NULL,
    is_weekend BOOLEAN
);

CREATE TABLE dim_customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id VARCHAR(50) UNIQUE, 
    customer_unique_id VARCHAR(50),
    city VARCHAR(100),
    state CHAR(2)
);

CREATE TABLE dim_seller (
    seller_key SERIAL PRIMARY KEY,
    seller_id VARCHAR(50) UNIQUE,
    city VARCHAR(100),
    state CHAR(2)
);

CREATE TABLE dim_product (
    product_key SERIAL PRIMARY KEY,
    product_id VARCHAR(50) UNIQUE,
    category_name_english VARCHAR(100),
    product_weight_g FLOAT
);

-- 2. FACT TABLE
CREATE TABLE fact_sales_details (
    sales_sk SERIAL PRIMARY KEY,
    order_id VARCHAR(50),
    order_item_id INT,
    purchase_date DATE,
    delivery_date DATE,
    estimated_delivery_date DATE,
    shipping_limit_date DATE,
    date_key INT REFERENCES dim_date(date_key),
    customer_key INT REFERENCES dim_customer(customer_key),
    seller_key INT REFERENCES dim_seller(seller_key),
    product_key INT REFERENCES dim_product(product_key),
    item_price NUMERIC(10, 2),
    freight_value NUMERIC(10, 2),
    total_item_revenue NUMERIC(10, 2),
    delay_days INT
);