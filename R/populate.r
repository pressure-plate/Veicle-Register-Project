V_cognomi = readLines("./R/data/surnames.txt")
V_nomi = readLines("./R/data/names.txt")
V_residenza = readLines("./R/data/comuni.txt")

#install.packages("RPostgreSQL")
#library("RPostgreSQL")
drv = dbDriver("PostgreSQL")



con = dbConnect(drv , dbname = "postgres", host =  "127.0.0.1", port = "5432", user = "postgres", password = "admin")
print(con)







dbDisconnect(con)