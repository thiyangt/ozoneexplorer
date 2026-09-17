#' Spiral plot of missing daily ozone observations
#'
#' Creates a spiral visualization showing missing and observed daily total
#' column ozone observations for a selected station and period of years.
#' Each complete circle represents one year. Missing daily observations are
#' shown in black and observed daily observations are shown in grey.
#'
#' @param data A data frame containing WOUDC ozone data. The data frame must
#'   contain `station_name`, `daily_date`, and `daily_columno3`.
#' @param station A character string specifying the station to plot.
#' @param years A numeric vector specifying the years to include.
#' @param ring_spacing A numeric value specifying the radial spacing between
#'   successive yearly rings. Defaults to `2`.
#'
#' @return A ggplot object.
#'
#' @examples
#' \dontrun{
#' spiral_missing(
#'   ozonedata,
#'   station = "Irene",
#'   years = 2015:2016
#' )
#' }
#'
#' @export
#'
spiral_missing <- function(data, station, years, ring_spacing = 2) {
  
  plot_data <- data |>
    dplyr::mutate(
      daily_date = as.Date(daily_date),
      daily_columno3 = as.numeric(daily_columno3)
    ) |>
    dplyr::filter(
      station_name == station,
      lubridate::year(daily_date) %in% years
    )
  
  complete_dates <- tidyr::expand_grid(
    year = years,
    day_of_year = 1:365
  ) |>
    dplyr::mutate(
      date = as.Date(
        paste0(year, "-", day_of_year),
        format = "%Y-%j"
      )
    ) |>
    dplyr::filter(
      lubridate::year(date) == year
    )
  
  plot_data <- complete_dates |>
    dplyr::left_join(
      plot_data |>
        dplyr::mutate(
          year = lubridate::year(daily_date),
          day_of_year = lubridate::yday(daily_date)
        ) |>
        dplyr::select(
          year,
          day_of_year,
          daily_columno3
        ),
      by = c("year", "day_of_year")
    ) |>
    dplyr::mutate(
      status = dplyr::if_else(
        is.na(daily_columno3),
        "Missing",
        "Observed"
      )
    )
  
  ggplot2::ggplot(
    plot_data,
    ggplot2::aes(
      x = day_of_year,
      y = year * ring_spacing,
      fill = status
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
      values = c(
        "Missing" = "black",
        "Observed" = "grey80"
      )
    ) +
    ggplot2::labs(
      title = paste("Missing Daily Ozone Observations —", station),
      subtitle = paste(min(years), "to", max(years)),
      x = NULL,
      y = NULL,
      fill = NULL
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      panel.grid = ggplot2::element_blank()
    )
}
