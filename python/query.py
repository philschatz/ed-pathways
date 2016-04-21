'''
Created on Mar 30, 2016

@author: slewis
'''

import sqlite3 as lite
import sys

def printResults(f, rows):
    for row in rows:
        f.write(','.join([str(x) for x in row]))
        f.write('\n')

def usage():
    print 'usage: query.py sqlquery [-db <dblitefilename> default:q1tableimport.db] [-out outputfile default:stdout]'          
    sys.exit(1)

argc = len(sys.argv)
if argc < 2:
    usage()
    sys.exit(1)

dbfilename = 'q1tableimport.db'
query = sys.argv[1]
outputfile = None
#parse arguments
for arg in sys.argv:
    nextArgIndex = sys.argv.index(arg)+1
    if arg == '-db' and nextArgIndex < argc:
        dbfilename = sys.argv[nextArgIndex]
    elif arg == '-out' and nextArgIndex < argc:
        outputfile = sys.argv[nextArgIndex]
    elif arg == '-h':
        usage()
        
#open connection to db file    
print 'connecting to sqlite dbfile: %s' % dbfilename
con = lite.connect(dbfilename)
#execute query
print 'executing query: %s' % query
all_rows = con.execute(query).fetchall()
con.close()
print 'query result has %s rows' % len(all_rows)

try :
    if outputfile != None:
        print 'sending output to %s' % outputfile
        with open(outputfile,'w') as out:
            printResults(out,all_rows)
    else:
        print '----query results----'
        printResults(sys.stdout, all_rows)
        print '----end query results----'
except IOError:
    print 'could not open file %s.  Printing to stdout' % outputfile
    print '----query results----'
    printResults(sys.stdout, all_rows)
    print '----end query results----'
    
print 'done'