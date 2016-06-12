# NOTE:
# This script assumes that the data has already been downloaded and unzipped to the current
# working directory. For reference, the URL for the zip file to be downloaded is:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


# -- C A L L I N G   L I B R A R I E S ---
# We will be using functions from the dplyr package:
library(dplyr)


# --- R E A D I N G   T A B L E S ---
# activity_labels contains six activities, indexed by number. 
activityLabels <- read.table ("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")

# features has 561 observations (tBodyAcc-mean()-x, tBodyAcc-mean-Y, etc.). These will
# be names for X data (X_test contains 2947 obs. of 561 variables).
features <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")

# Moving into the "test" folder, we see that subject_test is 2947 obs. of 1 variable.
subjectTest <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

# We've also got X_test and y_test in this folder. X_test has 2947 obs. of 561 variables. 
xTest <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")

# y_test has 2947 obs. of just 1 variable. Per the ReadMe file, these are the labels?
yTest <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")

# ...and it looks like we have all of the same corresponding tables in the "train" folder.
subjectTrain <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
xTrain <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")


# --- S H A P I N G   D A T A ---
# Lets combine the test and train data for each of the table types (STEP 1)
xCombined <- rbind(xTest, xTrain)
yCombined <- rbind(yTest, yTrain)
subjectCombined <- rbind(subjectTest,subjectTrain)

# Let's apply the "features" as names to the xCombined dataframe.(STEP 4)
# Note that the actual names are in the second column of the features dataframe.
# These names do not follow the variable name restrictions in R, so we need to make valid names.
# Adding these names now will make it easier to subset mean and standard deviation later. 
validNames <- make.names(features[,2], unique = TRUE)
colnames(xCombined) <- validNames

# We'll also manually label the single column of yCombined and subjectCombined.(still STEP 4)
colnames(yCombined) <- "Activity"
colnames(subjectCombined) <- "Subject"

# ...and we're going to recode the values for yCombined by setting "Activity" as a factor
# and changing the levels. Note the activity names are in the second column (V2) of the 
# activityLabels dataframe. (STEP 3)
yCombined$Activity <- as.factor(yCombined$Activity)
levels(yCombined$Activity) <- activityLabels$V2

# ...and we'll subset only the mean and standard deviation measurements then cbind them.(STEP 2)
subsettedMean <- select(xCombined,contains("mean"))
subsettedStd <- select(xCombined, contains("std"))
combinedSubsetted <- cbind(subsettedMean, subsettedStd)

# Let's cbind the activity and subject to this data as well.
combinedSubsetted <- cbind(yCombined, subjectCombined, combinedSubsetted)


# --- C R E A T I N G   S U M M A R I Z E D   T A B L E ---
# (Step 5)
summarizedData <- combinedSubsetted %>% 
    group_by(Activity, Subject) %>% 
    summarize_each_(funs(mean), names(combinedSubsetted)[-(1:2)])


# -- C L E A N I N G   U P   W O R K I N G   D A T A ---
rm(activityLabels, features, 
   subjectTest, xTest, yTest, 
   subjectTrain, xTrain, yTrain,
   xCombined, yCombined, subjectCombined,
   validNames, subsettedMean, subsettedStd)