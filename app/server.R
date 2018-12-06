server <- function(input, output) {
  # What is gentrification
  output$text3 <- renderText({
    paste("<font color=\"#666666\"><font size=4><b>Gentrification</b> has 
          become the accepted term to describe neighborhoods that start 
          off predominantly occupied by households of relatively low socioeconomic 
          status, and then experience an inflow of higher socioeconomic status households.</br>",
          "</br>","The word is applied broadly and interchangeably to describe a range of
          neighborhood changes, including rising incomes, changing racial composition, shifting
          commercial activity, and displacement of original residents.</font></br>","</br>")
  })
  # Signs of gentrification
  output$text4 <- renderText({
    paste("<font color=\"#666666\"><font size=4>There were 22 NYC Sub-Borough Areas (SBA) that were low-income in 1990 (in the bottom 40 percent
           with respect to average household income) experienced rent growth
           between 1990 and 2010-2014. According to a study by NYU Furman Center, 15 of them were classified as “gentrifying,” meaning they
           experienced rent increases higher than the median SBA. The map shows that gentrifying neighborhoods are concentrated in or 
           near Manhattan. The remaining seven low-income neighborhoods are classified as “non-gentrifying” neighborhoods. 
          Neighborhoods in the top 60 percent of the 1990 neighborhood income distribution are classified as “higher-income.”</font></br></br>")
  })
  # demographic eda
  output$demo_1 <- renderHighchart({
    hcboxplot(
      x = demo_1_data$value,
      var = demo_1_data$variable,
      var2 = demo_1_data$class,
      outliers = F,
      color = c("#2980b9", "Red")
    ) %>% hc_xAxis(categories=list("Poverty rate, population under 18 years old",
                                   "Poverty rate, population aged 65+",
                                   "Poverty rate",
                                   "% of car-free commuters",
                                   "Population aged 65+",
                                   "Population aged 25+ without a high school diploma",
                                   "Population aged 25+ with a bachelor's degree or higher",
                                   "Disconnected youth",
                                   "Households with children under 18 years old",
                                   "Single-person households",
                                   "Born in New York State",
                                   "Percent white",
                                   "Percent Hispanic",
                                   "Percent black",
                                   "Percent Asian",
                                   "Racial diversity index",
                                   "Foreign-born population",
                                   "Unemployment rate",
                                   "Labor force participation rate",
                                   "Within 1/2 mile of a subway station"
                                   ))
  })
  output$demo_2 <- renderHighchart({
    hcboxplot(
      x = demo_2_data$value,
      var = demo_2_data$variable,
      var2 = demo_2_data$class,
      outliers = F,
      color = c("#2980b9", "Red")
    ) %>% hc_xAxis(categories=list("Population"))
  })
  output$demo_3 <- renderHighchart({
    hcboxplot(x = demo_3_data$value,
              var = demo_3_data$variable,
              var2 = demo_3_data$class) %>% 
      hc_colors(c("#2980b9", "Red")) %>%
      hc_xAxis(categories=list("Income diversity ratio",
                               "Mean travel time to work",
                               "Serious crime rate, violent",
                               "Serious crime rate, property",
                               "Serious crime rate"
                               ))
  })
  output$demo_4 <- renderHighchart({
    hcboxplot(x = demo_4_data$value,
              var = demo_4_data$variable,
              var2 = demo_4_data$class) %>%
      hc_colors(c("#2980b9", "Red")) %>%
      hc_xAxis(categories=list("Median rent burden"))
  })
  # restaurant eda
  output$res_1 <- renderHighchart({
    hchart(category_freq,
           'bar',
           hcaes(x = 'category', y = 'density', group = 'class')) %>% 
      hc_title(text="Food Category",style=list(fontWeight="bold",fontSize="15px")) %>% hc_xAxis(title = list(text = NULL))
  })
  output$res_2 <- renderHighchart({
    hchart(price_freq,
           'bar',
           hcaes(x = 'price', y = 'density', group = 'class')) %>%
      hc_title(text="Price Level",style=list(fontWeight="bold",fontSize="15px")) %>% hc_xAxis(title = list(text = NULL))
  })
  # model output - SHAP
  output$text0 <- renderText({
    paste("<font color=\"#404040\"><font size=6><b>", "Define Popularity Index", "</b></font></br>",
          "<font color=\"#666666\"><font size=4>","Adjust the over-high ratings with only a small number of reviews to evaluate the successfulness of a restaurant.","</br>",
          "<font color=\"#666666\"><font size=4>","For example, if a restaurant is rated as 5-star with only one review, we considered it as an over rating and downscaled it to around 4.3 stars","</font>","</br>")
  })
  output$text1 <- renderText({
    paste("<font color=\"#404040\"><font size=6><b>","What Affects Restaurant Popularity? Are There Differences between Gentrifying and Non-Gentrifying Areas?","</b></font>","</br>",
          "</br>",
          "<font color=\"#666666\"><font size=5><b><li>","First Step: Land Your Restaurant in the Right Place","</li></b></font></br>",
          "<font color=\"#666666\"><font size=4>","Explore the relationship between the sub-borough statistics and restaurant popularity","</br>",
          "Regress the popularity scores on the demographic variables using <code>XGboost</code> model","</br>",
          "<div class = \"indented\">","Use SHAP plots to show the feature importance and how the strongest predictors affect the popularity (left: Gentrifying areas; right: Non-gentrifying areas).","</font></br>",
          "<font size=3><i><ul><li>","Each row represents a predictor and every restaurant has one dot on each row.","</li>",
          "<li>","The horizontal position of the dot is the impact of that predictor on the popularity score.","</li>",
          "<li>","The color of the dot represents the value of that predictor (with red color representing higher scores and blue representing lower ones).","</li></ul></i></font></div>",
          "</br>"
          )
  })
  output$text2 <- renderText({
    paste("<font color=\"#666666\"><font size=5><b><li>","Second Step: Find Your Customers’ Taste","</li></b></font>","</br>",
          "<font color=\"#666666\"><font size=4>","Explore the effect of pricing and service types using <code>XGboost</code>","</br>",
          "Regress the residuals obtained from the first step on the restaurant variables","</font></br>",
          "</br>")
  })
  # map
  filter_react <- eventReactive(input$submit, {
    return(list(
      demographic = input$demo,
      categories = input$catego,
      prices = input$price
    ))
  }, ignoreNULL = FALSE)
  # leaflet map for gentrifying areas
  output$map_gen <- renderLeaflet({
    filters <- filter_react()
    demographic <- filters[['demographic']]
    categories <- filters[['categories']]
    prices <- filters[['prices']]
    gentri_plot <-
      gentri_data[rowSums(cbind(gentri_data[, categories], gentri_data[, prices])) >
                    0,]
    
    heat_color <-
      colorNumeric(palette = "Blues",
                   domain = c(
                     demographic_info[, demographic],
                     3 * min(demographic_info[, demographic]) -
                       max(demographic_info[, demographic])
                   ))
    rest_color <-
      colorNumeric(palette = "Reds", domain = unique(c(
        gentri_data$rating_adj, nongen_data$rating_adj
      )))
    leaflet(PUMA_Demo_gen) %>%
      setView(lat = 40.76,
              lng = -73.93,
              zoom = 11) %>%
      addProviderTiles("CartoDB.Positron", options = providerTileOptions(opacity = 0.99)) %>%
      addPolygons(
        stroke = F,
        color = ~ heat_color(PUMA_Demo_gen@data[, demographic]),
        fillOpacity = 0.8,
        smoothFactor = 0.2
      ) %>%
      addLegend(
        "bottomright",
        pal = heat_color,
        values = ~ PUMA_Demo_gen@data[, demographic],
        title = "Demographic",
        opacity = 1
      )  %>%
      addCircleMarkers(
        data = gentri_plot,
        lng = ~ longitude,
        lat = ~ latitude,
        radius = 3,
        color = ~ rest_color(gentri_plot$rating_adj),
        popup = paste(
          gentri_plot$name,
          "<br>",
          "Popularity Score:",
          gentri_plot$rating_adj
        )
      )
  })
  # leaflet map for non-gentrified areas
  output$map_nongen <- renderLeaflet({
    filters <- filter_react()
    demographic <- filters[['demographic']]
    categories <- filters[['categories']]
    prices <- filters[['prices']]
    nongen_plot <-
      nongen_data[rowSums(cbind(nongen_data[, categories], nongen_data[, prices])) >
                    0,]
    
    heat_color <-
      colorNumeric(palette = "Blues",
                   domain = c(
                     demographic_info[, demographic],
                     3 * min(demographic_info[, demographic]) -
                       max(demographic_info[, demographic])
                   ))
    rest_color <-
      colorNumeric(palette = "Reds", domain = unique(c(
        gentri_data$rating_adj, nongen_data$rating_adj
      )))
    
    leaflet(PUMA_Demo_nongen) %>%
      setView(lat = 40.76,
              lng = -73.87,
              zoom = 10.8) %>%
      addProviderTiles("CartoDB.Positron", options = providerTileOptions(opacity = 0.99)) %>%
      addPolygons(
        stroke = F,
        color = ~ heat_color(PUMA_Demo_nongen@data[, demographic]),
        fillOpacity = 0.8,
        smoothFactor = 0.2
      ) %>%
      addLegend(
        "bottomright",
        pal = heat_color,
        values = ~ PUMA_Demo_nongen@data[, demographic],
        title = "Demographic",
        opacity = 1
      ) %>%
      addCircleMarkers(
        data = nongen_plot,
        lng = ~ longitude,
        lat = ~ latitude,
        radius = 3,
        color = ~ rest_color(nongen_plot$rating_adj),
        popup = paste(
          nongen_plot$name,
          "<br>",
          "Popularity Score:",
          nongen_plot$rating_adj
        )
      )
  })
}