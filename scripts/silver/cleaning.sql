-- Check for NULLS and duplicates in the primary keys
SELECT count(*),
cst_id 
FROM bronze.crm_cust_info 
GROUP BY (cst_id) 
HAVING count(cst_id) > 1 or cst_id is NULL;

-- Check for unwanted spaces
SELECT 
cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

