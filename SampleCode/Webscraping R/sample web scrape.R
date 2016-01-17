install.packages("RCurl")
library(RCurl)

install.packages("XML")
library(XML)

install.packages("stringr")
library(stringr)

html.raw<-htmlTreeParse("http://app2.nea.gov.sg/anti-pollution-radiation-protection/air-pollution-control/psi/historical-psi-readings/year/2014/month/11/day/3", useInternalNodes=T)
html.parse<-xpathApply(html.raw, "//tr", xmlValue)

data<-unlist(html.parse)

data<-gsub("\r", "", data)
data<-gsub("\n", "", data)
data<-str_split_fixed(data, "\\W+\\s",20)
