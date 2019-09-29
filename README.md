# Getting and Cleaning Data Course Project

## 1. Merge the training and the test sets to create one data set
First we check the files in "train" and "test" folder and we observe coincidences in number of rows and columns.
Next we import them (except the internal data that doesn't provide us with relevant information)
Then we merge the data frames that match the number of rows:
  - subject_test, y_test and x_test
  - subject_train, y_train, x_train
Then we merge the resultant files that have the same number of columns: merge_test and merge_train

## 2. Extract only the measurements on the mean and standard deviation for each measurement
We import the features file which contains the variable names for the features.
Then we filter this names collecting only the ones with mean() or std().
We match the variable name in the merge with the features adding "V" to the feature index.
We use the modified index to perform a select on the merged data frame.

## 3. Use descriptive activity names to name the activities in the data set
We import the activity file and match the names with the y index on the merged data frame.
Then we mutate the y column to use the names instead of the ids

## 4. Appropriately label the data set with descriptive variable names
We first change the names of the features to be more descriptive and then we apply the result in the merged data frame columns (and also change the y col name to "activity")

## 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
First we group by subject and activity columns and then we summarise the data with the mean function.

## Export
Finally we export the data of the merged data frame and the average data frame to txt.
