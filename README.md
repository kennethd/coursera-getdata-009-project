
# Coursera Project for Getting and Cleaning Data

This repo is my submission for the Coursera course "Getting and Cleaning Data"

## Instructions

    The purpose of this project is to demonstrate your ability to collect, work
    with, and clean a data set. The goal is to prepare tidy data that can be used
    for later analysis. You will be graded by your peers on a series of yes/no
    questions related to the project. You will be required to submit: 1) a tidy
    data set as described below, 2) a link to a Github repository with your script
    for performing the analysis, and 3) a code book that describes the variables,
    the data, and any transformations or work that you performed to clean up the
    data called CodeBook.md. You should also include a README.md in the repo with
    your scripts. This repo explains how all of the scripts work and how they are
    connected.

## Introduction to the Code

The code is provided in the form of several functions in the `run_analysis.R` module.

### getTidyData()

There is only one function you need to call to download, build, and read the
tidied dataset: 

```
source("run_analysis.R")
d <- getTidyData()
```

The full signature is:

```
    getTidyData <- function(tidyFile = TIDY_DATA_FILE,
                            subsetFile = SUBSET_DATA_FILE,
                            zipFile = LOCAL_ZIP_FILE_NAME,
                            exdir = EXTRACT_DIR)
```

Each of the arguments provides a default, so none are required. 

Please note that the default name of the local zip file is not the same as the
remote name of the file, if you have the zip file available in the current working
directory with it's original name you can avoid downloading it again with:

```
    d <- getTidyData(zipFile = "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
```

By default the 8 files needed to create our subset data frame are extracted to
a new directory ".d" in the current working directory (and the `cleanUp()`
helper introduced below will try to remove this directory).  If this causes a
conflict for you, be careful to specify "exdir":

```
    d <- getTidyData(exdir = ".some-other-name") 
    cleanUp(zipFile = "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", exdir = ".some-other-name")
```

The `tidyFile` and `subsetFile` arguments are the local filenames to write our
two stages of data frames to (in the current working directory).

### full list of functions

A number of helper functions also exist, a full list follows:

* `getTidyData()` uses `read.table(f, header = T, check.names = T)` to read the data.frame from disk & return it to caller.
* `makeTidyData()` is automatically called by `getTidyData()` if the data is not already on disk.  This function calls `getStdsAndMeansSubset()` to retrieve the subset of standard deviations and means, and uses `aggregate()` to calculate the mean of each set of activity + subject + variable.
* `getStdsAndMeansSubset()` uses `read.table(f, header = T, check.names = T)` to read our subset of UCI data, containing only the attributes we are concerned with.
* `makeStdsAndMeansSubset()` will be called by `getStdsAndMeansSubset` if the subset data is not already available on disk.
* `extractFiles()` extracts required files from the zip file provided by UCI, if needed by `makeStdsAndMeansSubset`.
* `downloadZip()` will be called by `extractFiles` if it needs to extract one or more files, but the zip is not found in the current directory.

Data transformations that take place in `makeStdsAndMeansSubset` and
`makeTidyData` are described in [CodeBook.md](CodeBook.md)

The same set of function arguments are passed all the way up the stack, as far
as each variable makes sense, so just as you can pass `zipFile` and `exdir` to
`getTidyData`, if you want to load the original subset, you can pass the same
values to `getStdsAndMeansSubset`:

```
    ss <- getStdsAndMeansSubset(zipFile = "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", exdir = ".some-other-name")
```

In addition to the above, there are a couple of helper functions which are
helpful for development:

* `describeTidyData()` simply calls `getTidyData()` and then calls `dim()` and `str()` on the returned data.frame.
* `cleanUp()` removes downloaded, extracted, and or created resources from disk.  Each step of the above procedure may be kept on disk by overriding the default parameters with empty strings:
    * `cleanUp()`: remove everything from disk
    * `cleanUp("")`: do not remove the 60mb zip file
    * `cleanUp("", "")`: do not remove the zip file or the files extracted from it
    * `cleanUp("", "", "")`: do not remove zip, extracted files, or subset
* `memUsage()` out of curiosity, I added some calls to `message()` that prints out `mem_used()` periodically (from the `pryr` package, if it is installed)

## Unit Tests

I created some very basic test cases by loading the resulting data.frame files
into Libre Office Calc, and counting rows from the subset data for a subject +
activity, then calculating the mean to test the tidy dataset.

This is completely extraneous to the stated assignment, I just happen to feel
better when I have unit tests.

To run the unit tests from within RStudio, your working directory must be the
top-level of this project, then source the `run_tests.R` script.  For example:

```
setwd('~/git/coursera-getdata-009-project')
source('run_tests.R')
```

You can also run the tests from the command line using `Rscript`:

```
kenneth@dhalgren:~/git/coursera-getdata-009-project$ Rscript ./run_tests.R
```
