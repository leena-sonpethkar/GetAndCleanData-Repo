# GetAndCleanData-Repo
Getting and Cleaning Data Course Project
The goal is to prepare tidy data that can be used for later analysis. 

#Readme.md
This file is to give overview on how the data processed to get tidy data set

#About Data Directory (UCI HAR Dataset)
This directory contains unzipped data files downloaded from url

#About CodeBook.md
a code book that describes the variables

#About run_analysis.R script
R script, which will be executed by user, which will perform below activities
1. Download data zip file from the url and unzip (if doesn't exist in target data directory)
2. Read data files from test & train directory along with Features and Activity data 
3. Merged training and test data set
4. Extracts only Mean amd Standard Deviation data columns with Subject and Activity columns
5. Update activity id with activity description
6. Label the data set with descriptive variable names.
7. Create a second, independent tidy set with the average of each variable for each activity and each subject.
8. Write the data set to the Activity_tidy_data.txt file.