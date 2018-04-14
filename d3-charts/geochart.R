library(mongolite)
library(ggplot2)

client = mongo(collection = "events", db = "precog_fb_data", url = "mongodb://localhost", verbose=TRUE )

categories = c('travel','food','music','art','education')

category = vector()
longitude = list()
latitude = list()

for(cat in categories){
  temp_cursor = client$find(paste('{"category":"',cat,'"}',sep=""))
  len = length(unlist(temp_cursor$longitude))
  temp_cat = unlist(temp_cursor$category)
  category = c(category,temp_cat[1:len])
  longitude = c(longitude, temp_cursor$longitude)
  print(length(unlist(longitude)))
  latitude = c(latitude, temp_cursor$latitude)
  }
longitude = unlist(longitude)
latitude = unlist(latitude)
geo_data = data.frame(category,longitude,latitude)

setwd('~/fb_event_minor/d3-charts')
write.csv(geo_data, "geo_data.csv")