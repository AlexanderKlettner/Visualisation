library(ggmap)
library(dplyr)

address <- url("http://www.trutschnig.net/RTR2015.RData")
load(address)
#head(RTR2015)
new_df = RTR2015[sample(nrow(RTR2015), 1000), ]
#View(RTR2015)

geocodeQueryCheck(userType = "free")
map1<-get_map(c(lon=14, lat = 47.5),zoom = 6, scale = 1, maptype = "terrain", source = "google")

ggmap(map1)+geom_point(data = new_df, aes(x=longitude,y=latitude, color = nw_cat ))

ggmap(map1, base_layer = ggplot(data = new_df, aes(x=longitude,y=latitude, color = nw_cat )))+geom_point() #normal

ggmap(map1, base_layer = ggplot(data = new_df, aes(x=longitude,y=latitude, color = nw_cat )), 
      extent = "device", legend = "topleft", padding = 0.18)+geom_point() #legend settings

ggmap(map1, base_layer = ggplot(data = new_df, aes(x=longitude,y=latitude, color = nw_cat )), 
      darken = c(0.3, "blue"))+geom_point() #colour settings


qmplot(longitude, latitude, data = new_df, zoom = 6, 
       source = "google", maptype = "roadmap",  color = nw_cat)

?qmplot
