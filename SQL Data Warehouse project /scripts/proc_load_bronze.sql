-- 1) Create master key (run once per database)
-- Password removed for security
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<MASTER_KEY_PASSWORD>';

-- 2) Create credential for Azure Blob Storage access
-- SAS token removed for security
CREATE DATABASE SCOPED CREDENTIAL CrmBlobSas
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
     SECRET = '<SAS_TOKEN>';



-- 3) Define external data source (Azure Storage location)
CREATE EXTERNAL DATA SOURCE CrmBlob
WITH (
    TYPE = BLOB_STORAGE,
    LOCATION = 'https://<storage-account>.blob.core.windows.net',
    CREDENTIAL = CrmBlobSas
);


-- 4) Load data into bronze table from CSV file
TRUNCATE TABLE bronze.crm_cust_info;

BULK INSERT bronze.crm_cust_info
FROM 'crmdata/cust_info.csv'
WITH (
    DATA_SOURCE = 'MyBlobStorage',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

TRUNCATE TABLE bronze.crm_prd_info;

BULK INSERT bronze.crm_prd_info
FROM 'crmdata/prd_info.csv'
WITH (
    DATA_SOURCE = 'MyBlobStorage',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

TRUNCATE TABLE bronze.crm_sales_details;

BULK INSERT bronze.crm_sales_details
FROM 'crmdata/sales_details.csv'
WITH (
    DATA_SOURCE = 'MyBlobStorage',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

TRUNCATE TABLE bronze.erp_cust_az12;

BULK INSERT bronze.erp_cust_az12
FROM 'erpdata/CUST_AZ12.csv'
WITH (
    DATA_SOURCE = 'MyBlobStorage',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

TRUNCATE TABLE bronze.erp_loc_a101;

BULK INSERT bronze.erp_loc_a101
FROM 'erpdata/LOC_A101.csv'
WITH (
    DATA_SOURCE = 'MyBlobStorage',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);

TRUNCATE TABLE bronze.erp_px_cat_g1v2;

BULK INSERT bronze.erp_px_cat_g1v2
FROM 'erpdata/PX_CAT_G1V2.csv'
WITH (
    DATA_SOURCE = 'MyBlobStorage',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
