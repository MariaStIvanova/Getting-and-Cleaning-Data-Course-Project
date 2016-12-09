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

## Summary of the dataset 

### summary(TidyDT)

subject         activityname              domain           acceleration   instrument           jerk        magnitude        measurement axis     
 Min.   : 1.0   LAYING            :1980   Frequency:4680   Body   :5760   Accelerometer:7200   Jerk:4680   Magnitude:3240   Mean:5940   X   :2880  
 1st Qu.: 8.0   SITTING           :1980   Time     :7200   Gravity:1440   Gyroscope    :4680   NA's:7200   NA's     :8640   SD  :5940   Y   :2880  
 Median :15.5   STANDING          :1980                    NA's   :4680                                                                 Z   :2880  
 Mean   :15.5   WALKING           :1980                                                                                                 NA's:3240  
 3rd Qu.:23.0   WALKING_DOWNSTAIRS:1980                                                                                                            
 Max.   :30.0   WALKING_UPSTAIRS  :1980                                                                                                            
 average        
 Min.   :-0.99767  
 1st Qu.:-0.94151  
 Median :-0.39653  
 Mean   :-0.42791  
 3rd Qu.:-0.07633  
 Max.   : 0.97451  

## Exemplary rows, 6 at random 

### TidyDT[sample(nrow(TidyDT), 6), ]

           subject activityname    domain    acceleration    instrument    jerk magnitude measurement axis     average
4853       13      SITTING         Time      Gravity         Accelerometer <NA> <NA>      Mean        Z         0.07577739
10047      26      STANDING        Time      <NA>            Gyroscope     Jerk Magnitude Mean        <NA>     -0.98854483
8104       21      STANDING        Frequency Body            Accelerometer <NA> <NA>      Mean        Y        -0.45653018
3641       10      SITTING         Time      <NA>            Gyroscope     Jerk <NA>      Mean        Z        -0.04894119
1686        5      SITTING         Time      Gravity         Accelerometer <NA> <NA>      SD          X        -0.98313754
1994        6      LAYING          Time      <NA>            Gyroscope     Jerk <NA>      SD          Z        -0.95957907
