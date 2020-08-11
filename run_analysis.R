
# course 3 - getting and cleanning data - Assignment

### 0. preparation 

# create data folder if not exist
if (!file.exists('data')){
  dir.create('data')
}

# download data
DataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(DataURL,destfile = 'data/data_project.zip')
unzip('data/data_project.zip',exdir = 'data')

# read data into R
feature <- read.table('data/UCI HAR Dataset/features.txt',
                       col.names = c('Index_Feature','Feature'))

activity_label <- read.table('data/UCI HAR Dataset/activity_labels.txt', col.names = c('Index_Activity','Activity'))

X_train <- read.table('data/UCI HAR Dataset/train/X_train.txt',
                      col.names = feature$Feature,
                      check.names = FALSE) 
# so that the col names won't be changed automatically
y_train <- read.table('data/UCI HAR Dataset/train/y_train.txt')
subject_train <- read.table('data/UCI HAR Dataset/train/subject_train.txt') #?

X_test <- read.table('data/UCI HAR Dataset/test/X_test.txt',
                     col.names = feature$Feature,check.names = FALSE)
y_test <- read.table('data/UCI HAR Dataset/test/y_test.txt')
subject_test <- read.table('data/UCI HAR Dataset/test/subject_test.txt')




### 1. Merges the training and the test sets to create one data set.

X_data <- rbind(X_train,X_test)
y_data <- rbind(y_train,y_test)
subject_data <- rbind(subject_train,subject_test)




### 2.Extracting only the measurements on the mean and standard deviation

#extract colomns with "mean()" and "std()"
col_names <- colnames(X_data)
col_mean  <- grep('mean\\(\\)',col_names)
col_std   <- grep('std\\(\\)',col_names)
# combine the columns
X_mean_std <- X_data[,c(col_mean,col_std)]





### 3. Uses descriptive activity names to name the activities in the data set

#adding activity and subject data, remane column names
X_cleaned <- cbind(y_data,X_mean_std)
colnames(X_cleaned)[1] <- 'Index_Activity'
X_cleaned <- cbind(subject_data,X_cleaned)
colnames(X_cleaned)[1] <- 'Subject'

# merging activity index with descriptive activity names
X_cleaned <- merge(activity_label,X_cleaned)
#delete index column
X_cleaned$Index_Activity <- NULL




### 4. Appropriately labels the data set with descriptive variable names
col_names <- colnames(X_cleaned)
col_names
#use sub to match pattern and replace with descriptive names
col_names <- sub(x = col_names,pattern = '^t',replacement = 'Time domain signal: ')
col_names <- sub(x = col_names,pattern = '^f',replacement = 'Frequency domain signal: ')
col_names <- sub(x = col_names,pattern = 'mean\\(\\)',replacement = ' mean, ')
col_names <- sub(x = col_names,pattern = 'std\\(\\)',replacement = ' standart deviation, ')
col_names <- sub(x = col_names,pattern = '-X',replacement = ' X axis')
col_names <- sub(x = col_names,pattern = '-Y',replacement = ' Y axis')
col_names <- sub(x = col_names,pattern = '-Z',replacement = ' Z axis')
col_names <- sub(x = col_names,pattern = 'AccJerk',replacement = ' acceleration jerk')
col_names <- sub(x = col_names,pattern = 'Acc',replacement = ' acceleration')
col_names <- sub(x = col_names,pattern = 'GyroJerk',replacement = ' angular velocity jerk')
col_names <- sub(x = col_names,pattern = 'Gyro',replacement = ' angular velocity')
col_names <- sub(x = col_names,pattern = 'Mag',replacement = ' magnitude')

colnames(X_cleaned) <- col_names





### 5. creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#group by activity and subject, take mean value
X_tidy <- aggregate(X_cleaned[,3:68],by=list(X_cleaned$Activity,X_cleaned$Subject),FUN=mean)
# rename columns
colnames(X_tidy)[1] <- 'Activity'
colnames(X_tidy)[2] <- 'Subject'




# write the final data set
write.table(X_tidy,file = 'tidy_data_set.txt',row.names = F)
