import pandas as pd
from sqlalchemy import create_engine
import os

path = r'D:\ashikh\lit\data'    # Путь к csv файлам
ip = '192.168.100.127'
inital_db = 'testDB'
login = 'postgres'
password = 'absolut'
nameSchema = 'shikhaldin'
pgsql_con = create_engine(f'postgresql://{login}:{password}@{ip}/{inital_db}')

for filename in os.listdir(path):
    df = pd.read_csv(os.path.join(path, filename), sep=';')
    df.to_sql(name=filename.split('.')[0], con=pgsql_con, schema=nameSchema, if_exists='append', index=False)