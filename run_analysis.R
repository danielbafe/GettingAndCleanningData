## Get the data and set it on "./data/Dataset.zip"
if(!file.exists("./data")){dir.create("./data")}
## Get the data and set it on "./data/Dataset.zip"
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

## Unzip the folder and set it into the folder "./data"
unzip(zipfile="./data/Dataset.zip", exdir="./data")

## Set newpath as the new source "./data/UCI HAR Dataset"
newpath <- file.path("./data" , "UCI HAR Dataset")

y_test  <- read.table(file.path(newpath, "test" , "Y_test.txt" ),header = FALSE)
y_train <- read.table(file.path(newpath, "train", "Y_train.txt"),header = FALSE)


SubjectTrain <- read.table(file.path(newpath, "train", "subject_train.txt"),header = FALSE)
SubjectTest  <- read.table(file.path(newpath, "test" , "subject_test.txt"),header = FALSE)

FeaturesTest<- read.table(file.path(newpath, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain <- read.table(file.path(newpath, "train", "X_train.txt"),header = FALSE)


dataSubject <- rbind(SubjectTrain, SubjectTest)
dataActivity<- rbind(y_train, y_test)
dataFeatures<- rbind(FeaturesTrain, FeaturesTest)


names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
FeaturesNames <- read.table(file.path(newpath, "features.txt"),head=FALSE)
names(dataFeatures)<- FeaturesNames$V2


##1. Merges the training and the test sets to create one data set.
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

##2. Extracts only the measurements on the mean and standard deviation 
##for each measurement.
column.names <- colnames(Data)
col.nam<- grep("std\\(\\)|mean\\(\\)|activity|subject", column.names, value=TRUE)
datasetfil <- dataset[, col.nam] 

##3. Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table(file.path(newpath  , "activity_labels.txt"),header = FALSE)
Data$activity<-factor(Data$activity,labels=activityLabels[,2])

##5. From the data set in step 4, creates a second, independent tidy 
##data set with the average of each variable for each activity and each subject.
newData<-aggregate(. ~subject + activity, Data, mean)
newData<-newData[order(newData$subject,newData$activity),]

write.table(newData, file = "Tidy.txt", row.names = FALSE)