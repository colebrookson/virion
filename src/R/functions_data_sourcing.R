#' External data sourcing
#' 
#' There are a number of data streams that get pulled into this analysis. All
#' the functions that do the web scraping for any data hosted outside of a 
#' flat file happens here
#' 

#' download_genbank
#' 
#' @description Pull GenBank from the NCBI database for incorporation into 
#' virion
#' 
#' @param url chr. The url to point to the GenBank "AllNuclMetadata" compressed
#' csv file
#' @param ncbi_loc chr. The output location of the file to be written
#' @param out_loc chr. The location of the file with just the objects we want
#' and need
#' 
#' @return sequences
download_genbank <- function(url, ncbi_loc, out_loc) {
  
  # pull the file from the web
  system(paste0("wget ", url, " -P ", ncbi_loc))
  
  # read it in so we can keep only the parts we want 
  seq <- data.table::fread(
    paste0(here::here(), ncbi_loc, "AllNuclMetadata.csv.gz"),
    select = c("#Accession", "Release_Date", "Species", 
               "Host", "Collection_Date")) %>% 
    dplyr::rename(Accession = `#Accession`)
  
  # write out the seq dataframe as csv
  vroom::vroom_write(seq, here::here("./Source/sequences.csv"))
  
}