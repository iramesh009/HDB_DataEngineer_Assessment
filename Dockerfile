FROM python:3.11-slim

WORKDIR /app

# Install Java for PySpark
RUN apt-get update && \
    apt-get install -y openjdk-17-jre-headless && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install --no-cache-dir jupyter nbconvert

COPY Source_Code/HDB_Resale_ETL_Pipeline.ipynb .

RUN jupyter nbconvert --to script HDB_Resale_ETL_Pipeline.ipynb

CMD ["python", "HDB_Resale_ETL_Pipeline.py"]
