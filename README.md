# JHU-coursera_R_3_Assignment
Getting and Cleaning Data Week 4 Assignment_John Hopkins Data Science Specialization Coursera

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names.
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Goal of the Project
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 
The project outcome includes:
1) a tidy data set;
2) a link to a Github repository with your script for performing the analysis;
3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
4) a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

## Review Criteria

| Goal              |  Item name     | Link |      
| ----------------- | -------------- | ---- |
| A tidy data set   | Clean Data Set | [Tidy data](https://github.com/Yvonne27Jin/JHU-coursera_R_3_Assignment/blob/master/tidy_data_set.txt)     |   
| Analysis R Script | run_analysis.R | [R script](https://github.com/Yvonne27Jin/JHU-coursera_R_3_Assignment/blob/master/run_analysis.R)     |   
| Github Repo       | Repo           | [Repo](https://github.com/Yvonne27Jin/JHU-coursera_R_3_Assignment)     |  
| CodeBook          | CodeBook.md    | [CodeBook](https://github.com/Yvonne27Jin/JHU-coursera_R_3_Assignment/blob/master/CodeBook.md)     |    
| README            | This file      |      |   






# R script

## 0. preparation 

### create data folder if not exist

```R
if (!file.exists('data')){
  dir.create('data')
}
```




### download data

```R
DataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"`
`download.file(DataURL,destfile = 'data/data_project.zip')`
`unzip('data/data_project.zip',exdir = 'data')
```



### read data into R

```R
feature <- read.table('data/UCI HAR Dataset/features.txt',
                       col.names = c('Index_Feature','Feature'))

activity_label <- read.table('data/UCI HAR Dataset/activity_labels.txt', col.names = c('Index_Activity','Activity'))

X_train <- read.table('data/UCI HAR Dataset/train/X_train.txt',
                      col.names = feature$Feature,
                      check.names = FALSE) 
```

```R
#so that the col names won't be changed automatically

y_train <- read.table('data/UCI HAR Dataset/train/y_train.txt')`
subject_train <- read.table('data/UCI HAR Dataset/train/subject_train.txt') #?

X_test <- read.table('data/UCI HAR Dataset/test/X_test.txt',
                     col.names = feature$Feature,check.names = FALSE)
y_test <- read.table('data/UCI HAR Dataset/test/y_test.txt')
subject_test <- read.table('data/UCI HAR Dataset/test/subject_test.txt')


```




## 1. Merges the training and the test sets to create one data set.

```R
X_data <- rbind(X_train,X_test)
y_data <- rbind(y_train,y_test)
subject_data <- rbind(subject_train,subject_test)


```




## 2.Extracting only the measurements on the mean and standard deviation

```R
#extract colomns with "mean()" and "std()"
col_names <- colnames(X_data)
col_mean  <- grep('mean\\(\\)',col_names)
col_std   <- grep('std\\(\\)',col_names)

#combine the columns

X_mean_std <- X_data[,c(col_mean,col_std)]
```





## 3. Uses descriptive activity names to name the activities in the data set

```R
#adding activity and subject data, remane column names
X_cleaned <- cbind(y_data,X_mean_std)
colnames(X_cleaned)[1] <- 'Index_Activity'
X_cleaned <- cbind(subject_data,X_cleaned)
colnames(X_cleaned)[1] <- 'Subject'

#merging activity index with descriptive activity names

X_cleaned <- merge(activity_label,X_cleaned)
#delete index column
X_cleaned$Index_Activity <- NULL`
```




## 4. Appropriately labels the data set with descriptive variable names

```R
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
```





## 5. creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```R
#group by activity and subject, take mean value
X_tidy <- aggregate(X_cleaned[,3:68],by=list(X_cleaned$Activity,X_cleaned$Subject),FUN=mean)

#rename columns

colnames(X_tidy)[1] <- 'Activity'
colnames(X_tidy)[2] <- 'Subject'


```




## write the final data set

```R
write.table(X_tidy,file = 'tidy_data_set.txt',row.names = F)


```

