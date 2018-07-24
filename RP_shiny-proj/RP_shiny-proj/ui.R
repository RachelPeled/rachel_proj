

library(shiny)
library(shinydashboard)
dashboardPage(skin="black",
  dashboardHeader(title="Global terror attacks"),
  
  dashboardSidebar(
    
    sidebarMenu(
      menuItem("Chart-Casualties",tabName = "chart",icon =icon("signal")),
      menuItem("Global Map - 2016",tabName = "map",icon=icon("map")),
      menuItem("Chart-Attacks By Month ",tabName = "chart1",icon =icon("signal")),
      menuItem("US Map-Attack results",tabName = "map1",icon=icon("map")),
      menuItem("Data table",tabName ="data",icon=icon("database")))),
  dashboardBody(
    tabItems(
      tabItem("chart",
              box(plotlyOutput("plot"),width = 20,height=450)),
      tabItem(tabName="map",
              fluidPage(
                box(leafletOutput("mymap"),width = 20,height=450)),
              valueBox("","On 2016 Iraq and Afghanistan
                       experienced the greatest number of attacks, clearly
                      confirming the success of the War on Terror",color="green")),
      tabItem("chart1",
              plotlyOutput("plot1")),
      tabItem(tabName="map1",
              fluidPage(
                box(leafletOutput("mymap1"),width = 20,height=450)),
              valueBox("","Ratio~Radius
                           ,  Color~Attack Success" )),
      tabItem(tabName = "data",
              DT::dataTableOutput("data"))
))) 
  
