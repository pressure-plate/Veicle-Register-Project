V_cognomi = readLines("./R/data/surnames.txt")
V_nomi = readLines("./R/data/names.txt")
V_residenza = readLines("./R/data/comuni.txt")
V_alimentazione = readLines("./R/data/alimentazione.txt")
V_casaproduttrice = readLines("./R/data/casaproduttrice.txt)
V_cavallifiscali = readLines("./R/data/cavallifiscali.txt")
V_cilindrata = readLines("./R/data/cilindrata.txt")
V_classeveicolo = readLines("./R/data/classeveicolo.txt")
V_contattotelefonico = readLines("./R/data/contattotelefonico.txt")
V_data = readLines("./R/data/data.txt")
V_idModello = readLines("./R/data/idModello.txt")
V_numeropezzi = readLines("./R/data/numeropezzi.txt")
V_numeroposti = readLines("./R/data/numeroposti.txt")
V_numeroversione = readLines("./R/data/numeroversione.txt")
V_targa = readLines("./R/data/targa.txt")
V_velocitàmassima = readLines("./R/data/velocitàmassima.txt")

#install.packages("RPostgreSQL")
#library("RPostgreSQL")
drv = dbDriver("PostgreSQL")



con = dbConnect(drv , dbname = "postgres", host =  "127.0.0.1", port = "5432", user = "postgres", password = "admin")
print(con)

dbWriteTable( con, name=c("public", "casaproduttrice"), value=<data_frame>)
dbWriteTable( con, name=c("public", "casaproduttrice"), value=<data_frame>)
dbWriteTable( con, name=c("public", "casaproduttrice"), value=<data_frame>)
dbWriteTable( con, name=c("public", "casaproduttrice"), value=<data_frame>)





dbDisconnect(con)