#' Total Ozone Daily Observations At Some Selected Locations
#'
#' @description Ozone related data retrieve from World Ozone and Ultraviolet Radiation Data Centre (WOUDC). 
#'
#' @format A dataframe with 36 variables:
#' \describe{
#'   \item{x}{X coordinate of the station.}
#'   \item{y}{Y coordinate of the station.}
#'   \item{identifier}{Identifier of the observation or record.}
#'   \item{dataset_id}{Identifier of the dataset.}
#'   \item{station_id}{Identifier of the observing station.}
#'   \item{station_name}{Name of the observing station.}
#'   \item{station_gaw_id}{Global Atmosphere Watch (GAW) identifier of the station.}
#'   \item{station_gaw_url}{URL associated with the GAW station.}
#'   \item{contributor_name}{Name of the organization contributing the data.}
#'   \item{contributor_id}{Identifier of the data contributor.}
#'   \item{contributor_url}{URL associated with the data contributor.}
#'   \item{country_id}{Identifier of the country.}
#'   \item{country_name_en}{Country name in English.}
#'   \item{country_name_fr}{Country name in French.}
#'   \item{gaw_id}{Global Atmosphere Watch (GAW) identifier.}
#'   \item{instrument_name}{Name of the ozone-measuring instrument.}
#'   \item{instrument_model}{Model of the ozone-measuring instrument.}
#'   \item{instrument_serial}{Serial number of the ozone-measuring instrument.}
#'   \item{observation_date}{Date associated with the observation record.}
#'   \item{daily_date}{Date of the daily ozone observation.}
#'   \item{daily_wlcode}{Wavelength code associated with the daily ozone observation.}
#'   \item{daily_obscode}{Observation code associated with the daily ozone observation.}
#'   \item{daily_columno3}{Daily total column ozone, in Dobson Units (DU).}
#'   \item{daily_stdevo3}{Standard deviation of the daily total column ozone measurements.}
#'   \item{daily_utc_begin}{UTC start time of the daily observation period.}
#'   \item{daily_utc_end}{UTC end time of the daily observation period.}
#'   \item{daily_utc_mean}{Mean UTC time associated with the daily observations.}
#'   \item{daily_nobs}{Number of observations contributing to the daily ozone value.}
#'   \item{daily_mmu}{Daily MMU value associated with the observation.}
#'   \item{daily_columnso2}{Daily total column sulfur dioxide, in Dobson Units (DU).}
#'   \item{monthly_date}{Date associated with the monthly ozone record.}
#'   \item{monthly_columno3}{Monthly total column ozone, in Dobson Units (DU).}
#'   \item{monthly_stdevo3}{Standard deviation of the monthly total column ozone measurements.}
#'   \item{monthly_npts}{Number of observations or points contributing to the monthly ozone value.}
#'   \item{url}{URL associated with the original WOUDC data record.}
#'   \item{source_file}{Name of the source CSV file from which the record was obtained.}
#' }
#'
#' 
#'
#'@source World Ozone and Ultraviolet Radiation Data Centre (WOUDC), Environment and Climate Change Canada. \url{https://woudc.org/}. For a complete list of all contributors, see:
#' https://www.woudc.org/en/contributors
#' 
#'JMA, & NASA-WFF. World Meteorological Organization-Global Atmosphere Watch Program (WMO-GAW)/World Ozone and Ultraviolet Radiation Data Centre (WOUDC). Retrieved October 24, 2013, from https://woudc.org. doi:10.14287/10000001
#' 
#'WMO/GAW Ozone Monitoring Community, World Meteorological Organization-Global Atmosphere Watch Program (WMO-GAW)/World Ozone and Ultraviolet Radiation Data Centre (WOUDC). Retrieved October 24, 2013, from https://woudc.org. A list of all contributors is available on the website. doi:10.14287/10000001
#'
#'WMO/GAW UV Radiation Monitoring Community, World Meteorological Organization-Global Atmosphere Watch Program (WMO-GAW)/World Ozone and Ultraviolet Radiation Data Centre (WOUDC). Retrieved October 24, 2013, from https://woudc.org. A list of all contributors is available on the website. doi:10.14287/10000002
#'
#'Environment and Climate Change Canada, Toronto (n.d.). World Meteorological Organization-Global Atmosphere Watch Program (WMO-GAW)/World Ozone and Ultraviolet Radiation Data Centre (WOUDC). Retrieved October 24, 2013, from https://woudc.org.
#'
#' @examples
#' data("ozonedata")
"ozonedata"