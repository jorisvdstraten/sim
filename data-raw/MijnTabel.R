library(magrittr)
library(readr)

MijnTabel <- structure(list(Klantnummer = c(1001, 1003, 1001, 1009, 1003, 
                                            1013, 1003, 1009, 1013), Klantnaam = c("Lucas Janssen", "Meriam Kluytmans", 
                                                                                   "Lucas Janssen", "Wim de Groot", "Meriam Kluytmans", "Grad Daemen", 
                                                                                   "Meriam Kluytmans", "Wim de Groot", "Grad Daemen"), Soort = c("Iphone", 
                                                                                                                                                 "Ipad", "Ipad", "Samsung", "Ipad", "Oppo", "Iphone", "Samsung", 
                                                                                                                                                 "Ipad"), Type = c("7", "Pro", "Mini", "S8", "Pro", "R17", "7", 
                                                                                                                                                                   "Galaxy  Tab", "Pro"), verkoopprijs = c(959, 1175, 895, 910, 
                                                                                                                                                                                                           1095, 740, 899, 723, 1078), `datum aanschaf` = structure(c(1536278400, 
                                                                                                                                                                                                                                                                      1536624000, 1541203200, 1544140800, 1551744000, 1553126400, 1559001600, 
                                                                                                                                                                                                                                                                      1559865600, 1566086400), class = c("POSIXct", "POSIXt"), tzone = "UTC"), 
                            `datum geleverd` = structure(c(1536451200, 1536883200, 1541548800, 
                                                           1544400000, 1551916800, 1554076800, 1559260800, 1560038400, 
                                                           1566691200), class = c("POSIXct", "POSIXt"), tzone = "UTC")), row.names = c(NA, 
                                                                                                                                       -9L), class = c("tbl_df", "tbl", "data.frame"))
usethis::use_data(MijnTabel, overwrite = TRUE)