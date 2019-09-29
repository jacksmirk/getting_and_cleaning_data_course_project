## Getting and Cleaning Data Course Project
## author: Juan Gonzalez Doval
## date: 29 September 2019
## prerequisites: install dplyr package,
##                download .zip from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip,
##                extract data in "UCI HAR Dataset" folder
##

# load dplyr library
library(dplyr)

# 1. Merge the training and the test sets to create one data set
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
merge_test <- cbind(subject_test, y_test, x_test)
merge_train <- cbind(subject_train, y_train, x_train)
### rename labels to repetition
names(merge_test)[1:2] <- c("subject","y")
names(merge_train)[1:2] <- c("subject","y")
### merge test and train
merge_total <- rbind(merge_test, merge_train)

# 2. Extract only the measurements on the mean and standard deviation for each measurement
### features
features <- read.table("UCI HAR Dataset/features.txt")
### features with stg() or mean()
feat_std_and_mean <- features[grepl("mean()", features$V2, fixed = TRUE) | grepl("std()", features$V2, fixed = TRUE),]
### match variable names
feat_std_and_mean <- mutate(feat_std_and_mean, V1 = paste("V", V1, sep = ""))
### use these variable names as select for merge_total
merge_total_std_mean <- select(merge_total, c("subject","y",feat_std_and_mean$V1))

# 3. Use descriptive activity names to name the activities in the data set
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_match <- activity_labels[merge_total_std_mean$y,]
names(activity_match) <- c("y","activity")
mt_std_mean_activity <- mutate(merge_total_std_mean, y = activity_match$activity)

# 4. Appropriately label the data set with descriptive variable names
descriptiveNames <- gsub("-", ".", sub("^f", "freq", sub("^t", "time", feat_std_and_mean$V2)))
colnames(mt_std_mean_activity) <- c("subject", "activity", descriptiveNames)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
### group by subject and activity
groupped <- group_by(mt_std_mean_activity, subject, activity)
### summarise
average_act_subj <- summarise_at(groupped, vars(-group_cols()), mean)

# Export the data
write.csv(mt_std_mean_activity, "tidy_data/std_and_mean_with_activity_names.csv")
write.csv(average_act_subj, "tidy_data/average_groupped_by_subject_and_activity.csv")

