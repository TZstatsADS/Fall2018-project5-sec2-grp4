ui <- dashboardPage(
  dashboardHeader(title = "Does Gentrification Affect Restaurant Popularity?", titleWidth = 500),
  skin = "red",
  # Sidebar
  dashboardSidebar(
    sidebarMenu(
      id = "menu",
      menuItem("Welcome", tabName = "WelcomePage", icon = icon("book")),
      menuItem("Overview", tabName = "eda", icon = icon("chart-bar")),
      menuItem(
        "Model Output",
        tabName = "model",
        icon = icon("clipboard")
      ),
      menuItem("Map", tabName = "map", icon = icon("map"))
    )
  ),
  # Body
  dashboardBody(tabItems(
    tabItem(tabName = "WelcomePage",
            fluidRow(
              box(
                width = 12,
                title = "What Is Gentrification",
                solidHeader = T,
                status = "primary",
                htmlOutput(outputId="text3"),
                htmlOutput(outputId="text4"),
                img(
                  src = "NYC_sba.png",
                  height = 500,
                  width = 500
                ),
                img(
                  src = "blank.png",
                  height = 500,
                  width = 150
                ),
                img(
                  src = "sba_class.png",
                  height = 500,
                  width = 250
                )
              )
            )),
    tabItem(tabName = "eda",
            tabsetPanel(
              tabPanel('Demographic Features', fluidRow(
                box(
                  width = 12,
                  status = "primary",
                  highchartOutput(outputId = "demo_1", height = 500)
                ),
                box(
                  width = 12,
                  status = "primary",
                  highchartOutput(outputId = "demo_2", height = 125)
                ),
                box(
                  width = 12,
                  status = "primary",
                  highchartOutput(outputId = "demo_3", height = 250)
                ),
                box(
                  width = 12,
                  status = "primary",
                  highchartOutput(outputId = "demo_4", height = 125)
                )
              )),
              tabPanel('Restaurants Features', fluidRow(
                box(
                  width = 12,
                  status = "primary",
                  highchartOutput(outputId = "res_1", height = 800)
                ),
                box(
                  width = 12,
                  status = "primary",
                  highchartOutput(outputId = "res_2", height = 200)
                )
              ))
            )),
    tabItem(tabName = "model",
            fluidRow(
              box(
                width = 12,
                status = "primary",
                htmlOutput(outputId="text0")
              ),
              box(
                width = 12,
                status = "primary",
                htmlOutput(outputId="text1"),
                img(
                  src = "Gentri_step1.png",
                  height = 300,
                  width = 500
                ),
                img(
                  src = "Nongen_step1.png",
                  height = 300,
                  width = 500
                ),
                htmlOutput(outputId="text2"),
                img(
                  src = "Gentri_step2.png",
                  height = 300,
                  width = 500
                ),
                img(
                  src = "Nongen_step2.png",
                  height = 300,
                  width = 500
                )
              )
            )),
    tabItem(tabName = "map",
            fluidRow(box(
              width = 12,
              status = "primary",
              fluidRow(
                column(
                  5,
                  "Sub-borough Filters:",
                  selectInput(
                    "demo",
                    label = "Demographics of Sub-boroughs",
                    choices = list(
                      "Poverty rate, population under 18 years old" = 'pop_pov_u18_pct',
                      "Poverty rate, population aged 65+" =
                        'pop_pov_65p_pct',
                      "Poverty rate" =
                        'pop_pov_pct',
                      "Income diversity ratio" =
                        'income_diversity_ratio',
                      "Median rent burden" =
                        'rent_burden_med',
                      "Population" =
                        'pop_num',
                      "Population aged 65+" =
                        'pop_65p_pct',
                      "Population aged 25+ without a high school diploma" =
                        'pop_edu_nohs_pct',
                      "Population aged 25+ with a bachelor's degree or higher" =
                        'pop_edu_collp_pct',
                      "Disconnected youth" =
                        'pop_discon_youth_pct',
                      "Households with children under 18 years old" =
                        'hh_u18_pct',
                      "Single-person households" =
                        'hh_alone_pct',
                      "Born in New York State" =
                        'pop_bornstate_pct',
                      "Foreign-born population" =
                        'pop_foreign_pct',
                      "Percent white" =
                        'pop_race_white_pct',
                      "Percent Hispanic" =
                        'pop_race_hisp_pct',
                      "Percent black" =
                        'pop_race_black_pct',
                      "Percent Asian" =
                        'pop_race_asian_pct',
                      "Racial diversity index" =
                        'pop_race_div_idx',
                      "Unemployment rate" =
                        'pop_unemp_pct',
                      "Labor force participation rate" =
                        'pop_laborforce_pct',
                      "Mean travel time to work" =
                        'pop_commute_time_avg',
                      "% of car-free commuters" =
                        'pop_commute_carfree_pct',
                      "Within 1/2 mile of a subway station" =
                        'm_prox_subway_pct',
                      "Serious crime rate, violent" =
                        'm_crime_viol_rt',
                      "Serious crime rate, property" =
                        'm_crime_prop_rt',
                      "Serious crime rate" =
                        'm_crime_all_rt'
                    ),
                    selected = 'pop_pov_u18_pct'
                  )
                ),
                column(
                  5,
                  "Restaurant Filters:",
                  pickerInput(
                    "catego",
                    label = "Categories",
                    choices = colnames(gentri_data)[8:52],
                    selected = colnames(gentri_data)[8:52],
                    options = list(`actions-box` = TRUE),
                    multiple = TRUE
                  ),
                  pickerInput(
                    "price",
                    label = "Price",
                    choices = colnames(gentri_data)[54:57],
                    selected = colnames(gentri_data)[54:57],
                    options = list(`actions-box` = TRUE),
                    multiple = TRUE
                  )
                ),
                column(2, actionButton(inputId = "submit", label = "Submit", icon = icon("refresh")))
              )
            )),
            fluidRow(
              box(
                width = 6,
                title = "Gentrifying Areas",
                solidHeader = T,
                status = "primary",
                leafletOutput(outputId = "map_gen", height = 500)
              ),
              box(
                width = 6,
                title = "Non Gentrified Areas",
                solidHeader = T,
                status = "primary",
                leafletOutput(outputId = "map_nongen", height = 500)
              )
            ))
    
  ))
)
