#' Spiral plot of categorized daily total column ozone
#'
#' Creates a spiral time-series visualization of categorized daily total
#' column ozone observations for a selected station and period of years.
#' Each complete circle represents one year, with days of the year mapped
#' around the circle. Ozone observations are categorized according to
#' user-defined break points and displayed using a colour-blind-friendly
#' categorical colour scheme. The radial spacing between years can be
#' controlled using `ring_spacing`.
#'
#' @param data A data frame containing WOUDC ozone data. The data frame must
#'   contain the variables `station_name`, `daily_date`, and
#'   `daily_columno3`.
#' @param station A character string specifying the station to plot.
#' @param years A numeric vector specifying the years to include in the plot.
#' @param breaks A numeric vector specifying the break points used to
#'   categorize daily total column ozone values.
#' @param labels An optional character vector providing labels for the ozone
#'   categories. If `NULL`, category labels are generated from `breaks`.
#' @param ring_spacing A numeric value specifying the radial spacing between
#'   successive yearly rings. Defaults to `2`.
#'
#' @return A ggplot object.
#'
#' @examples
#' \dontrun{
#' spiral_ozone_category(
#'   ozonedata,
#'   station = "Irene",
#'   years = 2015:2020,
#'   breaks = c(0, 200, 250, 300, 350, Inf),
#'   labels = c(
#'     "<200",
#'     "200-250",
#'     "250-300",
#'     "300-350",
#'     ">=350"
#'   )
#' )
#' }
#'
#' @export
#'
spiral_ozone_category <- function(data, station, years, breaks,
                                  labels = NULL, ring_spacing = 2) {
  
  plot_data <- data |>
    dplyr::filter(
      station_name == station,
      lubridate::year(as.Date(daily_date)) %in% years
    ) |>
    dplyr::mutate(
      daily_date = as.Date(daily_date),
      daily_columno3 = as.numeric(daily_columno3),
      year = lubridate::year(daily_date),
      day_of_year = lubridate::yday(daily_date)
    ) |>
    dplyr::filter(
      !is.na(daily_columno3),
      !is.na(daily_date)
    ) |>
    dplyr::mutate(
      category = cut(
        daily_columno3,
        breaks = breaks,
        labels = labels,
        include.lowest = TRUE,
        right = FALSE
      )
    )
  
  # Colour-blind-friendly Okabe-Ito palette
  colour_blind_palette <- c(
    "#0072B2",
    "#56B4E9",
    "#009E73",
    "#E69F00",
    "#D55E00",
    "#CC79A7",
    "#F0E442",
    "#000000"
  )
  
  ggplot2::ggplot(
    plot_data,
    ggplot2::aes(
      x = day_of_year,
      y = year * ring_spacing,
      fill = category
    )
  ) +
    ggplot2::geom_tile(
      width = 1,
      height = 1
    ) +
    ggplot2::coord_polar(theta = "x") +
    ggplot2::scale_x_continuous(
      breaks = c(
        1, 32, 60, 91, 121, 152,
        182, 213, 244, 274, 305, 335
      ),
      labels = month.abb,
      minor_breaks = NULL
    ) +
    ggplot2::scale_y_continuous(
      breaks = years * ring_spacing,
      labels = years
    ) +
    ggplot2::scale_fill_manual(
      values = colour_blind_palette[seq_along(levels(plot_data$category))]
    ) +
    ggplot2::labs(
      title = paste("Daily Total Column Ozone —", station),
      subtitle = paste(min(years), "to", max(years)),
      x = NULL,
      y = NULL,
      fill = "Ozone"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      panel.grid = ggplot2::element_blank()
    )
}
