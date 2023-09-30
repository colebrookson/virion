#' Install Julia packages to use the functions for NCBI
#' 
#' Here we use the JuliaCall library to get the funcitons we need 

#' install_ncbi
#' 
#' @description this function exists to install the julia packages that are 
#' needed if they dont' seem to be installed
#' 
#' @return none  
install_ncbi <- function() {
  
  # install the packages if needed 
  JuliaCall::julia_install_package_if_needed("NCBITaxonomy")
  JuliaCall::julia_install_package_if_needed("DataFrames")
  JuliaCall::julia_install_package_if_needed("CSV")
  JuliaCall::julia_install_package_if_needed("ProgressMeter")
}