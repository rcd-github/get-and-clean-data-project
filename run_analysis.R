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

# Outcome: the test_train_df data frame combines the test and training data sets

### Request 3: Use descriptive activity names to name the activities in the data set

names(test_train_df)[c(1,length(names(test_train_df)))] <- c("subject_id", "activity_id")
names(activity_labels)[1:2] <- c("activity_id","activity")
big_data  <- merge(test_train_df, activity_labels, all=TRUE) %>% tbl_df
rm(test_train_df, activity_labels) # clean up

# Outcome: the big_data data frame has descriptive activity names in the "activity" column

### Request 4: Appropriately label the data set with descriptive variable names
names(big_data)[3:(length(names(big_data))-1)] <- as.character((features)[,2])
rm(features) # clean up

# Outcome: the big_data data frame has column names that describe the features and 
# measurements as provided by the features.txt file 

### Request 2: Extracts only the measurements on the mean and standard deviation 
#             for each measurement

selnames <-names(big_data)[grep("mean[^F]|std" , names(big_data))]
small_data <- big_data[ ,c("subject_id", "activity_id", "activity",selnames)] %>% tbl_df()
rm(selnames, big_data) # clean up

# Outcome: the small_data data frame includes only 66 combinations of the 33 features 
# with each of the mean and standard deviation measurements (i.e. total 66 variables)

### Request 5: From the data set in step 4, creates a second, independent tidy data set
#              with the average of each variable for each activity and each subject

# 5.1 create a tidy data set with the variables: subject_id, activity, feature,measurement,
#     and value
mini1 <- gather(small_data, feature_variable_axis, values, -c(subject_id, activity_id, activity))  %>% tbl_df()
mini1$feature_variable_axis <- as.character(mini1$feature_variable_axis)
mini1$feature_variable_axis[grep("mean..$|std..$" , mini1$feature_variable_axis)] <-
  paste(mini1$feature_variable_axis[grep("mean..$|std..$" , mini1$feature_variable_axis)], "noaxis", sep="-")
data <- separate(mini1, feature_variable_axis, c("feature","variable","axis"), sep="-") %>% tbl_df()
data <- mutate(data, feature_axis=paste(feature,axis, sep="-")) %>% select(subject_id, activity, variable, feature_axis, values)
data$feature_axis <-  sub("-noaxis$", "", data$feature_axis)
data$variable <- sub("mean..", "mean", data$variable); data$variable <- sub("std..", "std", data$variable)
data$variable <- as.factor(data$variable) ; data$feature_axis <- as.factor(data$feature_axis)
tidy_data <- select(data, subject_id, activity, feature=feature_axis, measurement=variable, values) %>%
  arrange(subject_id) 
rm(small_data, mini1, data) # clean up

# 5.2 group the tidy data and summarize to calculate the mean for each activity and subject

group_data <- group_by(tidy_data, subject_id, activity, feature, measurement) 
tidy <- summarise(group_data, average_value=mean(values, na.rm=TRUE))
rm(group_data, tidy_data)

# Outcome: the tidy data frame calculates the mean (average_value) for each person, 
# for each activity, for each feature and for each measure. 

# write.table(tidy, "tidy.txt", row.name=FALSE)
