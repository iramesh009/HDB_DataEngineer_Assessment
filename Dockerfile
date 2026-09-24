```dockerfile
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
```

### Your `.env` should use these Docker paths

```text
Rawdata_2000_to_Feb2012="/app/HDB_Raw_Dataset/Resale Flat Prices (Based on Approval Date), 2000 - Feb 2012.csv"

Rawdata_Mar2012_to_Dec2014="/app/HDB_Raw_Dataset/Resale Flat Prices (Based on Registration Date), From Mar 2012 to Dec 2014.csv"

Rawdata_Jan2015_to_Dec2016="/app/HDB_Raw_Dataset/Resale Flat Prices (Based on Registration Date), From Jan 2015 to Dec 2016.csv"

HDB_Master_Raw="/app/HDB_Master_Raw/HDB_Master_Raw.csv"

HDB_Cleaned="/app/HDB_Cleaned/HDB_Cleaned.csv"

HDB_Failed="/app/HDB_Failed/HDB_Failed.csv"

HDB_Lease_Recalculation="/app/HDB_Lease_Recalculation/HDB_Cleaned_With_Lease.csv"

HDB_ResalePrice_Anomaly_Detection="/app/HDB_ResalePrice_Anomaly_Detection/HDB_ResalePrice_Anomaly_Detection.csv"

HDB_Addtional_Data_Cleaning="/app/HDB_Addtional_Data_Cleaning/HDB_Addtional_Data_Cleaning.csv"

HDB_Transformed_Hashed="/app/HDB_Transformed_Hashed/HDB_Transformed_Hashed.csv"
```

One more thing: because your latest error was `ydata_profiling`, make sure `requirements.txt` contains:

```text
pandas==2.2.3
python-dotenv==1.1.1
pyspark==3.5.6
ydata-profiling
```

Then **commit → push to `main`**. GitHub Actions will automatically build and run the new Docker image.
