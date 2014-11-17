
= CodeBook for Getting and Cleaning Data Project

== Upstream Data

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

=== Upstream Credits

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

=== Overview

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

=== Original Dataset Details

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

== Transforming the Original Dataset

In the original dataset there are 561 variables tracked for each obversation.

In addition, each observation is associated (via secondary files) with a
subject (of which there are 30) and an activity (there are 6).

=== Subsetting the data

The instruction for subsetting the data is "Extracts only the measurements on
the mean and standard deviation for each measurement."

There are 86 variables in the original data set that match the regexp
'(mean|std)' case-insensitively:

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


It is unclear to me whether the 20 meanFreq, gravityMean, and angle(tBodyAccMean,gravity)
variables are to be included.  From the "Feature Selection" excerpt above it
appears some of these values at least are calculations rather than
measurements, but there is also the argument that all of them are more
calculation than simple measurement.

The subsetting implementation is such that the regular expression responsible
for selecting variables based on their names can easily be changed with no
further code changes required.

I therefore decided to err on the side of possibly including too many
variables, and subsetting the full set of 86.

The data returned by `getStdsAndMeansDataset()` includes these 86 columns of
numerical data, plus a column for the activity (called "activity",
c("SITTING", "STANDING", etc...)), and an integer column identifying the
subject (called "subject").


=== Aggregate Means in the Tidy Dataset

The final transformation of the original dataset into our tidy dataset
calculates the mean of all observations, aggregate for each unique pair of the
activity and subject variables that were added in the previous step.

This results in 180 rows (30 subjects * 6 actions) of 88 variables (the 86
above, plus "activity" and "subject"), with a named numeric value for each
representing the mean for that variable for each pair of activity and subject.

