#creating geomaps
#before you use this code run shape_files_LTLA.r.

#enter reference date in format "YYYY-MM-DD"
ref_date<-as.Date("2021-05-06")
ref_date_1<-as.Date(ref_date)-21
dat<- seq( as.Date(ref_date_1), by=1, len=22)



#import UK_regions. This includes regional information such as population and area at
#lower tier local authority level incluing 337 regions
UK_regions<- rio::import("C:/Users/Owner/Desktop/COVID/Paper_V3/data/UK_regions.xlsx")


#download data using API from Public Health England
#this will import all case data at LTLA over the entire pandemic

library(httr)

#' Extracts paginated data by requesting all of the pages
#' and combining the results.
#'
#' @param filters    API filters. See the API documentations for 
#'                   additional information.
#'                   
#' @param structure  Structure parameter. See the API documentations 
#'                   for additional information.
#'                   
#' @return list      Comprehensive list of dictionaries containing all 
#'                   the data for the given ``filter`` and ``structure`.`
get_paginated_data <- function (filters, structure) {
  
  endpoint     <- "https://api.coronavirus.data.gov.uk/v1/data"
  results      <- list()
  current_page <- 1
  
  repeat {
    
    httr::GET(
      url   = endpoint,
      query = list(
        filters   = paste(filters, collapse = ";"),
        structure = jsonlite::toJSON(structure, auto_unbox = TRUE),
        page      = current_page
      ),
      timeout(10)
    ) -> response
    
    # Handle errors:
    if ( response$status_code >= 400 ) {
      err_msg = httr::http_status(response)
      stop(err_msg)
    } else if ( response$status_code == 204 ) {
      break
    }
    
    # Convert response from binary to JSON:
    json_text <- content(response, "text")
    dt        <- jsonlite::fromJSON(json_text)
    results   <- rbind(results, dt$data)
    
    if ( is.null( dt$pagination$`next` ) ){
      break
    }
    
    current_page <- current_page + 1;
    
  }
  
  return(results)
  
}


# Create filters:
query_filters <- c(
  "areaType=LTLA"
)


# Create the structure as a list or a list of lists:
query_structure <- list(
  date       = "date", 
  name       = "areaName", 
  code       = "areaCode", 
  daily      = "newCasesBySpecimenDate",
  cumulative = "cumCasesBySpecimenDate"
)


result <- get_paginated_data(query_filters, query_structure)

list(
  "Shape"                = dim(result),
  "Data (first 3 items)" = result[0:3, 0:-1]
) -> report

#print(report)




#format all UK cases
library(plyr)



#uk daily cases (empty for now)
output <- matrix(ncol=22, nrow=337)


#formatting -alligning regions with daily cases looking at reference date and 21 days beforehand.
for(i in 1:length(dat)){
  
  
  data<-result
  dates<-as.Date(data$date)
  
  data<-data.frame(dates, result$name, result$code, result$daily)
             
  data<-subset(data, data$date==dat[i])               
  colnames(data)[2]<-"Area name"
  
  UK_regions<- rio::import("C:/Users/Owner/Desktop/COVID/paper_V3/data/UK_regions.xlsx")
  
  
  p<-merge(UK_regions, data, by="Area name",all.x=TRUE)
  
  p <- replace(p$result.daily, is.na(p$result.daily),0)
  
  
  output[,i]<-p
  
}
#a<-output
output <- data.frame(output)



#change the column names to the date
colnames(output)<-dat



#add columns of regional information (inc population and area) to output1
output1<-cbind(UK_regions, output)



#daily data
daily_cases<-output1


#reference date
colnames(daily_cases)[25]

#empty vector ready for number of day since the last case
number_days<- data.frame(col=integer(337))

#search for number of days until last case and store in the vector number_days
for(i in 1:337){
  
  if(daily_cases[i,25-1]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0 && daily_cases[i,25-5]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0 && daily_cases[i,25-5]==0 && daily_cases[i,25-6]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0 && daily_cases[i,25-5]==0 && daily_cases[i,25-6]==0 && daily_cases[i,25-7]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0 && daily_cases[i,25-5]==0 && daily_cases[i,25-6]==0 && daily_cases[i,25-7]==0 && daily_cases[i,25-8]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0 && daily_cases[i,25-5]==0 && daily_cases[i,25-6]==0 && daily_cases[i,25-7]==0 && daily_cases[i,25-8]==0 && daily_cases[i,25-9]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0 && daily_cases[i,25-5]==0 && daily_cases[i,25-6]==0 && daily_cases[i,25-7]==0 && daily_cases[i,25-8]==0 && daily_cases[i,25-9]==0 && daily_cases[i,25-10]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0 && daily_cases[i,25-5]==0 && daily_cases[i,25-6]==0 && daily_cases[i,25-7]==0 && daily_cases[i,25-8]==0 && daily_cases[i,25-9]==0 && daily_cases[i,25-10]==0 && daily_cases[i,25-11]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0 && daily_cases[i,25-5]==0 && daily_cases[i,25-6]==0 && daily_cases[i,25-7]==0 && daily_cases[i,25-8]==0 && daily_cases[i,25-9]==0 && daily_cases[i,25-10]==0 && daily_cases[i,25-11]==0 && daily_cases[i,25-12]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0 && daily_cases[i,25-5]==0 && daily_cases[i,25-6]==0 && daily_cases[i,25-7]==0 && daily_cases[i,25-8]==0 && daily_cases[i,25-9]==0 && daily_cases[i,25-10]==0 && daily_cases[i,25-11]==0 && daily_cases[i,25-12]==0 && daily_cases[i,25-13]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0 && daily_cases[i,25-5]==0 && daily_cases[i,25-6]==0 && daily_cases[i,25-7]==0 && daily_cases[i,25-8]==0 && daily_cases[i,25-9]==0 && daily_cases[i,25-10]==0 && daily_cases[i,25-11]==0 && daily_cases[i,25-12]==0 && daily_cases[i,25-13]==0 && daily_cases[i,25-14]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0 && daily_cases[i,25-5]==0 && daily_cases[i,25-6]==0 && daily_cases[i,25-7]==0 && daily_cases[i,25-8]==0 && daily_cases[i,25-9]==0 && daily_cases[i,25-10]==0 && daily_cases[i,25-11]==0 && daily_cases[i,25-12]==0 && daily_cases[i,25-13]==0 && daily_cases[i,25-14]==0 && daily_cases[i,25-15]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0 && daily_cases[i,25-5]==0 && daily_cases[i,25-6]==0 && daily_cases[i,25-7]==0 && daily_cases[i,25-8]==0 && daily_cases[i,25-9]==0 && daily_cases[i,25-10]==0 && daily_cases[i,25-11]==0 && daily_cases[i,25-12]==0 && daily_cases[i,25-13]==0 && daily_cases[i,25-14]==0 && daily_cases[i,25-15]==0 && daily_cases[i,25-16]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0 && daily_cases[i,25-5]==0 && daily_cases[i,25-6]==0 && daily_cases[i,25-7]==0 && daily_cases[i,25-8]==0 && daily_cases[i,25-9]==0 && daily_cases[i,25-10]==0 && daily_cases[i,25-11]==0 && daily_cases[i,25-12]==0 && daily_cases[i,25-13]==0 && daily_cases[i,25-14]==0 && daily_cases[i,25-15]==0 && daily_cases[i,25-16]==0 && daily_cases[i,25-17]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0 && daily_cases[i,25-5]==0 && daily_cases[i,25-6]==0 && daily_cases[i,25-7]==0 && daily_cases[i,25-8]==0 && daily_cases[i,25-9]==0 && daily_cases[i,25-10]==0 && daily_cases[i,25-11]==0 && daily_cases[i,25-12]==0 && daily_cases[i,25-13]==0 && daily_cases[i,25-14]==0 && daily_cases[i,25-15]==0 && daily_cases[i,25-16]==0 && daily_cases[i,25-17]==0 && daily_cases[i,25-18]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0 && daily_cases[i,25-5]==0 && daily_cases[i,25-6]==0 && daily_cases[i,25-7]==0 && daily_cases[i,25-8]==0 && daily_cases[i,25-9]==0 && daily_cases[i,25-10]==0 && daily_cases[i,25-11]==0 && daily_cases[i,25-12]==0 && daily_cases[i,25-13]==0 && daily_cases[i,25-14]==0 && daily_cases[i,25-15]==0 && daily_cases[i,25-16]==0 && daily_cases[i,25-17]==0 && daily_cases[i,25-18]==0 && daily_cases[i,25-19]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0 && daily_cases[i,25-5]==0 && daily_cases[i,25-6]==0 && daily_cases[i,25-7]==0 && daily_cases[i,25-8]==0 && daily_cases[i,25-9]==0 && daily_cases[i,25-10]==0 && daily_cases[i,25-11]==0 && daily_cases[i,25-12]==0 && daily_cases[i,25-13]==0 && daily_cases[i,25-14]==0 && daily_cases[i,25-15]==0 && daily_cases[i,25-16]==0 && daily_cases[i,25-17]==0 && daily_cases[i,25-18]==0 && daily_cases[i,25-19]==0 && daily_cases[i,25-20]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
  if(daily_cases[i,25-1]==0 && daily_cases[i,25-2]==0 && daily_cases[i,25-3]==0 && daily_cases[i,25-4]==0 && daily_cases[i,25-5]==0 && daily_cases[i,25-6]==0 && daily_cases[i,25-7]==0 && daily_cases[i,25-8]==0 && daily_cases[i,25-9]==0 && daily_cases[i,25-10]==0 && daily_cases[i,25-11]==0 && daily_cases[i,25-12]==0 && daily_cases[i,25-13]==0 && daily_cases[i,25-14]==0 && daily_cases[i,25-15]==0 && daily_cases[i,25-16]==0 && daily_cases[i,25-17]==0 && daily_cases[i,25-18]==0 && daily_cases[i,25-19]==0 && daily_cases[i,25-20]==0 && daily_cases[i,25-21]==0){
    
    number_days[i,1]<-number_days[i,1]+1
  }
}


#checking (optional)
head(daily_cases[23:25])
head(number_days)



#shp are shapefile obtained using script file shape_files_LTLA. It contains
# 337 regions at LTLA level. Run this code before continuing.


#add column of number of cases since at least one case to shp
shp$"Days since the most recent case"<-number_days[,1]


#geomap results
tm_shape(shp) +
  tm_polygons(col="Days since the most recent case",n=21,breaks=c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21),labels=c("0","1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21"),palette=c("#FF0000", "#FF3300", "#FF6600", "#FF9900", "#FFFF00", "#FFFF33", "#FFFF66", "#FFFF99", "#FFFFCC", "#CCFFFF", "#99FFFF", "#66FFFF", "#33FFFF", "#00FFFF", "#66CCFF", "#3399FF", "#0066CC", "#003399", "#0000FF", "#0000CC", "#000099"))+
  tm_layout(legend.outside = TRUE, main.title = paste(ref_date))+
  tm_borders(lwd=0.5)
  
  






