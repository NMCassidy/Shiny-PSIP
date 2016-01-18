library(shiny)
library(reshape2)

#read data
dta<-readRDS("Q:/Shiny Test GGplot/dataset")

#This splits the indicator form the year
test<-colsplit(names(dta)[1:292], "20", c("indicator", "year"))                
test$year<-paste0("20",test$year)   

shinyUI(navbarPage("Test PSIP", id = "nav", theme = "bootstrap.css",
                   
                  
              #First tab that shows a summary of a single area at one time
                   tabPanel("Area Stats",
                    sidebarPanel(
                      selectInput("inds", "Choose Indicator Domain(s)", c("All", "Housing", "Welfare", "Health"), multiple = TRUE),
                      selectInput("x", "Select an Indicator", unique(test$indicator)),
                      sliderInput("y", "choose year",min = 2002, max = 2012, step = 1, value = 2002,  sep = ""),
               #In here we may put the ability to choose the geography level
               #that we want to see, which would alter the available inputs below
                      selectInput("Geo", "Select a Geography", c("LA", "MMW", "Intermediate Geography", "Data Zone")),
                      selectInput("LA", "Select a Local Authority Area", unique(dta$council))
                    ),
                    mainPanel(
              #Create a tabset of outputs to view
                      tabsetPanel(
                        tabPanel("graph", plotOutput("histogram")),
              #Probably a clickable map that shows some summary stats for each  
              #datazone/int geo- useful for finding geographies people are interested in          
                        tabPanel("map", plotOutput("map")),
              #table would have to have some sort of filtering function 
              #based on what you want to see eg high/low, 5 year averages, comparison with national/ LA mean          
                        tabPanel("summary table", textOutput("sumt")),
              #Data Explorer could have all data for selected domain for selected area
                        tabPanel("data explorer", textOutput("dex"))
                      ))),
  
              #Additional tab
                    tabPanel("Comparison of Two Areas",
                            sidebarPanel(
                              selectInput("geo", "Select geography type to examine", c("LA", "IG", "DZ_2001", "DZ_2011")),
              #Might have to add in additional options for choosing these
              #Such as choose a council, choose a ward and so on...-can use renderUI
                              fluidRow( column(6, selectInput("A1", "Select Area 1", c("This", "That"))),
                                      column(6, selectInput("A2", "Select Area 2", c("Those", "These")))),
                              selectInput("yrs","Choose year(s)", c("2010", "2011"), multiple = TRUE)
                            ),
                            mainPanel(
                              tabsetPanel(
                                tabPanel("boxplots"),
                                tabPanel("table"),
                                tabPanel("line charts")#Could have comparisons for all available years - Only for a few indicators though
                              ))),
                #Another Tab
                    tabPanel("Comparison Over Time",
                             sidebarPanel(
                #See above regarding selecting the geography type               
                               selectInput("geo2", "Select an area", c("This", "That")),
                               dateRangeInput("DR","Date Range", test$year, format = "yyyy", startview = "year")
                             ),
                #Can also put in a table tab + relative/absolute change over time
                              mainPanel(p("Data for available years for one (or more) indicators; would be able to choose dates;
  Boxplots, tables, and line charts; comparison with local authority/national changes;
                                          view year on year (relative) change and absolute change"))
                             ),
      #Additional tab for metadata
                   tabPanel("Metadata",
                            sidebarPanel(
                              selectInput("md", "Select Indicator/Domain", c("Domain A", "Dom B", "Dom C"))
                            ),
                            mainPanel(p("Some sort of metadata here, possibly comes directly form Statistics Beta?"))
                            ),
                   tabPanel("Data Explorer",
                            fluidRow(column(4, selectInput("LA2", "Select a Local Authority", 
                                                           c("All Scotland" = "",unique(dta$council)), multiple = TRUE)
                            ),
                            column(4, selectInput("domain", "Select a Domain", 
                                                  c("All","Income and Employment", 
                                                    "Health", "Housing", "Community Safety", 
                                                    "Demography and Geography"))
                            )))
      #Additional tab for high/low
))