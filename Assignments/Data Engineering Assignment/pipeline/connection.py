from sqlalchemy import create_engine

source_engine = create_engine(f'sqlite:///source/olist.sqlite')
target_engine = create_engine(f'postgresql://postgres:admin@localhost:5432/e-commerce_dw')