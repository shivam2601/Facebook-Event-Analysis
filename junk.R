if (interactive()) {
  
  ui <- fluidPage(
    uiOutput("moreControls")
  )
  
  server <- function(input, output) {
    output$moreControls <- renderUI({
      tagList(
        sliderInput("n", "N", 1, 1000, 500),
        textInput("label", "Label")
      )
    })
  }
  shinyApp(ui, server)
}


##########################################
value = ~average_count
title = "Average Attending count"
if(input$param == 'total_count'){
  value = ~total_count
  title = "Total Events"
}else if(input$param == 'attending_count'){
  value = ~attending_count
  title = "Total Attending count"
}else if(input$param == 'interested_count'){
  value = ~interested_count
  title = "Total Interested count"
}else if(input$param == 'maybe_count'){
  value = ~maybe_count
  title = "Total Maybe count"
}else if(input$param == 'noreply_count'){
  value = ~noreply_count
  title = "Total No-Reply Count"
}else if(input$param == 'average_count'){
  value = ~average_count
  title = "Average Attending Count"
}

#################################################################

#tags$head(
# tags$style(HTML('#pie{background-color:blue}'))
#),


#################################################################
library(maps)
library(ggplot2)
world_map <- map_data("world")

p <- ggplot() + coord_fixed() +
  xlab("") + ylab("")

#Add map to base plot
base_world_messy <- p + geom_polygon(data=world_map, aes(x=long, y=lat, group=group), 
                                     colour="light green", fill="light green")

base_world_messy

#Strip the map down so it looks super clean (and beautiful!)
cleanup <- 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_rect(fill = 'white', colour = 'white'), 
        axis.line = element_line(colour = "white"), legend.position="none",
        axis.ticks=element_blank(), axis.text.x=element_blank(),
        axis.text.y=element_blank())

base_world <- base_world_messy + cleanup

base_world

#plot
map_data <- 
  base_world +
  geom_point(data=cities, 
             aes(x=Longitude, y=Latitude), colour="Deep Pink", 
             fill="Pink",pch=21, size=5, alpha=I(0.7))

map_data



if(input$geo_cat == "All"){
  base_world + geom_point(data = geo_data, 
                          aes(x=longitude, y=latitude, fill = category), 
                          pch=21,size=4, alpha=I(0.7), show.legend = TRUE)
}
if(input$geo_cat != "All")
{
  if(input$geo_cat == "Travel") geo_cat = "travel"
  else if(input$geo_cat == "Food") geo_cat = "food"
  else if(input$geo_cat == "Music") geo_cat = "music"
  else if(input$geo_cat == "Art") geo_cat = "art"
  else if(input$geo_cat == "Education") geo_cat = "education"
  base_world + geom_point(data = geo_data[geo_data$category == geo_cat,], 
                          aes(x=longitude, y=latitude), fill = "Red",
                          pch=21,size=4, alpha=I(0.7), show.legend = TRUE)
}