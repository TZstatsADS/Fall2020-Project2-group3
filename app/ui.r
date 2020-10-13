packages.used <- c("shinydashboard","leaflet", "maps", "viridis", "DT", "stringr", "dplyr", "tidyverse", "tibble",
                   "leaflet.extras", "RColorBrewer", "ggplot2", "plotly", "scales", "shinyWidgets", "shinydashboardPlus",
                   "lubridate", "shinyalert")
# check packages that need to be installed.
packages.needed <- setdiff(packages.used, 
                           intersect(installed.packages()[,1], 
                                     packages.used))
# install additional packages
if(length(packages.needed) > 0){
  install.packages(packages.needed, dependencies = TRUE)
}

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
library(tibble)
library(stringr)
library(shinyalert)
source("global.r")
# Header
header <- dashboardHeader(title='Covid 19 Group 3')

#####################################################################################################################################################################
# Sidebar
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Home', 
             tabName = 'Home', 
             icon = icon('home')
    ), 
    menuItem('Maps', 
             tabName='map', 
             icon = icon("map"), 
             menuSubItem('Business Map', 
                         tabName = 'business_map'
             ),
             menuSubItem('Covid Map', 
                         tabName = 'covid_map'
             )
    ),
    menuItem('Analyze a State', 
             tabName = 'stats', 
             icon = icon("chart-line"), 
             menuSubItem('Business', 
                         tabName = 'business_trend'
             ),
             menuSubItem('Covid-19', 
                         tabName = 'covid_trend'
             ) 
    ),  
    menuItem("Information Searching", tabName = "tabcb", icon = icon("clipboard")),
    menuItem('Reference', 
             tabName = 'ref', 
             icon = icon('ad')
    )
  )
)

#####################################################################################################################################################################

# Body 
body <- dashboardBody(fill = FALSE,
                      tags$head(
                        tags$style(
                          type="text/css",
                          ".shiny-output-error { visibility: hidden; }",
                          ".shiny-output-error:before { visibility: hidden; }", 
                          HTML('h1 {font-weight: bold; 
                font-family: impact}',
                               'h3 {font-style: italic;}',
                               # header color 
                               '.skin-black .main-header .navbar { background-color: #261c1c;}',
                               '.skin-black .main-header .navbar>.sidebar-toggle {color: white}', 
                               '.skin-black .main-header>.logo:hover {background-color: black;}', 
                               
                               '.skin-black .main-header>.logo {background-color: #261c1c; color: white;}', 
                               
                               
                               '.skin-black .main-sidebar {color:white; background-color: black;}',
                               
                               # change menu color 
                               '.skin-black .main-sidebar .sidebar-menu {background-color: black;}',
                               '.skin-black .main-sidebar .treeview{background-color: black;}',
                               
                               #flat menu color
                               '.skin-black .sidebar-menu>li>.treeview-menu {color: black; background-color: black;}',
                               
                               '.skin-black .sidebar-menu>li:hover>a {color: black; background-color: white;}'
                          )
                        )
                      ),
                      # Home
                      tabItems(
                        tabItem(tabName='Home',
                                fluidRow(
                                  valueBoxOutput("max_confirm"),
                                  valueBoxOutput("max_death"),
                                  valueBoxOutput("max_recover"),
                                  valueBoxOutput("max_incident"),
                                  valueBoxOutput("max_test"),
                                  valueBoxOutput("max_hosptial")
                                ),
                        ),
                        # States map
                        tabItem(tabName = 'business_map', 
                                fluidPage(
                                  tabBox(id=' ', width = 22, title=" ",
                                         tabPanel("Month",
                                                  leafletOutput('stmaps', width="100%",height=750),
                                                  
                                                  absolutePanel(id = "control", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                                                top = 260, left = "auto", right = "auto", bottom = "auto", width = 200, height = "auto",
                                                                
                                                                box(status='info', width=12,
                                                                    selectInput(inputId = 'basic_metric_month', 
                                                                                label = 'Metrics', 
                                                                                choices = c('Affinity','Merchants','Revenue'),
                                                                                selected = 'Affinity'
                                                                    ), 
                                                                    br(),
                                                                    selectInput(inputId = 'metric_month', 
                                                                                label = 'Category',
                                                                                choices = c('spend_acf')
                                                                    ),
                                                                    br(),
                                                                    selectInput(inputId = 'month',
                                                                                label = 'Month',
                                                                                choices = c('January', "February", 'March', 'April', 'May', 
                                                                                            'June', 'July', 'August', 'September'),
                                                                                selected = 'January'
                                                                    ),
                                                                    uiOutput('moreControls')
                                                                ))),tabPanel("Date",
                                                                             leafletOutput('stmaps_1', width="100%",height=750),
                                                                             
                                                                             absolutePanel(id = "control", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                                                                           top = 260, left = "auto", right = "auto", bottom = "auto", width = 200, height = "auto",
                                                                                           
                                                                                           box(status='info', width=12,
                                                                                               selectInput(inputId = 'basic_metric_date', 
                                                                                                           label = 'Metrics', 
                                                                                                           choices = c('Affinity','Merchants','Revenue'),
                                                                                                           selected = 'Affinity'
                                                                                               ), 
                                                                                               br(),
                                                                                               selectInput(inputId = 'metric_date', 
                                                                                                           label = 'Category',
                                                                                                           choices = c('spend_acf')
                                                                                               ),
                                                                                               br(),
                                                                                               dateInput("date", "Date:", value = "2020-01-22",min = "2020-01-22", max = "2020-09-20")
                                                                                           )
                                                                             ))))
                        ),
                        # Covid map
                        tabItem(tabName = 'covid_map',
                                fluidPage(
                                  tabBox(id='', width = 22, title=" ",
                                  tabPanel("Pandemic in US",
                                           leafletOutput('covidmaps', width="100%",height=750),
                                           absolutePanel(id = "covidid", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                                         top = 260, left = "auto", right = "auto", bottom = "auto", width = 250, height = "auto",
                                                         box(status='info', width=100,
                                                             selectInput(inputId = 'var', 
                                                                         label = 'Case Type', 
                                                                         choices = c('Changes of Confirmed Cases','Changes of Death Cases', 'Changes of Active Cases', 
                                                                                     'Changes of Recovered Cases',
                                                                                     'Mean Incident Rate', 'Mean Testing Rate', 'Mean Hospitalization Rate'),
                                                                         selected = 'Changes of Confirmed Cases'
                                                             ), 
                                                             dateRangeInput(inputId = 'date_range', 
                                                                            label = 'Select Date Range',
                                                                            start = '2020-01-22', 
                                                                            end = '2020-09-20',
                                                                            min = '2020-01-22', 
                                                                            max = '2020-09-20'),
                                                             textOutput("DateRange"),
                                                             uiOutput('moreControls_1')
                                                         ))))
                                 
                                  
                                )
                        ),
                        # Business Trend
                        tabItem(tabName="business_trend",
                                fluidRow(
                                  
                                  box(h3(strong('The Business Trend Map')), width=9, status='primary',plotlyOutput("business_trend", width="100%", height=650)),
                                  # absolutePanel(id = "control", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                  #             top = 260, left = "auto", right = "auto", bottom = "auto", width = 200, height = "auto",
                                  
                                  box(width = 3, status='info',
                                      selectInput("busi_state", "State:",
                                                  choices = names$Name, 
                                                  selected = names$Name[1]),
                                      br(),
                                      selectInput("busi_metric_1", "Metric", 
                                                  choices = colnames(merge_data)[c(7:25)],
                                                  selected = "% Change in Accomodation and Food Service"),
                                      br(),
                                      selectInput("busi_metric_2", "Metric", 
                                                  choices = colnames(merge_data)[c(7:25)],
                                                  selected = "% Change in Arts, Entertainment, and Recreation"))
                                  #)
                                ) 
                        ),
                        # Covid Trend
                        tabItem(tabName="covid_trend",
                                fluidRow(
                                  box(h3(strong('The Covid Trend Map')), width=9, status='primary',plotlyOutput("covid_trend", width="90%", height=650)),
                                  #absolutePanel(id = "control", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                  #       top = 260, left = "auto", right = "auto", bottom = "auto", width = 200, height = "auto",
                                  
                                  box(width = 3, status='info',
                                      selectInput("covid_state", "State:",
                                                  choices = names$Name, 
                                                  selected = names$Name[1]),
                                      br(),
                                      selectInput("covid_metric_1", "Metric", 
                                                  choices = colnames(covid19)[3:9],
                                                  selected = "Confirmed Cases"),
                                      br(),
                                      selectInput("covid_metric_2", "Metric", 
                                                  choices = colnames(covid19)[3:9],
                                                  selected = "Deaths"),uiOutput('if'))
                                  #)
                                ) 
                        ),
                        #Reference
                        tabItem(tabName = 'ref',
                                fluidPage(
                                  
                                ),
                                
                        ),
                        #Searching
                        tabItem(tabName = "tabcb",
                                fluidPage(box(width = 12,height = 365,status = "success",searchInput("cb_table",
                                                                                                  h2(strong(br(),br(),br(),"Information Searching for Business and Covid-19:",align = "center"), 
                                                                                                     style = "color:white"),
                                                                                                  btnSearch = icon("search"))),
                                          tags$style(HTML(".box.box-success{
                        background:url('../business_covid1.jpeg');background-repeat: no-repeat;background-size: 100% 100%;opacity: 1.1}")),
                                          
                                          fluidRow(width = 4, height = 1,status = "primary", height = "575",solidHeader = T,
                                                   column(12,
                                                          dataTableOutput("cb_table")
                                                   )
                                          )
                                #fluidPage(DTOutput("cb_table"))
                        )
                      )
))
#####################################################################################################################################################################
ui <- dashboardPagePlus(
  skin='black',
  header=header,
  sidebar=sidebar,
  body=body
)