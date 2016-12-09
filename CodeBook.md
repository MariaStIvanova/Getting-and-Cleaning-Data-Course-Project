# CodeBook 

## Variable names 

### names(TidyDT)

[1] "subject"      "activityname" "domain"       "acceleration" "instrument"   "jerk"         "magnitude"    "measurement"  "axis"        
[10] "average" 

## Type and nature of the variables 

### str(TidyDT) 

Variable name | Variable type | Variable description 
------------- | --------------| --------------------
subject | Integer | ID of a volunteer, from 1 to 30
activityname | Factor w/ 6 levels | Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
domain | Factor w/ 2 levels | Time or frequency domain
acceleration | Factor w/ 2 levels | Acceleration signal is separated into body and gravity acceleration signals
instrument | Factor w/ 2 levels | Accelerometer or gyroscope embedded in a smartphone (Samsung Galaxy S II)
jerk | Factor w/ 1 level | Jerk signal, if present
magnitude | Factor w/ 1 level | Magnitude of the signals calculated using the Euclidean norm
measurement | Factor w/ 2 levels | Mean value or standard deviation of the signals 
axis | Factor w/ 3 levels | Axes in the 3-dimensional space, X, Y, Z
average | Numeric | Average for each activity and each subject

## Units 
Features, in other words, signals are normalized and bounded within [-1,1]. Therefore the units of their respective averages are the same, namely unitless. They range between -0.99767 and 0.97451. 
