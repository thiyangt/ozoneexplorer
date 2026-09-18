#' Interactive Linked Ozone Time-Series and Spiral Plot
#'
#' Creates an interactive cross-linked visualization of daily total
#' column ozone. Clicking an observation in the time-series plot
#' highlights the corresponding observation in the spiral plot,
#' and vice versa.
#'
#' @param data A data frame containing ozone observations.
#' @param station Character string giving the station name.
#' @param years Numeric vector of years to display.
#' @param ring_spacing Numeric value controlling the spacing between
#'   spiral rings.
#'
#' @return A Shiny application.
#'
#' @importFrom dplyr filter mutate
#' @importFrom shiny fluidPage sidebarLayout sidebarPanel mainPanel
#'   selectInput sliderInput
#' @importFrom plotly plot_ly layout renderPlotly plotlyOutput
#' @export
interactive_ozone <- function(
    data,
    station,
    years,
    ring_spacing = 2
) {
  
  library(shiny)
  library(plotly)
  library(dplyr)
  
  ozone <- data |>
    filter(
      station_name == station,
      lubridate::year(as.Date(daily_date)) %in% years
    ) |>
    mutate(
      daily_date = as.Date(daily_date),
      daily_columno3 = as.numeric(daily_columno3)
    ) |>
    filter(
      !is.na(daily_date),
      !is.na(daily_columno3)
    ) |>
    arrange(daily_date) |>
    mutate(
      id = seq_len(n()),
      year = lubridate::year(daily_date),
      day_of_year = lubridate::yday(daily_date),
      theta = 2 * pi * (day_of_year - 1) / 365.25 +
        2 * pi * (year - min(year)),
      radius = (year - min(year)) * ring_spacing +
        daily_columno3 / max(daily_columno3) * ring_spacing,
      x = radius * cos(theta),
      y = radius * sin(theta)
    )
  
  ui <- fluidPage(
    
    titlePanel(
      paste(
        "Ozone Explorer:",
        station
      )
    ),
    
    sidebarLayout(
      
      sidebarPanel(
        selectInput(
          "year",
          "Year",
          choices = c(
            "All",
            sort(unique(ozone$year))
          ),
          selected = "All"
        )
      ),
      
      mainPanel(
        
        plotlyOutput(
          "timeseries",
          height = "400px"
        ),
        
        plotlyOutput(
          "spiral",
          height = "600px"
        ),
        
        tags$hr(),
        
        textOutput("selected")
      )
    )
  )
  
  server <- function(input, output, session) {
    
    filtered_data <- reactive({
      
      if (input$year == "All") {
        ozone
      } else {
        ozone |>
          filter(year == as.numeric(input$year))
      }
      
    })
    
    output$timeseries <- renderPlotly({
      
      d <- filtered_data()
      
      plot_ly(
        d,
        x = ~daily_date,
        y = ~daily_columno3,
        type = "scatter",
        mode = "lines+markers",
        customdata = ~id,
        key = ~id,
        line = list(width = 1),
        marker = list(size = 5),
        source = "ozone"
      ) |>
        layout(
          title = paste(
            "Daily Total Column Ozone —",
            station
          ),
          xaxis = list(
            title = "Date"
          ),
          yaxis = list(
            title = "Total Column Ozone (DU)"
          ),
          hovermode = "closest"
        )
    })
    
    output$spiral <- renderPlotly({
      
      d <- filtered_data()
      
      plot_ly(
        d,
        x = ~x,
        y = ~y,
        type = "scatter",
        mode = "lines+markers",
        customdata = ~id,
        key = ~id,
        marker = list(size = 6),
        line = list(width = 1),
        source = "ozone"
      ) |>
        layout(
          title = "Spiral Time Series",
          xaxis = list(
            title = "",
            showticklabels = FALSE,
            zeroline = FALSE
          ),
          yaxis = list(
            title = "",
            showticklabels = FALSE,
            zeroline = FALSE,
            scaleanchor = "x"
          ),
          hovermode = "closest"
        )
    })
    
    selected <- reactiveVal(NULL)
    
    observeEvent(
      event_data(
        "plotly_click",
        source = "ozone"
      ),
      {
        
        click <- event_data(
          "plotly_click",
          source = "ozone"
        )
        
        if (!is.null(click$key)) {
          selected(click$key)
        }
      }
    )
    
    observeEvent(selected(), {
      
      id <- selected()
      
      # Highlight the selected observation in both plots
      plotlyProxy(
        "timeseries",
        session
      ) |>
        plotlyProxyInvoke(
          "restyle",
          list(
            selectedpoints = list(
              which(
                filtered_data()$id == as.numeric(id)
              )
            )
          )
        )
      
      plotlyProxy(
        "spiral",
        session
      ) |>
        plotlyProxyInvoke(
          "restyle",
          list(
            selectedpoints = list(
              which(
                filtered_data()$id == as.numeric(id)
              )
            )
          )
        )
    })
    
    output$selected <- renderText({
      
      req(selected())
      
      d <- ozone |>
        filter(id == as.numeric(selected()))
      
      paste0(
        "Selected: ",
        format(d$daily_date, "%d %B %Y"),
        " | Ozone: ",
        round(d$daily_columno3, 1),
        " DU"
      )
    })
  }
  
  shinyApp(ui, server)
}