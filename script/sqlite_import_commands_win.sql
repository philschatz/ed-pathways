-- Note: A line beginning with 2 dashes is a comment in SQL
-- Specify that we will be importing files of type CSV
.mode csv
-- Close existing database and reopen ed-pathways.sqlite
.open ./db/ed-pathways.sqlite
-- Drop the table if it was already there in the database and import again
DROP TABLE IF EXISTS schools;
-- Import the CSV file into a table and as long as the table does not exist, the column names will be the first line in the CSV file
.import ./data/schools.csv schools
DROP TABLE IF EXISTS CACFP;
.import ./data/CACFP.csv CACFP
DROP TABLE IF EXISTS OASK;
.import ./data/OASK_DB.csv OASK_DB
DROP TABLE IF EXISTS Performance;
.import ./data/Performance.csv Performance
DROP TABLE IF EXISTS Summer_2013;
.import ./data/Summer_2013.csv Summer_2013
DROP TABLE IF EXISTS Summer_2014;
.import ./data/Summer_2014.csv Summer_2014
DROP TABLE IF EXISTS Summer_2015;
.import ./data/Summer_2015.csv Summer_2015
DROP TABLE IF EXISTS FreeReducedLunch;
.import ./data/FreeReducedLunch.csv FreeReducedLunch
DROP TABLE IF EXISTS RCmediaSchoolsAggregate;
.import ./data/RCmediaSchoolsAggregate.csv RCmediaSchoolsAggregate