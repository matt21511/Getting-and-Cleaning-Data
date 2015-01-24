library("reshape2")

#Get data from txt files
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
X.train <- read.table("UCI HAR Dataset/train/X_train.txt")
y.train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X.test <- read.table("UCI HAR Dataset/test/X_test.txt")
y.test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Merge training and test data sets
X.merged <- rbind(X.train, X.test)
y.merged <- rbind(y.train, y.test)
subject.merged <- rbind(subject.train, subject.test)

#Add column for activity names based on activity IDs
y.merged[,1] <- activity.labels[y.merged[,1],2]

#Add column names to data sets
names(X.merged) <- features[,2]
names(y.merged) <- "Activity"
names(subject.merged) <- "Subject"

#Remove columns that do not contain mean/std measurements
used.cols <- grepl("mean|std", features[,2])
X.merged <- X.merged[,used.cols]

#Create overall data sets
dataset <- cbind(X.merged, y.merged, subject.merged)
data.melt <- melt(dataset, id = c("Subject", "Activity"), measure.vars = names(dataset[,1:(ncol(dataset)-2)]))
tidy.data <- dcast(data.melt, Subject + Activity ~ variable, mean)
write.table(tidy.data,"tidy_data.txt")
