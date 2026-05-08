import schedule
import time
from pipeline.dimensions import load_all_dimensions
from pipeline.fact import load_fact

def run_pipeline():
    start_time = time.time()
    print(f"\nExecution Started at: {time.strftime('%Y-%m-%d %H:%M:%S')}")
    print("--- Starting ETL Pipeline (Full Truncate & Load) ---")
    
    try:
        load_all_dimensions()
        load_fact()
        
        end_time = time.time()
        duration = round(end_time - start_time, 2)
        print(f"Pipeline took {duration} seconds")
        
    except Exception as e:
        print(f"Pipeline Failed: {e}")

run_pipeline()

schedule.every(1).hour.do(run_pipeline)
print("⏳ Scheduler Initialized: Running every 1 hour...")
while True:
    schedule.run_pending()
    time.sleep(1)