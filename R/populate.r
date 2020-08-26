# Questo script popola la relazione ‘CasaProduttrice’ con tuple generate casualmente

#Carico in memoria il driver per PostgreSQL e mi connetto al database.

#install.packages("RPostgreSQL")
library("RPostgreSQL")
drv = dbDriver("PostgreSQL")
con = dbConnect(drv ,
                dbname = "postgres", 
                host =  "127.0.0.1", 
                port = "5432", 
                user = "postgres", 
                password = "admin")

print(con)

# Elimino eventuali tuple gia presenti così da evitare errori dovuti alla duplicazione
# della chiave primaria
dbSendQuery(con,
            "set search_path to MotorizzazioneCivile, public;

            delete from Propietario;")

dbSendQuery(con,
            "set search_path to MotorizzazioneCivile, public;

            delete from CasaProduttrice;")

dbSendQuery(con,
            "set search_path to MotorizzazioneCivile, public;

            delete from Modello;")

dbSendQuery(con,
            "set search_path to MotorizzazioneCivile, public;

            delete from Allestimento;")

dbSendQuery(con,
            "set search_path to MotorizzazioneCivile, public;

           delete from VeicoloImmatricolato;")

dbSendQuery(con,
            "set search_path to MotorizzazioneCivile, public;

            delete from Cessione;")

proprietario = read.csv("./R/data/csv/proprietario.csv")
casaProduttrice = read.csv("./R/data/csv/casaProduttrice.csv")
modello = read.csv("./R/data/csv/modello.csv")
allestimento = read.csv("./R/data/csv/allestimento.csv")
veicoloImmatricolato = read.csv("./R/data/csv/veicoloImmatricolato.csv")
#cessione = read.csv("./R/data/csv/cessione.csv")

# Inserisco le tuple nella relazione Proprietario            

    dbWriteTable(con, name=c("motorizzazionecivile", "propietario"), value=proprietario, append=T, row.names=F)

    dbWriteTable( con, name=c("motorizzazionecivile", "casaproduttrice"), value=casaProduttrice, append=T, row.names=F)

    dbWriteTable( con, name=c("motorizzazionecivile", "modello"), value=modello, append=T, row.names=F)

    dbWriteTable( con, name=c("motorizzazionecivile", "allestimento"), value=allestimento, append=T, row.names=F)

    dbWriteTable( con, name=c("motorizzazionecivile", "veicoloimmatricolato"), value=veicoloImmatricolato, append=T, row.names=F)

    #dbWriteTable( con, name=c("motorizzazionecivile", "cessione"), value=cessione, append=T, row.names=F)



# Chiudo la connessione con il server

dbDisconnect(con)