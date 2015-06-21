# Code Book
This is the code book for the tidy data generated using the [run_analysis.R script](https://github.com/SriramKeerthi/gettingcleaning/blob/master/run_analysis.R "Run Analysis R Script").

The output of the script is written into `sensorDataAvg.txt`. It can be imported into R using:
```
sdat <- read.table("sensorDataAvg.txt", header=T)
```

## Variables
There are 180 observations of 81 variables in the `sensorDataAvg.txt` file, divided into:
- ActivityName: Name of the activity being performed, labeled as WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
- Subject: ID of the Subject who participated in the experiment
- 79 sensor variables in `Time` and `Frequency` domains, with a postfix of `Mean` or `StandardDeviation` depending on the source variable, followed by `XYZ` if they are dimension based:
<table>
  <tr>
    <th>Time Domain</th><th>Frequency Domain</th>
  </tr>
  <tr>
    <td>Frequency.BodyAcceleration.Mean.XYZ</td><td>Time.BodyAcceleration.Mean.XYZ</td>
  </tr>
  <tr>
    <td>Frequency.BodyAcceleration.MeanFrequency.XYZ</td><td></td>
  </tr>
  <tr>
    <td>Frequency.BodyAcceleration.StandardDeviation.XYZ</td><td>Time.BodyAcceleration.StandardDeviation.XYZ</td>
  </tr>
  <tr>
    <td>Frequency.BodyAccelerationJerk.Mean.XYZ</td><td>Time.BodyAccelerationJerk.Mean.XYZ</td>
  </tr>
  <tr>
    <td>Frequency.BodyAccelerationJerk.MeanFrequency.XYZ</td><td></td>
  </tr>
  <tr>
    <td>Frequency.BodyAccelerationJerk.StandardDeviation.XYZ</td><td>Time.BodyAccelerationJerk.StandardDeviation.XYZ</td>
  </tr>
  <tr>
    <td>Frequency.BodyAccelerationJerkMagnitude.Mean</td><td>Time.BodyAccelerationJerkMagnitude.Mean</td>
  </tr>
  <tr>
    <td>Frequency.BodyAccelerationJerkMagnitude.MeanFreq</td><td></td>
  </tr>
  <tr>
    <td>Frequency.BodyAccelerationJerkMagnitude.StandardDeviation</td><td>Time.BodyAccelerationJerkMagnitude.StandardDeviation</td>
  </tr>
  <tr>
    <td>Frequency.BodyAccelerationMagnitude.Mean</td><td>Time.BodyAccelerationMagnitude.Mean</td>
  </tr>
  <tr>
    <td>Frequency.BodyAccelerationMagnitude.MeanFreq</td><td></td>
  </tr>
  <tr>
    <td>Frequency.BodyAccelerationMagnitude.StandardDeviation</td><td>Time.BodyAccelerationMagnitude.StandardDeviation</td>
  </tr>
  <tr>
    <td>Frequency.BodyGyro.Mean.XYZ</td><td>Time.BodyGyro.Mean.XYZ</td>
  </tr>
  <tr>
    <td>Frequency.BodyGyro.MeanFrequency.XYZ</td><td></td>
  </tr>
  <tr>
    <td>Frequency.BodyGyro.StandardDeviation.XYZ</td><td>Time.BodyGyro.StandardDeviation.XYZ</td>
  </tr>
  <tr>
    <td></td><td>Time.BodyGyroJerk.Mean.XYZ</td>
  </tr>
  <tr>
    <td></td><td>Time.BodyGyroJerk.StandardDeviation.XYZ</td>
  </tr>
  <tr>
    <td>Frequency.BodyGyroJerkMagnitude.Mean</td><td>Time.BodyGyroJerkMagnitude.Mean</td>
  </tr>
  <tr>
    <td>Frequency.BodyGyroJerkMagnitude.MeanFreq</td><td></td>
  </tr>
  <tr>
    <td>Frequency.BodyGyroJerkMagnitude.StandardDeviation</td><td>Time.BodyGyroJerkMagnitude.StandardDeviation</td>
  </tr>
  <tr>
    <td>Frequency.BodyGyroMagnitude.Mean</td><td>Time.BodyGyroMagnitude.Mean</td>
  </tr>
  <tr>
    <td>Frequency.BodyGyroMagnitude.MeanFreq</td><td></td>
  </tr>
  <tr>
    <td>Frequency.BodyGyroMagnitude.StandardDeviation</td><td>Time.BodyGyroMagnitude.StandardDeviation</td>
  </tr>
  <tr>
    <td></td><td>Time.GravityAcceleration.Mean.XYZ</td>
  </tr>
  <tr>
    <td></td><td>Time.GravityAcceleration.StandardDeviation.XYZ</td>
  </tr>
  <tr>
    <td></td><td>Time.GravityAccelerationMagnitude.Mean</td>
  </tr>
  <tr>
    <td></td><td>Time.GravityAccelerationMagnitude.StandardDeviation</td>
  </tr>
</table>

## Transformations
The input data is transformed as follows:

### Combine Test and Train data
We combine the datasets using a series of `cbind` and `rbind` calls on the data:
```
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
```

### Extract relevant variables
We subset the data by selecting fields which contain the terms `mean`, `std`, `Subject` or `Activity` using:
```
selectColumn <- grepl("mean|std|Subject|Activity", names(sensorData))
sensorDataSubset <- sensorData[,selectColumn]
```

### Use descriptive Activity names
This is obtained by merging the sensor data with the Activity Labels provided in the `activity_labels.txt` file and removing the first variable (Which isn't required anymore):
```
sensorDataSubsetJoined <- join(sensorDataSubset, activityLabels, by="Activity", match="first")[,-1]
```

### Rename data labels
The data labels are cleaned up by expanding shortened names such as `Freq` with `Frequency`, `^t` with `Time`, etc. using the `gsub` function:
```
names(sensorDataSubsetJoined) <- gsub('Mag\\.','Magnitude.',names(sensorDataSubsetJoined))
```

### Compute tidy data
This is done by grouping and averaging the data by `Subject` and `ActivityName`:
```
sensorDataAvg = ddply(sensorDataSubsetJoined, c("Subject","ActivityName"), numcolwise(mean))
```

### Export data
The data is written by calling the `write.table` function on the tidy data:
```
write.table(sensorDataAvg, file = "sensorDataAvg.txt", row.names=FALSE)
```

