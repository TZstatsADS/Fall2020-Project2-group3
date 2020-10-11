server<-function(input, output,session){
  
#####################################################################################################################################################################
# business map for month
  observeEvent(input$basic_metric_month, {
    choice <- basic_metric_select_month()%>% 
      select(-Name, -date)%>%
      colnames()
    updateSelectInput(session, 'metric_month', choices=c(choice))
  })
  
  basic_metric_select_month <- reactive({
    sel <- if(input$basic_metric_month=='Affinity') colnames(merge_data)[7:15]
    else if(input$basic_metric_month=='Merchants') colnames(merge_data)[16:20]
    else if(input$basic_metric_month=='Revenue') colnames(merge_data)[21:25]
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
  
#####################################################################################################################################################################
# business map for date
  observeEvent(input$basic_metric_date, {
    choice <-basic_metric_select_date()%>% 
      select(-Name, -date)%>%
      colnames()
    updateSelectInput(session, 'metric_date', choices=c(choice))
  })
  basic_metric_select_date <- reactive({
    sel <- if(input$basic_metric_date=='Affinity') colnames(merge_data)[7:15]
    else if(input$basic_metric_date=='Merchants') colnames(merge_data)[16:20]
    else if(input$basic_metric_date=='Revenue') colnames(merge_data)[21:25]
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
      colnames(Value) <-'Value'
      dt<-data.frame(dt, Value)
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
#-----------------------------------------------------------------------------------------------------------------------------
#################################################################################################################
observeEvent(input$var, {
  choice <- variable()%>%
    select(-Name, -date)%>%
    colnames()
  #updateSelectInput(session, 'metric_date', choices=c(choice))
})

variable <- reactive({
  sel <- if(input$var=='Confirmed Cases') colnames(covid19)[10]
  else if(input$var=='Death Cases') colnames(covid19)[11]
  else if(input$var=='Active Cases') colnames(covid19)[13]
  else if(input$var=='Recovered Cases') colnames(covid19)[12]
  covid19 %>%
    select(Name, date, sel)%>%as.data.frame()
})


dateFiltered <- reactive({
  thing <- variable() %>% filter(as.Date(date) >= as.Date(input$date_range[1]) & as.Date(date) <=
                                   as.Date(input$date_range[2]))
  Value <- thing%>%select(3) #sel
  colnames(Value) <-'Value'
  thing <- data.frame(thing, Value)
  thing %>%
    select(Name, Value) %>%
    right_join(names, by = "Name")
  
})


output$covidmaps<- renderLeaflet({
  map_data <- dateFiltered()
  dt1 <- input$date_range[1]
  dt2 <- input$date_range[2]
  labels <- sprintf(
    "<strong>%s<br/>%s<br/>%s",map_data$Name, input$var, map_data$Value)%>%lapply(htmltools::HTML)
  covid_map(map_data, labels)
})

#################################################################################################################
inputtext <- reactive(input$job_table %>% str_to_lower())
output$job_table <- DT::renderDataTable({DT::datatable(whole_data,filter = "none", extensions = c('Buttons'),
                                                       options = list(scrollY = 500,
                                                                      scrollX = 1000,
                                                                      autoWidth = TRUE,
                                                                      deferRender = TRUE,
                                                                      scroller = TRUE,
                                                                      select= TRUE,
                                                                      visible=TRUE,
                                                                      # paging = TRUE,
                                                                      # pageLength = 25,
                                                                      dom = 'Bfrt<"bottom"lip>',
                                                                      buttons = 
                                                                        list('colvis','copy',  list(
                                                                          extend = 'collection',
                                                                          buttons = c('csv', 'excel', 'pdf'),
                                                                          text = 'Download'
                                                                          
                                                                        )),
                                                                      fixedColumns = TRUE), 
                                                       rownames = FALSE)})

}


#-----------------------------------------------------------------------------------------------------------------------------






