library(shiny)
library(reshape2)

#read data
dta<-readRDS("Q:/Shiny Test GGplot/dataset")

#This splits the indicator form the year
test<-colsplit(names(dta)[1:292], "20", c("indicator", "year"))                
test$year<-paste0("20",test$year)   

shinyUI(navbarPage("Example Interface", id = "nav", theme = "bootstrap.css",
                   
                  
              #First tab that shows a summary of a single area at one time
                   tabPanel("Area Stats",
                    sidebarPanel(
                      selectInput("inds", "Choose Indicator Domain(s)", c("All","SIMD", "Housing", "Welfare", "Health"), multiple = TRUE),
                      selectInput("x", "Select an Indicator", unique(test$indicator)),
                      sliderInput("y", "choose year",min = 2001, max = 2012, step = 1, value = 2001,  sep = ""),
               #In here we may put the ability to choose the geography level
               #that we want to see, which would alter the available inputs below
                      selectInput("Geo", "Select a Geography", c("LA", "MMW", "Intermediate Geography", "Data Zone")),
                      selectInput("LA", "Select a Local Authority Area", unique(dta$council))
                    ),
                    mainPanel(
              #Create a tabset of outputs to view
                      tabsetPanel(
                        tabPanel("graph", plotOutput("bgraph"), p("Probably would be a barplot of some sort - showing summary stats compared to Scotland/LA/ etc mean/median.
                                                                     If it was a local authority it might show it compared with other LA, if a datazone it might show it compared with other data zones in that LA")),
              #Probably a clickable map that shows some summary stats for each  
              #datazone/int geo- useful for finding geographies people are interested in          
                        tabPanel("map", plotOutput("map", height = "800px", width = "800px")),
              #table would have to have some sort of filtering function 
              #based on what you want to see eg high/low, 5 year averages, comparison with national/ LA mean          
                        tabPanel("summary table", p("This table would contain information on the selected geography such as comparisons 
with the national, local authority, mmw etc averages/median; highest and lowest values 
              for the indicator and geography on that geography type; plus something like 5 year average?")),
              #Data Explorer could have all data for selected domain for selected area
                        tabPanel("data explorer", p("Would provide all available stats for the indicators within the selected domain."))
                      ))),
  
              #Additional tab
                    tabPanel("Comparison of Multiple Areas",
                            sidebarPanel(
                              selectInput("areas", "Select Number of Areas to Compare", c(2,3,4)),
                              selectInput("geo", "Select geography type to examine", c("LA", "IG", "DZ_2001", "DZ_2011")),
              #Might have to add in additional options for choosing these
              #Such as choose a council, choose a ward and so on...-can use renderUI
                              fluidRow( column(6, selectInput("A1", "Select Area 1", c("This", "That"))),
                                      column(6, selectInput("A2", "Select Area 2", c("Those", "These")))),
                              fluidRow(column(6, conditionalPanel(condition = "input.areas == '3'||input.areas == '4'",
                                       selectInput("A3", "Select Area 3", c("Somewhere", "Somewhere Else")))),
                                       column(6, conditionalPanel(condition = "input.areas == '4'",
                                          selectInput("A4", "Select Area 4", c("A Place", "Another Place"))))),
                              selectInput("yrs","Choose year(s)", c("2010", "2011"), multiple = TRUE)
                            ),
                            mainPanel(
                              tabsetPanel(
                                tabPanel("boxplots", p("Multiple boxplots showing something....")),
                                tabPanel("table", p("A summary table with basic stuff")),
                                tabPanel("line charts", p("Has to be fairly limited, might make it possible to see only one indicator at a time"))#Could have comparisons for all available years - Only for a few indicators though
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
                            mainPanel(p("Some sort of metadata here, possibly comes directly from Statistics Beta?"))
                            ),
                   tabPanel("Data Explorer",
                            fluidRow(column(4, selectInput("LA2", "Select a Local Authority", 
                                                           c("All Scotland" = "",unique(dta$council)), multiple = TRUE)
                            ),
                            column(4, selectInput("domain", "Select a Domain", 
                                                  c("All","Income and Employment", 
                                                    "Health", "Housing", "Community Safety", 
                                                    "Demography and Geography"))
                            ))),
      #Additional tab for high/low
                           tabPanel("High-Low",
                                    sidebarPanel(
                                      selectInput("AT", "Select Geography Level", c("LA", "INtG", "DZ")),
                                      selectInput("idid", "Indicator", c("Blah", "blah", "blahhh")),
                                      selectInput("yeer", "Select Year", c(2002:2010))),
                                    tabsetPanel(
                                      tabPanel("Map", p("Show these areas on a nice map - doesn't have to be interactive, but this might be a good function to have, provided it is not too slow with this functionality")),
                                      tabPanel("Summary", p("Summary table"))
                                    )
                                    ))
      )