monthlywd<-read.csv("C:\\Users\\hostarian\\Documents\\capstoneUI\\Capstone\\monthlydata.csv")
loc<-sqldf("SELECT DISTINCT Longitude, Latitude FROM monthlywd")
loc1<-paste(loc$Longitude,loc$Latitude)
prc_train<-loc[1:87,]
prc_train_labels1<-loc1[1:87]
prc_test<-loc[88:90,]
prc_test_labels1<-loc1[88:90]
#userinput["long"]
dfr<-data.frame("Longitude"=c(userinput["long"]),"Latitude"=c(userinput["lat"]))
prc_test_predlong <- knn(train = prc_train, test = prc_test,cl = prc_train_labels1, k=1)
minloc<-strsplit(as.character(prc_test_predlong[[1]])," ")
as.character(prc_test_predlong[[1]])
library("gmodels")
CrossTable(x=prc_test_labels1,y=prc_test_predlong,prop.chisq = FALSE)