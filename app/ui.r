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
    menuItem('Analyze a States/County', 
             tabName = 'stats', 
             icon = icon("chart-line"), 
             menuSubItem('State', 
                         tabName = 'specific_state_stats'
             ),
             menuSubItem('County', 
                         tabName = 'specific_county_stats'
             ) 
    ),  menuItem("Job search", tabName = "job", icon = icon("clipboard")),
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
    # Specific Stats
    tabItem(tabName = 'covid_map',
            fluidRow(
              tabPanel("",
                       leafletOutput('covidmaps', width="100%",height=750),
                       absolutePanel(id = "covidid", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                     top = 260, left = "auto", right = "auto", bottom = "auto", width = 200, height = "auto",
                                     box(status='info', width=20,
                                         selectInput(inputId = 'var', 
                                                     label = 'Case Type', 
                                                     choices = c('Confirmed Cases','Death Cases'),
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
    tabItem(tabName="specific_county_stats",
            fluidRow(
              
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