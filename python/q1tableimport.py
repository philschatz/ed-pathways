'''
Created on Mar 23, 2016

@author: slewis
'''
from csvutil.csv2sql import Csv2Sql
import sqlite3 as lite

#Csvs
perfbyschool = ('../data/Performance by School_Lang. Arts, Math .csv','Performance')
summer2015 = ('../data/Summer_2015.csv','Summer_2015')
oask = ('../data/OASK_DB.csv','OASK')

# read into DataTables
perfbyschooldt = Csv2Sql(*perfbyschool).read_csv()
summer2015dt = Csv2Sql(*summer2015).read_csv()
oaskdt = Csv2Sql(*oask).read_csv()

#print datatables
print summer2015dt
print perfbyschooldt
print oaskdt

#open db connection (create)
con = lite.connect('q1tableimport.db')

# call to_sql for each datatable
summer2015dt.to_sql('Summer_2015', con)
con.close()

con = lite.connect('q1tableimport.db')
perfbyschooldt.to_sql('Performance', con)
con.close()

con = lite.connect('q1tableimport.db')
oaskdt.to_sql('OASK', con)
con.close()

con = lite.connect('q1tableimport.db')
#results = con.execute('select * from Performance')
results = con.execute('select * from Summer_2015')
all_rows = results.fetchall()

for row in all_rows:
    print row

con.close()

print 'done'

