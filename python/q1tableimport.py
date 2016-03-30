'''
Created on Mar 23, 2016

@author: slewis
'''
import sqlite3 as lite
import pandas as pd

# csv files to read
performance = ('../data/Performance by School_Lang. Arts, Math .csv','Performance')
summer2015 = ('../data/Summer_2015.csv','Summer_2015')
oask = ('../data/OASK_DB.csv','OASK')
rcmediaschoolsaggregate = ('../data/RCmediaSchoolsAggregate.csv','RCmediaSchoolsAggregate')
#output file name
outputfilename = 'q1tableimport'

# read into DataTables
performancedt = pd.read_csv(performance[0],dtype={ 'SchoolID': str, 'ParticipationRate2014to2015': pd.np.float64, 'Level3or4in2014to2015': pd.np.float64})
summer2015dt = pd.read_csv(summer2015[0], dtype={ 'SchoolID': str })
oaskdt = pd.read_csv(oask[0], dtype={ 'SchoolID': str })
rcmediaschoolsaggregatedt = pd.read_csv(rcmediaschoolsaggregate[0], dtype={ 'SchoolID': str})

#open db connection (create)
con = lite.connect(outputfilename+'.db')

# call to_sql for each datatable
performancedt.to_sql(performance[1], con, if_exists='replace')
summer2015dt.to_sql(summer2015[1], con, if_exists='replace')
oaskdt.to_sql(oask[1], con, if_exists='replace')
rcmediaschoolsaggregatedt = rcmediaschoolsaggregatedt.to_sql(rcmediaschoolsaggregate[1], con, if_exists='replace')

# create ddl 
with open(outputfilename+'.sql', 'w') as f:
    for line in con.iterdump():
        f.write('%s\n' % line)

con.close()

print 'done with import'

