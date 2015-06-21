# ==== #
# Init #
# ==== #
require(plyr)

# Directory for the data
dataHome <- "/path/to/uci/har/dataset/"

# Set working directory to the data directory
setwd(dataHome)

# ============= #
# Read all data #
# ============= #

# Read the Features and Labels
features <- read.table("features.txt", colClasses = c("character"))
activityLabels <- read.table("activity_labels.txt", col.names = c("Activity", "ActivityName"))

# Read the Test data
subjectTest <- read.table("test/subject_test.txt", col.names=c("Subject"))
yTest <- read.table("test/y_test.txt", col.names=c("Activity"))
xTest <- read.table("test/X_test.txt", col.names=features[,2])

# Read the Training data
subjectTrain <- read.table("train/subject_train.txt", col.names=c("Subject"))
yTrain <- read.table("train/y_train.txt", col.names=c("Activity"))
xTrain <- read.table("train/X_train.txt", col.names=features[,2])

## Merge the training and test data sets
testData <- cbind(cbind(xTest, subjectTest), yTest)
trainingData <- cbind(cbind(xTrain, subjectTrain), yTrain)
sensorData <- rbind(testData, trainingData)

## Extract mean and standard deviation measurements
# Select valid columns
selectColumn <- grepl("mean|std|Subject|Activity", names(sensorData))
# Extract a subset from the sensor data
sensorDataSubset <- sensorData[,selectColumn]

## Give data descriptive names
# Combine the data with the activity name
sensorDataSubsetJoined <- join(sensorDataSubset, activityLabels, by="Activity", match="first")[,-1]
# Clean up names
names(sensorDataSubsetJoined) <- make.names(gsub('\\(|\\)', "", names(sensorDataSubsetJoined), perl=TRUE))
names(sensorDataSubsetJoined) <- gsub('Acc','Acceleration',names(sensorDataSubsetJoined))
names(sensorDataSubsetJoined) <- gsub('^t','Time.',names(sensorDataSubsetJoined))
names(sensorDataSubsetJoined) <- gsub('^f','Frequency.',names(sensorDataSubsetJoined))
names(sensorDataSubsetJoined) <- gsub('\\.mean','.Mean',names(sensorDataSubsetJoined))
names(sensorDataSubsetJoined) <- gsub('\\.std','.StandardDeviation',names(sensorDataSubsetJoined))
names(sensorDataSubsetJoined) <- gsub('\\.\\.\\.','.',names(sensorDataSubsetJoined))
names(sensorDataSubsetJoined) <- gsub('Freq\\.','Frequency.',names(sensorDataSubsetJoined))
names(sensorDataSubsetJoined) <- gsub('Mag\\.','Magnitude.',names(sensorDataSubsetJoined))
names(sensorDataSubsetJoined) <- gsub('\\.\\.$','',names(sensorDataSubsetJoined))

## Export tidy data with average values
# Compute averages
sensorDataAvg = ddply(sensorDataSubsetJoined, c("Subject","ActivityName"), numcolwise(mean))
# Write averages
write.table(sensorDataAvg, file = "sensorDataAvg.txt", row.names=FALSE)

