server <- function(input, output) {
  # demographic eda
  output$demo_1 <- renderHighchart({
    hcboxplot(
      x = demo_1_data$value,
      var = demo_1_data$variable,
      var2 = demo_1_data$class,
      outliers = F,
      color = c("#2980b9", "Red")
    )
  })
  output$demo_2 <- renderHighchart({
    hcboxplot(
      x = demo_2_data$value,
      var = demo_2_data$variable,
      var2 = demo_2_data$class,
      outliers = F,
      color = c("#2980b9", "Red")
    )
  })
  output$demo_3 <- renderHighchart({
    hcboxplot(x = demo_3_data$value,
              var = demo_3_data$variable,
              var2 = demo_3_data$class) %>% hc_colors(c("#2980b9", "Red"))
  })
  output$demo_4 <- renderHighchart({
    hcboxplot(x = demo_4_data$value,
              var = demo_4_data$variable,
              var2 = demo_4_data$class) %>% hc_colors(c("#2980b9", "Red"))
  })
  # restaurant eda
  output$res_1 <- renderHighchart({
    hchart(category_freq,
           'bar',
           hcaes(x = 'category', y = 'density', group = 'class'))
  })
  output$res_2 <- renderHighchart({
    hchart(price_freq,
           'bar',
           hcaes(x = 'price', y = 'density', group = 'class'))
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