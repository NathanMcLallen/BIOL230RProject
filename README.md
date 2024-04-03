# BIOL230RProject

Summary: Uses a python script to read data from a gene folder and a transcription data file, then an R file to perform tests for significance
and print plot bar and scatter plots of the data to a pdf file

Dependencies:
OsX operating system, python 3.11.5, R 4.3.3
  Python: Pandas, os, os.path, fileinput, re (regular expressions)
  R: ggplot2, grid

Directions:
 1. Place both scripts and the Nagalakshmi transcription data in the same folder as the YeastGenes folder found in the course code repo
 2. Open the R script in a text editor and insert the scripts directory into line 8 (input) and line 119 (output)
 3. From a command line run the python script "CSVMaker.py" to create a CSV file from the transcription data and YeastGenes
 4. From a command line run the R script
 5. The T test results will be printed to the console and the 6 charts will be printed to a pdf file in the same folder as the scripts.

