FROM python:3.11-slim

WORKDIR /app

# ============================================================
# Install Java for PySpark
# ============================================================
RUN apt-get update && \
    apt-get install -y openjdk-21-jre-headless && \
    rm -rf /var/lib/apt/lists/*

# Configure Java
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# ============================================================
# Install Python dependencies
# ============================================================
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Install Jupyter and nbconvert
RUN pip install --no-cache-dir jupyter nbconvert

# ============================================================
# Copy source files
# ============================================================
COPY Source_Code/HDB_Resale_ETL_Pipeline.ipynb .
COPY Source_Code/hdb_resale.env .

# ============================================================
# Copy raw HDB datasets
# ============================================================
COPY HDB_Raw_Dataset /app/HDB_Raw_Dataset

# ============================================================
# Create output directories
# ============================================================
RUN mkdir -p \
    /app/HDB_Master_Raw \
    /app/HDB_Cleaned \
    /app/HDB_Failed \
    /app/HDB_Lease_Recalculation \
    /app/HDB_ResalePrice_Anomaly_Detection \
    /app/HDB_Addtional_Data_Cleaning \
    /app/HDB_Transformed_Hashed

# ============================================================
# Convert notebook to Python script
# ============================================================
RUN jupyter nbconvert --to script HDB_Resale_ETL_Pipeline.ipynb

# ============================================================
# Run ETL pipeline
# ============================================================
CMD ["python", "HDB_Resale_ETL_Pipeline.py"]
