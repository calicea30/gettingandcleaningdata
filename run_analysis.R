library(dplyr)

# load the csv file for test and train
# https://sparkbyexamples.com/r-programming/r-read-text-file/

activites <- read.table("./data/activity_labels.txt", col.names = c("activity_id", "activity"))
features <- read.table("./data/features.txt", col.names = c("feature_id", "feature"))
subject_test <- read.table("./data/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./data/test/X_test.txt")
y_test <- read.table("./data/test/y_test.txt", col.names = "label")
subject_train <- read.table("./data/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./data/train/X_train.txt")
y_train <- read.table("./data/train/y_train.txt", col.names = "label")

# renamed columns to match the feature names
colnames(x_test) <- features$feature
colnames(x_train) <- features$feature

# select only the columns with mean or std
# https://www.marsja.se/select-columns-in-r-by-name-index-letters-certain-words-with-dplyr/
x_test <- x_test %>% select(contains("mean") | contains("std"))
x_train <- x_train %>% select(contains("mean") | contains("std"))

# merged test and train data frames
test <- cbind(subject_test, y_test, x_test)
train <- cbind(subject_train, y_train, x_train)
all_data <- rbind(test,train)

# replace activity number with activity name
all_data <- all_data %>%
        mutate(label = activites[all_data$label, 2])

colnames(all_data)
# name columns with more descriptive variable names
names(all_data)[2] <- "activity"
names(all_data) <- gsub("-mean", "_mean", names(all_data))
names(all_data) <- gsub("-std", "_std", names(all_data))
names(all_data) <- gsub( "Acc", "_accelerometer", names(all_data))
names(all_data) <- gsub("Gyro", "_gyroscope", names(all_data))
names(all_data) <- gsub("BodyBody", "Body", names(all_data))

# calculated average by subject and activity
# https://www.rdocumentation.org/packages/dplyr/versions/0.5.0/topics/summarise_all
avg_of_columns <- all_data %>%
        group_by(subject, activity) %>%
        summarise_all(mean)

# Exported tidy dataset and final dataset 
write_csv(all_data, "tidydata.csv")
write_csv(avg_of_columns, "final.csv")
