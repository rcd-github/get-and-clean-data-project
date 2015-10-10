---
title: "README"
output: html_document
---

### Request 1: Merge the training and the test sets to create one data set

1.1 Load the files 

* general files (i.e. features and activity_labels)
* test files
* training files

1.2 Combine the files

I used *cbind()* to combine the 3 training and the 3 test files, and then i used *rbind()* to bring both
toghether

**Outcome: the *test_train_df* data frame combines the test and training data sets**

### Request 3: Use descriptive activity names to name the activities in the data set

I renamed the column names of both the *test_train_df* data frame and the *activity_labels* data frame and merged them on the activity_id column, using *merge()*.

**Outcome: the *big_data data* frame has descriptive activity names in the "activity" column**

### Request 4: Appropriately label the data set with descriptive variable names

I  renamed the columns containing features in the *big_data* data frame (i.e. all columns except for subject_id, activity_id and activity) with the names listed in the *features* data frame. 

**Outcome: the *big_data* data frame has column names that describe the features and measurements as provided by the *features.txt* file**

### Request 2: Extracts only the measurements on the mean and standard deviation for each measurement

I used the *grep()* function to find the column names containing "mean" and "std" and then created a subset of the *big_data* data frame containing only those columns, plus subject_id, activity_id and activity. 

**Outcome: the *small_data* data frame obtained includes only 66 combinations of the 33 features with each of the mean and standard deviation measurements (i.e. 66 columns)**

### Request 5: From the data set in step 4, creates a second, independent tidy data set              with the average of each variable for each activity and each subject

* Create a tidy data set with the variables: subject_id, activity, feature,measurement, and value

First, I used the *gather()* function to create a variable containing the 66 features/measures combinations. Second, I used the *separate()* function to obtain a column (variable) called "features" that can take 33 different values, corresponding to the features identified in the *features_info.txt* files, and another column (variable) that can take two values: mean and standard deviation, corresponding to the two measurements requested by Coursera out of the original 17 measurements present in the *features_info.txt* file. 

Note: due to the composition of the strings in the *features* data frame, I had to make some intermediate steps to separate the two variables.

**Outcome: the *tidy_data* data frame obtained contains the following variables: *subject_id* (30 possible values), *activity* (6 possible values), *feature* (33 possible values), *measurement* (i.e. either "mean" or "std"), and *values***


* Group the tidy data and summarize to calculate the mean for each activity and subject

I used the *group_by()* function to group the *tidy_data* data frame for each of the four variables: subject_id, activity, feature, and measurement. Then I used the *summarise()* function to calculate the means by group.

**Final Outcome: the *tidy data* frame calculates the mean (average_value) for each person, for each activity, for each feature and for each measure**