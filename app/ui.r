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
    menuItem("Job search", tabName = "job", icon = icon("clipboard")),
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
  tabItems(
    # Home
    tabItem(tabName='Home',
            fluidPage( 
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
            fluidRow(
              tabPanel("",
                       leafletOutput('covidmaps', width="100%",height=750),
                       absolutePanel(id = "covidid", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                     top = 260, left = "auto", right = "auto", bottom = "auto", width = 250, height = "auto",
                                     box(status='info', width=100,
                                         selectInput(inputId = 'var', 
                                                     label = 'Case Type', 
                                                     choices = c('Confirmed Cases','Death Cases', 'Active Cases', 'Recovered Cases'),
                                                     selected = 'Confirmed Cases'
                                         ), 
                                         dateRangeInput(inputId = 'date_range', 
                                                        label = 'Select Date Range',
                                                        start = '2020-01-22', 
                                                        end = '2020-09-20',
                                                        min = '2020-01-22', 
                                                        max = '2020-09-20'),
                                         
                                         uiOutput('moreControls_1')
                                     )))
                       
                       
                       
                       
                       
                       
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
                                            choices = colnames(covid19)[4:14],
                                            selected = "Aggregated Confirmed Cases"),
                                br(),
                                selectInput("covid_metric_2", "Metric", 
                                            choices = colnames(covid19)[4:14],
                                            selected = "Aggregated Deaths"),uiOutput('if'))
              #)
            ) 
    ),
    #Reference
    tabItem(tabName = 'ref',
            fluidPage(
              
            ),
            
    ),
    tabItem(tabName = "job",
            fluidPage(DTOutput("job_table"))
    )
  )
)

#####################################################################################################################################################################
ui <- dashboardPagePlus(
  skin='black',
  header=header,
  sidebar=sidebar,
  body=body,
)