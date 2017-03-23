# Load the libraries
library(dplyr)
library(tidyr)
library(tidytext)
library(randomForest)
library(tree)
library(gbm)
library(caret)

# Change into the Kaggle Dir

setwd("~/Desktop/Kaggel_2Sigma")

# Source the directory with our functions

source('data_Cleaning.R')

# Import the data
imported_data <- importRentHopData('train.json','test.json')

# Clean the data
clean_train <- cleanRentHopData(imported_data$train)
clean_test <- cleanRentHopData(imported_data$test)

# Add the sentiment analysis
clean_train <- get_senti(clean_train)
clean_test <- get_senti(clean_test)

# Add the manager skills, impute for missing managers in the test data
clean_train1 <- manager_fracs_train(clean_train)
clean_test1 <- manager_fracs_test(clean_test, clean_train)

# write out the data to a CSV file
setwd("~/Dropbox/Kaggle")
write.csv(clean_train1, file="Glen_train_data.csv")
write.csv(clean_test1, file="Glen_test_data.csv")

# Read in Emil's picture data
photo_data <- readRDS('image_data.rds')

# Merge Photo data with the test and training data
clean_train2 <-  merge(x=clean_train1, y=photo_data, by = "listing_id", all.x = TRUE)
clean_test2 <-  merge(x=clean_test1, y=photo_data, by = "listing_id", all.x = TRUE)
# set the NAs to zero
clean_train2[is.na(clean_train2)] <- 0
clean_test2[is.na(clean_test2)] <- 0
# Drop manager_id, building_id, description, and address_missing
clean_train3 <- dplyr::select(clean_train2, -manager_id, -building_id, -description, -address_missing)
clean_test3 <- dplyr::select(clean_train2, -manager_id, -building_id, -description, -address_missing)
# Write the files out to CVS and RDS formats
write.csv(clean_train3, file="Working_Traning.csv")
saveRDS(clean_train3, file="Working_Traning.rds")
