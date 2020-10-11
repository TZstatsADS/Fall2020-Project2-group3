#####################################################################################################################################################################library(shiny)
library(shinydashboard)
library(leaflet)
library(maps)
library(tidyverse)
library(viridis)
library(leaflet.extras)
library(RColorBrewer)
library(ggplot2)
library(plotly)
library(scales)
library(dplyr)
library(shinyWidgets)
library(shinydashboardPlus)
library(lubridate)
library(DT)
#####################################################################################################################################################################
whole_data <- read.csv("~/Documents/5243/Fall2020-Project2-group3/output/whole.csv")

merge_data <- read_csv("~/Documents/5243/Fall2020-Project2-group3/output/full_data.csv")
merge_data$spend_all_inclow[merge_data$spend_all_inclow=="."]<-"0"
merge_data$revenue_ss60[merge_data$revenue_ss60=="."]<-"0"
merge_data$merchants_ss60[merge_data$merchants_ss60=="."]<-"0"
merge_data <- merge_data%>%mutate(Name = str_to_upper(Province_State),date=as.Date(merge_data$date, format = "%m/%d/%y"),spend_all_inclow=as.double(spend_all_inclow),merchants_ss60=as.double(merchants_ss60),revenue_ss60=as.double(revenue_ss60))%>%mutate(mth=months(date))
colnames(merge_data)[7:15] <- c("% Change in Accomodation and Food Service",
                                "% Change in Arts, Entertainment, and Recreation",
                                "% Change in All Merchant Categories",
                                "% Change in General Merchandise Stores",
                                "% Change in Grocery and Food Store",
                                "% Change in Health Care and Social Assistance ",
                                "% Change in High income people",
                                "% Change in Median income people",
                                "% Change in Low income people")

colnames(merge_data)[16:20] <- c("% Change in All Small Businesses Open",
                                 "% Change in Transportation Open",
                                 "% Change in Professional and Business Services Open",
                                 "% Change in Education and Health Services Open",
                                 "% Change in Leisure and Hospitality Open")

colnames(merge_data)[21:25] <- c("% Change in All Small Businesses Revenue",
                                 "% Change in Transportation Revenue",
                                 "% Change in Professional and Business Services Revenue",
                                 "% Change in Education and Health Services Revenue",
                                 "% Change in Leisure and Hospitality Revenue")

#####################################################################################################################################################################
# Data load for map
ST<-c("alabama","arizona","arkansas","california","colorado","connecticut","delaware","florida" ,"georgia","idaho","illinois","indiana","iowa","kansas","kentucky","louisiana","maine","maryland","massachusetts","michigan","minnesota","mississippi","missouri","montana","nebraska","nevada","new hampshire","new jersey","new mexico","New York","north carolina","north dakota","ohio","oklahoma","oregon","pennsylvania","rhode island","south carolina", "south dakota","tennessee","texas","utah","vermont","virginia","washington","west virginia","wisconsin","wyoming")
mapStates = maps::map("state",ST,fill = TRUE, plot = FALSE)
names <-tibble(Name=str_to_upper(mapStates$names)) %>% 
  separate(Name, c('Name', 'sub'), ':') %>% 
  select(Name)

#####################################################################################################################################################################
business_map <- function(map_data, labels,pal){
  pal <- colorBin("Blues", domain = map_data$Value)
  leaflet(data = mapStates) %>%  
    setView(-96, 37.8, 4.3) %>%
    addTiles() %>%
    addResetMapButton() %>% addPolygons(fillColor = pal(map_data$Value),
                                        weight = 2,
                                        opacity = 1,
                                        color='white',
                                        dashArray = 3,
                                        fillOpacity = .7,
                                        highlightOptions = highlightOptions(weight = 4,
                                                                            color = "#666",
                                                                            dashArray = "",
                                                                            fillOpacity = .75,
                                                                            bringToFront = T
                                        ),  label = labels,labelOptions = labelOptions(style = list("font-weight" = "normal", 'padding' = "10px 15px"),
                                                                                       textsize = "15px",
                                                                                       direction = "auto"))%>%addLegend(pal = pal,
                                                                                                                        values = map_data$Value,
                                                                                                                        opacity = 0.85,
                                                                                                                        title = NULL,
                                                                                                                        position = "bottomright")}
###############################################################################################################
#covid
covid19 <- read.csv("~/Documents/5243/Fall2020-Project2-group3/output/covid19.csv")
covid19 <- covid19[,-1]
covid19 <- covid19%>%mutate(date=as.Date(date))
covid19[is.na(covid19)] <- 0

covid_map <- function(map_data, labels, pal){
  pal <- colorBin("Reds", domain = map_data$Value)
  leaflet(data = mapStates) %>%  
    setView(-96, 37.8, 4.3) %>%
    addTiles() %>%
    addResetMapButton() %>% addPolygons(fillColor = pal(map_data$Value),
                                        weight = 2,
                                        opacity = 1,
                                        color='white',
                                        dashArray = 3,
                                        fillOpacity = .7,
                                        highlightOptions = highlightOptions(weight = 4,
                                                                            color = "#666",
                                                                            dashArray = "",
                                                                            fillOpacity = .75,
                                                                            bringToFront = T
                                        ),  label = labels,labelOptions = labelOptions(style = list("font-weight" = "normal", 'padding' = "10px 15px"),
                                                                                       textsize = "15px",
                                                                                       direction = "auto"))%>%addLegend(pal = pal,
                                                                                                                        values = map_data$Value,
                                                                                                                        opacity = 0.85,
                                                                                                                        title = NULL,
                                                                                                                        position = "bottomright")}

