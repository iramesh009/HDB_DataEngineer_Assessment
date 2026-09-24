FROM python:3.11-slim

WORKDIR /app

# Install Java for PySpark
RUN apt-get update && \
    apt-get install -y openjdk-21-jre-headless && \
    rm -rf /var/lib/apt/lists/*

# Configure Java
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Install Python dependencies
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Install Jupyter and nbconvert to convert notebook to Python
RUN pip install --no-cache-dir jupyter nbconvert

# Copy notebook and environment file
COPY Source_Code/HDB_Resale_ETL_Pipeline.ipynb .
COPY Source_Code/hdb_resale.env .

# Convert notebook to Python script
RUN jupyter nbconvert --to script HDB_Resale_ETL_Pipeline.ipynb

# Run the converted Python script
CMD ["python", "HDB_Resale_ETL_Pipeline.py"]
