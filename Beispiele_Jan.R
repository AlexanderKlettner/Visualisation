library(ggmap)
library(dplyr)


#geocode
x1 = geocode(c("Kapitelgasse 4, 5020 Salzburg", "Hellbrunnerstrasse 34, 5020 Salzburg"), output = "latlona")
geocodeQueryCheck(userType = "free") # so you can use geocode about 2500 times a day

#revgeocode, geocode reverse
x1Num_Kapit4 = as.numeric(x1[1,])
revgeocode(x1Num_Kapit4)

#route
route_df <- route("Kapitelgasse 4, 5020 Salzburg","Hellbrunnerstrasse 34, 5020 Salzburg", mode = "bicycling", 
                  structure = "route", alternatives = FALSE)
routeQueryCheck()


#get Salzburg
Salzburg <- get_map("Salzburg", zoom = 13,scale = 1) #get_map
geocodeQueryCheck(userType = "free")

#mapping
p = ggmap(Salzburg, extent = "panel") + #Salzburg = Objekt from get_map
      geom_point(data=x1,aes(x=lon, y=lat),color = 'red', size = 3) +
      geom_line(data=x1,aes(x=lon, y=lat),color = 'blue', size = 1.4)+
      scale_x_continuous(limits = c(13.045,13.065), expand = c(0,0))+
      scale_y_continuous(limits = c(47.785,47.8), expand = c(0,0))
p

p1 = ggmap(Salzburg, extent = "panel") +
      geom_path(data = route_df, aes(x=lon,y=lat), color = "green", size = 1.8,  lineend = "round")+
      scale_x_continuous(limits = c(13.045,13.065), expand = c(0,0))+
      scale_y_continuous(limits = c(47.785,47.8), expand = c(0,0))
p1


#distance, duration
mapdist("Kapitelgasse 2, 5020 Salzburg", "Hellbrunnerstrasse 34, 5020 Salzburg")

from <- c("Hauptbahnhof, 5020 Salzburg", "Hellbrunnerstrasse 34, 5020 Salzburg")
to <- c("Mirabellplatz, 5020 Salzburg", "Kapitelgasse 4, 5020 Salzburg")
mapdist(from, to)

distQueryCheck()


#ggmap Erklärung.......
#qmplot Erklärung.........





#Idee: Darstellung von Trutschnigs Messpunkten
#weitere Punkte erhalten wir mit ggmap::geocode...

#install.packages("devtools", dependencies= TRUE)
#devtools::install_github("rstudio/leaflet")

install.packages("leaflet")
library(leaflet)

orte = c("Haunspergstrasse 88, 5020 Salzburg","Kapitelgasse 4, 5020 Salzburg","Hellbrunnerstrasse 34, 5020 Salzburg")
df = data.frame(orte, x1)

address <- url("http://www.trutschnig.net/RTR2015.RData")
load(address)
head(RTR2015)
str(RTR2015)
new_df = RTR2015[sample(nrow(RTR2015), 1000), ]

leaflet(x1) %>% addTiles() %>% addMarkers()
leaflet(df) %>% addProviderTiles(providers$OpenStreetMap.DE) %>% addMarkers(lng = df$lon, lat = df$lat, popup=df$orte)
leaflet(new_df) %>% addProviderTiles(providers$OpenStreetMap.DE) %>% addMarkers(lng = new_df$longitude, lat = new_df$latitude, popup=paste0(new_df$device, " - ", new_df$op_name))
 
#Kartentypen für addProviderTiles
#http://leaflet-extras.github.io/leaflet-providers/preview/
