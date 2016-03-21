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
    
