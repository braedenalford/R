# server.R
library('shiny')

shinyServer(function(input, output) {
    
#------------------Reading and Transforming Tree Data--------------------------#
    
    tree_data <- read_csv('PE2_R_Tree_Data.csv')
    
    tree_count <- count(tree_data, Genus)
    tree_count <- tree_count[order(-tree_count$n),]
    tree_count_t5 <- tree_count[1:5,]
    
    tree_data_t5 <- tree_data%>%
        filter(Genus %in% tree_count_t5$Genus)
    
    tree_life_t5 <- select(tree_data_t5, Genus, Useful.Life.Expectancy.Value)
    
#------------------Map Plot Using Leaflet--------------------------------------#
    
    output$testLeaf <- renderLeaflet({
        tree_data_t5_filter <- filter(tree_data_t5, tree_data_t5$Genus %in% input$trees)
        
        pal <- colorFactor(c("#11A722","#36A9D3","#D00000","#F9C80E","#3D2D8B"), domain = tree_count_t5$Genus)
        
        #Map will show all genera if empty, otherwise show selected
        
        if(length(tree_data_t5_filter$Genus) == 0){                
            map <- leaflet(tree_data_t5) %>% addTiles() 
            map <- map %>% setView(144.978, -37.8138, 16)
            map <- map %>% addCircleMarkers(
                    radius = tree_data_t5$Diameter.Breast.Height*0.01, 
                    opacity = 1,
                    fillOpacity = 1,
                    color = ~pal(Genus))
            map <- map %>% addLegend("bottomleft", pal, tree_count_t5$Genus, opacity = 1,title = "Genera")
        }
        
        else{
            map <- leaflet(tree_data_t5_filter) %>% addTiles()  
            map <- map %>% setView(144.978, -37.8138, 16)
            map <- map %>% addCircleMarkers(
                    radius = tree_data_t5_filter$Diameter.Breast.Height*0.01, 
                    opacity = 1,
                    fillOpacity = 1,
                    color = ~pal(Genus))
            map <- map %>% addLegend("bottomleft", pal, tree_data_t5_filter$Genus, opacity = 1,title = "Genera")
        }
        map
    })
    
#------------------Visual 1 Bar Chart------------------------------------------#
    
    output$vis1 <- renderPlot({
        v1plot <- tree_count_t5%>%
            mutate(Genus = fct_reorder(Genus, n))%>%
            ggplot(aes(Genus, n)) + 
            geom_bar(stat = 'identity', fill = '#C8FACC', color = 'black') + 
            geom_text(aes(label = n), vjust = -0.5, colour = "black") +
            labs(title = 'Top 5 Genera by count', x = 'Genus', y = 'Count')
        v1plot
    })
    
#------------------Visual 2 Box Plot-------------------------------------------#
    
    output$vis2 <- renderPlot({
        tree_life_t5 <- select(tree_data_t5, Genus, Useful.Life.Expectancy.Value)
        
        tree_life_t5%>%
            ggplot(aes(Genus,Useful.Life.Expectancy.Value)) + 
            geom_boxplot(fill = '#C8FACC') +
            labs(title = "Distribution of Life Expectancy", x = "Genus", y = "Useful Life Expectancy (Years)")
    })
    
#------------------Visual 1 Text-----------------------------------------------#
    
    output$vis1txt <- renderText({
        paste("It is clear to see that Ulmus is by far the most prevalent genus in the Fitzroy Gardens, whereas Corymbia, Ficus, and Quercus are quite similar.")
    })
    
#------------------Visual 2 Text-----------------------------------------------#
    
    output$vis2txt <- renderText({
        paste("We can see that the two most common tree genera actually have the lowest useful life expectancy, which is surprising, however these two genera are most likely chosen for their look or another factor, rather than their life expectancy. Furthermore we can see that most of the Corymbia genus has an expectancy value of 60, with all other values being labelled as outliers. Lastly, the Quercus genus has the largest expectancy value with at least 50% of the trees at a value of 60 or 80, while the Ficus genus has a wide distribution with no outliers as a result. ")
    })
})
