library(dplyr)
library(tidyr)

### Request 1: Merge the training and the test sets to create one data set

# 1.1 Select the working directory where the files with data are saved
myworkdirectory <- "C:/Users/me/myworkdirectory"
setwd(myworkdirectory)

# 1.2 Load the files 
# general files
features <- read.table("features.txt") 
activity_labels <- read.table("activity_labels.txt") %>% tbl_df()
# test files
setwd("./test/")
X_test <- read.table("X_test.txt")
y_test <-  read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")
# training files
setwd(myworkdirectory)
setwd("./train/")
X_train <- read.table("X_train.txt")
y_train <-  read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")
setwd(myworkdirectory)

# 1.3 Combine the files
# 1.3.1 Combine the test files
part_1 <- cbind(subject_test, X_test)
test_df <- cbind(part_1, y_test)
names(test_df) ; rm(part_1, X_test, subject_test, y_test) # clean up
# 1.3.2 Combine the training files
part_1 <- cbind(subject_train, X_train)
train_df <- cbind(part_1, y_train)
names(train_df) ; rm(part_1, X_train, subject_train, y_train)
# 1.3.3 Combine the test and training databases 
test_train_df <- rbind(test_df, train_df) %>% tbl_df()
rm(test_df, train_df) # clean up

# 1.4 rename variables
names(test_train_df)[2:(length(names(test_train_df))-1)] <- as.character((features)[,2])
rm(features) # clean up
names(test_train_df)[c(1,length(names(test_train_df)))] <- c("subject_id", "activity_id")

# Outcome: the test_train_df data frame combines the test and training data sets

### Request 2: Extracts only the measurements on the mean and standard deviation 
#             for each measurement

selnames <-names(test_train_df)[grep("mean[^F]|std" , names(test_train_df))]
small_data <- test_train_df[ ,c("subject_id", "activity_id", selnames)] %>% tbl_df()
rm(selnames, test_train_df) # clean up

# Outcome: the small_data data frame includes only 66 combinations of the 33 features 
# with each of the mean and standard deviation measurements (i.e. total 66 variables)

### Request 3: Use descriptive activity names to name the activities in the data set

names(activity_labels)[1:2] <- c("activity_id","activity")
small_data1  <- merge(small_data, activity_labels, all=TRUE) 
small_data <- small_data1[,c(2,69,3:68)] %>% tbl_df
rm(small_data1, activity_labels) # clean up

# Outcome: the big_data data frame has descriptive activity names in the "activity" 
# column replacing activity ids coming from the activity_labels data frame

### Request 4: Appropriately label the data set with descriptive variable names

values <- gsub("^t", "time-", names(small_data))
values <- gsub("^f", "freq-", values)
values <- gsub("BodyBody", "Body", values)
values <- gsub("BodyGyro", "Gyro", values)
values <- gsub("mean()", "mean", values, fixed=TRUE)
values <- gsub("std()", "std", values, fixed=TRUE)
values <- gsub("BodyAcc-mean", "BodyAcc-NoJerk-mean", values)
values <- gsub("BodyAcc-std", "BodyAcc-NoJerk-std", values)
values <- gsub("GravityAcc-mean", "GravityAcc-NoJerk-mean", values)
values <- gsub("GravityAcc-std", "GravityAcc-NoJerk-std", values)
values <- gsub("Gyro-mean", "Gyro-NoJerk-mean", values)
values <- gsub("Gyro-std", "Gyro-NoJerk-std", values)
values <- gsub("GyroMag", "Gyro-NoJerk-Euclid", values)
values <- gsub("BodyAccMag", "BodyAcc-NoJerk-Euclid", values)
values <- gsub("GravityAccMag", "GravityAcc-NoJerk-Euclid", values)
values <- gsub("BodyAccJerk", "BodyAcc-Jerk", values)
values <- gsub("GravityAccJerk", "GravityAcc-Jerk", values)
values <- gsub("GyroJerk", "Gyro-Jerk", values)
values <- gsub("JerkMag-mean", "Jerk-mean-Euclid", values)
values <- gsub("JerkMag-std", "Jerk-std-Euclid", values)
values <- gsub("Euclid-mean", "mean-Euclid", values)
values <- gsub("Euclid-std", "std-Euclid", values)
names(small_data) <- values ; rm(values)


# Outcome: the small_data data frame has column names that contain the variables in
# the codebook, but in "wide format"


### Request 5: From the data set in step 4, creates a second, independent tidy data set
#              with the average of each variable for each activity and each subject

# 5.1 create a tidy data set with the variables: subject_id, activity, sensor_signal,
# axis_or_norm, jerk, signal_domain, statistic and value

mini1 <- gather(small_data, features, values, -c(subject_id, activity))  %>% tbl_df()

data <- separate(mini1, features, c("signal_domain","sensor_signal","jerk","statistic",
                                    "axis_or_norm"), sep="-") %>% tbl_df()
tidy_data <- select(data, subject_id, activity, sensor_signal, axis_or_norm, jerk,
               signal_domain, statistic, values) %>% arrange(subject_id)
for(i in names(tidy_data)[3:7]) {
  tidy_data[[i]] <- as.factor(tidy_data[[i]])
}
rm(small_data, mini1, data, i) # clean up

# 5.2 group the tidy data and summarize to calculate the mean for each activity and subject

group_data <- group_by(tidy_data, subject_id, activity, sensor_signal, axis_or_norm,
                       jerk, signal_domain, statistic) 
tidy <- summarise(group_data, average_value=mean(values, na.rm=TRUE))
rm(group_data, tidy_data)

# Outcome: the tidy data frame calculates the mean (average_value) for each person, 
# for each activity, and for each of the five other variables: sensor_signal,
# axis_or_norm,jerk, signal_domain and statistic

write.table(tidy, "tidy.txt", row.name=FALSE)
