# ui.R
library('shiny')
require('datasets')
require('ggplot2')
require('readr')
require('dplyr')
require('leaflet')
require('forcats')

#------------------Reading and Transforming Tree Data--------------------------#

tree_data <- read_csv('PE2_R_Tree_Data.csv')

tree_count <- count(tree_data, Genus)
tree_count <- tree_count[order(-tree_count$n),]
tree_count_t5 <- tree_count[1:5,]

# Define UI for application that draws a histogram
shinyUI(fixedPage(
    titlePanel(
        "Common Trees around Fitzroy Gardens",
    ),

#------------------Visual 1 Text-----------------------------------------------#

    absolutePanel( 
        top = "70px",
        width = "300px", 
        height = "100px",
        left = "70px",
        h3("The Top 5 Trees"),
        textOutput("vis1txt")
    ),

#------------------Visual 1 Plot-----------------------------------------------#

    absolutePanel(
        top = "220px", 
        width = "330px", 
        left = "35px",
        height = "100px", 
        plotOutput("vis1")
    ),
    
#------------------Visual 2 Text-----------------------------------------------#

    absolutePanel( 
        top = "620px",
        width = "300px", 
        height = "100px",
        left = "70px",
        h3("Life Expectancy"),
        textOutput("vis2txt")
    ),
    
#------------------Visual 2 Plot-----------------------------------------------#

    absolutePanel(
        top = "560px", 
        width = "500px", 
        height = "200px", 
        left = "470px",
        plotOutput("vis2") 
    ),
    
#------------------Map Plot----------------------------------------------------#

    absolutePanel(
        top = "117px", 
        width = "500px", 
        left = "500px", 
        leafletOutput("testLeaf")
    ),
    
#------------------Genus Checkbox----------------------------------------------#

    absolutePanel(
        
        top = "80px", 
        left = "380px",
        checkboxGroupInput("trees", "Genera", sort(tree_count_t5$Genus))
    )
))