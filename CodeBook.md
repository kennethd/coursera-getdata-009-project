
# CodeBook for Getting and Cleaning Data Project

## Upstream Data

A summary of the original dataset follows.  All quoted text is from Coursera
instructions or the upstream data itself.  You can [jump to my transformations
of the original dataset](#transforming-the-original-dataset).

The original dataset was introduced to us via the Project instruction page:

    One of the most exciting areas in all of data science right now is wearable
    computing - see for example this article . Companies like Fitbit, Nike, and
    Jawbone Up are racing to develop the most advanced algorithms to attract new
    users. The data linked to from the course website represent data collected
    from the accelerometers from the Samsung Galaxy S smartphone. A full
    description is available at the site where the data was obtained:

    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

    Here are the data for the project:

    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### Upstream Credits

The README.txt file in the upstream data credits it to:

    ==================================================================
    Human Activity Recognition Using Smartphones Dataset
    Version 1.0
    ==================================================================
    Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
    Smartlab - Non Linear Complex Systems Laboratory
    DITEN - Università degli Studi di Genova.
    Via Opera Pia 11A, I-16145, Genoa, Italy.
    activityrecognition@smartlab.ws
    www.smartlab.ws
    ==================================================================

### Overview

The README.txt in the upstream data provides this overview:

    The experiments have been carried out with a group of 30 volunteers within an
    age bracket of 19-48 years. Each person performed six activities (WALKING,
    WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a
    smartphone (Samsung Galaxy S II) on the waist. Using its embedded
    accelerometer and gyroscope, we captured 3-axial linear acceleration and
    3-axial angular velocity at a constant rate of 50Hz. The experiments have been
    video-recorded to label the data manually. The obtained dataset has been
    randomly partitioned into two sets, where 70% of the volunteers was selected
    for generating the training data and 30% the test data.

    The sensor signals (accelerometer and gyroscope) were pre-processed by
    applying noise filters and then sampled in fixed-width sliding windows of 2.56
    sec and 50% overlap (128 readings/window). The sensor acceleration signal,
    which has gravitational and body motion components, was separated using a
    Butterworth low-pass filter into body acceleration and gravity. The
    gravitational force is assumed to have only low frequency components,
    therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a
    vector of features was obtained by calculating variables from the time and
    frequency domain. See 'features_info.txt' for more details.

    For each record it is provided:
    ======================================

    - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
    - Triaxial Angular velocity from the gyroscope.
    - A 561-feature vector with time and frequency domain variables.
    - Its activity label.
    - An identifier of the subject who carried out the experiment.

### Original Dataset Details

The following is from the "Feature Selection" section of the
"features_info.txt" file in the original dataset.

    The features selected for this database come from the accelerometer and
    gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain
    signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.
    Then they were filtered using a median filter and a 3rd order low pass
    Butterworth filter with a corner frequency of 20 Hz to remove noise.
    Similarly, the acceleration signal was then separated into body and gravity
    acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass
    Butterworth filter with a corner frequency of 0.3 Hz.

    Subsequently, the body linear acceleration and angular velocity were derived
    in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also
    the magnitude of these three-dimensional signals were calculated using the
    Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag,
    tBodyGyroJerkMag).

    Finally a Fast Fourier Transform (FFT) was applied to some of these signals
    producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag,
    fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain
    signals).

## Transforming the Original Dataset

In the original dataset there are 561 variables tracked for each obversation.

In addition, each observation is associated (via secondary files) with a
subject (of which there are 30) and an activity (there are 6).

### Assembling a single data frame

Data from the following files (extracted from the above zip file) is combined
into a single data frame, which is then subsetted to only include the
variables related to standard deviation or mean:

* UCI HAR Dataset/activity_labels.txt
* UCI HAR Dataset/features.txt
* UCI HAR Dataset/test/X_test.txt
* UCI HAR Dataset/test/y_test.txt
* UCI HAR Dataset/test/subject_test.txt
* UCI HAR Dataset/train/X_train.txt
* UCI HAR Dataset/train/y_train.txt
* UCI HAR Dataset/train/subject_train.txt

The upstream "X files" (X_test.txt & X_train.txt) provide the observational
data separated into a set of training data and a set of test data (as
described above, in the original dataset documentation); these files will be
concatenated together with rbind().  There will be no further distinction
between test & train data within our subsetted dataset or the tidy dataset
derived from it.

Similarly, the y_test.txt & y_train.txt contain mappings for each row of
observational data to an integer representing one of the Activity labels.
These are also rbind()ed together, and sapply() is used to translate the integer
to a character string read from activity_labels.txt.

Again, subjects_test.txt & subjects_train.txt contain mappings for each row of
observational data to an integer this time representing the human who was the
subject of the observation.  These are also rbind()ed together into a single
integer vector.

Finally, cbind() is used to graft our new activity & subject vectors onto the
merged observational data, and names() is used to assign column names read
from features.txt + "activity" + "subject".

The resulting single data frame contains 10299 observations of 563 variables,
the original 561 numeric observations, plus the added "activity" factor, and
integer vector "subject".  In addition, the numeric observations have been
named with values read from features.txt.

### Subsetting the data

The instruction for subsetting the data is "Extracts only the measurements on
the mean and standard deviation for each measurement."

There are 86 variables in the original data set that match the regexp
'(mean|std)' case-insensitively:

```
    tBodyAcc-mean()-X               tBodyAcc-mean()-Y               tBodyAcc-mean()-Z
    tBodyAcc-std()-X                tBodyAcc-std()-Y                tBodyAcc-std()-Z

    tGravityAcc-mean()-X            tGravityAcc-mean()-Y            tGravityAcc-mean()-Z
    tGravityAcc-std()-X             tGravityAcc-std()-Y             tGravityAcc-std()-Z

    tBodyAccJerk-mean()-X           tBodyAccJerk-mean()-Y           tBodyAccJerk-mean()-Z
    tBodyAccJerk-std()-X            tBodyAccJerk-std()-Y            tBodyAccJerk-std()-Z

    tBodyGyro-mean()-X              tBodyGyro-mean()-Y              tBodyGyro-mean()-Z
    tBodyGyro-std()-X               tBodyGyro-std()-Y               tBodyGyro-std()-Z

    tBodyGyroJerk-mean()-X          tBodyGyroJerk-mean()-Y          tBodyGyroJerk-mean()-Z
    tBodyGyroJerk-std()-X           tBodyGyroJerk-std()-Y           tBodyGyroJerk-std()-Z

            tBodyAccMag-mean()                      tBodyAccMag-std()
            tGravityAccMag-mean()                   tGravityAccMag-std()
            tBodyAccJerkMag-mean()                  tBodyAccJerkMag-std()
            tBodyGyroMag-mean()                     tBodyGyroMag-std()
            tBodyGyroJerkMag-mean()                 tBodyGyroJerkMag-std()

    fBodyAcc-mean()-X               fBodyAcc-mean()-Y               fBodyAcc-mean()-Z
    fBodyAcc-std()-X                fBodyAcc-std()-Y                fBodyAcc-std()-Z
    fBodyAcc-meanFreq()-X           fBodyAcc-meanFreq()-Y           fBodyAcc-meanFreq()-Z

    fBodyAccJerk-mean()-X           fBodyAccJerk-mean()-Y           fBodyAccJerk-mean()-Z
    fBodyAccJerk-std()-X            fBodyAccJerk-std()-Y            fBodyAccJerk-std()-Z
    fBodyAccJerk-meanFreq()-X       fBodyAccJerk-meanFreq()-Y       fBodyAccJerk-meanFreq()-Z

    fBodyGyro-mean()-X              fBodyGyro-mean()-Y              fBodyGyro-mean()-Z
    fBodyGyro-std()-X               fBodyGyro-std()-Y               fBodyGyro-std()-Z
    fBodyGyro-meanFreq()-X          fBodyGyro-meanFreq()-Y          fBodyGyro-meanFreq()-Z

    fBodyAccMag-mean()              fBodyAccMag-std()               fBodyAccMag-meanFreq()
    fBodyBodyAccJerkMag-mean()      fBodyBodyAccJerkMag-std()       fBodyBodyAccJerkMag-meanFreq()
    fBodyBodyGyroMag-mean()         fBodyBodyGyroMag-std()          fBodyBodyGyroMag-meanFreq()
    fBodyBodyGyroJerkMag-mean()     fBodyBodyGyroJerkMag-std()      fBodyBodyGyroJerkMag-meanFreq()

            angle(tBodyAccMean,gravity)             angle(tBodyAccJerkMean),gravityMean)
            angle(tBodyGyroMean,gravityMean)        angle(tBodyGyroJerkMean,gravityMean)

    angle(X,gravityMean)            angle(Y,gravityMean)            angle(Z,gravityMean)
```

It is unclear to me whether the 20 meanFreq, gravityMean, and angle(...)
variables are to be included.  From the "Feature Selection" excerpt above it
appears some of these values at least are calculations rather than
measurements, but there is also the argument that all of them are more
calculation than simple measurement.

I decided to err on the side of possibly including too many variables, and
chose to subset the full set of 86.

My subsetting implementation is such that the regular expression responsible
for selecting variables based on their names can easily be changed with no
further code changes required (there is no assumption about the number of
columns returned, or position of any particular column, except that activity &
subject are last), so refining the regex later after seeing the data and
realizing there are too many columns seems safer than possibly omitting wanted
columns from the start.

To accomplish this subset, I created a logical vector of feature names
sapply()ed to a function that used grepl() to test each name against the
simple regex '(mean|std)' (with ignore.case=T), and applied this column mask
to the single data frame prepared above.

The data returned by `getStdsAndMeansDataset()` includes these 86 columns of
named numerical data, plus the added "activity" factor, and integer vector
"subject".


### Transformation of Variable Names

The names of the 86 numeric variables are modified by reading the subset data
from disk with `read.table(check.names = T)` which converts any characters
that are not valid for variable names in R to a dot, so for example,
"angle(Z,gravityMean)" becomes "angle.Z.gravityMean."

In addition to converting invalid characters, `check.names` also ensures that
all converted names are unique.

This results in a set of human and machine readable, descriptive, and unique
variable names generated by R itself.


### Aggregate Means in the Tidy Dataset

The final transformation of the original dataset into our tidy dataset
calculates the mean of all observations, aggregate for each unique pair of the
activity and subject variables that were added in the previous steps.

This results in 180 rows (30 subjects * 6 actions) of 88 variables (the 86
renamed numeric variables above, averaged for each unique pair of activity and
subject, plus the "activity" and "subject" columns themselves.


## Table of Tidy Dataset Variables


| Tidy Dataset Name                    | Class   | Description |
| ------------------------------------ | ------- |-------------------------------------- |
| activity                             | factor  | Factor w/ 6 levels "LAYING","SITTING",..
| subject                              | integer | Int [1:30] identifier for subject of observations
| tBodyAcc.mean...X                    | numeric | Aggregate mean of tBodyAcc-mean()-X for activity + subject
| tBodyAcc.mean...Y                    | numeric | Aggregate mean of tBodyAcc-mean()-Y for activity + subject
| tBodyAcc.mean...Z                    | numeric | Aggregate mean of tBodyAcc-mean()-Z for activity + subject
| tBodyAcc.std...X                     | numeric | Aggregate mean of tBodyAcc-std()-X for activity + subject
| tBodyAcc.std...Y                     | numeric | Aggregate mean of tBodyAcc-std()-Y for activity + subject
| tBodyAcc.std...Z                     | numeric | Aggregate mean of tBodyAcc-std()-Z for activity + subject
| tGravityAcc.mean...X                 | numeric | Aggregate mean of tGravityAcc-mean()-X for activity + subject
| tGravityAcc.mean...Y                 | numeric | Aggregate mean of tGravityAcc-mean()-Y for activity + subject
| tGravityAcc.mean...Z                 | numeric | Aggregate mean of tGravityAcc-mean()-Z for activity + subject
| tGravityAcc.std...X                  | numeric | Aggregate mean of tGravityAcc-std()-X for activity + subject
| tGravityAcc.std...Y                  | numeric | Aggregate mean of tGravityAcc-std()-Y for activity + subject
| tGravityAcc.std...Z                  | numeric | Aggregate mean of tGravityAcc-std()-Z for activity + subject
| tBodyAccJerk.mean...X                | numeric | Aggregate mean of tBodyAccJerk-mean()-X for activity + subject
| tBodyAccJerk.mean...Y                | numeric | Aggregate mean of tBodyAccJerk-mean()-Y for activity + subject
| tBodyAccJerk.mean...Z                | numeric | Aggregate mean of tBodyAccJerk-mean()-Z for activity + subject
| tBodyAccJerk.std...X                 | numeric | Aggregate mean of tBodyAccJerk-std()-X for activity + subject
| tBodyAccJerk.std...Y                 | numeric | Aggregate mean of tBodyAccJerk-std()-Y for activity + subject
| tBodyAccJerk.std...Z                 | numeric | Aggregate mean of tBodyAccJerk-std()-Z for activity + subject
| tBodyGyro.mean...X                   | numeric | Aggregate mean of tBodyGyro-mean()-X for activity + subject
| tBodyGyro.mean...Y                   | numeric | Aggregate mean of tBodyGyro-mean()-Y for activity + subject
| tBodyGyro.mean...Z                   | numeric | Aggregate mean of tBodyGyro-mean()-Z for activity + subject
| tBodyGyro.std...X                    | numeric | Aggregate mean of tBodyGyro-std()-X for activity + subject
| tBodyGyro.std...Y                    | numeric | Aggregate mean of tBodyGyro-std()-Y for activity + subject
| tBodyGyro.std...Z                    | numeric | Aggregate mean of tBodyGyro-std()-Z for activity + subject
| tBodyGyroJerk.mean...X               | numeric | Aggregate mean of tBodyGyroJerk-mean()-X for activity + subject
| tBodyGyroJerk.mean...Y               | numeric | Aggregate mean of tBodyGyroJerk-mean()-Y for activity + subject
| tBodyGyroJerk.mean...Z               | numeric | Aggregate mean of tBodyGyroJerk-mean()-Z for activity + subject
| tBodyGyroJerk.std...X                | numeric | Aggregate mean of tBodyGyroJerk-std()-X for activity + subject
| tBodyGyroJerk.std...Y                | numeric | Aggregate mean of tBodyGyroJerk-std()-Y for activity + subject
| tBodyGyroJerk.std...Z                | numeric | Aggregate mean of tBodyGyroJerk-std()-Z for activity + subject
| tBodyAccMag.mean..                   | numeric | Aggregate mean of tBodyAccMag-mean() for activity + subject
| tBodyAccMag.std..                    | numeric | Aggregate mean of tBodyAccMag-std() for activity + subject
| tGravityAccMag.mean..                | numeric | Aggregate mean of tGravityAccMag-mean() for activity + subject
| tGravityAccMag.std..                 | numeric | Aggregate mean of tGravityAccMag-std() for activity + subject
| tBodyAccJerkMag.mean..               | numeric | Aggregate mean of tBodyAccJerkMag-mean() for activity + subject
| tBodyAccJerkMag.std..                | numeric | Aggregate mean of tBodyAccJerkMag-std() for activity + subject
| tBodyGyroMag.mean..                  | numeric | Aggregate mean of tBodyGyroMag-mean() for activity + subject
| tBodyGyroMag.std..                   | numeric | Aggregate mean of tBodyGyroMag-std() for activity + subject
| tBodyGyroJerkMag.mean..              | numeric | Aggregate mean of tBodyGyroJerkMag-mean() for activity + subject
| tBodyGyroJerkMag.std..               | numeric | Aggregate mean of tBodyGyroJerkMag-std() for activity + subject
| fBodyAcc.mean...X                    | numeric | Aggregate mean of fBodyAcc-mean()-X for activity + subject
| fBodyAcc.mean...Y                    | numeric | Aggregate mean of fBodyAcc-mean()-Y for activity + subject
| fBodyAcc.mean...Z                    | numeric | Aggregate mean of fBodyAcc-mean()-Z for activity + subject
| fBodyAcc.std...X                     | numeric | Aggregate mean of fBodyAcc-std()-X for activity + subject
| fBodyAcc.std...Y                     | numeric | Aggregate mean of fBodyAcc-std()-Y for activity + subject
| fBodyAcc.std...Z                     | numeric | Aggregate mean of fBodyAcc-std()-Z for activity + subject
| fBodyAcc.meanFreq...X                | numeric | Aggregate mean of fBodyAcc-meanFreq()-X for activity + subject
| fBodyAcc.meanFreq...Y                | numeric | Aggregate mean of fBodyAcc-meanFreq()-Y for activity + subject
| fBodyAcc.meanFreq...Z                | numeric | Aggregate mean of fBodyAcc-meanFreq()-Z for activity + subject
| fBodyAccJerk.mean...X                | numeric | Aggregate mean of fBodyAccJerk-mean()-X for activity + subject
| fBodyAccJerk.mean...Y                | numeric | Aggregate mean of fBodyAccJerk-mean()-Y for activity + subject
| fBodyAccJerk.mean...Z                | numeric | Aggregate mean of fBodyAccJerk-mean()-Z for activity + subject
| fBodyAccJerk.std...X                 | numeric | Aggregate mean of fBodyAccJerk-std()-X for activity + subject
| fBodyAccJerk.std...Y                 | numeric | Aggregate mean of fBodyAccJerk-std()-Y for activity + subject
| fBodyAccJerk.std...Z                 | numeric | Aggregate mean of fBodyAccJerk-std()-Z for activity + subject
| fBodyAccJerk.meanFreq...X            | numeric | Aggregate mean of fBodyAccJerk-meanFreq()-X for activity + subject
| fBodyAccJerk.meanFreq...Y            | numeric | Aggregate mean of fBodyAccJerk-meanFreq()-Y for activity + subject
| fBodyAccJerk.meanFreq...Z            | numeric | Aggregate mean of fBodyAccJerk-meanFreq()-Z for activity + subject
| fBodyGyro.mean...X                   | numeric | Aggregate mean of fBodyGyro-mean()-X for activity + subject
| fBodyGyro.mean...Y                   | numeric | Aggregate mean of fBodyGyro-mean()-Y for activity + subject
| fBodyGyro.mean...Z                   | numeric | Aggregate mean of fBodyGyro-mean()-Z for activity + subject
| fBodyGyro.std...X                    | numeric | Aggregate mean of fBodyGyro-std()-X for activity + subject
| fBodyGyro.std...Y                    | numeric | Aggregate mean of fBodyGyro-std()-Y for activity + subject
| fBodyGyro.std...Z                    | numeric | Aggregate mean of fBodyGyro-std()-Z for activity + subject
| fBodyGyro.meanFreq...X               | numeric | Aggregate mean of fBodyGyro-meanFreq()-X for activity + subject
| fBodyGyro.meanFreq...Y               | numeric | Aggregate mean of fBodyGyro-meanFreq()-Y for activity + subject
| fBodyGyro.meanFreq...Z               | numeric | Aggregate mean of fBodyGyro-meanFreq()-Z for activity + subject
| fBodyAccMag.mean..                   | numeric | Aggregate mean of fBodyAccMag-mean() for activity + subject
| fBodyAccMag.std..                    | numeric | Aggregate mean of fBodyAccMag-std() for activity + subject
| fBodyAccMag.meanFreq..               | numeric | Aggregate mean of fBodyAccMag-meanFreq() for activity + subject
| fBodyBodyAccJerkMag.mean..           | numeric | Aggregate mean of fBodyBodyAccJerkMag-mean() for activity + subject
| fBodyBodyAccJerkMag.std..            | numeric | Aggregate mean of fBodyBodyAccJerkMag-std() for activity + subject
| fBodyBodyAccJerkMag.meanFreq..       | numeric | Aggregate mean of fBodyBodyAccJerkMag-meanFreq() for activity + subject
| fBodyBodyGyroMag.mean..              | numeric | Aggregate mean of fBodyBodyGyroMag-mean() for activity + subject
| fBodyBodyGyroMag.std..               | numeric | Aggregate mean of fBodyBodyGyroMag-std() for activity + subject
| fBodyBodyGyroMag.meanFreq..          | numeric | Aggregate mean of fBodyBodyGyroMag-meanFreq() for activity + subject
| fBodyBodyGyroJerkMag.mean..          | numeric | Aggregate mean of fBodyBodyGyroJerkMag-mean() for activity + subject
| fBodyBodyGyroJerkMag.std..           | numeric | Aggregate mean of fBodyBodyGyroJerkMag-std() for activity + subject
| fBodyBodyGyroJerkMag.meanFreq..      | numeric | Aggregate mean of fBodyBodyGyroJerkMag-meanFreq() for activity + subject
| angle.tBodyAccMean.gravity.          | numeric | Aggregate mean of angle(tBodyAccMean,gravity) for activity + subject
| angle.tBodyAccJerkMean..gravityMean. | numeric | Aggregate mean of angle(tBodyAccJerkMean),gravityMean) for activity + subject
| angle.tBodyGyroMean.gravityMean.     | numeric | Aggregate mean of angle(tBodyGyroMean,gravityMean) for activity + subject
| angle.tBodyGyroJerkMean.gravityMean. | numeric | Aggregate mean of angle(tBodyGyroJerkMean,gravityMean) for activity + subject
| angle.X.gravityMean.                 | numeric | Aggregate mean of angle(X,gravityMean) for activity + subject
| angle.Y.gravityMean.                 | numeric | Aggregate mean of angle(Y,gravityMean) for activity + subject
| angle.Z.gravityMean.                 | numeric | Aggregate mean of angle(Z,gravityMean) for activity + subject

