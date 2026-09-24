FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install --no-cache-dir jupyter nbconvert

COPY Source_Code/HDB_Resale_ETL_Pipeline.ipynb .

RUN jupyter nbconvert --to script HDB_Resale_ETL_Pipeline.ipynb

CMD ["python", "HDB_Resale_ETL_Pipeline.py"]
