## VITAL PORTION
options(stringsAsFactors=FALSE)
##
if(!require(dplyr)){
  install.packages("dplyr")
  library(plyr)
}

if(!require(tidyr)){
  install.packages("tidyr")
  library(tidyr)
}

data<-read.csv("combined_psi.csv")

# Drop first set of columns
columnDropFirst<-function(data, num){
  noOfColumns<-dim(data)[2]
  num<-num+1
  data<-data[,num:noOfColumns]
  data
}

data<-columnDropFirst(data, 1)
data<-gather(data, Variable, Value, 3:14)

write.csv(data, "NEA PSI FF.csv", row.names=FALSE)
