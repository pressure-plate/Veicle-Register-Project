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
                   
                    select modello, count(*) as n
                    from veicoloimmatricolato
                    group by modello;" )

k=3
barplot(height = auto$n[1:k],
        names.arg = auto$modello[1:k],
        main ="Modelli più immatricolati",
        ylab ="Numero immatricolazioni",
        xlab ="Modello",
        cex.names =0.9)