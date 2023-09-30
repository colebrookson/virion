#' File Description
#' AUTHOR: Cole B. Brookson
#' DATE OF CREATION: 2023-09-26
#'
#' This targets file contains all targets to compile the virion database
#'
#'All functions are documented using the roxygen2 framework and the docstring
#'library
#'

library(targets)
library(tarchetypes)
library(here)

source(here::here("./src/R/functions_data_sourcing.R"))
source(here::here("./Code/001_TaxizeFunctions.R"))
source(here::here("./Code/001_Julia functions.R"))

tar_option_set(packages = c("here", "vroom", "data.table", "magrittr", "rglobi",
                            "rentrez", "readr", "dplyr", "tidyr"))
options(dplyr.summarise.inform = FALSE)

# this is necessary for using the NCBI records of more than 10
rentrez::set_entrez_key("ec345b39079e565bdfa744c3ef0d4b03ba08")

list(
  # pull data from web-sources =================================================
  tar_target(
    genbank_download, # target name
    download_genbank( # target function
      url = paste0(
        "https://ftp.ncbi.nlm.nih.gov/genomes/Viruses/AllNuclMetadata/",
        "AllNuclMetadata.csv.gz"),
      ncbi_loc = here::here("./data/web-sourced/"),
      out_loc = here::here("./data/intermediate/")
    )),
  tar_target(
    globi_download, download_globi(
      globi_loc = here::here("./data/web-sourced/")
    )
  )
  # 
)