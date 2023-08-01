library(maps)
library(maptools)
library(terra)

world <- maps::map("world", fill = TRUE, plot = FALSE)
world_map <- map2SpatialPolygons(world, sub(":.*$", "", world$names))
world_map <- SpatialPolygonsDataFrame(world_map,
                                      data.frame(country = names(world_map), 
                                                 stringsAsFactors = FALSE), 
                                      FALSE)

world_map <- terra::vect(world_map)

crs(world_map)  <- "epsg:4326"
writeVector(world_map, "data/world_map.shp", overwrite=TRUE)
