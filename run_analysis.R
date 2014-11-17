
DATASET_ZIP_URL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
LOCAL_ZIP_FILE_NAME <- "UCI-HAR.zip"
EXTRACT_DIR <- ".d"
SUBSET_DATA_FILE <- "UCI-HAR.subset.txt"
TIDY_DATA_FILE <- "UCI-HAR.tidy.txt"

# just curious about garbage collection as stuff goes out of scope...
memUsage <- function(msg) {
    tryCatch(
        { library(pryr) ; message(paste(msg, mem_used())) },
        error = function(e) { message("could not load pryr for mem_used()") }
    )
}

# download zip file to current dir
downloadZip <- function(zipUrl = DATASET_ZIP_URL, saveAs = LOCAL_ZIP_FILE_NAME) {
    message(paste("downloading", zipUrl, "to", saveAs))
    download.file(zipUrl, saveAs)
}

# extract fileNames from zipFile, download if necessary
extractFiles <- function(fileNames, zipFile = LOCAL_ZIP_FILE_NAME,
                         exdir = EXTRACT_DIR) {
    if (! file.exists(exdir)) {
        dir.create(exdir)
    }
    for (fileName in fileNames) {
        if (! file.exists(file.path(exdir, basename(fileName)))) {
            message(paste("extracting", fileName, "from", zipFile)) 
            if (! file.exists(zipFile)) {
                downloadZip(saveAs = zipFile)
            }
            unzip(zipFile, files = fileName, exdir = exdir, junkpaths = T)
        }
    }
}

# parse data from zipfile & subset means and stds, with column names and activity
# names, and write new data.frame to subsetFile.  Does not return subset data,
# for consistency it is better to always get it from getStdsAndMeansSubset(),
# which will call this function for you, if necessary.
makeStdsAndMeansSubset <- function(subsetFile = SUBSET_DATA_FILE,
                                   zipFile = LOCAL_ZIP_FILE_NAME,
                                   exdir = EXTRACT_DIR) {
    message(paste("makeStdsAndMeansSubset", subsetFile, zipFile, exdir))

    # files needed from dataset
    reqFiles <- c(
        "UCI HAR Dataset/activity_labels.txt",
        "UCI HAR Dataset/features.txt",
        "UCI HAR Dataset/test/X_test.txt",
        "UCI HAR Dataset/test/y_test.txt",
        "UCI HAR Dataset/test/subject_test.txt",
        "UCI HAR Dataset/train/X_train.txt",
        "UCI HAR Dataset/train/y_train.txt",
        "UCI HAR Dataset/train/subject_train.txt"
    )
    extractFiles(reqFiles, zipFile = zipFile, exdir = exdir)

    activityLabelsFile = file.path(exdir, "activity_labels.txt")
    featuresFile = file.path(exdir, "features.txt")
    testDataFile = file.path(exdir, "X_test.txt")
    testLabelsFile = file.path(exdir, "y_test.txt")
    testSubjectsFile = file.path(exdir, "subject_test.txt")
    trainDataFile = file.path(exdir, "X_train.txt")
    trainLabelsFile = file.path(exdir, "y_train.txt")
    trainSubjectsFile = file.path(exdir, "subject_train.txt")

    activity_labels <- read.table(activityLabelsFile, sep = "", header = F, stringsAsFactors = F)
    message(paste("read", length(activity_labels[,2]), "activity labels"))
    features <- read.table(featuresFile, sep = "", header = F, stringsAsFactors = F)
    message(paste("read", length(features[,1]), "features"))
    test_data <- read.table(testDataFile, sep = "", header = F, stringsAsFactors = F)
    message(paste("read", length(test_data[,1]), "test data"))
    train_data <- read.table(trainDataFile, sep = "", header = F, stringsAsFactors = F)
    message(paste("read", length(train_data[,1]), "train data"))
    test_labels <- read.table(testLabelsFile, sep = "", header = F, stringsAsFactors = F)
    message(paste("read", length(test_labels[,1]), "test labels"))
    train_labels <- read.table(trainLabelsFile, sep = "", header = F, stringsAsFactors = F)
    message(paste("read", length(train_labels[,1]), "train labels"))
    test_subjects <- read.table(testSubjectsFile, sep = "", header = F, stringsAsFactors = F)
    message(paste("read", length(test_subjects[,1]), "test subjects"))
    train_subjects <- read.table(trainSubjectsFile, sep = "", header = F, stringsAsFactors = F)
    message(paste("read", length(train_subjects[,1]), "train subjects"))

    # > dim(test_data)
    # [1] 2947  561
    # > dim(train_data)
    # [1] 7352  561

    # rbind test + train labels & use sapply to translate into character vector
    activities = sapply(rbind(test_labels, train_labels), function(x) { activity_labels[x, 2] })
    subjects = rbind(test_subjects, train_subjects)
    levels(subjects) <- unique(subjects)
    # rbind test + train data & then cbind together with activities & subjects
    obs = cbind(rbind(test_data, train_data), activities, subjects)
    # assign column names from features + "activity" + "subject"
    names(obs) <- c(features[, 2], "activity", "subject")
    # for each obs we only want the mean & std deviation columns for each measurement
    # "Extracts only the measurements on the mean and standard deviation for each measurement."
    # create logical vector by applying regex to feature names
    colMask <- sapply(features[,2], function(s) { grepl('(mean|std)', s, ignore.case = T) })
    memUsage("mem used by makeStdsAndMeansSubset before applying colMask")
    obs <- obs[, colMask]
    write.table(obs, file = subsetFile, row.names = F)

    message(paste("created subset txt file", subsetFile))
    #dim(obs[, colMask])
    #str(obs[, colMask])
    memUsage("mem used by makeStdsAndMeansSubset after applying colMask")
}

# returns subset of UCI's HAR data, containing only std deviations & means of 
# measurements.  Called by makeTidyData()
getStdsAndMeansSubset <- function(subsetFile = SUBSET_DATA_FILE,
                                  zipFile = LOCAL_ZIP_FILE_NAME,
                                  exdir = EXTRACT_DIR) {
    message(paste("getStdsAndMeansSubset", subsetFile, zipFile, exdir))
    
    if (! file.exists(subsetFile)) {
        makeStdsAndMeansSubset(subsetFile = subsetFile,
                               zipFile = zipFile,
                               exdir = exdir)
        memUsage("mem used post makeStdsAndMeansSubset")
    }
    # For consistency, must always return data as read.table returns it; check.names
    # will convert any invalid chars for variable names found in the header to dots
    ss <- read.table(subsetFile, header = T, check.names = T)
    memUsage("mem used within getStdsAndMeansSubset")
    ss
}

# "From the data set in step 4, creates a second, independent tidy data set with
#  the average of each variable for each activity and each subject."
# Does not return tidied data, for consistency it is better to always get it from
# getTidyData(), which will call this function for you, if necessary.
makeTidyData <- function(tidyFile = TIDY_DATA_FILE,
                         subsetFile = SUBSET_DATA_FILE,
                         zipFile = LOCAL_ZIP_FILE_NAME,
                         exdir = EXTRACT_DIR) {
    message(paste("makeTidyData", tidyFile, subsetFile, zipFile, exdir))

    ss <- getStdsAndMeansSubset(subsetFile = subsetFile,
                                zipFile = zipFile,
                                exdir = exdir)
    # ss looks like :
    # prop-1 prop-2 prop-3 activity subject
    # 1.0000 1.0000 1.0000 STANDING subj-1
    # 2.0000 2.0000 2.0000 STANDING subj-1
    # 2.0000 2.0000 2.0000 SITTING  subj-1
    # 3.0000 3.0000 3.0000 SITTING  subj-1
    # 
    # we want to transform it into a matrix of averages:
    # prop-1 prop-2 prop-3 activity subject
    # 1.5000 1.5000 1.5000 STANDING subj-1
    # 2.5000 2.5000 2.5000 SITTING  subj-1

    # aggregate by formula (activity + subject) gives us 6 rows for each subject, one
    # for each activity, and a single mean value for each measurement, with header row.
    # Note: the formula version of aggregate(. ~ activity + subject, ...) also
    # has the benefit of not making assumptions about the shape of the row -- if 
    # the grepl() used to create the subset is found to be too permissive or 
    # restrictive & needs to be edited, resulting in a different number of columns, 
    # the following will continue to work
    tidy <- aggregate(. ~ activity + subject, data = ss, mean)
    write.table(tidy, file = tidyFile, row.names = F)
    message(paste("created tidy txt file", tidyFile))
    memUsage("mem used within makeTidyData")
}

# returns tidied data set, creating on-disc cache if needed
getTidyData <- function(tidyFile = TIDY_DATA_FILE,
                        subsetFile = SUBSET_DATA_FILE,
                        zipFile = LOCAL_ZIP_FILE_NAME,
                        exdir = EXTRACT_DIR) {
    message(paste("getTidyData", tidyFile, subsetFile, zipFile, exdir))
    if (! file.exists(tidyFile)) {
        makeTidyData(tidyFile = tidyFile,
                     subsetFile = subsetFile,
                     zipFile = zipFile,
                     exdir = exdir)
    }
    # For consistency, must always return data as read.table returns it; check.names
    # will convert any invalid chars for variable names found in the header to dots
    tidy <- read.table(tidyFile, header = T, check.names = T)
    memUsage("mem used within getTidyData")
    tidy
}

# handy endpoint for development that calls getTidyData() & allows
# us to examine its results by calling dim() and str() on it
describeTidyData <- function(tidyFile = TIDY_DATA_FILE,
                             subsetFile = SUBSET_DATA_FILE,
                             zipFile = LOCAL_ZIP_FILE_NAME,
                             exdir = EXTRACT_DIR) {
    message(paste("describeTidyData", tidyFile, subsetFile, zipFile, exdir))
    tidy <- getTidyData(tidyFile = tidyFile, subsetFile = subsetFile,
                        zipFile = zipFile, exdir = exdir)
    dim(tidy)
    str(tidy)
    memUsage("mem used within describeTidyData")
}

# by default cleans up all resources on disc ; if you don't want a dependency
# cleaned up (ex. to not re-download the 60mb zip file for every run), pass an
# empty string for that argument
cleanUp <- function(zipFile = LOCAL_ZIP_FILE_NAME,
                    exdir = EXTRACT_DIR,
                    subsetFile = SUBSET_DATA_FILE,
                    tidyFile = TIDY_DATA_FILE) {
    message(paste("cleanUp", zipFile, exdir, subsetFile, tidyFile))

    if (length(zipFile) > 0) {
        unlink(zipFile)
    }
    if (length(exdir) > 0) {
        unlink(exdir, recursive = T)
    }
    if (length(subsetFile) > 0) {
        unlink(subsetFile)
    }
    if (length(tidyFile) > 0) {
        unlink(tidyFile)
    }
}

# pass empty string(s) to not force re-download, re-parse, re-extract
#cleanUp("", "", "")
#describeTidyData()
