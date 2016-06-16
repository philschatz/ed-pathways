# Programming to Progress Script Explanation

##[Setup.bat] (./Setup.bat)
This is a windows batch file which creates a SQL database `ed-pathways.sqlite` in sqlite3. It also executes `sqlite_import_commands_win.sql` and imports tables from .csv files. If that database already exists in slite3 then it asks the user if user wants to replace the datbase or not. Based on user response it replaces the database or cancels the import.

##[sqlite_import_commands_win.sql] (./sqlite_import_commands_win.sql)
This sql file imports several .csv files into the ed-pathways.sqlite database. If a table already exists in the database it drops that table and imports the table again into the database.

##[setup] (./setup)
setup is the linux version of the windows Setup.bat file. It creates `ed-pathways.sqlite` SQL database in sqlite3 and executes `sqlite-import-commands.sql` which imports tables from .csv files.

##[sqlite-import-commands.sql] (./sqlite-import-commands.sql)
This sql file is called inside the `setup` file for importing .csv files into the sql database.

##[Final_SQL_For_Result_Table.txt] (./Final_SQL_For_Result_Table.txt)
This sql query executes on `ed-pathways.sqlite`database. It gives lists of SchoolID, School Name, District, School Type (Elementary, Middle, High), Student Enrollment, Number of programs offered in the school, Percent of Students Eligible for free reduced lunch, Percent of Students Not Chronically Absent, Students Participation Rate 2014 to 2015 and Percentage Meets OR Exceeds 2014 to 2015 for English Language, Mathematics, Science.
