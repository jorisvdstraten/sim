id <- "6ccbb5c4-fa22-45dc-ad57-74c29cc8b3d6"

#' @importFrom magrittr %>%
loadTable <- function(id, tableName = NULL) {
  if (is.null(tableName))
  {
    jsonlite::fromJSON(paste0("http://i885981core.venus.fhict.nl/json/", id)) %>% 
      dplyr::mutate_at(dplyr::vars(dplyr::ends_with("date", ignore.case = TRUE)), lubridate::as_datetime)
  }
  else {
    jsonlite::fromJSON(paste0("http://i885981core.venus.fhict.nl/table/", tableName, "/", id)) %>% 
      dplyr::mutate_at(dplyr::vars(dplyr::ends_with("date", ignore.case = TRUE)), lubridate::as_datetime)
  }
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
    assign(tolower(tables[i]), loadTable(id, tables[i]), envir = parent.frame())
    dplyr::copy_to(con, get(tolower(tables[i])), tolower(tables[i]))
  }
  
  # JoinThemAll
  assign("joinAll", loadTable(id), envir = parent.frame())
  dplyr::copy_to(con, get("joinAll"), "joinAll")
  
  con
}
