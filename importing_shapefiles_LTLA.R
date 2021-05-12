library(sf)
library(raster)
library(dplyr)
library(spData)


library(tmap)    # for static and interactive maps
library(ggplot2) # tidyverse data visualization package
library(rgdal)
library("png")
library(rgeos)
library(tmap)
#match shapefiles so that they are identical to LTLA regions defined in datasets


#download shape files, store in directory and import here.
#bournemouth, christchurch and poole
shp2 <- shapefile("C:/Users/Owner/Desktop/COVID/COVID_update/geomap/Bournemouth, Christchurch, Poole/Counties_and_Unitary_Authorities_December_2019_Boundaries_UK_BFC.shp")
#wales
shp3 <- shapefile("C:/Users/Owner/Desktop/COVID/COVID_update/geomap/wales/wales_lad_2011.shp")
#cornwall and isles of scilly
shp4 <- shapefile("C:/Users/Owner/Desktop/COVID/COVID_update/geomap/Cornwall and Isles of Scilly/england_healthauth_2001.shp")
#england with removed regions
shp5 <- shapefile("C:/Users/Owner/Desktop/COVID/COVID_update/geomap/england_remove_regions/england_lad_2011.shp")


#the next chuck of code is some simple manipulation so that names of regions and regional cases are alighned to PHE
#select all code and run.
#bind shape files together
shp <- bind(shp2, shp3, shp4)
shp<-shp[-c(25:41),]
shp <- bind(shp, shp5)
#remove unwanted columns
drops <- c("objectid", "ctyua19cd", "ctyua19nmw", "bng_e", "bng_n", "long", "lat", "st_areasha", "st_lengths", "label", "altname", "code")
shp<-shp[ , !(names(shp) %in% drops)]
shp$name[1]<- "Bournemouth, Christchurch and Poole"
drops <- c("ctyua19nm")
shp<-shp[ , !(names(shp) %in% drops)]
names(shp@data) <- "region"
#england with removed regions
shp6 <- shapefile("C:/Users/Owner/Desktop/COVID/COVID_update/geomap/england with combined regions/Local_Authority_Districts__April_2019__UK_BFE_v2.shp")
shp6 <- shp6[order(shp6$LAD19NM),]
shp6<-shp6[-c(1:97),]
shp6<-shp6[-c(2:18),]
shp6<-shp6[-c(3:17),]
shp6<-shp6[-c(4:157),]
shp6<-shp6[-c(5:81),]
shp6<-shp6[-c(6:22),]
#remove unwanted columns
drops <- c("OBJECTID", "LAD19CD", "LAD19NMW", "BNG_E", "BNG_N", "LONG", "LAT", "Shape__Are", "Shape__Len")
shp6<-shp6[ , !(names(shp6) %in% drops)]
names(shp6@data) <- "region"
shp <- bind(shp, shp6)
shp <- shp[order(shp$region),]
shp$region[291]<- "Vale of Glamorgan"
shp$region[185]<- "Newcastle under Lyme"
shp$region[186]<- "Newcastle upon Tyne"
shp<-shp[-319,]
#combined
shp7 <- shapefile("C:/Users/Owner/Desktop/COVID/COVID_update/geomap/combined/combined.shp")
shp7 <- shp7[order(shp7$name),]
shp7<-shp7[-c(1:61),]
shp7<-shp7[-c(2:105),]
names(shp7@data) <- "region"
shp7<-shp7[,-c(2:4)]
shp7<-shp7[,-c(2:10)]
shp <- bind(shp, shp7)
shp <- shp[order(shp$region),]
#shp<-shp[-88,]
shp$region[88]<- "Hackney and City of London"
shp <- shp[order(shp$region),]













############################

#removing walsch regions
shp_england<-shp

#Blaenau Gwent
shp_england$region[23]
#Bridgend
shp_england$region[34]
#Caerphilly
shp_england$region[44]
#Cardiff
shp_england$region[50]
#Carmarthenshire
shp_england$region[52]
#Ceredigion
shp_england$region[55]
#Conwy
shp_england$region[67]
#Denbighshire
shp_england$region[81]
#Flintshire
shp_england$region[109]
#Gwynedd
shp_england$region[121]
#Isle of Anglesey
shp_england$region[146]
#Merthyr Tydfil
shp_england$region[174]
#Monmouthshire
shp_england$region[182]
#Neath Port Talbot
shp_england$region[183]
#Newport
shp_england$region[189]
#Pembrokeshire
shp_england$region[209]
#Powys
shp_england$region[214]
#Rhondda Cynon Taf
shp_england$region[221]
#Swansea
shp_england$region[281]
#Torfaen
shp_england$region[296]
#Vale of Glamorgan
shp_england$region[302]
#Wrexham
shp_england$region[332]


shp_england<-shp_england[-c(23,34,44,50,52,55,67,81,109,121,146,174,182,183,189,209,214,221,281,296,302,332),]
