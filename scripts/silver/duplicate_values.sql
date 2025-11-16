-- Duplicate and Null pk

-- Has Duplicate values
select 
	count(*),
	sls_ord_num
from bronze.crm_sales_details
group by sls_ord_num
having count(sls_ord_num) > 1 or sls_ord_num is null;

select 
	count(*),
	prd_id
from bronze.crm_prd_info
group by prd_id
having count(prd_id) > 1 or prd_id is null;

-- Has Duplicate values
select 
	count(*),
	cst_id
from bronze.crm_cust_info
group by cst_id
having count(cst_id) > 1 or cst_id is null;

select 
	count(*),
	cid
from bronze.erp_cust_az12
group by cid
having count(cid) > 1 or cid is null;


select 
	count(*),
	cid
from bronze.erp_loc_a101
group by cid
having count(cid) > 1 or cid is null;

select 
	count(*),
	id
from bronze.erp_px_cat_g1v2
group by id
having count(id) > 1 or id is null;
