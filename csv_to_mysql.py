import pandas as pd
import mysql.connector
from mysql.connector import Error
from datetime import datetime

# Load CSV data into the DataFrame
df = pd.read_csv('layoffs.csv')

# Database connection configuration
config = {
    'user': 'root',
    'password': 'XXXXXXXX',
    'host': 'localhost',
    'database': 'world_layoffs',
}

# Create a connection to the MySQL database
try:
    connection = mysql.connector.connect(**config)
    if connection.is_connected():
        cursor = connection.cursor()

        # Create the table if it does not exist
        create_table_query = """
        CREATE TABLE IF NOT EXISTS layoff_data (
            id INT AUTO_INCREMENT PRIMARY KEY,
            company VARCHAR(255),
            location VARCHAR(255),
            industry VARCHAR(255),
            total_laid_off INT,
            percentage_laid_off FLOAT,
            date DATE,
            stage VARCHAR(255),
            country VARCHAR(255),
            funds_raised_millions INT
        )
        """
        cursor.execute(create_table_query)
        
        # Insert data
        insert_query = """
        INSERT INTO layoff_data (company, location, industry, total_laid_off, percentage_laid_off, date, stage, country,funds_raised_millions)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        df = df.where(pd.notna(df), None)

        for index, row in df.iterrows():
            data = (
                row['company'],
                row['location'],
                row['industry'],
                row['total_laid_off'] if pd.notna(row['total_laid_off']) else None,
                row['percentage_laid_off'] if pd.notna(row['percentage_laid_off']) else None,
                datetime.strptime(str(row['date']), '%m/%d/%Y').strftime('%Y-%m-%d') if pd.notna(row['date']) else None,
                row['stage'],
                row['country'],
                row['funds_raised_millions'] if pd.notna(row['funds_raised_millions']) else None
            )
            cursor.execute(insert_query, data)
        
       
        connection.commit()
        print("Data inserted successfully.")

except Error as e:
    print(f"Error: {e}")

finally:
    if connection.is_connected():
        cursor.close()
        connection.close()
