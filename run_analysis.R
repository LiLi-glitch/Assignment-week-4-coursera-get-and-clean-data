
#You should create one R script called run_analysis.R that does the following.
#DONE

#download the zipfile and unzip it
Dataset <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./FUCI.zip")

unzip(zipfile="./FUCI.zip", exdir = ".")

#load text files (activity_label and name the columns)
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt") 
colnames(activity_labels)<- c("activityID", "activityType")

#load text file features (these are the list of column names of the dataset)
features <- read.table("./UCI HAR Dataset/features.txt")

##################################################################
#1. Merges the training and the test sets to create one data set.
##################################################################
##training - set##
#load training set in object
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

#there are no column names for x_train, name x_train columns with the second column of object "features", y_train is 1 column that contains the activitylabelID, 
#subject_train is one column with repetitive subjectID
colnames(x_train) <- features$V2
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

#then we can merge these sets together with cbind
merge_train <- cbind(x_train, y_train, subject_train)

##test - set##
#load test data in object
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")

#name column names for x_test with second column of object "features", y_test is 1 column that contains the activityID, 
#subject_test is one column with repetitive subjectID
colnames(x_test) <- features$V2
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

#merge test set with cbind
merge_test <- cbind(x_test, y_test, subject_test)

##merge test and training set## <-- objective 1. Merges the training and the test sets to create one data set.
merge_train_test <- rbind(merge_test, merge_train)

##########################################################################################
#2.Extracts only the measurements on the mean and standard deviation for each measurement.
##########################################################################################

##look at all the column names
colnames <- colnames(merge_train_test)

##set criteria to the column names to get only column names that contain the IDs, mean and std
mean_std <- (grepl("activityID", colnames)| grepl("subjectID", colnames)| grepl("mean..", colnames)|grepl("std..", colnames))

##make subset by using the criteria of mean_std
MergeSetMeanStd <- merge_train_test[, mean_std == TRUE]

#########################################################################
#3.Uses descriptive activity names to name the activities in the data set
#########################################################################

##Replace activity ID and activityType by merging the activity_labels by activityID
MergeSetMeanStd_activity <- merge(MergeSetMeanStd, activity_labels, by = "activityID", all.x = TRUE)

#####################################################################
#4.Appropriately labels the data set with descriptive variable names.
#####################################################################
##write full out variables so no confusion will be induced
##Every name that begins with t or f should be replaced by time or frequency, respectively.
names(MergeSetMeanStd_activity)<-gsub("^t", "time", names(MergeSetMeanStd_activity))
names(MergeSetMeanStd_activity)<-gsub("^f", "frequency", names(MergeSetMeanStd_activity))

##Write out Acc, Gyro, Mag so it is complete clear to everybody else
names(MergeSetMeanStd_activity)<-gsub("Acc", "Accelerometer", names(MergeSetMeanStd_activity))
names(MergeSetMeanStd_activity)<-gsub("Gyro", "Gyroscope", names(MergeSetMeanStd_activity))
names(MergeSetMeanStd_activity)<-gsub("Mag", "Magnitude", names(MergeSetMeanStd_activity))

##There are some names that contain BodyBody, this should be Body.
names(MergeSetMeanStd_activity)<-gsub("BodyBody", "Body", names(MergeSetMeanStd_activity))

#################################################################################################################################################
#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#################################################################################################################################################

##create new dataset with mean statistics
Tidysetavg <- aggregate( . ~ subjectID + activityID, MergeSetMeanStd_activity, mean)
Tidysetavg <- Tidysetavg[order(Tidysetavg$subjectID, Tidysetavg$activityID), ]

##write output
write.table(Tidysetavg, "Tidysetavg.txt", row.name = FALSE)
