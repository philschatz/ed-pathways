# education-data

This repository contains the source data, analysis reports, and scripts to convert the data.

1. [./data/](./data) contains the source CSV data
2. [./script/](./script) contains scripts to clean up the CSV files by importing them into a SQLite Database and then outputting them to CSV
3. [./analysis/](./analysis) contains the Jupyter and R Studio files and reports


# Running python query:

- `pip install virtualenv`
- `source bin/activate` (OSX/Unix) `./Scripts/activate.bat` (Windows)
- Confirm that your terminal prompt starts with `(ed-pathways)`
- `pip install --upgrade pip`
- `pip install pandas==0.18.0`
- `pip install pysqlite==2.8.2`
- `cd python`
- `python ./q1tableimport.py`
- `python ./q1query.py`


# :tada: :balloon: Contributing

Please feel free to make edits, but create a Pull Request so others will be notified of changes and can discuss :smile:
