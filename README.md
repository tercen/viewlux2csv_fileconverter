# viewlux2cvs file converter

#### Description
`viewlux2cvs` converts a measurement file of ViewLux uHTS Microplate Imager file by selecting all plate information within the measurement file and outputing each plate seperately into a run folder.

##### Usage

__How to run__

Install Tercen Desktop, this will also install R

`git clone https://github.com/tercen/viewlux2csv_fileconverter`

`cd viewlux2csv_fileconverter`

Run on Windows:

double click `run-win.bat` 

A dialog appears for user to choose a viewlux file to convert

Hit any key to close the black command DOS shell

Run on linux:

make a shell script

__Input file__

Takes a text measurement file (exported by the Wallach software) and extracts each plate reading into a seperate file. The indvidual plates are put into a folder.

__Parameters__

`RSCRIPT_EXE` represents the location of the RScript.exe, default is the RScript.exe which comes with Tercen Desktop.

__Output file__

Same name as the input file but with a tracker id and a timestamp


##### Details

Takes a text measurement file (exported by the Wallach software) and extracts each plate reading into a seperate file. The indvidual plates are put into a folder.  An extra identifier are added such as:

* `run_id`
* `plate_id`
* `well_id`
* `row`
* `col`
* `well_name`
* `sample_id`

#### References

##### See Also

#### Examples
