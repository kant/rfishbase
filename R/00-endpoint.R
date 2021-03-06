
## Allows us to define functions for each endpoint using closures
#' @importFrom dplyr left_join rename
endpoint <- function(endpt, join = NULL, by = NULL){
  
  function(species_list = NULL, fields = NULL, 
           server = NULL, ...){
    full_data <- fb_tbl(endpt, server = server)
    
    full_data <- fix_ids(full_data)
    out <- species_subset(species_list, full_data, server = server)
    
    if(!is.null(fields)){
      out <- out[fields]
    }
    
    if(!is.null(join))
      out <- left_join(out, join, by = by)
    
    out
  }
}


species_subset <- function(species_list, full_data, server = NULL){

  ## drop any existing Species column, 
  ## we'll get this data from joining on SpecCode
  full_data <- full_data[!( names(full_data) %in% "Species") ]

  if(is.null(species_list)){
    return(dplyr::left_join(fb_species(server), full_data, by = "SpecCode"))
  }
    
  ## 
  suppressMessages({
    out <- speccodes(species_list, db = fb_species(server), server) %>% 
      dplyr::left_join(fb_species(server), by = "SpecCode") %>%
      dplyr::left_join(full_data, by = "SpecCode")
  })
  out
}


fix_ids <- function(full_data){
  if("Speccode" %in% names(full_data)){ 
    full_data <- dplyr::rename(full_data, SpecCode = Speccode)
  }
  full_data
}
