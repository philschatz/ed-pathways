'''
Created on Mar 20, 2016

@author: slewis
'''

from csv2sqlutil.csv2sql import Csv2Sql

# Example:  convert schools_ordered_updated csv file to Schools sql table.  
# This will create two new files:  Schools.db is the sqllite database file,
# and Schools.sql is the DDL output file suitable for import into any SQL database
csv2sql = Csv2Sql('C:\Users\slewis\git\ed-pathways\data\schools_ordered_updated.csv','Schools')
# This does all the work
csv2sql.toDDL()

