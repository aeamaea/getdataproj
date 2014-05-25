Getting and Cleaning Data - Project Readme
========================================================

This Readme Explains the choices made in selecting the various variables in the Data Set provided by the course.

The data has been knitted together based on this excellent explanation by David Hood, Community TA for the course:

![Data Configuration Diagram by David Hood](Slide2.png)

David gives his [permission to use the diagram here](https://class.coursera.org/getdata-003/forum/thread?thread_id=90#comment-777) : 

```
https://class.coursera.org/getdata-003/forum/thread?thread_id=90#comment-777
```

The following files were incorporated to build the data set.:

1. Features --> Cleaned up names using Vim (as R sucks at doing simple search/replace)
2. test/X_test, test/y_test, test/subject_test files
3. train/X_train, train/y_train, train/subject_train files.

### How features file was cleaned up
* load in vim
* :%s/(//g
* :%s/)//g
* :%s/,//g
* :%s/-/g
* :w features_clean.txt

Load and use the cleaned up activity names as so: 

``` 
features <- read.table("features_clean.txt",stringsAsFactors=FALSE)
```  
  
Now load just the features into a vector so you can assign it to the test/train as column names
```
featnames <- features[,2]
```
### Why there are Caps in the feature names?

The reason is that it helps us to read the names and it does not affect the R language processing of any variables. Therefore I took out things like ')', '(','-','_' and ',' but kept the Caps as that helps in reading the various names.

### Knitting the Data Together. 

These are the steps taken to put every thing together before selecting certain mean/std-dev values.


### Creat the vector that would become the variable names of the combined data frame
```
varnames <- append(features[,2],c("Subject","Activity"))
```
## ---- FEATURES ----  

### load the X_train.txt file
```
X_train <- read.table("train\\X_train.txt",stringsAsFactors=FALSE)
```
### load the X_test file
```
X_test <- read.table("test\\X_test.txt",stringsAsFactors=FALSE)
```

### Row Bind these two data frames together
```
X_train_test <- rbind(X_train,X_test)
```

## ---- SUBJECT ----

### load the subject_train.txt file

```
subject_train <- read.table("train\\subject_train.txt", stringsAsFactors=FALSE)
```
### load the subject_test.txt file
```
subject_test <- read.table("test\\subject_test.txt", stringsAsFactors=FALSE)
```
### Row Bind these two data frames together
```
subject_train_test <- rbind(subject_train,subject_test)
```
## ---- ACTIVITY ----

### load the y_train.txt file
```
y_train <- read.table("train\\y_train.txt", stringsAsFactors=FALSE)
```

### load the y_test.txt file
```
y_test <- read.table("test\\y_test.txt", stringsAsFactors=FALSE)
```

### Row Bind these two data frames together
```
y_train_test <- rbind(y_train,y_test)
```

## Step 1
  
### Now knit the three row bind-ed data sets of 10299 observeration each column wise and give it a name

```
fulldf <- cbind(X_train_test,subject_train_test, y_train_test)
```

### Now give names to this data frame, 561+2 X 10299 data frame
```
names(fulldf) <- varnames
```

STEP 2 :: MEAN and STANDARD DEVIATION variable Extraction
-----------------------------------------------------------

The following Variables are extracted. 

| Index in Features | Variable Name| 
| ----------------- | -------------|
| 1                 | tBodyAccmeanX| 
| 2                  | tBodyAccmeanY| 
| 3	                | tBodyAccmeanZ| 
| 4	                | tBodyAccstdX| 
| 5	                | tBodyAccstdY| 
| 6	                | tBodyAccstdZ| 
| 41	| tGravityAccmeanX| 
| 42	| tGravityAccmeanY| 
| 43	| tGravityAccmeanZ| 
| 44	| tGravityAccstdX| 
| 45	| tGravityAccstdY| 
| 46	| tGravityAccstdZ| 
| 559	| angleXgravityMean| 
| 560	| angleYgravityMean| 
| 561	| angleZgravityMean| 

```
 finaldf <- fulldf[,c(1,2,3,4,5,6,41,42,43,44,45,46,559,560,561,562,563,564)]
```


## Step 3
  
### Give Descriptive Activity Labels to each activity. I'm just adding an Activity Label to the full dataframe (as per David Hood's example in the forums)
```
fulldf$actlabel <- "Unset"
fulldf$actlabel[fulldf2$Activity==1] <- "Walking"
fulldf$actlabel[fulldf2$Activity==1] <- "Walking"
fulldf$actlabel[fulldf2$Activity==2] <- "wALKING_UPSTAIRS"
fulldf$actlabel[fulldf2$Activity==3] <- "wALKING_DOWNSTAIRS"
fulldf$actlabel[fulldf2$Activity==4] <- "SITTING"
fulldf$actlabel[fulldf2$Activity==5] <- "STANDING"
fulldf$actlabel[fulldf2$Activity==6] <- "LAYING"
```

## Step 4 ::  Descriptive names for the fucking data set
* Also set the names to lowercase to make them easier to work with*

```
names(finaldf) <- gsub("Acc","Acceleration",names(finaldf))
names(finaldf) <- gsub("std","StandardDeviation",names(finaldf))
names(finaldf) <- tolower(names(finaldf))

names(finaldf) <- gsub("tbody","tbody.", names(finaldf))
names(finaldf) <- gsub("x",".x", names(finaldf))
names(finaldf) <- gsub("y",".y", names(finaldf))
names(finaldf) <- gsub("z",".z", names(finaldf))
names(finaldf) <- gsub("acceleration","acceleration.", names(finaldf))

names(finaldf) <- gsub("activit.y","activity", names(finaldf))
names(finaldf) <- gsub("tbod.y","tbody", names(finaldf))
names(finaldf) <- gsub("tgravit.y","tgravity", names(finaldf))
names(finaldf) <- gsub("angle.xgravit.ymean","angle.x.gravity.mean", names(finaldf))
names(finaldf) <- gsub("angle.ygravit.ymean","angle.y.gravity.mean", names(finaldf))
names(finaldf) <- gsub("angle.zgravit.ymean","angle.z.gravity.mean", names(finaldf))
names(finaldf) <- gsub("tgravityacceleration","tgravity.acceleration", names(finaldf))
```

### Reason for extracting these variables:

As per the requirements and explaination by David Hood, there is NO fix number of columns
We are to extract based on our judgement. I extracted on the Body Acceleration Means/Std and the Gravity Accelerometer as I wanted to see what the data looks like together and if there are 
any correlations. 

## Step 5: Write out the Data Set
* melt the data frame using subject/actlabel (this is the activity with descriptive name)*

```
library(reshape2)
fdf.melt <- melt(finaldf, id=c("subject","actlabel"))
```

### recast it and create a final tidy data set. (Step 5)
```
fdf.cast <- dcast(fdf.melt, subject+actlabel ~ variable,mean)
```

### Write out the tidy data set to a CSV file, 

```
write.csv(file="getdata_proj_tidy_final.csv",x=fdf.cast)
```
