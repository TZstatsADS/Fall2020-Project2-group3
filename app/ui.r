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
header <- dashboardHeader(title='Covid 19 Group 3',titleWidth = 195
)

#####################################################################################################################################################################
# Sidebar
sidebar <- dashboardSidebar(
  width = 195,
  sidebarMenu(
    menuItem('Home', 
             tabName = 'Home', 
             icon = icon('home')
    ), 
    menuItem('Maps', startExpanded = TRUE,
             tabName='map', 
             icon = icon("map"), 
             menuSubItem('Business Map', 
                         tabName = 'business_map'
             ),
             menuSubItem('Covid Map', 
                         tabName = 'covid_map'
             )
    ),
    menuItem('Analyze a State', startExpanded = TRUE,
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
                      # Home Xinyi Wei, Yunuo Ma
                      tabItems(
                        tabItem(tabName='Home',
                            fluidPage(
                              br(),
                              includeHTML("home.html"),
                              tags$script(src = "plugins/scripts.js")),
                          
                            br(),
                                fluidRow(
                                  
                                  valueBoxOutput("max_confirm"),
                                  valueBoxOutput("max_death"),
                                  valueBoxOutput("max_recover"),
                                  valueBoxOutput("max_incident"),
                                  valueBoxOutput("max_test"),
                                  valueBoxOutput("max_hosptial"),
                                  br(),
                                  img(src="https://raw.githubusercontent.com/TZstatsADS/Fall2020-Project2-group3/master/app/www/business_histgram_home.png?token=AG54Q4J2ARJVALMJSMX2UV27R5ZZW",width=355,height=320,style="float: left;margin:auto 0;"),
                                  img(src="https://knowledge.insead.edu/sites/www.insead.edu/files/styles/w_650/public/styles/panoramic/public/images/2020/04/covid-19_how_every_business_can_help.jpg?itok=WmDcAeeJ",width=355,height=320,style="float: left;margin: auto 0;"),
                                  img(src="https://raw.githubusercontent.com/TZstatsADS/Fall2020-Project2-group3/master/app/www/boxplot_b.png?token=AOLIQAGWLIBQHAJXW577KS27R6AHS",
                                      width=355,height=320,style="float: middle;margin: auto 0;")
                              
                               
                        )),
                        # Business map Xinyi Wei
                        tabItem(tabName = 'business_map', 
                                fluidPage(
                                  #tags$style(HTML(".box.box-info{
                        #background:lightblue;opacity: 1.0}")),
                                  tabBox(id=' ', width = 22, title=" ",
                                         tabPanel("Month",
                                                  leafletOutput('stmaps', width="100%",height=750),
                                                  
                                                  absolutePanel(id = "control", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                                                top = 260, left = "auto", right = "auto", bottom = "auto", width = 200, height = "auto",
                                                                
                                                                box(status='info', width=12,
                                                                    selectInput(inputId = 'basic_metric_month', 
                                                                                label = 'Metrics', 
                                                                                choices = c('Consumer Spending','Small Business Open','Small Business Revenue'),
                                                                                selected = 'Consumer Spending'
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
                                                                                                           choices = c('Consumer Spending','Small Business Open','Small Business Revenue'),
                                                                                                           selected = 'Consumer Spending'
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
                        # Covid map Yunuo Ma
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
                        # Business Trend Minzhi Zhang
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
                        # Covid Trend Minzhi Zhang
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
                        #Reference Minzhi Zhang, Mina Jiang
                        tabItem(tabName = 'ref',
                                fluidPage(
                                  mainPanel(width=12,
                                            h1(strong("Business Value"), align = "center"),
                                            hr(),
                                            column(12,
                                                   h4("COVID-19 has drastically impacted everyone’s daily life, especially for those small business owners, 
                                                      whose business may not survive in this global pandemic. 
                                                      Thousands of people are closing their business due to the COVID-19. 
                                                      To ease the difficult situations that most small business owners are facing, 
                                                      this app is aimed to help those local small business owners to gather some useful information about their industries, 
                                                      and help them get a sense of how COVID-19 is affecting their businesses. 
                                                      We hope this app can help those small business owners develop business strategies and continue operating. 
                                                      Together, we're relentlessly fighting COVID-19!")),
                                            br(),
                                            br(),
                                            br(),
                                            br(),
                                            br(),
                                            column(12,
                                            h1(strong("Tips for Small Business under the Pandemic"), align = "center"),
                                            h4(align = "Left",
                                            br(), 
                                            tags$ul(
                                            tags$li('Communicate with clients and customers'),
                                            br(),
                                            tags$li('Find your unique business value (There are a lot of great examples of businesses embracing the current situation and successfully pivoting into completely new areas. But you need to be careful about how you do this and stay true to what your business stands for)'),
                                            br(),
                                            tags$li('Connecting with others in the same industry for support'),
                                            br(),
                                            tags$li('Know what financial support you have access to (different states gov. varies)'),
                                            br(),
                                            tags$li('Focus on customer service that differentiates small business from big business instead of competition itself')
                                            ),
                                            br(),
                                            
                                            h1(strong("About the Data"), align = "center"),
                                            hr(),
                                            column(12,
                                                   h4("This app uses data from", 
                                                      tags$a(href = "https://tracktherecovery.org/" , "the Economic Tracker"),
                                                      "and data from", 
                                                      tags$a(href = "https://github.com/CSSEGISandData/COVID-19" , "the 2019 Novel Coronavirus Visual Dashboard"),
                                                      "operated by the Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE).")
                                            ),
                                            br(),
                                            br(),
                                            br(),
                                            h3(strong("Business")),
                                            column(12,
                                                   tags$ul(
                                                     tags$li(h4("Consumer Spending: Seasonally adjusted credit/debit card spending relative to January 4-31 2020 in different business sectors.")),
                                                     tags$li(h4("Small Business Open: Percent change in number of small businesses open calculated as a seven-day moving average seasonally adjusted and indexed to January 4-31 2020 in different business sectors.")),
                                                     tags$li(h4("Small Business Revenue: Percent change in number of small businesses open calculated as a seven-day moving average seasonally adjusted and indexed to January 4-31 2020 in different business sectors."))
                                                   )),
                                            br(),
                                            h3(strong("Covid-19")),
                                            column(12,
                                                   tags$ul(
                                                     tags$li(h4('The Covid-19 data contains number of confirmed, active, death, recovered cases and hospitalization, incidence and testing rates across each state in the U.S. in a daily time series summary.')),
                                                     tags$li(h4('Confirmed Cases: Counts include confirmed and probable (where reported)')),
                                                     tags$li(h4('Active Cases: Active cases = total cases - total recovered - total deaths')),
                                                     tags$li(h4('Recovered Cases: Recovered cases are estimates based on local media reports, and state and local reporting when available, and therefore may be substantially lower than the true number.')),
                                                     tags$li(h4('Testing Rate: Total test results per 100,000 persons')),
                                                     tags$li(h4('Incident Rate: cases per 100,000 persons.')),
                                                     tags$li(h4('Hospitalization Rate: US Hospitalization Rate (%): = Total number hospitalized / Number cases.'))
                                                   )
                                            ),
                                               ))
                                            
                                            
                                  )
                                )
                                
                        ),
                                
                      
                        #Searching Yunuo Ma, Xinyi Wei
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



