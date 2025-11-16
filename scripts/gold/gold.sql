-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
DROP VIEW IF EXISTS gold.dim_customers;

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key, -- Surrogate key
    ci.cst_id                          AS customer_id,
    ci.cast_key                         AS customer_number,
    ci.cst_firstname                   AS first_name,
    ci.cst_lastname                    AS last_name,
    la.cntry                           AS country,
    ci.cst_marital_status              AS marital_status,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the primary source for gender
        ELSE COALESCE(ca.gen, 'n/a')  			   -- Fallback to ERP data / The COALESCE is used to return the first non-null value from a list.
    END                                AS gender,
    ca.bdate                           AS birthdate,
    ci.cst_create_date                 AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cast_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cast_key = la.cid;

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
DROP VIEW IF EXISTS gold.dim_products;

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- Surrogate key
    pn.prd_id       AS product_id,
    pn.prd_key      AS product_number,
    pn.prd_nm       AS product_name,
    pn.cat_id       AS category_id,
    pc.cat          AS category,
    pc.subcat       AS subcategory,
    pc.maintenance  AS maintenance,
    pn.prd_cost     AS cost,
    pn.prd_line     AS product_line,
    pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL; -- Filter out all historical data

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
DROP VIEW IF EXISTS gold.fact_sales;

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num  AS order_number,
    pr.product_key  AS product_key,
    cu.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;


select * from silver.crm_sales_details limit 10;

select * from silver.crm_prd_info limit 10;

select * from silver.crm_cust_info limit 5;

select * from silver.crm_cust_info where cst_id = 21768;

-- Top ten sales
select * from silver.crm_sales_details order by sls_sales DESC limit 5;

-- Top Ten Customers with most orders

create view gold.top_customers_orders as
select 
	count(cst_id) as orders,
	ca.cst_id as CustomerId
from silver.crm_cust_info ca
inner join silver.crm_sales_details sa
on ca.cst_id = sa.sls_cust_id
group by ca.cst_id
order by orders desc
limit 10

select 
	ca.cst_firstname || ' ' || ca.cst_lastname as customer_name,
	ca.cst_marital_status as marital_status,
	ca.cst_gndr as gender,
	pa.orders
from gold.top_customers_orders pa
inner join silver.crm_cust_info ca
on pa.customerid = ca.cst_id
order by orders desc;

-- Top Ten Customers with highets purchases
create view gold.top_customers_sales as
select 
	count(cst_id) as orders,
	sum(sls_sales) as total,
	ca.cst_id as CustomerId
from silver.crm_cust_info ca
inner join silver.crm_sales_details sa
on ca.cst_id = sa.sls_cust_id
group by ca.cst_id
order by total desc
limit 10;

select 
	ca.cst_firstname || ' ' || ca.cst_lastname as customer_name,
	ca.cst_marital_status as marital_status,
	ca.cst_gndr as gender,
	sa.orders,
	sa.total
from gold.top_customers_sales sa
inner join silver.crm_cust_info ca
on sa.customerid = ca.cst_id
order by total desc;

-- Top Ten Products bought
create view gold.top_products as
select 
	count(prd_key) as total_count,
	pa.prd_key as Product
from silver.crm_prd_info pa
inner join silver.crm_sales_details sa
on pa.prd_key = sa.sls_prd_key
group by(prd_key)
order by total_count desc
limit 10;

select 
	pa.prd_nm as product,
	pa.prd_cost as price,
	pa.prd_line as product_line,
	sa.total_count
from gold.top_products as sa
inner join silver.crm_prd_info pa
on sa.product = pa.prd_key
order by total_count desc;

-- Ten products that generated most revenue
create view gold.top_revenue_products as
select 
	count(prd_key) as total_count,
	sum(sls_sales) as total,
	pa.prd_key as Product
from silver.crm_prd_info pa
inner join silver.crm_sales_details sa
on pa.prd_key = sa.sls_prd_key
group by(prd_key)
order by total desc
limit 10;

select 
	pa.prd_nm as product,
	pa.prd_cost as price,
	pa.prd_line as product_line,
	sa.total_count,
	sa.total as sales
from gold.top_revenue_products as sa
inner join silver.crm_prd_info pa
on sa.product = pa.prd_key
order by sales desc;


-- Top Ten Products bought by single people
-- Top ten products bought by married people
-- Top products bought by people from a given region
-- Products bought by given gender
-- Products by age groups
-- Purchase patterns over the years(top ten products per year, top ten buyers per year)
-- Products that experienced growth

-- Top product lines
select 
	product_line,
	sum(total_count) as total
from (
	select 
	distinct pa.prd_nm as product,
	pa.prd_line as product_line,
	sa.total_count
	from gold.top_products as sa
	inner join silver.crm_prd_info pa
	on sa.product = pa.prd_key
	order by total_count desc
)
group by (product_line)
order by total desc;