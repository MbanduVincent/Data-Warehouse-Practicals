/*
===================================================
Create Database and Schemas
===================================================
Script Purpose: 
    This script creates a new database names 'datawarehouse' after checking if it already exists. 
    IF the database exists, it is dropped and recreated. 
    Additionaly, the script sets up three schemas within the database: 'bronze', 'silver' and 'gold'. 

WARNING: 
    Running this script will drop the entire 'datawarehouse' database if it exists. 
    All data in this database will be premanently deleted. Proceed with caution
    and ensure you have a proper backup before running this script. 
*/

-- Drop the 'datawarehouse' database
DROP DATABASE IF EXISTS datawarehouse;

-- Create Database 'datawarehouse'
CREATE DATABASE datawarehouse;

-- Use datawarehouse
USE datawarehouse;

-- -- Create the schemas
CREATE schema bronze;
CREATE schema silver;
CREATE schema gold;