
## Clean up the feature names so we can use them as column names

if(file.exists("features_clean1.txt")) {
  features <- read.table("features_clean.txt",stringsAsFactors=FALSE)
} else { "You must create features_clean.txt file by opening features in vim and search/replace paren,commas,dashes,underscores with emptystrings"}

## Creat the vector that would become the variable names of the combined data frame
varnames <- append(features[,2],c("Subject","Activity"))

## ---- FEATURES ----

## load the X_train.txt file
X_train <- read.table("train\\X_train.txt",stringsAsFactors=FALSE)

## load the X_test file
X_test <- read.table("test\\X_test.txt",stringsAsFactors=FALSE)

## Row Bind these two data frames together

X_train_test <- rbind(X_train,X_test)
## ---- SUBJECT ----

## load the subject_train.txt file
subject_train <- read.table("train\\subject_train.txt", stringsAsFactors=FALSE)

## load the subject_test.txt file
subject_test <- read.table("test\\subject_test.txt", stringsAsFactors=FALSE)

## Row Bind these two data frames together

subject_train_test <- rbind(subject_train,subject_test)

## ---- ACTIVITY ----

## load the y_train.txt file
y_train <- read.table("train\\y_train.txt", stringsAsFactors=FALSE)

## load the y_test.txt file

y_test <- read.table("test\\y_test.txt", stringsAsFactors=FALSE)

## Row Bind these two data frames together

y_train_test <- rbind(y_train,y_test)

## ----------------------------------------------------------------
## Now knit the three row bind-ed data sets of 10299 observeration each
## column wise and give it a name
## ----------------------------------------------------------------

fulldf <- cbind(X_train_test,subject_train_test, y_train_test)

## Now give names to this data frame, 561+2 X 10299 data frame
names(fulldf) <- varnames

### Give Descriptive Activity Labels to each activity. I'm just adding an Activity Label to the full dataframe (as per David Hood's example in the forums)

fulldf$actlabel <- "Unset" #<-- This adds new column actlabel to data frame
fulldf$actlabel[fulldf2$Activity==1] <- "Walking"
fulldf$actlabel[fulldf2$Activity==1] <- "Walking"
fulldf$actlabel[fulldf2$Activity==2] <- "wALKING_UPSTAIRS"
fulldf$actlabel[fulldf2$Activity==3] <- "wALKING_DOWNSTAIRS"
fulldf$actlabel[fulldf2$Activity==4] <- "SITTING"
fulldf$actlabel[fulldf2$Activity==5] <- "STANDING"
fulldf$actlabel[fulldf2$Activity==6] <- "LAYING"

# The following Variables are extracted. 
# 
# | Index in Features | Variable Name| 
#   | ----------------- | -------------|
#   | 1                 | tBodyAccmeanX| 
#   | 2                  | tBodyAccmeanY| 
#   | 3	                | tBodyAccmeanZ| 
#   | 4	                | tBodyAccstdX| 
#   | 5	                | tBodyAccstdY| 
#   | 6	                | tBodyAccstdZ| 
#   | 41	| tGravityAccmeanX| 
#   | 42	| tGravityAccmeanY| 
#   | 43	| tGravityAccmeanZ| 
#   | 44	| tGravityAccstdX| 
#   | 45	| tGravityAccstdY| 
#   | 46	| tGravityAccstdZ| 
#   | 559	| angleXgravityMean| 
#   | 560	| angleYgravityMean| 
#   | 561	| angleZgravityMean| 
finaldf <- fulldf[,c(1,2,3,4,5,6,41,42,43,44,45,46,559,560,561,562,563,564)]

## "Descriptive names for the fucking data set"
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

## ----------------------------------------------------------------
## melt the data frame using subject/actlabel (this is the activity with descriptive name)
## ----------------------------------------------------------------

library(reshape2)
fdf.melt <- melt(finaldf, id=c("subject","actlabel"))

## recast it and create a final tidy data set. (Step 5)
fdf.cast <- dcast(fdf.melt, subject+actlabel ~ variable,mean)

## Write out the tidy data set to a CSV file, 

write.csv(file="getdata_proj_tidy_final.csv",x=fdf.cast)




