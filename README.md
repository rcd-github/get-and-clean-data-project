# README FILE

### Request 1: Merge the training and the test sets to create one data set

1.1 Load the files 

* general files (i.e. features and activity_labels)
* test files
* training files

1.2 Combine the files

I used *cbind()* to combine the 3 training and the 3 test files, and then i used *rbind()* to bring both
toghether

1.4 Rename the files
I  renamed the columns containing features in the *test_train_df* data frame (i.e. all columns except for subject_id and activity_id) with the names listed in the *features* data frame. 

**Outcome: the *test_train_df* data frame combines the test and training data sets**

### Request 2: Extracts only the measurements on the mean and standard deviation for each measurement

I used the *grep()* function to find the column names containing "mean" and "std" and then created a subset of the data frame containing only those columns, plus  subject_id, and activity_id. 

**Outcome: the *small_data* data frame obtained includes only 66 combinations of the 33 features with each of the mean and standard deviation measurements (i.e. 66 columns)**

### Request 3: Use descriptive activity names to name the activities in the data set

I renamed the column names of both the *small_data* data frame and the *activity_labels* data frame and merged them on the activity_id column, using *merge()*.

**Outcome: the *small_data data* frame has descriptive activity names in the "activity" column which replaces the activity_id variable**

### Request 4: Appropriately label the data set with descriptive variable names

I renamed the column names using the grep() and gsub() functions in order to take into account the variables described in the Code Book. 

**Outcome: the small_data data frame has column names that contain the variables in the code book, but in "wide format"**

### Request 5: From the data set in step 4, creates a second, independent tidy data set              with the average of each variable for each activity and each subject

* Create a tidy data set with the variables: subject_id, activity, sensor_signal, axis_or_norm, jerk, signal_domain, statistic and value

First, I used the *gather()* function to create a variable containing the 66 variables to manipulate. Second, I used the *separate()* function to obtain five columns: ubject_id, activity, sensor_signal, axis_or_norm, jerk, signal_domain, statistic. These variables are explained in the code book. 

Then I used the select() and arrange() dplyr package functions to select the variables of interest in the order I wanted them (as in the code book), and sort them by subject id. Then I used a for() loop to convert the new columns to factor. 

* Group the tidy data and summarize to calculate the mean for each activity and subject

I used the *group_by()* function to group the *tidy_data* data frame for each of the seven variables: subject_id, activity, sensor_signal, axis_or_norm, jerk, signal_domain, and statistic. Then I used the *summarise()* function to calculate the means by group.

**Final Outcome: the _tidy data_ frame calculates the mean (average_value) for each person, for each activity, and for each of the five other variables: sensor_signal, axis_or_norm, jerk, signal_domain and statistic** 