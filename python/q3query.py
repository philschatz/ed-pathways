'''
Created on Mar 23, 2016

@author: slewis
'''

import sqlite3 as lite

con = lite.connect('q1tableimport.db')

# test query
#results = con.execute('select * from Performance')

# here is the actual query
query = 'Select prf.SchoolID, prf.School, RCAgg.SchoolType, coalesce(program.No_of_Prog,0) as No_of_Program,replace(smr.Activities, ",", "") as Summer_2015_Activities, FrRedLnch.PercentEligible, prf.Subject, prf.ParticipationRate2014to2015, prf.PercentageMeetsORExceeds2014to2015 from Performance prf Inner Join RCmediaSchoolsAggregate RCAgg on prf.SchoolID=RCAgg.SchoolID Inner Join Summer_2015 smr on prf.SchoolID=smr.SchoolID Inner Join FreeReducedLunch FrRedLnch on prf.SchoolID=FrRedLnch.SchoolID Left Join (Select SchoolID, count(Program_name) as No_of_Prog from OASK_DB where SchoolID <> "" group by 1) as program on prf.SchoolID=program.SchoolID Where prf.Subgroup="Total Population" group by 1,2,3,4,5,6,7,8,9 Order by prf.School'

#print 'running query: %s' % query

results = con.execute(query)
all_rows = results.fetchall()

#print 'number of rows: %d' % len(all_rows)

#print rows
for row in all_rows:
    print '%s,%s,%s,%s,%s,%s,%s,%s,%s' % row 
    
con.close()
