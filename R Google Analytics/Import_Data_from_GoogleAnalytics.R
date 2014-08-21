## Require the setup of the Google Analytics Account with the required profiles setup

## Require the setup of an account in the Google Developer console 
## Refer to references as listed
## 
## References:
## https://github.com/Tatvic/RGoogleAnalytics
## https://developers.google.com/analytics/solutions/articles/hello-analytics-api#select_language
## Also check manual at CRAN.

## Installing the necessary packages
install.packages("RGoogleAnalytics")
library(RGoogleAnalytics)
install.packages("httpuv")
library(httpuv)

## Setting up necessary security tokens
## Obtain the necessary client.id and client.secret from the Developer Console
client.id<-"PLACEHOLDER"
client.secret<-"PLACEHOLDER"

## Creating the security token
token<-Auth(client.id,client.secret)

## Saving a file to store token value on local computer 
save(token, file="./token_file")

## When entering new R environment
load(file="./token_file")

## Checking that security token still valid
Validate(token)

## Build query
## Table id is obtained from the Google Analytics account
## It is the View ID.
## To access it, it is admin tab of a view, view settings
query.list <- Init(start.date = "2013-11-28",
                   end.date = "2013-12-04",
                   dimensions = "ga:date,ga:pagePath,ga:hour,ga:medium",
                   metrics = "ga:sessions,ga:pageviews",
                   max.results = 10000,
                   sort = "-ga:date",
                   filters = "ga:medium==referral",
                   table.id = "ga:33093633")


# Create the Query Builder object so that the query parameters are validated
ga.query <- QueryBuilder(query.list)

# Extract the data and store it in a data-frame
ga.data <- GetReportData(ga.query, token)


