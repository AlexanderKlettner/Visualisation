
#Drei Wege location zu spezifizieren:
#1 center of the map "c(lon=14, lat = 47.5)"
get_map(c(lon=14, lat = 47.5),zoom = 6, scale = 1, maptype = "terrain") #Österreich

#2 name of location
geocode("the white house") #lon/lat für das weiße Haus
get_map(location = "Salzburg", zoom = 13, scale = 2)

#Unter-/Obergrenze der Karte
get_map(location = c(left = 12, bottom = 47.5, right = 14, top = 48), maptype = "roadmap")


#-------------------------------------------------------------------------

#get-map function:
#get_map is a wrapper function for the underlying functions: get_googlemap, get_stamenmap, get_cloudmademap, get_openstreetmap

k1 = get_map(c(lon=14, lat = 47.5),zoom = 6, scale = 1, source = "google", maptype = "terrain")
ggmap(k1)

#options:
#scale: Anzahl der pixel: 1 = 680x680, 2 = 1280x1280
#zoom: between 3 and ~21 (3 = continent, 10=city, 21=building)
#source:  #GoogleMaps: get_googlemap (source = "google")
          #Stamen Maps: get_stamenmap (source = "stamen")
          #CloudmadeMaps: get_cloudmademap (source = "cloudmade") -> Karten konnten individuell erstellt werden, aber Company shutdown
          #OpenStreetMaps: get_openstreetmap (source = "osm")
#maptype: according to source

#The result of get_map is a specially classed raster object (article S.5)
    #(a matrix of colors as hexadecimal character strings, output: chr [1:1280, 1:1280] "#C6DAB6" "#C2D6B3" "#C2D6B3")

#-------------------------------------------------------------------------

#ggmap function
#Karte ploten:
ggmap(k1)

#extent
#base_layer
#maprange
#legend
#padding
#darken


ggplot(aes(x=lon, y=lat), data=fourCorners) +
  geom_blank() + coord_map("mercator") +
  annotation_raster(ggmap,
                    xmin, xmax, ymin, ymax)


