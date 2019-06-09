ipsystem <- function(cropx,longx,latx,monthx,areax) {
#irrigation water requirement

library(sqldf)
library("class")
#weatherdata<-read.csv("C:\\Users\\hostarian\\Documents\\4091_2019-03-31-14-05-15\\4091_2019-03-31-14-05-15\\nfmodifed.csv")
cropdata<-read.csv("capstonecrop.csv")
#monthlywd = sqldf("SELECT CAST(strftime('%Y',Date) AS INT) as Year, CAST(strftime('%m',Date) AS INT) 
 #                 as Month,Longitude,Latitude,Elevation,AVG(MaxTemperature) as MaxTemp,AVG(MinTemperature) 
  #                as MinTemp,SUM(Precipitation) as Rainfall FROM weatherdata GROUP BY Longitude, Latitude,
   #               strftime('%Y',Date),strftime('%m',Date)")
monthlywd<-read.csv("monthlydata.csv")
n<-dim(monthlywd)[1]
monthlywd<-monthlywd[1:(n-1),]
userinput<-c(crop=cropx,begmonth=monthx,long=longx,lat=latx,area=areax)
#calculate the nearest station and get the location
loc<-sqldf("SELECT DISTINCT Longitude, Latitude FROM monthlywd")
minlocstation<-sqldf(sprintf("SELECT Longitude,Latitude, SQRT(SQUARE(Longitude-%s)+SQUARE(Latitude-%s)) 
                             AS Distance FROM loc ORDER BY Distance LIMIT 1",
                             userinput["long"],userinput["lat"]))
filteredcropdetail<-sqldf(sprintf("SELECT Type,minrainfall,maxrainfall,grow1,grow2 from cropdata where 
                                  Type='%s' LIMIT 1",userinput["crop"]))
filteredrainfalldata<-sqldf(sprintf("SELECT Year,Longitude, Latitude,SUM(Rainfall) AS Rainfall FROM monthlywd 
                       WHERE Longitude=%s AND Latitude=%s AND Month>=%s AND Month<=(SELECT (grow2/30)+%s 
                       FROM filteredcropdetail) GROUP BY Year",minlocstation$Longitude,
                       minlocstation$Latitude,userinput["begmonth"],userinput["begmonth"]))
filteredavgrainfall<-sqldf("SELECT AVG(Rainfall) AS Rainfall FROM filteredrainfalldata")
flx<-(filteredcropdetail$minrainfall-filteredavgrainfall)
c<-flx[[1]]
t<-(as.numeric(userinput["area"]))
ifelse(flx>-1,return(sprintf("Please manage atleast %s litre of irrigation water",round(c*t))),return("Required water expected from rainfall"))
}
