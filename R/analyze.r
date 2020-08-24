#Carico in memoria il driver per PostgreSQL e mi connetto al database.

install.packages("RPostgreSQL")
library("RPostgreSQL")
drv = dbDriver("PostgreSQL")
con = dbConnect(drv ,
                dbname = "postgres", 
                host =  "127.0.0.1", 
                port = "5432", 
                user = "postgres", 
                password = "admin")

print(con)

# Grafico delle case automobilistiche con più immatricolazioni

auto = dbGetQuery(con,
                   "set search_path to MotorizzazioneCivile, public;
                   
                   create or replace view Temp(casaProduttrice) as 
                   select " )