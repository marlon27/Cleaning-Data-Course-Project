library(plyr);
#Set the workSpace#
setwd("~/Curso Virtual/DataScientist")

#Step 1. Step read File adn assign columns names#
#Read file for merging#
act_lab<-read.table('./activity_labels.txt',header = FALSE);
feature<-read.table('./features.txt',header = FALSE);
#Read file for training#
sub_train<-read.table('./train/subject_train.txt',header = FALSE);
xTra<-read.table('./train/X_train.txt',header = FALSE);
yTra<-read.table('./train/y_train.txt',header = FALSE);
#Read file for TEST#
sub_TEST<-read.table('./test/subject_test.txt',header = FALSE);
xTst<-read.table('./test/X_test.txt',header = FALSE);
yTst<-read.table('./test/y_test.txt',header = FALSE);
#Colums names#
colnames(act_lab)<-c('ActId','Type');
colnames(sub_train)  <-"subjId";
colnames(yTra)     <-"ActId";
colnames(xTra)   <- feature[,2];
colnames(sub_TEST)  <-"subjId";
colnames(yTst)     <-"ActId";
colnames(xTst)   <- feature[,2]; 
#Step  2. Extracting mean and std in names in xTrain and xTest#
mean_std <- grep("-(mean|std)\\(\\)", feature[, 2]);
xTst <- xTst[, mean_std];
names(xTst) <- feature[mean_std, 2];
xTra <- xTra[, mean_std];
names(xTra) <- feature[mean_std, 2];
#Step  3. merging data train and data test
train <- cbind(sub_train,yTra,xTra);
test <- cbind(sub_TEST,yTst,xTst);
mergeData <- rbind(train,test);

#Step  4 create avarage variable and Include Descriptive names
tidyData <-aggregate(mergeData[,names(mergeData) != c('ActId','subjId')],by=list(ActIdAvg=mergeData$ActId,subjIdAvg = mergeData$subjId),mean);
#include descriptive names#
tidyData <-merge(tidyData,act_lab,by='ActId',all.x=TRUE);

#Step 5. Exporting the tidyData set 
write.table(tidyData, './tidyData.txt',row.names=FALSE,sep='\t');

