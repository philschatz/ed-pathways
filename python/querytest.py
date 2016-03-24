'''
Created on Mar 23, 2016

@author: slewis
'''

import sqlite3 as lite

con = lite.connect('question1.db')

#results = con.execute('select * from Performance')

#results = con.execute('Select Summer_2015.SchoolID, Summer_2015.Activities, Performance.* from Summer_2015 Inner Join Performance on Summer_2015.SchoolID=Performance.SchoolID')

results = con.execute('select * from Summer_2015')

all_rows = results.fetchall()

for row in all_rows:
    print row
    
con.close()

