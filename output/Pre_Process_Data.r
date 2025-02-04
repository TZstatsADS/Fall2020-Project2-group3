library(readr)
time_series_covid19_confirmed_US <- read_csv("../data/time_series_covid19_confirmed_US.csv")
GeoIDs_State <- read_csv("../data/GeoIDs - State.csv")

library(dplyr)
new_time_series_covid19_confirmed_US <- time_series_covid19_confirmed_US[,c(7,12:ncol(time_series_covid19_confirmed_US))]
new_time_series_covid19_confirmed_US <- new_time_series_covid19_confirmed_US %>% 
                                          group_by(Province_State) %>% 
                                          summarise_each(funs(sum))

new_time_series_covid19_confirmed_US <- merge(new_time_series_covid19_confirmed_US, 
                                              GeoIDs_State[c('statename','statefips')], 
                                              by.x = "Province_State", by.y = "statename")

new_time_series_covid19_confirmed_US <- new_time_series_covid19_confirmed_US %>% 
                                          select(Province_State,statefips, 
                                                 c(colnames(new_time_series_covid19_confirmed_US)[2:(length(new_time_series_covid19_confirmed_US)-1)]))

library(tidyr)
new_confirmed<-new_time_series_covid19_confirmed_US %>% 
                  gather(date, 
                         confirmed,
                         c(colnames(new_time_series_covid19_confirmed_US)[3:(length(new_time_series_covid19_confirmed_US))]))

write.csv(new_confirmed,"../data/new_confirmed.csv")

time_series_covid19_deaths_US <- time_series_covid19_deaths_US[,c(7,12:ncol(time_series_covid19_deaths_US))]
new_time_series_covid19_deaths_US <- time_series_covid19_deaths_US %>% 
                                       group_by(Province_State) %>% 
                                       summarise_each(funs(sum))

new_time_series_covid19_deaths_US <- merge(new_time_series_covid19_deaths_US, 
                                           GeoIDs_State[c('statename','statefips')], 
                                           by.x = "Province_State", 
                                           by.y = "statename")

new_time_series_covid19_deaths_US
new_time_series_covid19_deaths_US<- new_time_series_covid19_deaths_US %>% 
                                      select(Province_State,
                                             statefips,
                                             c(colnames(new_time_series_covid19_deaths_US)[2:(length(new_time_series_covid19_deaths_US)-1)]))

new_time_series_covid19_deaths_US
new_death <- new_time_series_covid19_deaths_US %>% 
              gather(date, 
                     death,
                     c(colnames(new_time_series_covid19_deaths_US)[4:(length(new_time_series_covid19_deaths_US))]))

new_death
write.csv(new_death,"../data/new_death.csv")

new_death <- new_death %>% 
                mutate(date=as.Date(new_death$date,"%m/%d/%y"))

new_death
new_confirmed <- new_confirmed %>% 
                    mutate(date=as.Date(new_confirmed$date,"%m/%d/%y"))

new_confirmed
Affinity_State_Daily <- read_csv("../data/Affinity - State - Daily.csv")
new_Affinity_State_Daily <- Affinity_State_Daily %>% 
                              mutate(date=as.Date(with(Affinity_State_Daily, paste(month,day,year,sep="/")), "%m/%d/%Y"))

new_Affinity_State_Daily <- new_Affinity_State_Daily %>% 
                              select(date,
                                     c(colnames(new_Affinity_State_Daily)[4:(length(Affinity_State_Daily)-1)]))

new_Affinity_State_Daily
Employment_Combined_State_Daily <- read_csv("../data/Employment Combined - State - Daily.csv")
new_Employment_Combined_State_Daily <-Employment_Combined_State_Daily %>% 
                                        mutate(date=as.Date(with(Employment_Combined_State_Daily , 
                                                                 paste(month,day,year,sep="/")), 
                                                                 "%m/%d/%Y"))

new_Employment_Combined_State_Daily <-new_Employment_Combined_State_Daily %>% 
                                        select(date,
                                               c(colnames(new_Employment_Combined_State_Daily )[4:(length(new_Employment_Combined_State_Daily)-1)]))

new_Employment_Combined_State_Daily 
Womply_Merchants_State_Daily <- read_csv("../data/Womply Merchants - State - Daily.csv")
new_Womply_Merchants_State_Daily <- Womply_Merchants_State_Daily %>% 
                                      mutate(date=as.Date(with(Womply_Merchants_State_Daily, 
                                                               paste(month,day,year,sep="/")), 
                                                               "%m/%d/%Y"))

new_Womply_Merchants_State_Daily <- new_Womply_Merchants_State_Daily %>% 
                                      select(date,
                                             c(colnames(new_Womply_Merchants_State_Daily)[4:(length(new_Womply_Merchants_State_Daily)-1)]))

new_Womply_Merchants_State_Daily
Womply_Revenue_State_Daily <- read_csv("../data/Womply Revenue - State - Daily.csv")
new_Womply_Revenue_State_Daily <- Womply_Revenue_State_Daily %>% 
                                    mutate(date=as.Date(with(Womply_Revenue_State_Daily, 
                                                             paste(month,day,year,sep="/")), "%m/%d/%Y"))

new_Womply_Revenue_State_Daily <- new_Womply_Revenue_State_Daily %>% 
                                    select(date, 
                                           c(colnames(new_Womply_Revenue_State_Daily)[4:(length(new_Womply_Revenue_State_Daily)-1)]))
new_Womply_Revenue_State_Daily

library(purrr)
data_business <- list(new_Affinity_State_Daily, 
                      new_Employment_Combined_State_Daily , 
                      new_Womply_Merchants_State_Daily,new_Womply_Revenue_State_Daily) %>% 
                        reduce(full_join, by = c("date","statefips"))
write.csv(data_business,"../data/data_business.csv")

new_confirmed
new_death
covid_data<-list(new_confirmed,new_death) %>% 
              reduce(full_join, by = c("Province_State","statefips","date"))

covid_data<-covid_data %>% 
              select(Province_State,statefips,date,Population,confirmed,death)
covid_data
write.csv(covid_data,"../data/covid_data.csv")
merge_data <- list(covid_data,data_business) %>% 
  reduce(full_join, by = c("statefips","date"))
write.csv(merge_data,"../data/merge_data.csv")



library(dplyr)
library(readr)
file_name <- list.files(path="./csse_covid_19_daily_reports_us", full.names = TRUE)
data <- data.frame()
date <- c()
for (file in file_name) {
  if (grepl('.csv$', file)) {
    date <- regmatches(file, regexpr("[0-9]{2}-[0-9]{2}-[0-9]{4}", file))
    full_data <- read_csv(file) %>%
      mutate(date = date)
    data <- data %>%
      bind_rows(full_data)
  }
}
data$date <- as.Date(data$date, "%m-%d-%Y")
write.csv(data,'./covid_data_2.csv')

merge_1 <- read_csv("./merge_1.csv")
full_data <- merge_1 %>%
                left_join(data, by = c("date", "Province_State")) %>%
                select(-c(1,2))

full_data$spend_all_inclow <- as.numeric(full_data$spend_all_inclow)
full_data$emp_combined_inclow <- as.numeric(full_data$emp_combined_inclow)
full_data$emp_combined_incmiddle <- as.numeric(full_data$emp_combined_incmiddle)
full_data$emp_combined_ss40 <- as.numeric(full_data$emp_combined_ss40)
full_data$emp_combined_ss60 <- as.numeric(full_data$emp_combined_ss60)
full_data$emp_combined_ss65 <- as.numeric(full_data$emp_combined_ss65)
full_data$emp_combined_ss70 <- as.numeric(full_data$emp_combined_ss70)
full_data$merchants_ss60 <- as.numeric(full_data$merchants_ss60)
full_data$revenue_ss60 <- as.numeric(full_data$revenue_ss60)

write.csv(full_data,'./full_data.csv')




