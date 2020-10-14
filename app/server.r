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
server<-function(input, output,session){
  ################################################################################################################################
  # Value boxes for Home Page 
  # Yunuo Ma
  output$max_confirm <- renderValueBox({
    max_confirm_tab <- covid19 %>% filter(`Confirmed Cases`==max(`Confirmed Cases`)) %>% select(Name,`Confirmed Cases`)
      valueBox(value=max_confirm_tab$`Confirmed Cases`,
               subtitle = paste("Max number of Confirmed Cases is in","CA"),
               icon = icon("head-side-virus"),
               color = "red")
  })
  #colnames(covid19)
  output$max_death <- renderValueBox({
    max_death_tab <- covid19 %>% filter(Deaths==max(Deaths)) %>% select(Name,Deaths)
    valueBox(value=max_death_tab$Deaths,
             subtitle = paste("Max number of Death Cases is in",as.character(max_death_tab$Name)),
             icon = icon("skull-crossbones"),
             color = "light-blue")
  })
  
  output$max_recover <- renderValueBox({
    max_recover_tab <- covid19 %>% filter(Recovers==max(Recovers)) %>% select(Name,Recovers)
    valueBox(value=max_recover_tab$Recovers,
             subtitle = paste("Max number of Recovered Cases is in",as.character(max_recover_tab$Name)),
             icon = icon("grin-squint"),
             color = "green")
  })
  
  output$max_incident <- renderValueBox({
    max_incident_tab <- covid19 %>% filter(`Incident Rate`==max(`Incident Rate`)) %>% select(Name,`Incident Rate`)
    valueBox(value=round(max_incident_tab$`Incident Rate`,digits=2),
             subtitle = paste("Max Incident Rate is in",as.character(max_incident_tab$Name)),
             icon = icon("head-side-mask"),
             color = "orange")
  })
  
  output$max_test <- renderValueBox({
    max_test_tab <- covid19 %>% filter(`Testing Rate`==max(`Testing Rate`)) %>% select(Name,`Testing Rate`)
      valueBox(value=round(max_test_tab$`Testing Rate`,digits=2),
               subtitle = paste("Max Tesing Rate is in",as.character(max_test_tab$Name)),
               icon = icon("vial"),
               color = "purple")
  })
  
  output$max_hosptial <- renderValueBox({
    max_hospital_tab <- covid19 %>% filter(`Hospitalization Rate`==max(`Hospitalization Rate`)) %>% select(Name,`Hospitalization Rate`)
    valueBox(value=round(max_hospital_tab$`Hospitalization Rate`,digits=2),
             subtitle = paste("Max Hospital Rate is in",as.character(max_hospital_tab$Name)),
             icon = icon("hospital"),
             color = "maroon")
  })
  
  ################################################################################################################################
  # Business map for month 
  # Xinyi Wei
  observeEvent(input$basic_metric_month, {
    choice <- basic_metric_select_month()%>% 
      select(-Name, -date)%>%
      colnames()
    updateSelectInput(session, 'metric_month', choices=c(choice))
  })
  
  basic_metric_select_month <- reactive({
    sel <- if(input$basic_metric_month=='Consumer Spending') colnames(merge_data)[7:15]
    else if(input$basic_metric_month=='Small Business Open') colnames(merge_data)[16:20]
    else if(input$basic_metric_month=='Small Business Revenue') colnames(merge_data)[21:25]
    merge_data %>% 
      select(Name, date, sel)})
  
  metric_select_month <- reactive({
    merge_data%>% 
      select(Name, mth, input$metric_month) %>%
      drop_na()
  })
  
  month_select <- reactive({
    dt <- metric_select_month() %>%
      filter(mth == input$month) %>%
      group_by(Name,mth)%>%summarise_all("mean")%>%rename(Value=input$metric_month)%>%mutate(Value=round(Value,4))
    dt %>%
      select(Name, Value) %>%
      right_join(names, by = "Name")
  })
  
  # Map Part
  output$stmaps<- renderLeaflet({
    map_data <- month_select()
    met <-input$metric_month
    dt <- input$month
    #pal <- colorBin("Blues", domain = map_data$Value)
    labels <- sprintf(
      "<strong>%s<br/>%s<br/>%s<br/>%s%s",map_data$Name,input$basic_metric_month,dt,map_data$Value,met)%>%lapply(htmltools::HTML)
    business_map(map_data,labels)
  })
  
  ################################################################################################################################
  # Business map for date
  # Xinyi Wei
  observeEvent(input$basic_metric_date, {
    choice <-basic_metric_select_date()%>% 
      select(-Name, -date)%>%
      colnames()
    updateSelectInput(session, 'metric_date', choices=c(choice))
  })
  basic_metric_select_date <- reactive({
    sel <- if(input$basic_metric_date=='Consumer Spending') colnames(merge_data)[7:15]
    else if(input$basic_metric_date=='Small Business Open') colnames(merge_data)[16:20]
    else if(input$basic_metric_date=='Small Business Revenue') colnames(merge_data)[21:25]
    merge_data %>% 
      select(Name, date, sel)})
  # business map for date
  metric_select_date<-reactive({
    merge_data%>% 
      select(Name, date, input$metric_date) %>%
      drop_na()
  })
  
  data_select_date <- reactive({
    {
      dt <- metric_select_date() %>%
        filter(date==input$date)
      Value <- dt[, 3]
      
      #colnames(Value) <-'Value'
      dt <- data.frame(dt, Value)
      dt %>%
        select(Name, Value) %>%
        right_join(names, by = "Name")
    }
  })
  
  output$stmaps_1<- renderLeaflet({
    map_data <- data_select_date()
    met <-input$metric_date
    dt <- input$date
    labels <- sprintf(
      "<strong>%s<br/>%s<br/>%s<br/>%s%s",map_data$Name,input$basic_metric_date,dt,map_data$Value,met)%>%lapply(htmltools::HTML)
    business_map(map_data,labels)
    
  })
  #-------------------------------------------------------------------------------------------------------------------------------
  ################################################################################################################################
  # COVID-19 Map 
  # Yunuo Ma
  observeEvent(input$var, {
    choice <- variable()%>%
      select(-Name, -date)%>%
      colnames()
  })
  
  r <- reactiveValues(
    start = as.Date("2020-01-22"),
    end = as.Date("2020-09-20")
  )

  observeEvent(input$date_range, {
    start <- as.Date(input$date_range[1])
    end <- as.Date(input$date_range[2])
    if (start >= end){
      shinyalert::shinyalert("start > end", type = "error")
      updateDateRangeInput(
        session,
        "date_range",
        start = r$start,
        end = r$end
      )
    } else {
      r$start <- input$date_range[1]
      r$end <- input$date_range[1]
    }
  }, ignoreInit = TRUE)
  
  variable <- reactive({
    sel <- if(input$var=='Changes of Confirmed Cases') colnames(covid19)[3]
    else if(input$var=='Changes of Death Cases') colnames(covid19)[4]
    else if(input$var=='Changes of Active Cases') colnames(covid19)[5]
    else if(input$var=='Changes of Recovered Cases') colnames(covid19)[6]
    else if(input$var=='Mean Incident Rate') colnames(covid19)[7]
    else if(input$var=='Mean Testing Rate') colnames(covid19)[8]
    else if(input$var=='Mean Hospitalization Rate') colnames(covid19)[9]
    covid19 %>%
      select(Name, date, sel)%>%as.data.frame()
  })
  
  dateFiltered <- reactive({
    if (input$var=='Mean Incident Rate'|input$var=='Mean Testing Rate'|input$var=='Mean Hospitalization Rate'){
      thing <- variable() %>% filter(as.Date(date)>=as.Date(input$date_range[1]) & as.Date(date)<=as.Date(input$date_range[2]))
      pwdat <- thing %>% pivot_wider(everything(),names_from=date,values_from=colnames(thing)[3])
      cbind(Name=pwdat$Name,data.frame(Value=rowSums(pwdat[,2:ncol(pwdat)])/(ncol(pwdat)-1)))%>%
        right_join(names, by = "Name")
    }else{
      if (input$date_range[1]=="2020-01-22"){
        thing <- variable() %>% filter(as.Date(date)==as.Date(input$date_range[2]))
        pwdat <- thing %>% pivot_wider(everything(),names_from=date,values_from=colnames(thing)[3])
        colnames(pwdat)[2] <- "Value"
        pwdat %>% select(Name,Value)%>%
          right_join(names, by = "Name")
      }else if(input$date_range[1]!=input$date_range[2]){
        thing <- variable() %>% filter(as.Date(date)==as.Date(input$date_range[1]) | as.Date(date)==as.Date(input$date_range[2]))
        pwdat <- thing%>%pivot_wider(everything(),names_from=date,values_from=colnames(thing)[3])
        pwdat['Value'] = pwdat[,3]-pwdat[2]
        pwdat %>% select(Name,Value)%>%
          right_join(names, by = "Name")
      }else if(input$date_range[1]==input$date_range[2]){
        thing <- variable() %>% filter(as.Date(date)==as.Date(input$date_range[1]))
        pwdat <- thing%>%pivot_wider(everything(),names_from=date,values_from=colnames(thing)[3])
        pwdat['Value']=pwdat[2]
        pwdat %>% select(Name,Value)%>%
          right_join(names, by = "Name")
      }
    }
    
  })
  
  output$DateRange <- renderText({
    # make sure end date later than start date
    validate(
      need(input$date_range[2] > input$date_range[1], "end date is earlier than start date"
      )
    )
    
    paste("There are", 
          difftime(input$date_range[2], input$date_range[1], units="days"),
          "days between your selected dates")
  })

  output$covidmaps<- renderLeaflet({
    map_data <- dateFiltered()
    dt1 <- input$date_range[1]
    dt2 <- input$date_range[2]
    labels <- sprintf(
      "<strong>%s<br/>%s<br/>%s",map_data$Name, input$var, map_data$Value)%>%lapply(htmltools::HTML)
    covid_map(map_data, labels)
  })
  
  ################################################################################################################################
  # Search part Yunuo Ma, Xinyi Wei
  inputtext <- reactive(input$cb_table %>% str_to_lower())
  tab <- whole_data[,-1]%>%mutate(Name = str_to_title(Name))
  output$cb_table <- DT::renderDataTable({DT::datatable(tab[str_detect(tab$Name, regex(inputtext(), ignore_case = T))|str_detect(tab$date, inputtext()), ] %>%
                                                           select(Name, date, confirmed, death, Recovered, Active,
                                                                  spend_all,merchants_all,revenue_all) %>%
                                                           rename(States=Name, Dates= date, Confirms= confirmed, Deaths=death,
                                                                  Recovers = Recovered, Actives = Active,
                                                                  `%Change in Spending of all Merchant Categories`=spend_all,
                                                                  `%Change in all Small Businesses Open`=merchants_all,
                                                                  `%Change in all Small Businesses Revenue`=revenue_all),
                                                         #filter = "none", 
                                                         extensions = c('Buttons'),
                                                         options = list(deferRender = TRUE,
                                                                        select= TRUE,
                                                                        visible=TRUE,
                                                                        searching = FALSE, 
                                                                        scrollX = TRUE, 
                                                                        pageLength =10,
                                                                        scrollY = '500px',
                                                                        dom = 'Bfrt<"bottom"lip>',
                                                                        buttons = 
                                                                          list('colvis','copy',  list(
                                                                            extend = 'collection',
                                                                            buttons = c('csv', 'excel', 'pdf'),
                                                                            text = 'Download'
                                                                          )),
                                                                        fixedColumns = TRUE), 
                                                                        rownames = FALSE)})
  
    observeEvent(input$cb_table, {
      updateTextInput(session, "cb_table")
    })

  ################################################################################################################################
    # Business Trend Plot
    # Minzhi Zhang
    observeEvent(input$busi_metric_1, {
      choice <- busi_metric_select()
      updateSelectInput(session, 'busi_metric_2', choices=c(choice))
    })
    
    busi_metric_select <- reactive({
      sel <- colnames(merge_data[7:25])
      sel[sel != input$busi_metric_1]
    })
    
    output$business_trend <- renderPlotly({
      busi_trend_plot <- merge_data %>%
        mutate(Province_State = toupper(Province_State)) %>%
        filter(Province_State == input$busi_state) %>%
        select(Province_State, date, input$busi_metric_1, input$busi_metric_2) %>%
        # mutate("% Change in Transportation Revenue" = `% Change in Transportation Revenue`*10000) %>%
        gather("Metric", "Value", 3:4) %>%
        ggplot(aes(x = date, y = Value, color = Metric)) +
        geom_line() +
        labs(x = "Date") +
        theme_bw() +
        labs(y = "% Change") +
        theme(legend.position = c(0.8, 0.2))
      
      ggplotly(busi_trend_plot, tooltip=c('Name', 'value'))
    })
    
    # Covid Trend Plot
    # Minzhi Zhang
    observeEvent(input$covid_metric_1, {
      choice <- covid_metric_select()
      updateSelectInput(session, 'covid_metric_2', choices=c(choice))
    })
    
    covid_metric_select <- reactive({
      sel <- colnames(covid19[3:9])
      sel[sel != input$covid_metric_1]
    })
    
    
    output$covid_trend <- renderPlotly({
      covid_trend_plot <- covid19 %>%
        filter(Name == input$covid_state) %>%
        select(Name, date, input$covid_metric_1, input$covid_metric_2) %>%
        gather("Metric", "Value", 3:4) %>%
        ggplot(aes(x = date, y = Value, color = Metric)) +
        geom_line() +
        labs(x = "Date") +
        theme_bw() +
        labs(y = "Value") +
        theme(legend.position = c(0.8, 0.2))
      
      ggplotly(covid_trend_plot, tooltip=c('Name', 'value'))
    })
}



#-----------------------------------------------------------------------------------------------------------------------------


