@echo off
REM This is a comment in batch file
REM Check if the database file exists otherwise it will create the databse
IF EXIST .\db\ed-pathways.sqlite (
echo Database file already exists
goto Ask
) ELSE (sqlite3 ./db/ed-pathways.sqlite ".read ./script/sqlite_import_commands_win.sql"
echo Database created and tables imported
goto cont
)
REM Ask for user input if user wants to replace the datbase or not
:Ask
echo Do you wish to continue? It will clear the existing DB (Y/N)  
set INPUT=
set /P INPUT=Type input: %=%
If /I "%INPUT%"=="y" goto yes 
If /I "%INPUT%"=="n" goto no
echo Incorrect input & goto Ask
:yes
sqlite3 ./db/ed-pathways.sqlite ".read ./script/sqlite_import_commands_win.sql
echo Tables imported
goto cont
:no
echo Cancelling import
goto cont
:cont
pause