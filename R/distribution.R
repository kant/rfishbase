## Consider information from: Countries | FAO areas | Ecosystems | Occurrences | Point map | Introductions | Faunaf


#' country
#' 
#' return a table of country for the requested species, as reported in FishBASE.org 
#' 
#' @inheritParams species
#' @export
#' @examples \dontrun{
#' country(species_list(Genus='Labroides'))
#' }
#' @details 
#' e.g. http://www.fishbase.us/Country
country <- endpoint("country", join = country_names())

#' countrysub
#' 
#' return a table of countrysub for the requested species
#' 
#' @inheritParams species
#' @export
#' @examples \dontrun{
#' countrysub(species_list(Genus='Labroides'))
#' }
countrysub <- endpoint("countrysub", join = country_names())

#' countrysubref
#' 
#' return a table of countrysubref
#' @inheritParams species
#' @export
#' @examples \dontrun{
#' countrysubref()
#' }
countrysubref <- function(server = NULL){
  fb_tbl("countrysubref", server) %>% left_join(country_names())
}


#' c_code
#' 
#' return a table of country information for the requested c_code, as reported in FishBASE.org 
#' 
#' @inheritParams species
#' @param c_code a C_Code or list of C_Codes (FishBase country code)
#' @export
#' @examples \dontrun{
#' c_code(440)
#' }
#' @details 
#' e.g. http://www.fishbase.us/Country
c_code <- function(c_code = NULL, 
                   server = NULL, 
                   ...){
  
  out <- 
    fb_tbl("countrysubref", server) %>% 
    left_join(country_names(server))
  
  if(is.null(c_code)) 
    out
  else
    out %>% filter(C_Code %in% c_code)
}

globalVariables(c("C_Code", "PAESE"))

country_names <- function(server = NULL){
  fb_tbl("countref", server) %>% select(country = PAESE, C_Code)
}
#' distribution
#' 
#' return a table of species locations as reported in FishBASE.org FAO location data
#' 
#' @inheritParams species
#' @export
#' @examples \dontrun{
#' distribution(species_list(Genus='Labroides'))
#' }
#' @details currently this is ~ FAO areas table (minus "note" field)
#' e.g. http://www.fishbase.us/Country/FaoAreaList.php?ID=5537
distribution <- function(species_list=NULL, fields = NULL, 
                         server = NULL, ...){
  faoareas(species_list, fields = fields, server = server)
}


#' faoareas
#' 
#' return a table of species locations as reported in FishBASE.org FAO location data
#' 
#' @inheritParams species
#' @importFrom dplyr left_join
#' @export
#' @return a tibble, empty tibble if no results found
#' @examples 
#' \dontrun{
#'   faoareas()
#' }
#' @details currently this is ~ FAO areas table (minus "note" field)
#' e.g. http://www.fishbase.us/Country/FaoAreaList.php?ID=5537
faoareas <- function(species_list = NULL, fields = NULL, server = NULL, ...){
  area <- fb_tbl("faoareas", server)
  ref <- faoarrefs(server)
  out <- left_join(area, ref, by = "AreaCode")
  out <- select_fields(out, fields)
  species_subset(species_list, out, server)
}

select_fields <- function(df, fields = NULL){
  if (is.null(fields)) return(df)
  do.call(dplyr::select, 
           c(list(df), as.list(c("SpecCode", fields))))
}

faoarrefs <- function(server = NULL){
  fb_tbl("faoarref", server)
}


## FIXME: Reproduce the ECOSYSTEMS table: 
# see `ecosystem` sql-table
# http://www.fishbase.us/trophiceco/EcosysList.php?ID=5537

#' ecosystem
#' 
#' @return a table of species ecosystems data
#' @inheritParams species
#' @export
#' @examples \dontrun{
#' ecosystem("Oreochromis niloticus")
#' }
ecosystem <- endpoint("ecosystem", 
                      join = fb_tbl("ecosystemref", server = NULL), 
                      by = "E_CODE")

#' occurrence
#' 
#' @details THE OCCURRENCE TABLE HAS BEEN DROPPED BY FISHBASE - THIS
#' FUNCTION NOW RETURNS A STOP MESSAGE.
#' @export
occurrence <- function() {
  stop("occurrence is no longer available", call. = FALSE)
  #endpoint("occurrence")
}

#' introductions
#' 
#' @return a table of species introductions data
#' @inheritParams species
#' @export
#' @examples \dontrun{
#' introductions("Oreochromis niloticus")
#' }
introductions <- endpoint("intrcase")

#' stocks
#' 
#' @return a table of species stocks data
#' @inheritParams species
#' @export
#' @examples \dontrun{
#' stocks("Oreochromis niloticus")
#' }
stocks <- endpoint("stocks")


## Not indexed by speccode, needs new method
# country <- endpoint("country")
# countryref <- 

