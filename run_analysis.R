##download the file and extract the data
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile="data.zip",method="curl")
if(!file.exists("./extract")){dir.create("./extract")}
unzip("data.zip",overwrite=FALSE,exdir="./extract")

##make a data frame for all the data
DF <- NULL

## set paths for test and training data
testPath <- "./extract/UCI HAR Dataset/test/"
trainPath <- "./extract/UCI HAR Dataset/train/"

## pull in variables: subject_id, activity_label, X, body_acc XYZ, body_gyro XYZ, total_acc XYZ
## subject_... y_... X_... then intertial signals

files1 <- c("subject","y","X")
#files2 <- c("body_acc_x","body_acc_y","body_acc_z","body_gyro_x","body_gyro_y","body_gyro_z","total_acc_x","total_acc_y","total_acc_z")
activity_label <- read.table("./extract/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./extract/UCI HAR Dataset/features.txt")

##load the files into DF
for(file in files1){
    fileToLoad <- paste(testPath,file,"_test.txt", sep="")
    vartest <- read.table(fileToLoad)
    if (file == "X") names(vartest) <- features[,2]
    else names(vartest) <- file
    fileToLoad <- paste(trainPath,file,"_train.txt", sep="")
    vartrain <- read.table(fileToLoad)
    if (file == "X") names(vartrain) <- features[,2]
    else names(vartrain) <- file
    rboth <- rbind(vartest,vartrain)
    if (is.null(DF)) {DF <- rboth}
    else {DF <- cbind(DF,rboth)}
}
##replace the activity numbers with labels, and change the column name
DF$y = factor(DF$y,labels=activity_label[,2])
colnames(DF)[2] <- "activity"

## is this needed?
# for(file in files2){
#     fileToLoad <- paste(testPath,"Inertial Signals/",file,"_test.txt", sep="")
#     vartest <- read.table(fileToLoad)
#     names(vartest) <- paste(file,seq(1,128,1))
#     fileToLoad <- paste(trainPath,"Inertial Signals/",file,"_train.txt", sep="")
#     vartrain <- read.table(fileToLoad)
#     names(vartrain) <- paste(file,seq(1,128,1))
#     rboth <- rbind(vartest,vartrain)
#     if (is.null(DF)) {DF <- rboth}
#     else {DF <- cbind(DF,rboth)}
# }

##make a second dataset including only mean and standard deviation
DFx <- DF[,grep("subject|activity|std|mean\\()",colnames(DF),value=TRUE)]
##average all the variables and sort by subject and activity
agg <- aggregate(.~subject+activity, DFx, mean)
##write tidy data to a txt file
write.table(agg,file = "CPANSWER.txt")
#read in with this line
#read.table("CPANSWER.txt")
