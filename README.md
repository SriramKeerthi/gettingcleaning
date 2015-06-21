# Getting and Cleaning Data
Coursera Data Science Specialization - Getting and Cleaning Data

## Introduction
This repository is the Course Project for the Getting and Cleaning Data course. The input data for this course project is the [Human Activity Recognition Using Smartphones Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "UCI HAR Dataset").
This repository includes the following files:

1.  README.md
This file.

2.  codebook.md
Code Book detailing the output tidy data file (sensorDataAvg.txt)

3.  run_analysis.R
R Script for analysing the input data and generating the tidy data.

## Assumptions
The raw data for the analysis is assumed to be present at a predefined location which is specified in [Line 7 of the run_analysis.R](https://github.com/SriramKeerthi/gettingcleaning/blob/master/run_analysis.R#7 "Run Analysis R Script (Line 7)") file.
This line has the be edited to match the target system. This is the path to the folder containing the extracted input data downloaded from the link above.

Output tidy data file is written into the input data folder as `sensorDataAvg.txt`, hence write access is required to the folder.

## Script Execution
Download the raw sensor data from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "UCI HAR Dataset") and extract it.

Clone this repository onto your local machine using:
```
git clone https://github.com/sriramkeerthi/gettingcleaning
```
Open the `run_analysis.R` file inside the repository with a text editor and modify line #7 to match the location of the dataset downloaded above and save it.

Run the script using:
```
RScript run_analysis.R
```

## Output
The output tidy data is written to `sensorDataAvg.txt`, which has been described in the [Codebook file](https://github.com/SriramKeerthi/gettingcleaning/blob/master/codebook.md "Codebook").
