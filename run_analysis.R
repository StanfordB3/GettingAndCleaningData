####  Section I: Download HAR Data from University of California, Irvine Repository
if (!file.exists("~/Desktop/DataScience/3 Data Cleaning/Week 4/UCI HAR Dataset")) {
    dir.create("/Users/pb/RData")
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    DestFile <- "Pojectfiles_UCI_HAR_Dataset.zip"
    DestFile = paste0("~/RData/", DestFile)
    download.file(fileURL, destfile = DestFile, method = "curl")
    library(lubridate)
    now()
}

# # Unzip the data file to the local direcotory
unzip(DestFile)
# list.files("UCI HAR Dataset")

#### Section II: R Libraries 
library(dplyr)
library(tidyr)
library(stringr)


#### Section III: Read HAR files 
## Read the feature files "X_test.txt"
TestFile <- "UCI HAR Dataset/test/X_test.txt"
Test <- read.csv(TestFile, header = FALSE, sep = " ")

## Read the feature files "X_train.txt"
TrainFile <- "UCI HAR Dataset/train/X_train.txt"
Train <- read.csv(TrainFile, header = FALSE, sep = " ")

## Read the feature files "features.txt"
featureFile <- "UCI HAR Dataset/features.txt"
flbl <- read.csv(featureFile, header = FALSE, sep = " ")

## Read the feature files "subject_test.txt"
subjectFile <- "UCI HAR Dataset/test/subject_test.txt"
sTest <- read.csv(subjectFile, header = FALSE, sep = " ")
sTest <- sTest[1]

## Read activities files "y_train.txt"
actTestFile <- "UCI HAR Dataset/test/y_test.txt"
actTest <- read.csv(actTestFile, header = FALSE, sep = " ")
actTest <- actTest[1]

## Read subject files "subject_train.txt" 
subTrainFile <- "UCI HAR Dataset/train/subject_train.txt"
sTrain <- read.csv(subTrainFile, header = FALSE, sep = " ")
sTrain <- sTrain[1]

## Read activities files "y_train.txt"
actTrainFile <- "UCI HAR Dataset/train/y_train.txt"
actTrain <- read.csv(actTrainFile, header = FALSE, sep = " ")
actTrain <- actTrain[1]

## Trim the "Train" data to match size of the actTrain & sTrain data length  
Trn <- Train[1:nrow(sTrain), 1:nrow(flbl)]  
Tst <- Test[1:nrow(sTest), 1:nrow(flbl)]

#### Section IV:  Manipulate data
### Assignment Requirement # 1:  Merge the Training anad Test data sets
# In the following TT is the merged data.frame as per  
TT <- rbind(Trn, Tst)

act <- rbind(actTrain, actTest)
subj <- rbind(sTrain, sTest)

TT$Activity.type <- act
TT$Subject <- as.matrix(subj)

### Note ...
# The valueu of TT satisfies Assignment Requiremet #1 with Activities and Subjec info associated

### Assignment Requirement # 3: Use the descriptive names for label 
lbl1 <- flbl$V2
lbl1 <- str_replace_all(lbl1, "\\(\\)", "")
lbl1 <- str_replace_all(lbl1, "\\(", "")
lbl1 <- str_replace_all(lbl1, "\\)", "")
lbl1 <- str_replace_all(lbl1, "-", ".")
lbl1 <- str_replace_all(lbl1, "-", ".")
lbl1 <- str_replace_all(lbl1, "tBodyAcc", "Time.body.accelerometer")
lbl1 <- str_replace_all(lbl1, "fBodyAcc", "Frequency.domain.body.accelerometer")
lbl1 <- str_replace_all(lbl1, "tBodyGyro", "Time.body.gyroscope")
lbl1 <- str_replace_all(lbl1, "Jerk", ".jerk")
lbl1 <- str_replace_all(lbl1, "fBodyGyro", "Frequency.domain.body.gyrpscope")
lbl1 <- str_replace_all(lbl1, "Coeff", ".coefficient")
lbl1 <- str_replace_all(lbl1, ",", ".")
lbl1 <- str_replace_all(lbl1, "meanFreq", "mean.frequency")
lbl1 <- str_replace_all(lbl1, "JerkMag", "jerk.magnitude")
lbl1 <- str_replace_all(lbl1, "bandsEnergy", "bands.energy")
lbl1 <- str_replace_all(lbl1, "gravityMean", "gravity.mean")

### Assignment Requirement 2 :: (Extract observations for the MEAN and the STD)
###   As well as ...
### Assignment Requirement # 4 (Appropriately label variable names with discriptive names)
for (i in 1:length(lbl1)) {names(TT)[i] <- paste(lbl1[i])} # Satisfies Requirement 4
MeanStd_Idx <- grep("mean|std", lbl1)
nCols <- ncol(TT)
MeanStd_Idx <- c(nCols-1, nCols, MeanStd_Idx)
TT <- TT[, MeanStd_Idx] ## Satisfies Assignment Requirement # 2 


### Assignment Requirement #:  3 
# Read activities files "activity_labels.txt"
actLabelsFile <- "UCI HAR Dataset/activity_labels.txt"
actLabels <- read.csv(actLabelsFile, header = FALSE, sep = " ")
actLabels <- as.character(actLabels$V2)

TT[, 1] <- actLabels[TT$Activity.type[[1]]] # Satisfies Assignment Requirement #4

#### Section V:  Write the Output files
### Assignment Requirement #:  5
df1 <- data.frame(TT %>% group_by(Subject, Activity.type) %>% summarise_each(funs(mean(., na.rm = TRUE))))
write.table(df1, "Tidy_HAR_Summary.txt", row.names = FALSE)
