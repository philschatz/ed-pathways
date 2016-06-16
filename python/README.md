This directory contains a script that converts the CSV files into 1 CSV file that contains fields that are used by Jupyter & R Studio files in [../analysis](../analysis).

- `readtables.ipynb` is used to verify that the .out files were generated correctly
- `q4queryargs.txt` contains the final SQL query used which should be the input to `query.py`
- `query.py` runs the CSV import and then a SQL query to "boil down" the CSV into a couple tables that analysis


# Running python query:

- `pip install virtualenv`
- `source bin/activate` (OSX/Unix) `./Scripts/activate.bat` (Windows)
- Confirm that your terminal prompt starts with `(ed-pathways)`
- `pip install --upgrade pip`
- `pip install pandas==0.18.0`
- `pip install pysqlite==2.8.2`
- `cd python`
- `python ./query.py ${cat q4queryargs.txt}`
