-- Note: A line beginning with 2 dashes is a comment in SQL
-- Specify that we will be importing files of type CSV
.mode csv

-- Import the CSV file into a table and as long as the table does not exist,
-- the column names will be the first line in the CSV file
.import ./data/CACFP.csv CACFP
.import ./data/OASK_DB.csv OASK
.import ./data/Performance.csv Performance
.import ./data/Summer_2013.csv Summer_2013
-- .import ./data/Summer_2014.csv Summer_2014
.import ./data/Summer_2015.csv Summer_2015
