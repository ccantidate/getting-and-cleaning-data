## This R script, run_analysis.R, does the following: 
##1.	Merges into one data set the training and the test sets. The data was captured from a series
##      of experiments monitoring the activities of participant wearing a Smartphone on their waists.
##2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
##3.	Uses descriptive activity names to name the activities in the data set
##4.	Appropriately labels the data set with descriptive variable names. 
##5.	From the data set in step 4, creates a second, independent tidy data set 
##      with the average of each variable for each activity and each subject.
##  This script was written on a Mac OS 10.12.6 and R version 3.4.1

## load the dplyr package
library(dplyr)

## Check if the Data directory exists, if not, create the directory. Download the file.
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/UCIHARDataset.zip", method = "curl")

## unzip the downloaded file, UCIHARDataset.zip, to the ./data directory
if (!file.exists("./data/UCI HAR Dataset")) { 
        unzip(zipfile="./data/UCIHARDataset.zip" ,exdir="./data")
}


## Merges the training and the test sets to create one data set
        ## Read the unzipped files

           ## Read the training files
           subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
           activity_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE)
           measurement_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE)
                
           ## Read the test files  
           subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
           activity_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE)
           measurement_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
                
           ## Read the features file
           features <- read.table("./data/UCI HAR Dataset/features.txt", header = FALSE)
                
           ## Read the activity labels file
           activity_labels = read.table("./data/UCI HAR Dataset/activity_labels.txt", header = FALSE)
        
        ## Provide column names to each data table
        colnames(measurement_train) <- features[,2] 
        colnames(measurement_test) <- features[,2] 
        colnames(activity_train) <- "activity"
        colnames(activity_test) <- "activity"
        colnames(subject_train) <- "subjectId"
        colnames(subject_test) <- "subjectId"
        colnames(activity_labels) <- c("activityId","activity")
       
                        
        ## Merge all training and test data sets in one data set. Putting the data columns in order by
        ## Subject Id, Activity and Measurement and then merging train and test data rows, 
        ## i.e., appending the test data rows to the train data rows.
        merged_train <- cbind(subject_train, activity_train, measurement_train)
        merged_test <- cbind(subject_test, activity_test, measurement_test)
        mergedtraintest <- rbind(merged_train, merged_test)
        
## Extracts only the measurements on the mean and standard deviation for each measurement
        
        ## Create a vector of all the column names in the merged data set
        colNames <- names(mergedtraintest)
        
        ## Using the vector of calumn names, create a logical vector of TRUE and FALSE entries for the columns 
        ## containing mean or standard deviation measurements (i.e., the column name contains 
        ## "mean" or "std") and include the Subject Id and Activity columns. Note: not selecting the angle() columns
        ## although the column names contain the word "mean", the measurement is the angle between two vectors
        mean_and_std <- (
                        grepl("subjectId" , colNames) |
                        grepl("activity" , colNames) |                      
                        grepl("-mean.." , colNames) | 
                        grepl("-std.." , colNames) 
                        )
       
        ## Create a data set containing the data rows for the Subject Id and Activity columns 
        ## and any calumns with the mean or standard deviation measurements
        mergedtraintest_mean_std <- mergedtraintest[, mean_and_std == TRUE]
       
                
## Use descriptive activity names to name the activities in the data set
        
for (i in activity_labels[,1]) {
        mergedtraintest_mean_std[,2] <- sub(activity_labels[i,1], 
                                        activity_labels[i,2], mergedtraintest_mean_std[,2])
}


## Appropriately labels the data set with descriptive variable names
## Based on the information in the README file and in the feature_info file, assign descriptive names
## to the short name or abbreviations in the column names

names(mergedtraintest_mean_std) <- gsub("-mean", "Mean", names(mergedtraintest_mean_std))
names(mergedtraintest_mean_std) <- gsub("-std", "StandardDeviation", names(mergedtraintest_mean_std))
names(mergedtraintest_mean_std) <- gsub("Freq", "Frequency", names(mergedtraintest_mean_std))
names(mergedtraintest_mean_std) <- gsub("^f","Frequency", names(mergedtraintest_mean_std))
names(mergedtraintest_mean_std) <- gsub("^t","Time", names(mergedtraintest_mean_std))
names(mergedtraintest_mean_std) <- gsub("Acc","Acceleration", names(mergedtraintest_mean_std))
names(mergedtraintest_mean_std) <- gsub("Mag","Magnitude", names(mergedtraintest_mean_std))
names(mergedtraintest_mean_std) <- gsub("[-()]", "", names(mergedtraintest_mean_std))
        
        
## Create a second, independent tidy data set with the average of each variable for each 
## activity and each subject
        
TidySet_average_by_activity_subject <- mergedtraintest_mean_std %>%
                                        group_by(subjectId, activity) %>%
                                        summarise_all(funs(mean))

TidySet_average_by_activity_subject <- TidySet_average_by_activity_subject[order(
        TidySet_average_by_activity_subject$subjectId, 
        TidySet_average_by_activity_subject$activity),]
        
write.table(TidySet_average_by_activity_subject, 
            "./data/TidyDataSetAverage_by_activity_subject.txt", 
            row.name=FALSE)
