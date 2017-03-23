library("jsonlite")
library("dplyr") 
library("purrr")
library("ggplot2")
library("mlogit")
library("nnet")
library("car")
library("MASS")
setwd("~/Desktop/Kaggel_2Sigma")
purrr::walk(packages, library, character.only = TRUE, warn.conflicts = FALSE)

data <- fromJSON("train.json")
# unlist every variable except `photos` and `features` and convert to tibble
vars <- setdiff(names(data), c("photos", "features"))
data <- map_at(data, vars, unlist) %>% tibble::as_tibble(.)

library(VIM)
aggr(data)

nrow(data[data$bathrooms == 0,])

na_list <- sapply(data, is.na)
.trim <- function (x) gsub("^\\s+|\\s+$", "", x)
data$description <- .trim(data$description)
summary(data)
studio <- filter(data, bedrooms == 0)

data_reduced1 <- dplyr::select(data, -photos, -features, -description)
data_reduced1$bathrooms <- as.factor(data_reduced$bathrooms)
data_reduced1$bedrooms <- as.factor(data_reduced$bedrooms)
sapply(data_reduced1,class)
high_priced <- filter(data_reduced1, price > 10000)
data_reduced <- filter(data_reduced1, price < 10000)

g <- ggplot(data=data_reduced1) 
g + geom_boxplot(aes(x=bedrooms,y=price))

g <- ggplot(data=data_reduced1) 
g + geom_boxplot(aes(x=interest_level,y=price))

d <- data_reduced %>% 
     group_by(bedrooms, interest_level) %>%
     summarise(count=n())

g<- ggplot(data=d) 
g + geom_bar(aes(x=bedrooms,y=count), stat='identity') + facet_grid(. ~ interest_level)

d <- data_reduced1 %>% 
     group_by(bathrooms, interest_level) %>%
     summarise(count=n())

g<- ggplot(data=d) 
g + geom_bar(aes(x=bathrooms,y=count), stat='identity') + facet_grid(. ~ interest_level)

data_reduced1$interest_level <- as.factor(data_reduced$interest_level)

d <- data_reduced1 %>% 
  group_by(interest_level) %>%
  summarise(median(price))

library(leaflet)
leaflet()%>%addTiles()%>%
  addCircleMarkers(data = data_reduced1, clusterOptions = markerClusterOptions(), ~longitude, ~latitude, 
                   popup = ~paste(longitude, latitude, street_address, sep=' | '))

missing_lat_long <- filter(data_reduced, latitude == 0 | longitude ==0)

logit.overall = multinom(interest_level ~  , data = data_reduced)
summary(logit.overall)
logit.just_price = multinom(interest_level ~ price, data = data_reduced)
summary(logit.just_price)

predict(logit.overall, )


