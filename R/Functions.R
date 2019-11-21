id <- "6ccbb5c4-fa22-45dc-ad57-74c29cc8b3d6"

#' @importFrom magrittr %>%
loadTable <- function(tableName) {
  jsonlite::fromJSON(paste0("http://i885981core.venus.fhict.nl/table/", tableName, "/", id)) %>% 
    dplyr::mutate_at(dplyr::vars(dplyr::ends_with("date", ignore.case = TRUE)), lubridate::as_datetime)
}


#' loads all tables
#' @export
loadAllTables <- function()
{
  tables <- c("Customers", "Employees", "Orders", "OrderLines", "Products", "ProductCategories", "ProductPrices", "SalesRegions", "Stock")
  
  for (i in 1:length(tables)){
    assign(tolower(tables[i]), loadTable(tables[i]), envir = parent.frame())
  }
}