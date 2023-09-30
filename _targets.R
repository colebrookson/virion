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

source(here::here("./R/functions_data_sourcing.R"))

tar_option_set(packages = c("here", ))
options(dplyr.summarise.inform = FALSE)

list(
  tar_target(
    genbank_download, # target name
    download_genbank(
      url = paste0(
        "https://ftp.ncbi.nlm.nih.gov/genomes/Viruses/AllNuclMetadata/",
        "AllNuclMetadata.csv.gz")
    ))
)