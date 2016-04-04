'''
Created on Mar 23, 2016

@author: slewis
'''

import sqlite3 as lite

con = lite.connect('q1tableimport.db')

# test query
#results = con.execute('select * from Performance')

# here is the actual query
results = con.execute('Select Summer_2015.SchoolID, Performance.School, replace(Summer_2015.Activities, ",", "") as "Summer_15.Activities", Performance.Subject, Performance.ParticipationRate2014to2015, Performance.PercentageMeetsORExceeds2014to2015 from Summer_2015 Inner Join Performance on Summer_2015.SchoolID=Performance.SchoolID where Performance.Subgroup="Total Population"')

all_rows = results.fetchall()

#print rows
for row in all_rows:
    print('%s,%s,%s,%s,%s,%s' % row)
    
con.close()

