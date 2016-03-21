'''
Created on Mar 20, 2016

@author: slewis
'''

import pandas as pd
import sqlite3 as lite

class Csv2Sql(object):
    '''
    Column separated values to sql converter utility class
    '''

    def __init__(self, read_csv_filepath, tablename, deletedb=True, read_csv_params={}, to_sql_params={}):
        self.csv_parse_params = read_csv_params
        if 'filepath_or_buffer' not in self.csv_parse_params:
            self.csv_parse_params['filepath_or_buffer'] = read_csv_filepath
        if read_csv_filepath.endswith('.csv'):
            self.filepath_wo_ext = read_csv_filepath[:-4]
        else:
            self.filepath_wo_ext = read_csv_filepath
        self.db_filepath = tablename + ".db"
        self.deletedb = deletedb
        self.to_sql_params = to_sql_params
        if 'name' not in self.to_sql_params:
            self.to_sql_params['name'] = tablename
        self.ddl_filepath = tablename + ".sql"
        
    def read_csv(self):
        return pd.read_csv(**self.csv_parse_params)
    
    def open_db(self):
        return lite.connect(self.db_filepath)
    
    def tosqllite(self):
        self.to_sql_params['con'] = self.open_db()
        self.read_csv().to_sql(**self.to_sql_params)
        return self.to_sql_params['con']
    
    def toDDL(self):
        con = self.tosqllite()
        with open(self.ddl_filepath, 'w') as f:
            for line in con.iterdump():
                f.write('%s\n' % line)
        con.close()

    
    