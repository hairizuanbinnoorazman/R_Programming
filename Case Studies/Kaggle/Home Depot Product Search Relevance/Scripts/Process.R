#' Home Depot Product Search Relevance
#' 
#' Purpose of this script:
#' This script is to be used for process data provided for this Kaggle competition
#' 
#' Ensure that your current working is within this folder
#' ".../Home Depot Product Search Relevance/Scripts/"

# Define directories
rawDataFolder <- "../Data/Raw Data/"
processDataFolder <- "../Data/Processed Data/"

# Define raw file names
raw_fileName_attributes <- paste0(rawDataFolder, "attributes.csv.zip")
raw_fileName_test <- paste0(rawDataFolder, "test.csv.zip")
raw_fileName_product_descriptions <- paste0(rawDataFolder, "product_descriptions.csv.zip")
raw_fileName_sample_submission <- paste0(rawDataFolder, "sample_submission.csv.zip")
raw_fileName_train <- paste0(rawDataFolder, "train.csv.zip")

# Unzip files
unzip(raw_fileName_attributes, exdir = rawDataFolder)
unzip(raw_fileName_test, exdir = rawDataFolder)
unzip(raw_fileName_train, exdir = rawDataFolder)
unzip(raw_fileName_product_descriptions, exdir = rawDataFolder)
unzip(raw_fileName_sample_submission, exdir = rawDataFolder)

# Read data
attributes <- read.csv(paste0(rawDataFolder, "attributes.csv")) # ~ 2 million rows
product_descriptions <- read.csv(paste0(rawDataFolder, "product_descriptions.csv")) # ~ 120000 rows
train <- read.csv(paste0(rawDataFolder, "train.csv")) # ~ 70000 rows
