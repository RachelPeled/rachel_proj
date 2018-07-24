library(ggplot2)
library(leaflet)
library(dplyr)
library(shiny)
library(ggthemes)
library(DT)
library(plotly)
## calling dataset
terrorattacks=read.csv("./globalterrorismdb_0617dist.csv",stringsAsFactors=F)
##selecting the relevent columns
terror_attacks=select(terrorattacks,eventid,country,country_txt,city,longitude,latitude,weapsubtype1_txt,region_txt,nwound,iyear,imonth,iday,nkill)


#### grouping by year and counting the attacks occured on 2016 by area.  
group_by=group_by(terror_attacks,iyear)
by_years=(summarise(group_by,num_of_attacks=n()))

    
##### plotting the cluster map with leaflet

a=filter(terror_attacks,iyear==2016) ##map of attcks happned on 2016 
head(a)
leaflet(a) %>%
  addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addMarkers(clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = TRUE))
#### clasification fo chart1 reducing the amount of variables
terror_attacks=mutate(terror_attacks,
                      region_txt=ifelse(region_txt %in% c("Western Europe","Eastern Europe"),
                                        "Europ",
                                        ifelse(region_txt %in% c("East Asia","South Asia","Central Asia","Southeast Asia"),
                                               
                                               "Asia",region_txt)))

### data filtered and grouped fo chart 1 :dead people by year from 2006-2016
num_of_kill=terror_attacks %>% filter(.,nkill>0 & iyear >=1985) %>% 
  group_by(.,region_txt,iyear) %>%
  summarise(.,num_kill=sum(nkill))

## chart 2 data+graf
attacks=filter(terror_attacks,iyear>2006 ,imonth>0) 
group_by_year=group_by(attacks,iyear,imonth) 
data=summarise(group_by_year,num_of_attacks=n())
data$year=as.factor(data$iyear)

attack_on_US=filter(terrorattacks,country_txt=="United States") 
map=attack_on_US %>%
  mutate(.,cas=ifelse(nkill==0 & nwound==0,"No_casualties","casualties")) %>%
  group_by(.,city) %>%
  summarise(.,no=sum(cas=="No_casualties"),total=n(),lat=mean(latitude),logt=mean(longitude)) %>%
  mutate(.,ratio=no/total)
map
pal=colorNumeric(palette = "Spectral",domain=map$ratio)
leaflet(map) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircleMarkers(lng=map$logt,lat=map$lat,radius = sqrt(map$total),color=pal(map$ratio)) %>%
  setView(lng=-100,lat=35,zoom=03)

data_terror=select(terrorattacks,region_txt,
                   country_txt,
                   city,longitude,latitude,
                   iyear,imonth,iday,nwound,nkill)

head(data_terror)
colnames(data_terror)=c("Region","County","City","Longitude","Latitude","Year","Month","Day","Number of dead","Number of wounded")
head(data_terror)


datatable(data_terror,caption = "Table: Global Terror attcks")


          
