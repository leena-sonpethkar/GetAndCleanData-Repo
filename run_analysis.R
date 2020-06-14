##############################################################################
#
# FILE  :   run_analysis.R
# Author:   Leena Sonpethkar
#
# OVERVIEW
#   Using data collected from the accelerometers from the Samsung Galaxy S 
#   smartphone, work with the data and make a clean data set, outputting the
#   resulting tidy data to a file named "tidy_data.txt".
#   See README.md for details.
#
##############################################################################

library(dplyr)

## Prestep 1: Get the data/zip file from url given
##############################################################################

# download zip file
zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"

if (!file.exists(zipFile)) {
  download.file(zipUrl, zipFile, mode = "wb")
}

# unzip zip file 
dataPath <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
  unzip(zipFile)
}


## PreStep 2: Read data test, train, feature, activity 
##############################################################################
#Create a Test dataset, by adding columns from subject, activity and test data provided

#Read test data
testactdata <- read.table(file.path(dataPath, "test", "y_test.txt"))
testsubdata <- read.table(file.path(dataPath, "test", "subject_test.txt"))
testXdata <- read.table(file.path(dataPath, "test", "X_test.txt"))

#Read train data
trnactdata <- read.table(file.path(dataPath, "train", "y_train.txt"))
trnsubdata <- read.table(file.path(dataPath, "train", "subject_train.txt"))
trnXdata <- read.table(file.path(dataPath, "train", "X_train.txt"))

#Read features data
features <- read.table(file.path(dataPath, "features.txt"), as.is = TRUE)

#Read activity data
activities <- read.table(file.path(dataPath, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")


##############################################################################
# Step 1 - Merge the training and the test sets to create one data set
##############################################################################

# concatenate individual data tables to make single data table
humanActivity <- rbind(
  cbind(trnsubdata, trnactdata, trnXdata),
  cbind(testsubdata, testactdata, testXdata )
)

##Remove data tables to save memory
rm(trnsubdata, trnXdata, trnactdata, testsubdata, testXdata, testactdata)

# assign column names
colnames(humanActivity) <- c("subject", "activity", features[, 2])

##############################################################################  
# Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
##############################################################################

# Keep columns: subject_id, activity_id and containing text "mean" & "std" ...
keep_cols <- grepl("subject|activity|mean|std", colnames(humanActivity))

# ... and keep data in these columns only
humanActivity <- humanActivity[, keep_cols]

##############################################################################  
# Setp 3 - Uses descriptive activity names to name the activities in the data set
##############################################################################  

humanActivity$activity <- factor(humanActivity$activity, levels = activities[, 1], labels = activities[, 2])

##############################################################################  
# Setp 4 - Appropriately labels the data set with descriptive variable names.
##############################################################################  

# Read column names in variable
humanActivityCols <- colnames(humanActivity)

# Appropriately name the columns
humanActivityCols <- gsub("^t", "Time", humanActivityCols)
humanActivityCols <- gsub("^f", "FrequencyDomain", humanActivityCols)
humanActivityCols <- gsub("Acc", "Accelerometer", humanActivityCols)
humanActivityCols <- gsub("Gyro", "Gyroscope", humanActivityCols)
humanActivityCols <- gsub("std", "StandardDeviation", humanActivityCols)
humanActivityCols <- gsub("mean", "Mean", humanActivityCols)
humanActivityCols <- gsub("Mag", "Magnitude", humanActivityCols)
humanActivityCols <- gsub("BodyBody", "Body", humanActivityCols)
humanActivityCols <- gsub("\\(", "", humanActivityCols)
humanActivityCols <- gsub("\\)", "", humanActivityCols)

# Assign back corrected/updated columnnames
colnames(humanActivity) <- humanActivityCols

#View(humanActivity)

##############################################################################  
# Setp 5 - From the data set in step 4, creates a second, 
#         independent tidy data set with the average of each variable for each activity and each subject.
##############################################################################  

ActivityTidyData <- humanActivity %>% group_by(subject, activity) %>%  summarise_each(funs(mean))

#View(ActivityTidyData)

# New output file "Activity_tidy_data.txt"
write.table(ActivityTidyData, "Activity_tidy_data.txt", row.names = FALSE, 
            quote = FALSE)

###End of code