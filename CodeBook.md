# CodeBook.md

This documents the function run_analysis.R and its output: CPANSWERS.txt

The code first downloads and unarchives the file at the following URL "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

The files are extracted using `unzip()` and saved to the working directory in a subfolder "/extract/"

If the files already exist, they are NOT overwritten.

## Data Folder Structure

The data is contained in .txt files in "/UCI HAR Dataset/test/" and "/UCI HAR Dataset/train/"
Both the test and training data is loaded listing the *subject*, *activity*, and *features*.
Once the data is loaded, the column names are adjusted to match the 561 features, as listed in "/UCI HAR Dataset/features.txt".
Then the activity codes are replaced with the 6 corresponding activity names as listed in "/UCI HAR Dataset/activity_labels.txt".

## Extraction of standard deviation and mean data

The variables containing "std" and "mean()" are extracted into a subset and organized based on *subject* and *activity*  using the `grep()` function as follows:

`DF[,grep("subject|activity|std|mean\\()",colnames(DF),value=TRUE)]`

A simple aggregate is created that takes the mean of each variable grouped by *subject* and *activity*.

`aggregate(.~subject+activity, DFx, mean)`

The result is then saved to CPANSWERS.txt in the working directory using `write.table()`.

The recommended method for loading the data is `read.table("CPANSWER.txt")`.

# Table Format - Variables

* Subject: The number of the subject in the test (1 to 30)
* Activity: The name of the activity being performed
    1. STANDING
    2. SITTING
    3. LAYING
    4. WALKING
    5. WALKING_DOWNSTAIRS
    6. WALKING_UPSTAIRS
* The remaining variables are **averages** of the features as a mean or standard deviation for each activity and subject.

See "/UCI HAR Dataset/features_info.txt" for information on each feature.