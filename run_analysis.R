# I download the files from
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# then load the data for the subjects, 
# the type of activity and the features for the training part of the research
xtrain <- read.table("X_train.txt", header = F)
subjtrain <- read.table("subject_train.txt", header = F)
ytrain <- read.table("y_train.txt", header = F) 

# I load the data with the list of features and proceed to rename the columns
colnames(ytrain) <- "ActivityLabels"
features <- read.table("features.txt", header = F)
colnames(xtrain) <- features$V2
colnames(subjtrain) <- "Subject"

# I create the data frame for the training part
training <- cbind(subjtrain, ytrain, xtrain)

# I do the same thing for the test data, this time I rename the columns after
# I merge the data
subjtest <- read.table("subject_test.txt", header = F)
xtest <- read.table("X_test.txt", header = F)
ytest <- read.table("y_test.txt", header = F)
test <- cbind(subjtest, ytest, xtest)
colnames(test) <- c("Subject", "ActivityLabels", features$V2)

# I merge the test and training databases and order it by subject and break the 
# ties by the activity
data <- rbind(test, training)
data <- data[order(data$Subject, data$ActivityLabels),]

# I want to subset the mean and std columns, I wanna do it by searching for text,
# but I have to get around the fact that there are some "mean" matches that aren't
# what I'm looking for, I only want mean() matches, but regular expressions won't
# match parentheses, so I substitute "(" with an "x" and then look for "meanx"
x <- gsub("\\(","x", colnames(data))
meanx <- grep("[Mm]eanx", x)
std <- grep("[Ss]td", colnames(data))
meanstd <- data[, c(1, 2, meanx, std)]

# I swap the activity labels for the actual activity name and change the
# name of the column
labels <- read.table("activity_labels.txt", header=F)
for (i in unique(data$ActivityLabels)){
  data$ActivityLabels <- gsub(labels$V1[i], labels$V2[i], data$ActivityLabels)
  }
colnames(data)[2] <- "Activity"

# I create a new data frame with the average of each variable for each activity
# and each subject (I think the procedure is right but I got 479 variables
# instead of 563 cause there are only 477 unique features in length(unique(features$V2))).
subact <- melt(as.data.table(data), id = c("Subject", "Activity"))
allmeans <- dcast(subact, Subject+Activity~ variable, mean)