# Extract-Load-and-Analyze

## Objective: 
The primary objective of this Extract and Load (EL) project is to efficiently extract data from an AWS RDS PostgreSQL database, perform minimal data transformation, and load it into Google BigQuery. The project aims to support analysis needs and fulfill business requirements using the small dataset that was generated by myself. Subsequently, the analysis is conducted using SQL in BigQuery, and the results are visualized using Looker Studio.

## Tools and Technology Used:
- __Cloud Service:__ - AWS (RDS for PostgreSQL), Google Cloud Platform (BigQuery), Google cloud Storage
- __Programming Language:__ Python
- __Database Connectivity:__ psycopg2 (Python library for PostgreSQL)
- __Data Processing:__  Pandas for minimal data transformation, SQL (for analysis in BigQuery)
- __Visualization:__  Looker Studio
  
## Architecture Diagram:
![EL](https://github.com/Abdur131054/Extract-Load-and-Analyze/assets/28232003/3f19370c-b93b-4902-8f55-e50fb548e364)
## Steps:
- __RDS Instance:__ First i created RDS Instance in AWS and make a database using PostgreSQL and create four tables and Inserted data. Small size Data was randomely generated by myself.
- __Create Bucket:__ Created a project on Google cloud and then i created a bucket on google cloud storage for temporarily store the data.
- __Service Account Creation:__ Created a service account for further accessing to this project giving role as a bigquery admin.
- __Dataset creation on BigQuery:__ created a dataset on google bigquery
- __Database Connection:__ Establish a connection to the PostgreSQL database on AWS RDS using psycopg2.
  
  ```rds_conn = psycopg2.connect(
    host="bde3-project.cqcqebjkmcrf.us-east-1.rds.amazonaws.com",
    database="abdur",
    user="abdur",
    password="*******"
   )
  ```
- __Data Extraction:__ Define SQL queries to select all columns from tables and use pd.read_sql to read the query results into Pandas DataFrames.
  
  ```sql_query_Products = "SELECT * FROM Products"
  sql_query_Customers = "SELECT * FROM Customers"
  sql_query_Orders = "SELECT * FROM Orders"
  sql_query_OrderDetails = "SELECT * FROM OrderDetails"

  df_Products = pd.read_sql(sql_query_Products, rds_conn)
  df_Customers = pd.read_sql(sql_query_Customers, rds_conn)
  df_Orders = pd.read_sql(sql_query_Orders, rds_conn)
  df_OrderDetails = pd.read_sql(sql_query_OrderDetails, rds_conn)
  ```
- __Export Dataframe to CSV:__ Save the DataFrames as CSV files
  ```df_Products.to_csv('Products.csv', index=False)
  df_Customers.to_csv('Customers.csv', index=False)
  df_Orders.to_csv('Orders.csv', index=False)
  df_OrderDetails.to_csv('OrderDetails.csv', index=False)
  ```
- __Upload CSV to cloud storage:__ Upload CSV files to Google Cloud Storage.
   ```
   project_id = 'etl-bde3'
   bucket_name = 'bde3-de-project'
   storage_client = storage.Client()

   for file_name in files_to_upload:
   blob_name = file_name
   blob = storage_client.bucket(bucket_name).blob(blob_name)
   blob.upload_from_filename(file_name)
   print(f"File {file_name} uploaded to GCS bucket {bucket_name}.")
   ```
- __BigQuery Setup and Data Loading:__ Create a BigQuery dataset and load each CSV file into a table
   ```
   project_id = 'etl-bde3'
   dataset_id = 'etl_bde3_data'
   igquery_client = bigquery.Client(project=project_id)

   for file_name in files_to_upload:
   table_id = f'{file_name.split(".")[0]}'
   table_ref = dataset_ref.table(table_id)

   try:
        bigquery_client.get_table(table_ref)
   except Exception as e:
        # Table not found, create it
        print(f"Table '{table_id}' not found. Error: {e}")
        print(f"Creating table '{table_id}' in dataset '{dataset_id}'.")
        # Define table schema and create an empty table
        table = bigquery.Table(table_ref)
        bigquery_client.create_table(table)

    uri = f"gs://{bucket_name}/{file_name}"
    load_job = bigquery_client.load_table_from_uri(uri, table_ref, job_config=job_config)

    print(f"Starting job {load_job.job_id}")
    load_job.result()
    print(f"Job finished. Loaded {load_job.output_rows} rows into {dataset_id}:{table_id}.")

    print("Data loading and table creation completed successfully.")
   ```
- __Analysis with SQL:__ Write SQL queries in BigQuery to perform various analyses on the loaded data. Examples include identifying top revenue-generating categories, finding top and bottom products, analyzing sales trends, calculating customer lifetime value, and more.
- __Visualization with Looker Studio:__ Utilize Looker Studio to create visualizations based on the SQL analysis. Construct meaningful charts, graphs, and dashboards to present insights derived from the dataset.
![Dashboard](https://github.com/Abdur131054/Extract-Load-and-Analyze/assets/28232003/60e7c4b9-462d-4f69-a997-4205280ce4bb)


