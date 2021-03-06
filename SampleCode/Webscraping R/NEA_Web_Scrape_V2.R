## NEA web scrape

# Install required libraries
# XML, RCurl, Stringr, tidyr, dplyr

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

if(!require(XML)){
  install.packages("XML")
  library(XML)
}

if(!require(RCurl)){
  install.packages("RCurl")
  library(RCurl)
}

if(!require(stringr)){
  install.packages("stringr")
  library(stringr)
}

if(!require(lubridate)){
  install.packages("lubridate")
  library(lubridate)
}

# Data cleaning functions
# These set of functions is generalized and can be reuse in any project if 
# necessary


deleteEmptyColumns<-function(data){
  data<-data[,!apply(data,2,function(x) all(x == ""))]
  data<-as.data.frame(data)
  data
}

rowDropLast<-function(data, num){
  noOfRows<-dim(data)[1]
  noOfRows<-noOfRows-num
  data<-data[1:noOfRows,]
  data
}

columnDropLast<-function(data, num){
  noOfColumns<-dim(data)[2]
  noOfColumns<-noOfColumns-num
  data<-data[,1:noOfColumns]
  data
}

rowShiftRight<-function(data,rowNo, shifts){
  temp_data<-data[rowNo,]
  temp_data<-columnDropLast(temp_data, shifts)
  
  ## Create temp shift columns
  shift_columns<-rep("", times=shifts)
  shift_columns<-data.frame(matrix(shift_columns, 1, shifts))
  temp_data<-cbind(shift_columns, temp_data)
  
  ## Return shift row to original data
  data[rowNo,]<-temp_data
  data
}

# Drop first set of rows
rowDropFirst<-function(data, num){
  noOfRows<-dim(data)[1]
  num<-num+1
  data<-data[num:noOfRows,]
  data
}

#########################################################################
#################### EDIT THIS SECTION OF THE CODE ######################
#########################################################################

# Setting the constants for the website scraping
# NEA website
URL<-"http://app2.nea.gov.sg/anti-pollution-radiation-protection/air-pollution-control/psi/historical-psi-readings"

# Name of file for storage
file.name.part<-"NEA_PSI"

# Initialize dim.data table to collect dimensions data for NEA dataset
cdata<-read.csv("template.csv")
temp_cdata<-cdata

# Set end date
Year<-"2014"
Month<-"11"
Day<-"01"
end_date<-as.Date(paste0(Day,"-",Month,"-",Year),"%d-%m-%Y")

# Set start date
Year<-"2012"
Month<-"09"
Day<-"14"
start_date<-as.Date(paste0(Day,"-",Month,"-",Year),"%d-%m-%Y")

#########################################################################
################ END EDIT THIS SECTION OF THE CODE ######################
#########################################################################

#########################################################################
## V2 aims to produce a large file with date column
## First portion would be to create an initial file with the appropiate column
## Second portion would be to append it on top of that continuously
#########################################################################

# Assign start date to loop variable before entering loop
loop_date<-start_date
while(loop_date<end_date){
  
  ## complete the URL
  year.string<-paste0("/year/",year(loop_date))
  month.string<-paste0("/month/",month(loop_date))
  day.string<-paste0("/day/",day(loop_date))
  URL_temp<-paste0(URL,year.string, month.string,day.string)
  
  ## Name of file
  file.name<-paste0(file.name.part, "_", day(loop_date), "-", month(loop_date), "-", year(loop_date), ".csv")
  
  ## Extract raw html
  html.raw<-htmlTreeParse(URL_temp, useInternalNodes=T)
  html.parse<-xpathApply(html.raw, "//tr", xmlValue)
  
  ## Convert to data frame
  data<-unlist(html.parse)
  
  ## Initial Cleaning
  ## Remove escape characters in HTML
  ## Split data via usage of regex
  data<-gsub("\r", "", data)
  data<-gsub("\n", "", data)
  data<-str_split_fixed(data, "\\W+\\s",20)
  
  ## Secondary Cleaning
  ## Usage of primary cleaning would result in many empty column
  ## Secondary Cleaning is to remove all empty columns
  data<-deleteEmptyColumns(data)
  
  ## Remove last 4 rows
  ## Last 4 rows contain information on agency and hotline numbers
  data<-rowDropLast(data, 4)
  
  ## Remove first 2 rows
  ## First 2 rows contain row names which would be irrelevant
  ## in the larger file
  data<-rowDropFirst(data,2)
  
  ## Add date column
  data<-cbind(loop_date, data)
  
  ## remove row names
  row.names(data)<-NULL
  
  ## Add empty columns
  data_column_no<-ncol(data)
  cdata_column_no<-ncol(cdata)
  data_column_no<-data_column_no+1
  if(data_column_no<14){
    data[,data_column_no:cdata_column_no]<-""
  }
  
  ## Map names correctly
  names(cdata)<-names(data)
  
  ## Append to cdata
  cdata<<-rbind(cdata,data)
  
  ## Check that dates are running correctly
  ## Can comment out if necessary
  loop_date<-loop_date+1
  print(loop_date)
}

names(cdata)<-names(temp_cdata)
write.csv(cdata,"combined_psi.csv")
