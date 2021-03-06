#load packages
library(ggmap)
library(dplyr)

#get data
address <- url("http://www.trutschnig.net/RTR2015.RData")
load(address)
#head(RTR2015)
new_df = RTR2015[sample(nrow(RTR2015), 1000), ]
#View(RTR2015)


#============get_map & ggmap============

#======function for get_map() to avoid geocodeQueryCheck()======
tryMap <- function(target, i=0) {
  
  map1 = tryCatch({
    get_map("Rome", zoom=10, scale=1, maptype="terrain", source="google") #change parameters
  },
  warning = function(w) {
    print(w)
    if(i < 5) {
      Sys.sleep(1)
      tryMap(target, i+1)
    }
    else {
      print("Timed out")
    }
  })
}

map1 <- tryMap()
ggmap(map1)


#get_map
geocodeQueryCheck(userType = "free") #so you have access to google maps 2500 times a day
map1<-get_map("Salzburg", zoom = 6, scale = 1, maptype = "terrain", source = "google")

ggmap(map1)+geom_point(data = new_df, aes(x=longitude,y=latitude, color = nw_cat ))

ggmap(map1, base_layer = ggplot(data = new_df, aes(x=longitude,y=latitude, color = nw_cat )))+geom_point() #normal

ggmap(map1, base_layer = ggplot(data = new_df, aes(x=longitude,y=latitude, color = nw_cat )), 
      extent = "device", legend = "topleft", padding = 0.08)+geom_point() #legend settings

ggmap(map1, base_layer = ggplot(data = new_df, aes(x=longitude,y=latitude, color = nw_cat )), 
      darken = c(0.3, "blue"))+geom_point() #colour settings


#============qmplot============
qmplot(longitude, latitude, data = new_df, zoom = 6, 
       source = "google", maptype = "roadmap",  color = nw_cat)


#============Exercise 1, Solution============
crime = crime[sample(nrow(crime), 1000), ]

geocodeQueryCheck(userType = "free")
houston <- get_map(location = "Houston", zoom = 10, scale = 2, source = "google", maptype = "roadmap")

ggmap(houston, base_layer = ggplot(data = crime, aes(x = lon, y = lat, color = offense)))+geom_point()


#============useful functions============
#geocode
geocodeQueryCheck(userType = "free")
x1 = geocode(c("Kapitelgasse 4, 5020 Salzburg", "Hellbrunnerstrasse 34, 5020 Salzburg"), output = "latlona")
x1

#revgeocode, geocode reverse
x1Num_Kapit4 = as.numeric(x1[1,1:2])
revgeocode(x1Num_Kapit4)

#======function for mapdist() to avoid distQueryCheck()======
tryDist <- function(target, i=0) {
  
  map1 = tryCatch({
    mapdist("Kapitelgasse 4, 5020 Salzburg", "Hellbrunnerstrasse 34, 5020 Salzburg", mode = "driving") #change parameters
  },
  warning = function(w) {
    print(w)
    if(i < 5) {
      Sys.sleep(1)
      tryMap(target, i+1)
    }
    else {
      print("Timed out")
    }
  })
}

distance <- tryDist()
distance


#mapdist
distQueryCheck()
mapdist("Kapitelgasse 4, 5020 Salzburg", "Hellbrunnerstrasse 34, 5020 Salzburg", mode = "driving")

from <- c("Hauptbahnhof, 5020 Salzburg", "Hellbrunnerstrasse 34, 5020 Salzburg")
to <- c("Mirabellplatz, 5020 Salzburg", "Kapitelgasse 4, 5020 Salzburg")
mapdist(from, to)


#======function for route() to avoid distQueryCheck()======
tryRoute <- function(target, i=0) {
  
  map1 = tryCatch({
    route("Kapitelgasse 4, 5020 Salzburg","Hellbrunnerstrasse 34, 5020 Salzburg", mode = "walking", 
          structure = "route", alternatives = FALSE) #change parameters
  },
  warning = function(w) {
    print(w)
    if(i < 5) {
      Sys.sleep(1)
      tryMap(target, i+1)
    }
    else {
      print("Timed out")
    }
  })
}

route_df0 <- tryRoute()
route_df0


#route
routeQueryCheck()
route_df <- route("Kapitelgasse 4, 5020 Salzburg","Hellbrunnerstrasse 34, 5020 Salzburg", mode = "walking", 
                  structure = "route", alternatives = FALSE)

#get Salzburg
geocodeQueryCheck(userType = "free")
Salzburg <- get_map("Salzburg", zoom = 13, scale = 2) #get_map

#mapping
p = ggmap(Salzburg) + #Salzburg = Objekt from get_map
  geom_point(data=x1,aes(x=lon, y=lat),color = 'red', size = 3) +
  geom_line(data=x1,aes(x=lon, y=lat),color = 'blue', size = 1.4)+
  scale_x_continuous(limits = c(13.045,13.065), expand = c(0,0))+
  scale_y_continuous(limits = c(47.785,47.8), expand = c(0,0))
p

p1 = ggmap(Salzburg) +
  geom_path(data = route_df, aes(x=lon,y=lat), color = "green", size = 1.8,  lineend = "round")+
  scale_x_continuous(limits = c(13.045,13.065), expand = c(0,0))+
  scale_y_continuous(limits = c(47.785,47.8), expand = c(0,0))
p1


#============Exercise 2, Solution============
route_df1 <- route("Prater Wien", "Stephansdom Wien", mode = "bicycling", 
                   structure = "route", alternatives = FALSE)
routeQueryCheck()

#get Wien
geocodeQueryCheck(userType = "free")
Wien <- get_map("Wien", zoom = 13, scale = 2) #get_map
ggmap(Wien)

p2 = ggmap(Wien, extent = "panel")+
  geom_path(data = route_df1, aes(x=lon, y=lat), color = "green", size = 1.8,  lineend = "round")+
  scale_x_continuous(limits = c(16.36, 16.41))+
  scale_y_continuous(limits = c(48.20, 48.22))
p2

mapdist("Prater Wien", "Stephansdom Wien", mode = "bicycling", output = "simple")


#============leaflet============
install.packages("leaflet")
library(leaflet)

m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
m

#============Exercise 3, Solution============
# Basic option
map_0 <- leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(lng=new_df$longitude, lat=new_df$latitude, color = new_df$nw_cat, popup = new_df$device)
map_0

# Advanced option
factpal <- colorFactor(c("magenta", "blue", "pink"), new_df$nw_cat)
map <- leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(lng=new_df$longitude, lat=new_df$latitude,radius = 4, color=factpal(new_df$nw_cat), stroke = F,fillOpacity = 1,popup=paste0("Device: ", new_df$device, "<br> Operator: ", new_df$op_name, "<br> Plattform: ", new_df$device_platform)) %>%  
  addLegend("bottomright", pal = factpal, values = new_df$nw_cat, opacity = 1)
map

#export map to html
install.packages("htmlwidgets")
htmlwidgets::saveWidget(map, file="test.html")



# Alternative option (f�r Interessierte)
leaflet() %>% addProviderTiles(providers$OpenStreetMap.DE) %>% addMarkers(lng = new_df$longitude, lat = new_df$latitude, popup = paste0(new_df$device))

#Kartentypen f�r addProviderTiles
#http://leaflet-extras.github.io/leaflet-providers/preview/
