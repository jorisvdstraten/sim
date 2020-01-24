library(magrittr)
library(readr)

tables <- c("Customers", "Employees", "Orders", "OrderLines", "Products", "ProductCategories", "ProductPrices", "SalesRegions")

LoadAndSaveTable <- function(tableName) {
  json <-jsonlite::fromJSON(paste0("http://i885981core.venus.fhict.nl/table/", tableName, "/", "d620197a-5611-c0ab-5a60-135aefe8bc67"))
  
  #df <- json %>% dplyr::mutate_at(dplyr::vars(dplyr::ends_with("date", ignore.case = TRUE)), lubridate::as_datetime)
  tbl <- json %>% 
    dplyr::mutate_at(dplyr::vars(dplyr::ends_with("date", ignore.case = TRUE)), as.character) %>% 
    dplyr::mutate_at(dplyr::vars(dplyr::ends_with("date", ignore.case = TRUE)), list(monthNr = ~lubridate::month(.), monthName = ~lubridate::month(., label = TRUE), yearNr = ~lubridate::year(.)))
  
  tblName <- tolower(tableName)
  assign(tblName, tbl, envir = sys.frame())
  save(list=tblName, file=paste0("data/", tblName, ".rda"))
  rm(tblName)
}

for (i in 1:length(tables)){
  LoadAndSaveTable(tables[i])
}
