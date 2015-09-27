==========================================================
Getting and Cleaning Data - Introduction to Data Science

Course Project - September 2015

Code Book for Data Set �meandata86.txt� 

Aggregated data created from a subset of variables in the 
Human Activity Recognition Using Smartphones Data Set  
==========================================================


DATA DESCRIPTION:
================

====================

Variables 1 and 2:

1. SubjectId (numeric) - the identification of subject

2. ActivityDailyLiving (factor) - one of the 6 everyday activities performed by each subject. Categories include �Walking", "Walking_Upstairs", "Walking_Downstairs", "Sitting", "Standing", "Laying�


Variables 3-88:

Variables 3 to 88 below are all numeric. They are the averages of either the means or standard deviations - denoted by mean() or std() in the variable name accordingly - of each type of measurement taken by each activity of each subject recorded by the Samsung Galaxy S II smartphone. X, Y or Z at the end of the variable name denotes the direction of the 3-axial signals. The variables include measurements of body and gravity acceleration signals, jerk signals measuring the body linear acceleration (BodyAcc) and angular velocity, and signals produced through the application of Fast Fourier Transform (FFT). Additional vectors were obtained by averaging the signals in a signal window sample. These are used on the angle() variable in the original dataset. The averages of the angle() variables are also calculated and recorded in Variables 49-55.

Variable names are constructed in the format intended to provide a description of the signal recorded as well as the calculations conducted (e.g. Mean_TimeBodyAcc-mean()-X - average of mean estimated time of body acceleration signals from direction X by activity by subject or Mean_TimeGravityAcc-std()-X - average of the standard deviations of the estimated time of gravity acceleration signals from director X by activity by subject). 

Further documentation on each measurement can be found at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. 

 
3.	Mean_TimeBodyAcc-mean()-X