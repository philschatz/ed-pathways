'''
Created on Mar 20, 2016

@author: slewis
'''

from csvutil.csv2sql import Csv2Sql

csvs = [ ('../data/CACFP_ordered_withid.csv','CACFP'),
         ('../data/OASK_DB.csv','OASK'), 
         ('../data/Performance by School_Lang. Arts, Math .csv','Performance'),
         ('../data/schools_ordered_updated.csv','Schools'),
         ('../data/Summer_2013-1.csv','Summer_2013'),
         ('../data/Summer_2014-1.csv','Summer_2014'),
         ('../data/Summer_2015.csv','Summer_2015')]

for csv in csvs:
    csv2sql = Csv2Sql(*csv)
    csv2sql.toDDL()
    
# Example:  convert schools_ordered_updated csv file to Schools sql table.  
# This will create two new files:  Schools.db is the sqllite database file,
# and Schools.sql is the DDL output file suitable for import into any SQL database
#csv2sql = Csv2Sql('C:\Users\slewis\git\ed-pathways\data\OASK_DB.csv','OASK')
# This does all the work
#csv2sql.toDDL()

