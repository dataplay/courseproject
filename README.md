=====================================================================
Getting and Cleaning Data - Introduction to Data Science

Course Project - September 2015

ReadMe for the r-programming script “run_analysis.R” to create dataset “meandata86.txt” 

R-programming script to create aggregated data from a subset of variables in the 
Human Activity Recognition Using Smartphones Data Set  

=====================================================================


DESCRIPTION of “run_analysis.R”:

STEP 1. “HARdata” is created in the main directory for the data files.  

if (!file.exists("HARdata"))  { dir.create("HARdata")}
zipfile <- tempfile()


STEP 2. The UCI HAR Dataset is downloaded from the given URL, unzipped and saved to the external directory "HARdata.” 

download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", zipfile)
unzip(zipfile, exdir = "HARdata")
actlabel <- read.table("~/HARdata/UCI HAR Dataset/activity_labels.txt")
features <- read.table("~/HARdata/UCI HAR Dataset/features.txt")
col_labels <- features[,c("V2")]


STEP 3. Read testing data from the files (subject_test.txt, x_test.txt, and y_test.txt) in the ”test" folder from the unzipped file "UCI HAR Dataset"

testsub <- read.table("~/HARdata/UCI HAR Dataset/test/subject_test.txt", col.names=c("subject"))
xtest <- read.table("~/HARdata/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("~/HARdata/UCI HAR Dataset/test/y_test.txt", col.names=c("activity"))
colnames(xtest) <- col_labels


STEP 4. Read training data from the files (subject_train.txt, x_train.txt, and y_train.txt) in the ”test" folder from the unzipped file "UCI HAR Dataset"

trainsub <- read.table("~/HARdata/UCI HAR Dataset/train/subject_train.txt", col.names=c("subject"))
xtrain <- read.table("~/HARdata/UCI HAR Dataset/train/X_train.txt")
ytrain<- read.table("~/HARdata/UCI HAR Dataset/train/y_train.txt", col.names=c("activity"))
colnames(xtrain) <- col_labels


STEP 5. Remove from testing and training data sets duplicate variables with "bandsEnergy()" in their names that are not needed in the tidy data set. Removing duplicate columns will allow the "select" function to work properly.

xtest_subset1 <- subset(xtest, select = -c(303:344, 382:423, 461:502))
xtrain_subset1 <- subset(xtrain, select = -c(303:344, 382:423, 461:502))

STEP 6. Open the package “dplyr” for the following steps
library(dplyr)

STEP 7. Select from testing data set only variables that are means or standard deviations of measurements from the list of variables in the original testing dataset. 

xtest_subset86 <- select(xtest_subset1, contains("Mean"), contains("mean"), contains("std"))
NOTE: Combining files to create the testing data set
testdata86 <- cbind(testsub, ytest, xtest_subset86)

STEP 8.  Select from training data set only variables that are means or standard deviations of measurements from the list of variables in the original training dataset. 

xtrain_subset86 <- select(xtrain_subset1, contains("Mean"), contains("mean"), contains("std"))
NOTE: Combining files to create the training data set
traindata86 <- cbind(trainsub, ytrain, xtrain_subset86)

STEP 9. Merge testing and training data together into mergedata86

mergedata86 <- rbind(testdata86, traindata86)
meandata86 <- summarise_each(group_by(mergedata86, subject, activity), funs(mean))


STEP 10. Use descriptive activity names to label the activities in the data set
meandata86$activity <- as.factor(meandata86$activity)
levels(meandata86$activity) <- c("Walking", "Walking_Upstairs", "Walking_Downstairs", "Sitting", "Standing", "Laying")

STEP 11.  Make a minor revision of variables originally named "subject" and "activity"
meandata86 <- rename(meandata86, SubjectId=subject, ActivityDailyLiving=activity)


STEP 12. The rest of the variables are now the averages of the measurements; the name of each variable is revised accordingly to reflect this.This is meant to differentiate the new variables from the original variables used to calculate the mean. The t (which stands for time) and f (which stands for frequency) in the original variable names are now spelled out to make variable names more descriptive.

names(meandata86) <- gsub("tBodyAcc", "Mean_TimeBodyAcc", names(meandata86))
names(meandata86) <- gsub("tGravityAcc", "Mean_TimeGravityAcc", names(meandata86))
names(meandata86) <- gsub("tBodyGyro", "Mean_TimeBodyGyro", names(meandata86))
names(meandata86) <- gsub("fBodyAcc", "Mean_FreqBodyAcc", names(meandata86))
names(meandata86) <- gsub("fGravityAcc", "Mean_FreqGravityAcc", names(meandata86))
names(meandata86) <- gsub("fBodyGyro", "Mean_FreqBodyGyro", names(meandata86))
names(meandata86) <- gsub("fBodyBody", "Mean_FreqBodyBody", names(meandata86))
names(meandata86) <- gsub("angle", "Mean_Angle", names(meandata86))

STEP 13.  Write the data file into a text file for submission per assignment instruction. Create the text file “variable_lst86.txt” which includes the list of variables in the data set “meandata86” to be used in the codebook.

meancol <- colnames(meandata86)
write(meancol, file = "variable_lst86.txt")
write.table(meandata86, file="meandata86.txt", row.name=FALSE)
