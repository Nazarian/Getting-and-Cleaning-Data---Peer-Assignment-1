setwd("~/Documents/Getting and Cleaning data/UCI HAR Dataset")

## 1. Merges the training and the test sets to create one data set.

## read activity labels
ActLabs = read.csv("activity_labels.txt", sep="", header=FALSE)

## read data
test = read.csv("test/X_test.txt", sep="", header=FALSE)
test[,562] = read.csv("test/Y_test.txt", sep="", header=FALSE)
test[,563] = read.csv("test/subject_test.txt", sep="", header=FALSE)

train = read.csv("train/X_train.txt", sep="", header=FALSE)
train[,562] = read.csv("train/Y_train.txt", sep="", header=FALSE)
train[,563] = read.csv("train/subject_train.txt", sep="", header=FALSE)

## bind datasets vertically
Data <- rbind(test, train) 

## read features
features = read.csv("features.txt", sep="", header=FALSE)

## beautify names
features[,2] = gsub('-std', 'Standard_Deviation', features[,2])
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

## get -mean and -std 
mean_and_std <- grep(".*Mean.*|.*Standard_Deviation.*", features[,2])

## eliminate the rest of cols
features <- features[mean_and_std,]

## remove columns not wanted from Data
Data <- Data[,c(mean_and_std, 562, 563)]

## add the column features to Data
colnames(Data) <- c(features$V2, "Activity", "Subject")
## All to lower case (lecture advice)
colnames(Data) <- tolower(colnames(Data))

## Substitute labels for each activity. 
currentAct = 1
for (currentActLab in ActLabs$V2) {
  Data$activity <- gsub(currentActivity, currentActLab, Data$activity)
  currentAct <- currentAct + 1
}

## Transform to factors
Data$activity <- as.factor(Data$activity)
Data$subject <- as.factor(Data$subject)

## aggregate all the stuff into the variable tidydata
tidydata = aggregate(Data, by=list(activity = Data$activity, subject=Data$subject), mean)

## remove the subject and activity column
tidydata[,90] = NULL
tidydata[,89] = NULL

## write to tidy.txt file, separated by a tab.  
write.table(tidydata, "Tidy_data.txt", sep="\t", row.name=FALSE)

## lots of warnings; I'm a newbie
