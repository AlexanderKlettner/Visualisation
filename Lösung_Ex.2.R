route_df1 <- route("Prater Wien", "Stephansdom Wien", mode = "bicycling", 
                   structure = "route", alternatives = FALSE)
routeQueryCheck()

#get Wien
Wien <- get_map("Wien", zoom = 13, scale = 2) #get_map
ggmap(Wien)
geocodeQueryCheck(userType = "free")

p2 = ggmap(Wien, extent = "panel")+
  geom_path(data = route_df1, aes(x=lon, y=lat), color = "green", size = 1.8,  lineend = "round")+
  scale_x_continuous(limits = c(16.36, 16.41))+
  scale_y_continuous(limits = c(48.20, 48.22))
p2