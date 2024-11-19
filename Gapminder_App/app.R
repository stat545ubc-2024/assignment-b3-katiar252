library(shiny)
library(gapminder)
library(tidyverse)

# Define UI for gapminder application, which plots a graph and creates an interactive table
ui <- fluidPage(

    # Application title
    titlePanel("Gapminder Application"),

    ## Feature 1: Create sidebar which allows users to define a continent and then countries within that continent ##
    #This feature is useful because the "country" options automatically update based on the selected continent, and
    #the users can choose multiple options (up to 10).

    sidebarLayout(
        sidebarPanel(
            selectInput("continentInput", "Select Continent:",
                        choices = c("Africa", "Americas", "Asia", "Europe", "Oceania")),

            #select up to 10 countries (changes based on selected continent)
            selectizeInput("countryInput", "Select Countries (Choose up to 10):",
                        choices = NULL, multiple = TRUE, options = list(maxItems = 10)),
        ),

        ## Feature 2: Generate two separate main tabs: one showing a Life Expectancy Plot, another showing the filtered data table ##
        #This feature makes the app more readable; users can individually look at the plot and the data table.
        mainPanel(
           tabsetPanel(
             tabPanel("Life Expectancy Plot",
                      plotOutput("lifeExp_Plot"),
                      br(),
                      downloadButton("downloadPlot", "Download Plot as PNG")),

             ##Feature 3: Generate Interactive Table
             #Here, users can interact with the filtered dataset and sort by their chosen variable.
             tabPanel("Gapminder Data Table",
                      br(),
                      DT::dataTableOutput("resultsTable"))
             )
        )
    )
)


# Define server logic required to draw a plot, allow the user to download the plot, and output a filtered table
server <- function(input, output, session) {

  # observe which continent is selected by user, obtain unique country names for that continent
  observeEvent(input$continentInput, {
    country_choice <- gapminder %>%
      filter(continent == input$continentInput) %>%
      pull(country) %>%
      unique()  #obtain unique country options within the selected continent

    # update country choices for user based on selected continent
    # auto-selection of 1st country in list (alphabetically)
    updateSelectizeInput(session,
                      "countryInput",
                      choices = country_choice,
                      selected = country_choice[1]) #update country choices in dropdown list

  })

  # define a reactive filtered dataset based on input continent and countries
  # "filtered" dataset is used in plotting and table output
  filtered <- reactive({
    req(input$countryInput) #ensure countryInput is present
    gapminder %>%
      filter(continent == input$continentInput) %>%
      filter(country %in% input$countryInput)
  })

  # draw plot showing life expectancy over time for the selected countries
  # each datapoint is shown, with line to demonstrate trends
  lifeExpectancyPlot <- reactive({
    req(filtered()) #double-check that the filtered dataset is present

    ggplot(filtered(), aes(year, lifeExp, color = country))+  #color based on the country
    geom_point()+
    geom_line()+
    labs(title = paste("Life Expectancy over Time in", input$continentInput),
         x = "Year",
         y = "Life Expectancy at Birth (years)")+
    theme_bw()
  })

    #create output plot
    output$lifeExp_Plot <- renderPlot({
        lifeExpectancyPlot()
    })

    #create table using filtered dataset
    #rename the columns for user readability
    output$resultsTable <- DT::renderDataTable ({
      filtered() %>%
        rename("Country" = country,
               "Continent" = continent,
               "Year" = year,
               "Life Expectancy" = lifeExp,
               "Population" = pop,
               "GDP per Capita" = gdpPercap)
    })

    ## Feature 4: download button to download plot as png ##
    #Users are able to download the plot they've generated to their device as a png for subsequent reference
    output$downloadPlot <- downloadHandler(
      filename = function() {
        paste("LifeExpectancyPlot_", Sys.Date(), ".png", sep = "")
      },
      content = function(file) {
        ggsave(filename = file, plot = lifeExpectancyPlot(), device = "png",
               width = 10, height = 8)
      }
    )
}

# Run the application
shinyApp(ui = ui, server = server)
