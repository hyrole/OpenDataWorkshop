## Course Project
## Module 3 - Data Cleaning

# download dataset from URL given
# create new folder <data> if not exist
if(!file.exists("./data")) {
  dir.create("./data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

#unzip dataset files
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#define path & list files
path <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE) # list files from the path
files
  
## ANSWER ##
## Step #1
## Merges the training and the test sets to create one data set.
train.dat = read.csv(paste(path,"/train/X_train.txt",sep=""), sep="", header=FALSE)
train.dat[,ncol(train.dat)+1] = read.csv(paste(path,"/train/Y_train.txt",sep=""), sep="", header=FALSE)
train.dat[,ncol(train.dat)+1] = read.csv(paste(path,"/train/subject_train.txt",sep=""), sep="", header=FALSE)
test.dat = read.csv(paste(path,"/test/X_test.txt",sep=""), sep="", header=FALSE)
test.dat[,ncol(test.dat)+1] = read.csv(paste(path,"/test/Y_test.txt",sep=""), sep="", header=FALSE)
test.dat[,ncol(test.dat)+1] = read.csv(paste(path,"/test/subject_test.txt",sep=""), sep="", header=FALSE)
  
#Merge train.dat and test.dat together into DF Data
# Merges the training and the test sets to create one data set.
df <- rbind(train.dat, test.dat)

## Step #2
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## taken Names of Features with "mean()" or "std()"
features <- read.csv(paste(path,"/features.txt", sep=""), sep="", header=FALSE)
  
# find the relevant columns having "-mean"or "-std" in column name
cols.in.scope <<- grep(".*-mean.*|.*-std.*", features[,2])
  
# set the features in scope (global)
features <<- features[cols.in.scope,]
var.count = ncol(df)

# also add the two columns for Subject and Activity (the last two columns of Data)
cols.in.scope <<- c(cols.in.scope, var.count-1, var.count)
  
# remove the obsolete columns from DF Data
#Data <- Data[,cols.in.scope]
df<-df[,cols.in.scope]
df



## Step 4
## Appropriately labels the data set with descriptive variable names. 
# make suitable feature names for R using substitutions 
features[,2] <- gsub('-meanFreq()', '.mean.freq', features[,2]) # substitutes "-meanFreq()" with ".mean.freq"
features[,2] <- gsub('-mean()', '.mean', features[,2]) # substitutes "-mean" with ".mean"
features[,2] <- gsub('-std()', '.std', features[,2]) # substitutes "-std" with ".std"
features[,2] <- gsub('[-]', '.', features[,2]) # substitutes "-" with "."
features[,2] <- gsub('[()]', '', features[,2]) # removes "()"
  
# set the column names (as of DF features 2nd column) for DF Data
colnames(df) <- c(features$V2, "Activity", "Subject")
# make all names lowercase
colnames(df) <- tolower(colnames(df))
df

## Step #3
## Uses descriptive activity names to name the activities in the data set
# read the activity lables into DF activity.Labels)
activity.Labels = read.csv(paste(path,"/activity_labels.txt", sep=""), sep="", header=FALSE)
View(activity.Labels)  
# set the matching activity label for each row
activity.ID = 1
for (ActivityLabel in activity.Labels$V2) {
  df$activity <- gsub(activity.ID, ActivityLabel, df$activity)
  activity.ID <- activity.ID + 1
}

## Step 5
## creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# declare Activity and Subject as nominal data
df$activity <- as.factor(df$activity)
df$subject <- as.factor(df$subject)
  
# aggregate DF Data by Activity and Subject while calculating the mean function
# define the number of colums in DF Data minus the nominal columns (activity and subject)
countnndc = ncol(df)-2 # the count of colums with non nominal data
nndc = c(1:countnndc) # the colums with non nominal data
  
# aggregate and calculate the mean only for the columns containing measured values
# tidy.Data = aggregate(Data[,c(1:nndc)], by=list(Activity = Data$Activity, Subject=Data$Subject), mean, na.rm=TRUE)
tidy <- aggregate(df[,nndc], by=list(activity = df$activity, subject=df$subject), mean, na.rm=TRUE)
head(tidy)

# write tidydata
write.table(tidy, "tidy.txt", sep="\t",row.names = F)
# for variables for CodeBook
write(names(tidy), file = "variables.txt", ncolumns = 1)
