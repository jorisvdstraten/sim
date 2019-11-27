id <- "6ccbb5c4-fa22-45dc-ad57-74c29cc8b3d6"

#' @importFrom magrittr %>%
loadTable <- function(id, tableName = NULL, con) {
  if (is.null(tableName))
  {
    tableName <- "joinAll"
    json <- jsonlite::fromJSON(paste0("http://i885981core.venus.fhict.nl/json/", id))
  }
  else {
    json <-jsonlite::fromJSON(paste0("http://i885981core.venus.fhict.nl/table/", tableName, "/", id))
  }
  
  df <- json %>% dplyr::mutate_at(dplyr::vars(dplyr::ends_with("date", ignore.case = TRUE)), lubridate::as_datetime)
  tbl <- json %>% 
    dplyr::mutate_at(dplyr::vars(dplyr::ends_with("date", ignore.case = TRUE)), as.character) %>% 
    dplyr::mutate_at(dplyr::vars(dplyr::ends_with("date", ignore.case = TRUE)), list(monthNr = ~lubridate::month(.), monthName = ~lubridate::month(., label = TRUE), yearNr = ~lubridate::year(.)))
    #dplyr::mutate_if(lubridate::is.POSIXct, list(monthNr = ~lubridate::month(.), monthName = ~lubridate::month(., label = TRUE), yearNr = ~lubridate::year(.)))
  
  # voor iedere datum kolom de maanden en jaren opsplitsen naar aparte kolommen
  # maand nummers en namen
  #tbl <- tbl %>% mutate_if(lubridate::is.POSIXct, list(monthNr = ~lubridate::month(.), monthName = ~lubridate::month(., label = TRUE), yearNr = ~lubridate::year(.)))
  
  #TODO: Use singular instead of plural table names
  #last.lets <- substr(word,nchar(word),nchar(word))
  # if(last.lets == "s")
  # {
  #   #remove 's'
  #   word <- substr(word,1,nchar(word)-1)
  # }
  
  assign(tolower(tableName), df, envir = sys.frame())
  
  dplyr::copy_to(con, tbl, tableName)
}


#' loads all tables
#' @importFrom magrittr %>%
#' @export
loadAllTables <- function(id = NULL)
{
  if (is.null(id)) {id <- "6ccbb5c4-fa22-45dc-ad57-74c29cc8b3d6"}
  con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
  
  tables <- c("Customers", "Employees", "Orders", "OrderLines", "Products", "ProductCategories", "ProductPrices", "SalesRegions", "Stock")
  
  for (i in 1:length(tables)){
    loadTable(id, tables[i], con)
  }
  
  # Load joinAll
  loadTable(id, tableName = NULL, con)
  
  con
}
