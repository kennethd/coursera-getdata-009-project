
# CodeBook for Getting and Cleaning Data Project

## Upstream Data

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

The subsetting implementation is such that the regular expression responsible
for selecting variables based on their names can easily be changed with no
further code changes required (there is no assumption about the number of
columns returned, or position of any particular column).

I therefore decided to err on the side of possibly including too many
variables, and subsetting the full set of 86.

The data returned by `getStdsAndMeansDataset()` includes these 86 columns of
numerical data, plus a column for the activity (called "activity",
c("SITTING", "STANDING", etc...)), and an integer column identifying the
subject (called "subject").


### Aggregate Means in the Tidy Dataset

The final transformation of the original dataset into our tidy dataset
calculates the mean of all observations, aggregate for each unique pair of the
activity and subject variables that were added in the previous step.

This results in 180 rows (30 subjects * 6 actions) of 88 variables (the 86
above, plus "activity" and "subject"), with a named numeric value for each
representing the mean for that variable for each pair of activity and subject.


### Transformation of Variable Names

The names of the 86 numeric variables are modified by reading the tidy dataset
from disk with `read.table(check.names = T)` which converts any characters
that are not valid for variable names in R to a dot, so for example,
"angle(Z,gravityMean)" becomes "angle.Z.gravityMean."

In addition to converting invalid characters, `check.names` also ensures that
all converted names are unique.

This results in a set of human and machine readable, descriptive, and unique
variable names generated by R itself.


## Table of Tidy Dataset Variables


| Tidy Dataset Name                    | Original Dataset Name                 | Class   |
| ------------------------------------ |-------------------------------------- | ------- |
| activity                             | NA                                    | factor  |
| subject                              | NA                                    | integer |
| tBodyAcc.mean...X                    | tBodyAcc-mean()-X                     | numeric |
| tBodyAcc.mean...Y                    | tBodyAcc-mean()-Y                     | numeric |
| tBodyAcc.mean...Z                    | tBodyAcc-mean()-Z                     | numeric |
| tBodyAcc.std...X                     | tBodyAcc-std()-X                      | numeric |
| tBodyAcc.std...Y                     | tBodyAcc-std()-Y                      | numeric |
| tBodyAcc.std...Z                     | tBodyAcc-std()-Z                      | numeric |
| tGravityAcc.mean...X                 | tGravityAcc-mean()-X                  | numeric |
| tGravityAcc.mean...Y                 | tGravityAcc-mean()-Y                  | numeric |
| tGravityAcc.mean...Z                 | tGravityAcc-mean()-Z                  | numeric |
| tGravityAcc.std...X                  | tGravityAcc-std()-X                   | numeric |
| tGravityAcc.std...Y                  | tGravityAcc-std()-Y                   | numeric |
| tGravityAcc.std...Z                  | tGravityAcc-std()-Z                   | numeric |
| tBodyAccJerk.mean...X                | tBodyAccJerk-mean()-X                 | numeric |
| tBodyAccJerk.mean...Y                | tBodyAccJerk-mean()-Y                 | numeric |
| tBodyAccJerk.mean...Z                | tBodyAccJerk-mean()-Z                 | numeric |
| tBodyAccJerk.std...X                 | tBodyAccJerk-std()-X                  | numeric |
| tBodyAccJerk.std...Y                 | tBodyAccJerk-std()-Y                  | numeric |
| tBodyAccJerk.std...Z                 | tBodyAccJerk-std()-Z                  | numeric |
| tBodyGyro.mean...X                   | tBodyGyro-mean()-X                    | numeric |
| tBodyGyro.mean...Y                   | tBodyGyro-mean()-Y                    | numeric |
| tBodyGyro.mean...Z                   | tBodyGyro-mean()-Z                    | numeric |
| tBodyGyro.std...X                    | tBodyGyro-std()-X                     | numeric |
| tBodyGyro.std...Y                    | tBodyGyro-std()-Y                     | numeric |
| tBodyGyro.std...Z                    | tBodyGyro-std()-Z                     | numeric |
| tBodyGyroJerk.mean...X               | tBodyGyroJerk-mean()-X                | numeric |
| tBodyGyroJerk.mean...Y               | tBodyGyroJerk-mean()-Y                | numeric |
| tBodyGyroJerk.mean...Z               | tBodyGyroJerk-mean()-Z                | numeric |
| tBodyGyroJerk.std...X                | tBodyGyroJerk-std()-X                 | numeric |
| tBodyGyroJerk.std...Y                | tBodyGyroJerk-std()-Y                 | numeric |
| tBodyGyroJerk.std...Z                | tBodyGyroJerk-std()-Z                 | numeric |
| tBodyAccMag.mean..                   | tBodyAccMag-mean()                    | numeric |
| tBodyAccMag.std..                    | tBodyAccMag-std()                     | numeric |
| tGravityAccMag.mean..                | tGravityAccMag-mean()                 | numeric |
| tGravityAccMag.std..                 | tGravityAccMag-std()                  | numeric |
| tBodyAccJerkMag.mean..               | tBodyAccJerkMag-mean()                | numeric |
| tBodyAccJerkMag.std..                | tBodyAccJerkMag-std()                 | numeric |
| tBodyGyroMag.mean..                  | tBodyGyroMag-mean()                   | numeric |
| tBodyGyroMag.std..                   | tBodyGyroMag-std()                    | numeric |
| tBodyGyroJerkMag.mean..              | tBodyGyroJerkMag-mean()               | numeric |
| tBodyGyroJerkMag.std..               | tBodyGyroJerkMag-std()                | numeric |
| fBodyAcc.mean...X                    | fBodyAcc-mean()-X                     | numeric |
| fBodyAcc.mean...Y                    | fBodyAcc-mean()-Y                     | numeric |
| fBodyAcc.mean...Z                    | fBodyAcc-mean()-Z                     | numeric |
| fBodyAcc.std...X                     | fBodyAcc-std()-X                      | numeric |
| fBodyAcc.std...Y                     | fBodyAcc-std()-Y                      | numeric |
| fBodyAcc.std...Z                     | fBodyAcc-std()-Z                      | numeric |
| fBodyAcc.meanFreq...X                | fBodyAcc-meanFreq()-X                 | numeric |
| fBodyAcc.meanFreq...Y                | fBodyAcc-meanFreq()-Y                 | numeric |
| fBodyAcc.meanFreq...Z                | fBodyAcc-meanFreq()-Z                 | numeric |
| fBodyAccJerk.mean...X                | fBodyAccJerk-mean()-X                 | numeric |
| fBodyAccJerk.mean...Y                | fBodyAccJerk-mean()-Y                 | numeric |
| fBodyAccJerk.mean...Z                | fBodyAccJerk-mean()-Z                 | numeric |
| fBodyAccJerk.std...X                 | fBodyAccJerk-std()-X                  | numeric |
| fBodyAccJerk.std...Y                 | fBodyAccJerk-std()-Y                  | numeric |
| fBodyAccJerk.std...Z                 | fBodyAccJerk-std()-Z                  | numeric |
| fBodyAccJerk.meanFreq...X            | fBodyAccJerk-meanFreq()-X             | numeric |
| fBodyAccJerk.meanFreq...Y            | fBodyAccJerk-meanFreq()-Y             | numeric |
| fBodyAccJerk.meanFreq...Z            | fBodyAccJerk-meanFreq()-Z             | numeric |
| fBodyGyro.mean...X                   | fBodyGyro-mean()-X                    | numeric |
| fBodyGyro.mean...Y                   | fBodyGyro-mean()-Y                    | numeric |
| fBodyGyro.mean...Z                   | fBodyGyro-mean()-Z                    | numeric |
| fBodyGyro.std...X                    | fBodyGyro-std()-X                     | numeric |
| fBodyGyro.std...Y                    | fBodyGyro-std()-Y                     | numeric |
| fBodyGyro.std...Z                    | fBodyGyro-std()-Z                     | numeric |
| fBodyGyro.meanFreq...X               | fBodyGyro-meanFreq()-X                | numeric |
| fBodyGyro.meanFreq...Y               | fBodyGyro-meanFreq()-Y                | numeric |
| fBodyGyro.meanFreq...Z               | fBodyGyro-meanFreq()-Z                | numeric |
| fBodyAccMag.mean..                   | fBodyAccMag-mean()                    | numeric |
| fBodyAccMag.std..                    | fBodyAccMag-std()                     | numeric |
| fBodyAccMag.meanFreq..               | fBodyAccMag-meanFreq()                | numeric |
| fBodyBodyAccJerkMag.mean..           | fBodyBodyAccJerkMag-mean()            | numeric |
| fBodyBodyAccJerkMag.std..            | fBodyBodyAccJerkMag-std()             | numeric |
| fBodyBodyAccJerkMag.meanFreq..       | fBodyBodyAccJerkMag-meanFreq()        | numeric |
| fBodyBodyGyroMag.mean..              | fBodyBodyGyroMag-mean()               | numeric |
| fBodyBodyGyroMag.std..               | fBodyBodyGyroMag-std()                | numeric |
| fBodyBodyGyroMag.meanFreq..          | fBodyBodyGyroMag-meanFreq()           | numeric |
| fBodyBodyGyroJerkMag.mean..          | fBodyBodyGyroJerkMag-mean()           | numeric |
| fBodyBodyGyroJerkMag.std..           | fBodyBodyGyroJerkMag-std()            | numeric |
| fBodyBodyGyroJerkMag.meanFreq..      | fBodyBodyGyroJerkMag-meanFreq()       | numeric |
| angle.tBodyAccMean.gravity.          | angle(tBodyAccMean,gravity)           | numeric |
| angle.tBodyAccJerkMean..gravityMean. | angle(tBodyAccJerkMean),gravityMean)  | numeric |
| angle.tBodyGyroMean.gravityMean.     | angle(tBodyGyroMean,gravityMean)      | numeric |
| angle.tBodyGyroJerkMean.gravityMean. | angle(tBodyGyroJerkMean,gravityMean)  | numeric |
| angle.X.gravityMean.                 | angle(X,gravityMean)                  | numeric |
| angle.Y.gravityMean.                 | angle(Y,gravityMean)                  | numeric |
| angle.Z.gravityMean.                 | angle(Z,gravityMean)                  | numeric |

