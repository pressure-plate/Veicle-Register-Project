# Questo script popola la relazione ‘CasaProduttrice’ con tuple generate casualmente

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

# Creo i data frame con cui popolerò il database recuperando i dati dai file csv

proprietario = read.csv("./PROGETTO/csv/proprietario.csv")
casaProduttrice = read.csv("./PROGETTO/csv/casaProduttrice.csv")
modello = read.csv("./PROGETTO/csv/modello.csv")
allestimento = read.csv("./PROGETTO/csv/allestimento.csv")
veicoloImmatricolato = read.csv("./PROGETTO/csv/veicoloImmatricolato.csv")
cessione = read.csv("./PROGETTO/csv/cessione.csv")


# Inserisco le tuple nelle varie relazioni           

dbWriteTable(con, name=c("motorizzazionecivile", "propietario"), value=proprietario, append=T, row.names=F)

dbWriteTable( con, name=c("motorizzazionecivile", "casaproduttrice"), value=casaProduttrice, append=T, row.names=F)

dbWriteTable( con, name=c("motorizzazionecivile", "modello"), value=modello, append=T, row.names=F)

dbWriteTable( con, name=c("motorizzazionecivile", "allestimento"), value=allestimento, append=T, row.names=F)

dbWriteTable( con, name=c("motorizzazionecivile", "veicoloimmatricolato"), value=veicoloImmatricolato, append=T, row.names=F)

dbWriteTable( con, name=c("motorizzazionecivile", "cessione"), value=cessione, append=T, row.names=F)


# Chiudo la connessione con il server
dbDisconnect(con)
