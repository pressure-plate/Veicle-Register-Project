library("RPostgreSQL")
drv = dbDriver("PostgreSQL")
con = dbConnect(drv ,
                dbname = "postgres", 
                host =  "127.0.0.1", 
                port = "5432", 
                user = "postgres", 
                password = "admin")

print(con)

modelliAllestitiQuery = dbGetQuery(con,
                                "set search_path to MotorizzazioneCivile, public;
                   
                                select nome, modello
                                from Allestimento;")


#write.csv(modelliAllestitiQuery, "./R/data/csv/modelliAllestiti.csv", row.names=FALSE)

dbDisconnect(con)