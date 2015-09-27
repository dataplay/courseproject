if (!file.exists("HARdata"))  { dir.create("HARdata")}
zipfile <- tempfile()

## Downlanding and unzipping UCI HAR Dataset" from URL
## Creating external directory "HARdata" to save files
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", zipfile)
unzip(zipfile, exdir = "HARdata")
actlabel <- read.table("~/HARdata/UCI HAR Dataset/activity_labels.txt")
features <- read.table("~/HARdata/UCI HAR Dataset/features.txt")
col_labels <- features[,c("V2")]

## Reading testing data from the "test" folder in the unzipped file "UCI HAR Dataset"
testsub <- read.table("~/HARdata/UCI HAR Dataset/test/subject_test.txt", col.names=c("subject"))
xtest <- read.table("~/HARdata/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("~/HARdata/UCI HAR Dataset/test/y_test.txt", col.names=c("activity"))
colnames(xtest) <- col_labels

## Reading training data from the "train" folder in the unzipped file "UCI HAR Dataset"
trainsub <- read.table("~/HARdata/UCI HAR Dataset/train/subject_train.txt", col.names=c("subject"))
xtrain <- read.table("~/HARdata/UCI HAR Dataset/train/X_train.txt")
ytrain<- read.table("~/HARdata/UCI HAR Dataset/train/y_train.txt", col.names=c("activity"))
colnames(xtrain) <- col_labels

## Removing from testing and training data sets duplicate variables with "bandsEnergy()"  
## in their names that are not needed in the tidy data set 
## Removing deuplicate columns will allow the "select" function to work properly
xtest_subset1 <- subset(xtest, select = -c(303:344, 382:423, 461:502))
xtrain_subset1 <- subset(xtrain, select = -c(303:344, 382:423, 461:502))

library(dplyr)

## Select from testing data set only variables that are 
## means or standard deviations of measurements
xtest_subset86 <- select(xtest_subset1, contains("Mean"), contains("mean"), contains("std"))
## Combining files to create the testing data set
testdata86 <- cbind(testsub, ytest, xtest_subset86)

## Select from training data set only variables that are 
## means or standard deviations of measurements
xtrain_subset86 <- select(xtrain_subset1, contains("Mean"), contains("mean"), contains("std"))
## Combining files to create the training data set
traindata86 <- cbind(trainsub, ytrain, xtrain_subset86)

## Merge testing and training data together 
mergedata86 <- rbind(testdata86, traindata86)
meandata86 <- summarise_each(group_by(mergedata86, subject, activity), funs(mean))


## Use descriptive activity names to label the activities in the data set
meandata86$activity <- as.factor(meandata86$activity)
levels(meandata86$activity) <- c("Walking", "Walking_Upstairs", "Walking_Downstairs", "Sitting", "Standing", "Laying")

## Renaming the variable names to make them more descriptive

## A minor revision of variables originally named "subject" and "activity"
meandata86 <- rename(meandata86, SubjectId=subject, ActivityDailyLiving=activity)

## The rest of the variables are now the averages of the measurements; 
## the name of each variable is revised accordingly to reflect this. 
## This is meant to differentiate the new variables from the original variables used to calculate the mean.
## The t (which stands for time) and f (which stands for frequency) in the original
## variable names are now spelled out to make variable names more descriptive.
names(meandata86) <- gsub("tBodyAcc", "Mean_TimeBodyAcc", names(meandata86))
names(meandata86) <- gsub("tGravityAcc", "Mean_TimeGravityAcc", names(meandata86))
names(meandata86) <- gsub("tBodyGyro", "Mean_TimeBodyGyro", names(meandata86))
names(meandata86) <- gsub("fBodyAcc", "Mean_FreqBodyAcc", names(meandata86))
names(meandata86) <- gsub("fGravityAcc", "Mean_FreqGravityAcc", names(meandata86))
names(meandata86) <- gsub("fBodyGyro", "Mean_FreqBodyGyro", names(meandata86))
names(meandata86) <- gsub("fBodyBody", "Mean_FreqBodyBody", names(meandata86))
names(meandata86) <- gsub("angle", "Mean_Angle", names(meandata86))

## Writing the data file into a text file for submission per assignment instruction
meancol <- colnames(meandata86)
write(meancol, file = "variable_lst86.txt")
write.table(meandata86, file="meandata86.txt", row.name=FALSE)