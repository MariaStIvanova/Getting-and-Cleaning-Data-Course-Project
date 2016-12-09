## LOAD NECESSARY PACKAGES
install.packages(c("data.table", "reshape2"))
library(reshape2)
library(data.table)
## SET PATH 
path <- getwd() 
## DOWNLOAD, SAVE AND UNZIP THE FILE; LIST THE NAMES OF THE ZIPPED FILES 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "OriginalDataSet.zip" 
download.file(url, file.path(path, filename)) 
unzip(file.path(path, filename), exdir = path) 
inputpath <- file.path(path, "UCI HAR Dataset")
list.files(inputpath, recursive = TRUE) 
##
## READ THE FILES IN R
## Read the Subjects files 
SubjTr <- fread(file.path(inputpath, "train", "subject_train.txt"))
SubjTe <- fread(file.path(inputpath, "test", "subject_test.txt"))
## Read the Activities files 
ActivTr <- fread(file.path(inputpath, "train", "Y_train.txt"))
ActivTe <- fread(file.path(inputpath, "test", "Y_test.txt"))
## Read the Features Data files 
Train <- fread(file.path(inputpath, "train", "X_train.txt"))
Test <- fread(file.path(inputpath, "test", "X_test.txt"))
##
## MERGE THE TRAINING AND THE TEST SETS TO CREATE ONE DATA SET
## Bind two by two by rows 
Subject <- rbind(SubjTr, SubjTe)
setnames(Subject, "V1", "subject")
Activity <- rbind(ActivTr, ActivTe)
setnames(Activity, "V1", "activitynum")
DT <- rbind(Train, Test)
## Bind by columns
Subject <- cbind(Subject, Activity)
DT <- cbind(Subject, DT) 
## Set key columns in the dataset 
setkey(DT, subject, activitynum)
##
## EXTRACT ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT
## Read the file containing the features names 
Features <- fread(file.path(inputpath, "features.txt"))
setnames(Features, names(Features), c("featurenum", "featurename"))
## Reduce it to measurements on the mean and standard deviation for each measurement
Features <- Features[grepl("mean()|std()", featurename)] 
## Create a help-column which purpose is later to match with certain columns in DT
featureVnum <- paste0("V", Features$featurenum)
Features$featureVnum <- Features[, featureVnum] 
## Reduce DT to the columns that contain mean and std measurements + keep the keys
touse <- c(key(DT), Features$featureVnum)
DT <- DT[, touse, with = FALSE]
##
## USE DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET 
## Read the file containing the names of the activities 
ActivName <- fread(file.path(inputpath, "activity_labels.txt"))
setnames(ActivName, names(ActivName), c("activitynum", "activityname"))
## Merge the main dataset with the help-dataset containing the names of the activities 
DT <- merge(DT, ActivName, by = "activitynum", all.x = TRUE)
## Set key columns in the main dataset
setkey(DT, subject, activitynum, activityname)
##
## TAKE A LOOK AT THE DATA AND PLAN FOR THE NEXT STEPS
head(DT)
head(Features)
## We have to create the average of each variable ( = V = a feature) for each activity and each subject 
## This means that different activities, subjects and features must be all rows in the dataset
## We have to reformat the data table from wide to long view 
DT <- data.table(melt(DT, id.vars = key(DT), variable.name = "featureVnum"))
## By assigning to variable.name the name “featureVnum”, we prepare the dataset DT for future merge with dataset Features wherefrom the names of the features will come (features = variables in the terminology of the project) 
##
## APPROPRIATELY LABEL THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES
## Merge DT with Features to get full names of the features 
DT <- merge(DT, Features, by = "featureVnum", all.x = TRUE) 
## Look at the dataset again and at the column “featurename”
head(DT)
## In the zip file there is a file called features_info.txt; there we can read about the meaning of these abbreviations
## So there is a Domain which can have two categories: Time or Frequency 
## There is an Instrument which can be Accelerometer or Gyroscope 
## There are two types of Acceleration: Body and Gravity 
## There are two types of Measurement: Mean and Std
## Some of the features have a Jerk thing and some not. I don’t get it but it is just another dichotomy 
## The Magnitude of the signals has been given in addition 
## At last, there are three Axes for the space: X, Y, Z 
## We have to add 7 new variables to DT; they will indicate which of the categories correspond to each row in the dataset 
mygrepl <- function(expression) {
  grepl(expression, DT$featurename)
}
## n gives the number of the categories
n <- 2
## y is a vector-column of length = the number of categories 
y <- matrix(seq(1, n), nrow = n)
## x is a matrix of two columns and it contains TRUEs and FALSEs depending on whether we meet t(time) or f(frequency)
x <- matrix(c(mygrepl("^t"), mygrepl("^f")), ncol = nrow(y))
## This creates a factor variable in the dataset that has 1s whenever we encounter Time and 2s - for Frequency; so T, F %*% 1, 2 would give 1 and F, T %*% 1, 2 would give 2 (matrices multiplication) 
DT$domain <- factor(x %*% y, labels = c("Time", "Frequency"))
## by analogy with the above
x <- matrix(c(mygrepl("Acc"), mygrepl("Gyro")), ncol = nrow(y))
DT$instrument <- factor(x %*% y, labels = c("Accelerometer", "Gyroscope"))
## 
x <- matrix(c(mygrepl("BodyAcc"), mygrepl("GravityAcc")), ncol = nrow(y))
DT$acceleration <- factor(x %*% y, labels = c(NA, "Body", "Gravity"))
## 
x <- matrix(c(mygrepl("mean()"), mygrepl("std()")), ncol = nrow(y))
DT$measurement <- factor(x %*% y, labels = c("Mean", "SD"))
## 
n <- 3
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(mygrepl("-X"), mygrepl("-Y"), mygrepl("-Z")), ncol = nrow(y))
DT$axis <- factor(x %*% y, labels = c(NA, "X", "Y", "Z"))
## 
DT$jerk <- factor(mygrepl("Jerk"), labels = c(NA, "Jerk"))
## 
DT$magnitude <- factor(mygrepl("Mag"), labels = c(NA, "Magnitude"))
## Set keys in the updated dataset; this makes the next code line easier and shorter to write
setkey(DT, subject, activityname, domain, acceleration, instrument, jerk, magnitude, measurement, axis) 
##
## CREATE A SECOND, TIDY DATA SET WITH THE AVERAGE OF EACH VARIABLE (=FEATURE) FOR EACH ACTIVITY AND EACH SUBJECT
TidyDT <- DT[, list(average = mean(value)), by = key(DT)]
newfilename <- "TidyDataSet.txt"
write.table(TidyDT, file.path(path, newfilename), col.names = TRUE, row.name=FALSE)