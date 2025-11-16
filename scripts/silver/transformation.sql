-- TRIM unwanted spaces
SELECT 
cst_id,
cast_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_id,
cst_marital_status,
cst_gndr,
cst_create_date
FROM (
    SELECT *,
    ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC ) as flag_last 
    FROM bronze.crm_cust_info
)
WHERE flag_last = 1;


-- Human readable options
SELECT 
cst_id,
cast_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_id,
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
    WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
    ELSE 'n/a'
END cst_marital_status,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
    WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
    ELSE 'n/a'
END cst_gndr,
cst_create_date
FROM (
    SELECT *,
    ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC ) as flag_last 
    FROM bronze.crm_cust_info
)
WHERE flag_last = 1;