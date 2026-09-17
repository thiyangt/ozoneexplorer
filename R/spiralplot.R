#' Spiral plot of daily total column ozone
#'
#' Creates a spiral time-series visualization of daily total column ozone
#' observations for a selected station and period of years. Each complete
#' circle represents one year, with days of the year mapped around the circle
#' and ozone values represented by colour. The radial spacing between years
#' can be controlled using `ring_spacing`.
#'
#' @param data A data frame containing WOUDC ozone data. The data frame must
#'   contain the variables `station_name`, `daily_date`, and
#'   `daily_columno3`.
#' @param station A character string specifying the station to plot.
#' @param years A numeric vector specifying the years to include in the plot.
#' @param ring_spacing A numeric value specifying the radial spacing between
#'   successive yearly rings. Defaults to `2`.
#'
#' @return A ggplot object.
#'
#' @examples
#' \dontrun{
#' spiral_ozone(
#'   ozonedata,
#'   station = "Irene",
#'   years = 2015:2016,
#'   ring_spacing = 2
#' )
#' }
#'
#' @export
#'
#' @importFrom dplyr filter mutate
#' @importFrom lubridate year yday
#' @importFrom ggplot2 ggplot aes geom_tile coord_polar
#'   scale_x_continuous scale_y_continuous scale_fill_viridis_c
#'   labs theme_minimal theme element_blank
#'
spiral_ozone <- function(data, station, years, ring_spacing = 2) {
  
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
    )
  
  ggplot2::ggplot(
    plot_data,
    ggplot2::aes(
      x = day_of_year,
      y = year * ring_spacing,
      fill = daily_columno3
    )
  ) +
    ggplot2::geom_tile(width = 1, height = 1) +
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
    ggplot2::scale_fill_viridis_c(
      name = "Ozone (DU)"
    #  option = "plasma"
    ) +
    ggplot2::labs(
      title = paste("Daily Total Column Ozone —", station),
      subtitle = paste(min(years), "to", max(years)),
      x = NULL,
      y = NULL
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      panel.grid = ggplot2::element_blank()
    )
}

