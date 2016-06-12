## Data Cleaning Assignment - Code Book

### Data
* activityLabels - contains six activities, indexed by number.
getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt

* features - names for X data
getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt

* subjectTest - subjects for each of the test observations (as number)
getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt

* xTest - test data
getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt

* yTest - activities being performed for each test observation
getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt

* subjectTrain - subjects for each of the train observations (as number)
getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt

* xTrain - train data
getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt

* yTrain - activities being performed for each train observation
getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt

### Variables
* validNames - list of features converted to a format that follows valid name restrictions in R.
This allows for subsetting of data based on features when they are applied as X data column names.


### Transformations
Test and train data was first combined by data type:
* xCombined - Combined X data for test and train sets
* yCombined - Combined Y data (Activities) for the test and train sets
* subjectCombined - Combined subject data for the test and train sets

Features was converted to valid variable names (via the validNames variable), and xCombined
column names were assigned to these values.
yCombined and subjectCombined contain just a single column, so these columns are individually
names "Activity" and "Subject" respectively.

The numeric values for yCombined (Activity) are converted to descriptive values by assigning
these values as factors and updating the levels of the table according to the indexed values
in activityLabels.

The xCombined dataframe is subsetted based on contents found within the column names:
* subsettedMean - xCombined columns with names that contain "mean"
* subsettedStd - xCombined columns with names that contain "std"
These two subsetted dataframes were combined to a new dataframe that contains both subsets of columns:
* combinedSubsetted - column-bound (cbind) dataframe combining subsettedMean and subsettedStd

NOTE: combinedSubsetted is the dataframe requested at Step 4 of the assignment

Using piping, the combinedSubsetted dataframe is first grouped by Activity and Subject, and 
each column is then summarized to find the mean using summarize_each_. The variables for the 
summarize_each function were identified by calling the column names of the combinedSubsetted dataframe,
excluding the first two columns (Activity and Subject).
