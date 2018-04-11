library(ggmap)
library(ggplot2)
library(dplyr)

A<-read.table("http://www.trutschnig.net/Datensatz.txt",head=TRUE)
summary(A)
View(A)

address <- url("http://www.trutschnig.net/RTR2015.RData")
load(address)
head(RTR2015)
View(RTR2015)


map1<-get_map(c(lon=14, lat = 47.5),zoom = 6, scale = 1, maptype = "terrain")

ggmap(map1)+geom_point(data = RTR2015, aes(x=longitude,y=latitude, color = nw_cat ))#, size = rtr_speed_dl-rtr_speed_ul))

ggmap(map1, base_layer = ggplot(data = RTR2015, aes(x=longitude,y=latitude, color = nw_cat )))+
        geom_point()

qmplot(longitude, latitude, data = RTR2015, geom = "point", color = nw_cat)

qmplot(longitude, latitude, data = RTR2015, geom = "point", color = nw_cat, maptype = c("terrain-background"))
?qmplot
