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

# Recupero i dati sulle auto più vendute interrogando la base di dati
auto = dbGetQuery(con,
                   "set search_path to MotorizzazioneCivile, public;
                   
                    select modello, count(*) as n
                    from veicoloimmatricolato
                    group by modello;" )

# Grafico delle case automobilistiche con più immatricolazioni
k=6
barplot(height = auto$n[1:k],
        names.arg = auto$modello[1:k],
        main ="Modelli più immatricolati",
        ylab ="Numero immatricolazioni",
        xlab ="Modello",\
        cex.names =0.9)


# Recupero i dati sugli allestimenti interrogando la base di dati
allestimentiAuto = dbGetQuery(con,
                   "set search_path to MotorizzazioneCivile, public;
                   
                    select allestimento, count(*) as x
                    from veicoloimmatricolato
                    group by allestimento;" )
# Grafico degli allestimenti più scelti.
k=5
barplot(height = allestimentiAuto$x[1:k],
        names.arg = allestimentiAuto$allestimento[1:k],
        main ="Allestimenti più Scelti",
        ylab ="Percentuale scelta dell'allestimento ",
        xlab ="Allestimento",
        cex.names =0.9)      
                     
# Chiudo la connessione con il server.        
dbDisconnect(con)