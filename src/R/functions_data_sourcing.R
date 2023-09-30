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
    paste0(ncbi_loc, "AllNuclMetadata.csv.gz"),
    select = c("#Accession", "Release_Date", "Species", 
               "Host", "Collection_Date")) %>% 
    dplyr::rename(Accession = `#Accession`)
  
  # write out the seq dataframe as csv
  vroom::vroom_write(seq, paste0(out_loc, "sequences.csv"))
  
  # return the seq object
  return(seq)
}

#' download_globi
#' 
#' @description Pull globi records from live online database. Note that this is
#' a somehwat frustrating process so you have to use pagination, by paging
#' results until the size of the page is less than the limit 
#' (e.g. nrows(interactions) < limit)
#' 
#' @param globi_loc chr. The output location of the file to be written when
#' all the pages are loaded in
#' 
#' @return globi_raw
download_globi <- function(globi_loc) {
  
  # set initializers
  j = 0
  k = 1 
  while(k > 0) {
    # call a specific page from the records
    page <- rglobi::get_interactions_by_taxa(
      sourcetaxon = 'Virus',
      targettaxon = 'Vertebrata',
      otherkeys = list("limit" = 1000, "skip" = 1000*j)
    )
    # this is iterating the k so when it's small it can stop
    k = nrow(page)
    # init the `all` variable on first pull then bind afterwards
    if(j == 0) {all <- page} else {
      all <- rbind(page,all)
    }
    j = (j + 1)
  }
  
  # do this again for "Viruses"
  while(k > 0) {
    page <- rglobi::get_interactions_by_taxa(
      sourcetaxon = 'Viruses',
      targettaxon = 'Vertebrata',
      otherkeys = list("limit" = 1000, "skip" = 1000*j))
    # iterate
    k = nrow(page)
    # binding
    all <- rbind(page,all)
    # iterate
    j = (j + 1)
    
  }
  
  # now only keep unique records and write the file 
  all <- unique(all)
  
  readr::write_csv(all, paste0(globi_loc, "GLOBI-raw.csv"))
  
}
