# viewlux2cvs file converter

#### Description
`viewlux2cvs` converts a measurement file of ViewLux uHTS Microplate Imager file by selecting all plate information within the measurement file and outputing each plate seperately into a run folder.

##### Usage

__How to run on Windows OS__
```
git clone https://github.com/tercen/viewlux2csv_fileconverter
cd viewlux2csv_fileconverter
run-win.bat
```

* A dialog appears for the user to choose a file to convert
* A black command DOS shell appears and indicates the progress of the conversion
* Hit any key to close the black command DOS shell

__Input file__

Takes a text measurement file (exported by the Wallach software) and extracts each plate reading into a seperate file. The indvidual plates are put into a folder.

__Output file__

A folder is created with the `run_id` and in the folder there is a file for each plate named with the `run_id` and `plate_num`.


##### Details
The ViewLux uHTS Microplate Imager is a high throughput instrument capable of reading many plates in one run. The software to control it is  called Wallach.
The file conversion takes a measurement file (exported by the Wallach software) and extracts each plate reading into a seperate file. The indvidual plates are put into a folder.  The output file contains extra identifiers such as:

* `run_id`
* `plate_id`
* `plate_num`
* `well_id`
* `row`
* `col`
* `well_name`
* `sample_id`

The `run.bat` file uses RScript.exe whose location is defined by the variable `RSCRIPT_EXE`) , default is the RScript.exe which comes with Tercen Desktop installation.

#### References

##### See Also

#### Examples

Use the `viewlux.txt` file located in the `data` folder.
