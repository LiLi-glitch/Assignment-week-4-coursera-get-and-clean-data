
#You should create one R script called run_analysis.R that does the following.
#DONE

#download the zipfile and unzip it
Dataset <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./FUCI.zip")

unzip(zipfile="./FUCI.zip", exdir = ".")

#load text files
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

#1. Merges the training and the test sets to create one data set.

#load training set
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

#load test data
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")

#2.Extracts only the measurements on the mean and standard deviation for each measurement.

#3.Uses descriptive activity names to name the activities in the data set

#4.Appropriately labels the data set with descriptive variable names.

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.