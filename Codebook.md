Codebook
--------

This is the code book for the Getting and Cleaning Data Course project that provides additional information about the variables, the data, and any transformations or work performed to clean up the data.

Files used in the project
-------------------------

The dataset includes the following files:

-   'README.txt'

-   'features\_info.txt': Shows information about the variables used on the feature vector.

-   'features.txt': List of all features.

-   'activity\_labels.txt': Links the class labels with their activity name.

-   'train/X\_train.txt': Training set.

-   'train/y\_train.txt': Training labels.

-   'test/X\_test.txt': Test set.

-   'test/y\_test.txt': Test labels.

For each record, it is provided:

-   Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
-   Triaxial Angular velocity from the gyroscope.
-   A 561-feature vector with time and frequency domain variables.
-   Its activity label.
-   An identifier of the subject who carried out the experiment.

Preprocessing steps
-------------------

The zip file is downloaded from the URL provided for the project and then upzipped. The files will be placed into ./data directory. There are checks to see if the data directory and the UCI HAR Dataset directory exist before downloading and unzipping the files.

1. Merges into one data set the training and the test sets.
-----------------------------------------------------------

Read all the data files into R, provide column names to each data table and merge all training and test data sets in one data set. The script puts the data columns in order by Subject Id, Activity and Measurement and then merge train and test data rows, i.e., appends the test data rows to the train data rows.

2. Extracts only the measurements on the mean and standard deviation for each measurement.
------------------------------------------------------------------------------------------

The script performs the following:

-   Creates a vector of all the column names in the merged data set.
-   Using the vector of column names, creates a logical vector of TRUE and FALSE entries for the columns containing mean or standard deviation measurements (i.e., the column name contains "mean" or "std") and include the Subject Id and Activity columns.

Please note that the script does not select the angle() columns although the column names contain the word "mean", since this measurement is the angle between two vectors.

-   Creates a data set containing the data rows for the Subject Id and Activity columns and any calumns with the mean or standard deviation measurements

3. Uses descriptive activity names to name the activities in the data set.
--------------------------------------------------------------------------

Using the sub function, the script replaces the Activity Value (Id) with the activity name.

4. Appropriately labels the data set with descriptive variable names.
---------------------------------------------------------------------

Based on the information in the README file and in the feature\_info file (from the unzipped file), assigns descriptive names to the short name or abbreviations in the column names using the gsub function.

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
-------------------------------------------------------------------------------------------------------------------------------------------------

The script performs the following:

-   Groups the data by Subject and by Activity and summarizes the data by the mean for each Subject and Activity group
-   Creates a txt file created with write.table() using row.name=FALSE
