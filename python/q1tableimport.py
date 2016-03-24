'''
Created on Mar 23, 2016

@author: slewis
'''
import sqlite3 as lite
import pandas as pd

# read into DataTables
perfbyschooldt = pd.read_csv('../data/Performance by School_Lang. Arts, Math .csv')
summer2015dt = pd.read_csv('../data/Summer_2015.csv')
oaskdt = pd.read_csv('../data/OASK_DB.csv')

#print datatables
#print summer2015dt
#print perfbyschooldt
#print oaskdt

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

#con = lite.connect('q1tableimport.db')
#results = con.execute('select * from Performance')
#results = con.execute('select * from Performance')
#all_rows = results.fetchall()

#for row in all_rows:
#    print row

#con.close()

print 'done'

