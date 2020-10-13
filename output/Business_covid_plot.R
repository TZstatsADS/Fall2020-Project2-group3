library(reshape2)
whole_data <- read.csv("../output/whole_new.csv")
new$revenue_ss60[new$revenue_ss60=="."]<-"0"
new$merchants_ss60[new$merchants_ss60=="."]<-"0"
new<-data.frame(new)
new<-new%>%select(c(Name,date,merchants_ss40,merchants_ss60,merchants_ss65,merchants_ss70,revenue_ss40,revenue_ss60,revenue_ss65,revenue_ss70))
M_Rplot<-new%>%mutate(`revenue_ss60`=as.numeric(`revenue_ss60`),`merchants_ss60`=as.numeric(`merchants_ss60`))
colnames(M_Rplot)[3:10]<-c("% Change in Transportation Open",
                              "% Change in Professional and Business Services Open",
                            "% Change in Education and Health Services Open",
                                      "% Change in Leisure and Hospitality Open","% Change in Transportation Revenue",
                                      "% Change in Professional and Business Services Revenue",
                                      "% Change in Education and Health Services Revenue",
                                       "% Change in Leisure and Hospitality Revenue")
#M_Rplot<-new%>%mutate(`revenue_ss60`=as.numeric(`revenue_ss60`),`merchants_ss60`=as.numeric(`merchants_ss60`))
dat.m <- melt(M_Rplot,id.vars='Name', measure.vars=c("% Change in Transportation Open",
                                                 "% Change in Professional and Business Services Open",
                                                 "% Change in Education and Health Services Open",
                                                 "% Change in Leisure and Hospitality Open","% Change in Transportation Revenue",
                                                 "% Change in Professional and Business Services Revenue",
                                                 "% Change in Education and Health Services Revenue",
                                                 "% Change in Leisure and Hospitality Revenue"))

h<-dat.m%>%group_by(Name,variable)%>%mutate(m=mean(value,ra.rm=TRUE))
h<-data.frame(h)
merge_data <- read_csv("../output/full_data.csv")
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

pic_home_business<-ggplot(h, aes(x=m,fill=variable))+geom_histogram()+facet_grid(variable~.)+labs(x="mean percentage")
inc <- merge_data %>% select(c(1,13:15)) %>% group_by(Province_State) %>% summarize(High  = mean(`% Change in High income people`),
                                                                                    Median = mean(`% Change in Median income people`),
                                                                                    Low = mean(`% Change in Low income people`))%>%
pivot_longer(cols=High:Low,names_to="variable", values_to="value")%>%mutate(variable=factor(inc$variable,levels=c("Low","Median","High")))

boxplot(value~variable,data=inc,xlab="People's Level of Income",ylab="Mean Percent Change of Affinity")
