library(shiny)
library(ggplot2)
library(ggmap)
library(RColorBrewer)
library(ggthemes)
source('S:/G - Governance & Performance Mngmt/Research Team/Generic R Tools/Function - cuts - improved.R')

#read data
shinyServer(
  function(input,output){
    
    dta<-readRDS("Q:/Shiny Test GGplot/dataset")
    
output$bgraph<-renderPlot({
  bg_dat<-dta[1:5,c(6,294)]
  bgraph<-ggplot(data = bg_dat, aes(x = bg_dat[,2], y = bg_dat[,1])
                )+geom_bar(stat = "identity")
  bgraph
  })

output$map<-renderPlot({
  dzs01_map_fort <- readRDS(file = "S:/G - Governance & Performance Mngmt/Research Team/Fire Research/Assessments-Rproject/data/dzs01_fort.rds")
  
  cols_keep <- c("datazone_2001","council", "SIMD ranking 2012")
  hlth_dta<-dta[, names(dta)%in% cols_keep]
  # Subset the data to match the selected indicator, no need to change anything
  mstr_map_dta <- dta[,(names(dta) %in% cols_keep)]
  # Merge map file with the indicator and data file
  mstr_map_dta <- merge(x = dzs01_map_fort, y = mstr_map_dta,
                        by.x = "id", by.y = "datazone_2001", all.x = TRUE)
  
  # Subset data  to get Aberdeenshire
  mstr_map_dta_cln <- subset(x = mstr_map_dta, subset = council == "Aberdeenshire")
  
  
  ##get pretty breaks
  mstr_map_dta_cln<-mstr_map_dta_cln[order(mstr_map_dta_cln$`SIMD ranking 2012`),]
  mstr_map_dta_cln$brks<-nice.cuts2(mstr_map_dta_cln$`SIMD ranking 2012`, 5)
  
  # Background Aberdeenshire map, zoom
  ## Geocode to have centre
  CentreOfMap <- geocode(location = "Bridge of Alford, UK")
  ## Get background
  backgr_Abrdn_zoom <- get_map(c(lon = CentreOfMap$lon,
                                 lat = CentreOfMap$lat), zoom = 8,
                               maptype = "terrain", source = "google")
  
  # Apply ggmap
  backgr_Abrdn_zoom <- ggmap(backgr_Abrdn_zoom, extent = "normal")
  
  clrs<-rev(brewer.pal(length(levels(mstr_map_dta_cln$brks)), "RdYlGn"))
  
  
  map_abdn_dzs_b <- backgr_Abrdn_zoom +
    geom_polygon(data = mstr_map_dta_cln, aes(x = lng, y = lat,
                                              fill = brks,
                                              group = group),
                 alpha = 0.8, colour = 'grey18', size = 0.15) +
    scale_fill_manual(name = "SIMD Ranking", values = clrs) +
    guides(fill = guide_legend(override.aes = list(colour = NULL))) +
    theme_map() +
    theme(legend.background = element_rect(colour = 'black'),
          plot.title = element_text(face = 'bold', size = 11),
          legend.position = c(0.71,0.28),
          legend.key.size = unit(2.5, "mm"),
          #   legend.text = element_text(size = 5),
          legend.title = element_text(face = 'bold'),
          legend.background = element_rect(size = 0.05, colour = 'black',
                                           linetype = 'solid'),
          plot.margin = unit(rep(0,4),"mm"),
          panel.margin = unit(rep(1,4),"mm"))
  
  map_abdn_dzs_b
  
})

})