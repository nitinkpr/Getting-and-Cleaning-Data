library(reshape2)

# Merges the training and the test sets to create one data set
subject_train <- read.table("train/subject_train.txt")
subject_test <- read.table("test/subject_test.txt")
X_train <- read.table("train/X_train.txt")
X_test <- read.table("test/X_test.txt")
y_train <- read.table("train/y_train.txt")
y_test <- read.table("test/y_test.txt")

# name columns in subject files
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"

# names columns for measurement files
featureNames <- read.table("features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2

# name columns for label files
names(y_train) <- "activity"
names(y_test) <- "activity"

# combine files into one dataset
alltrain <- cbind(subject_train, y_train, X_train)
alltest <- cbind(subject_test, y_test, X_test)
combined <- rbind(alltrain, alltest)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement
meanstdcols <- grepl("mean\\(\\)", names(combined)) | grepl("std\\(\\)", names(combined))

# Including subjectID and activity columns as well
meanstdcols[1:2] <- TRUE

# Removing other columns
combined <- combined[, meanstdcols]


## 3. Uses descriptive activity names to name the activities in the data set.
## 4. Appropriately labels the data set with descriptive activity names. 

# convert the activity column from integer to factor
combined$activity <- factor(combined$activity, labels=c("Walking","Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))


## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

# create the tidy data set
molten <- melt(combined, id=c("subjectID","activity"))
tidy <- dcast(molten, subjectID+activity ~ variable, mean)

# write the tidy data set to a file
write.csv(tidy, "tidy.csv", row.names=FALSE)