## code to prepare `DATASET` dataset goes here

usethis::use_data(DATASET, overwrite = TRUE)

## Website
# https://www.woudc.org/en/data/data-search-and-download/

usethis::create_package("C:/ozoneexplorer")

library(readr)
library(dplyr)
library(purrr)

data <- list.files(
  ".",
  pattern = "\\.csv$",
  full.names = TRUE,
  ignore.case = TRUE
) |>
  map_dfr(
    \(file) read_csv(
      file,
      col_types = cols(.default = col_character()),
      show_col_types = FALSE
    ) |>
      mutate(source_file = basename(file))
  )
dim(data)
ozonedata <- data
usethis::use_data(ozonedata, overwrite = TRUE)
colnames(data)





