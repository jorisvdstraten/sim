tables <- c("Customers", "Employees", "Orders", "OrderLines", "Products", "ProductCategories", "ProductPrices", "SalesRegions", "Stock")

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

#' list all available simulations
#' @importFrom magrittr %>%
#' @export
listSimulations <- function()
{
  jsonlite::fromJSON("http://i885981core.venus.fhict.nl/sims/")
}

#' loads all tables
#' @importFrom magrittr %>%
#' @export
loadSimulation <- function(id)
{
  if (is.null(id)) {id <- "d620197a-5611-c0ab-5a60-135aefe8bc67"}
  con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
  
  for (i in 1:length(tables)){
    loadTable(id, tables[i], con)
  }
  
  # Load joinAll
  loadTable(id, tableName = NULL, con)
  
  con
}

#' loads all tables from default KlantArtikel database
#' @importFrom magrittr %>%
#' @export
loadBasicDatabase <- function()
{
  tables <- c("Customers", "Employees", "Orders", "OrderLines", "Products", "ProductCategories", "ProductPrices", "SalesRegions")
  con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
  
  for (i in 1:length(tables)){
    tableName <- tolower(tables[i])
    dplyr::copy_to(con, get(tableName), tableName)
  }
  
  dplyr::copy_to(con, MijnTabel, "MijnTabel")
  
  con
}
