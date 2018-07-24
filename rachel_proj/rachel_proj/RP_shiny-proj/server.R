library(shiny)
library(shinydashboard)
library(plotly)
shinyServer(function(input, output){
  output$plot<-renderPlotly({
    plot_ly(data=num_of_kill, x=~iyear,y=~num_kill,
            type="bar",marker=list(color='Set1'),color=~region_txt) %>%
      layout(yaxis = list(title = 'Number Of Dead'),
             xaxis = list(title = ''),
             barmode="stack") })
  output$mymap<-renderLeaflet({
    leaflet(a) %>%
      addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
      addMarkers(clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = TRUE))
  }) 
  
    output$mymap1<-renderLeaflet({
    pal=colorNumeric(palette = "Spectral",domain=map$ratio)
      leaflet(map) %>%
        addProviderTiles(providers$CartoDB.Positron) %>%
        addCircleMarkers(lng=map$logt,lat=map$lat,radius =sqrt( map$total),color=pal(map$ratio),weight =3) %>%
        setView(lng=-100,lat=35,zoom=03)
    })
    output$plot1<-renderPlotly({
    p <- ggplot(data,
                aes(x=imonth, y=num_of_attacks,
                    colour=year)) +geom_line()+ylab("Number Of Attacks")+
      scale_x_discrete(name ="Month", limits=c(1:12))
      p <- ggplotly(p)
  })
    output$data<-DT::renderDataTable ({
      data_terror
    })
    
})


