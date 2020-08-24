
cognomi = readLines("./R/data/cognomi.txt")
codiciFiscali = readLines("./R/data/codiciFiscali.txt")
nomi = readLines("./R/data/names.txt")
indirizzi = readLines("./R/data/comuni.txt")
caseProduttrici = readLines("./R/data/casaProduttrice.txt")
cavalliFiscali = readLines("./R/data/cavalliFiscali.txt")
cilindrate = readLines("./R/data/cilindrata.txt")
contattiTelefonici = readLines("./R/data/contattoTelefonico.txt")
data = readLines("./R/data/data.txt")
idModelli = readLines("./R/data/idModello.txt")
numeroPosti = readLines("./R/data/numeroPosti.txt")
numeroVersioni = readLines("./R/data/numeroVersione.txt")
targa = readLines("./R/data/targa.txt")
velocitaMassime = readLines("./R/data/velocitaMassima.txt")
allestimenti = readLines("./R/data/allestimento.txt")

numAllestimento = length(allestimenti)
allestimento = data.frame(
    nome=sample(allestimenti, numAllestimento, replace = F),
    data_inizio_produzione=sample(data, numAllestimento, replace = T),
    data_fine_produzione=sample(data, numAllestimento, replace=T),
    modello=sample(idModelli, numAllestimento, replace = F)
)

cessione = data.frame(
    data_passaggio=sample(data, num, replace = T),
    vecchio_propietario=sample(codiciFiscali, num, replace = T),
    nuovo_propietario=sample(codiciFiscali, num, replace = T),
    veicolo_immatricolato=sample(targa, num, replace=T)
)

numVeicoloImmatricolato = length(targa)
veicoloImmatricolato = data.frame(
    targa=sample(targa, numVeicoloImmatricolato, replace = F),
    data_immatricolazione=sample(data, numVeicoloImmatricolato, replace = T),
    propietario=sample(codiciFiscali, numVeicoloImmatricolato, replace = T),
    modello=sample(idModelli, numVeicoloImmatricolato, replace = T),
    versione=sample(numeroVersioni, numVeicoloImmatricolato, replace = T)
)

numModello = length(idModelli)
modello = data.frame(
    id_modello=sample(idModelli, numModello, replace = F),
    cilindrata=sample(cilindrate, numModello, replace = T),
    cavalli_fiscali=sample(cavalliFiscali, numModello, replace = T),
    velocita_massima=sample(velocitaMassime, numModello, replace = T),
    numero_posti=sample(numeroPosti, numModello, replace = T),
    alimentazione=sample(sample(0:5), numModello, replace = T),
    classe_veicolo=sample(sample(0:5), numModello, replace = T),
    casa_produttrice=sample(caseProduttrici, numModello, replace = T)
)
numCasaProduttrice = length(caseProduttrici)
casaProduttrice = data.frame(
    nome = sample(caseProduttrici, numCasaProduttrice, replace = F),
    direttore=sample(nomi, numCasaProduttrice, replace = T),
    contatto_telefonico=sample(contattiTelefonici, numCasaProduttrice, replace = T),
    indirizzo_sede=sample(indirizzi, numCasaProduttrice, replace= T)
)
numProprietario = length(codiciFiscali)
proprietario = data.frame(
    cf=sample(codiciFiscali, numProprietario, replace = F),
    nome=sample(nomi, numProprietario, replace = T),
    cognome=sample(cognomi, numProprietario, replace=T),
    residenza=sample(indirizzi, numProprietario, replace = T)
)



#install.packages("RPostgreSQL")
#library("RPostgreSQL")
#drv = dbDriver("PostgreSQL")



con = dbConnect(drv , dbname = "postgres", host =  "127.0.0.1", port = "5432", user = "postgres", password = "admin")
print(con)

tryCatch({
    dbWriteTable( con, name=c("motorizzazionecivile", "propietario"), value=proprietario, append=T, row.names=F)
}, error=function(e){})

tryCatch({
    dbWriteTable( con, name=c("motorizzazionecivile", "casaproduttrice"), value=casaProduttrice, append=T, row.names=F)
}, error=function(e){})

tryCatch({
    dbWriteTable( con, name=c("motorizzazionecivile", "modello"), value=modello, append=T, row.names=F)
}, error=function(e){})

tryCatch({
    dbWriteTable( con, name=c("motorizzazionecivile", "allestimento"), value=allestimento, append=T, row.names=F)
}, error=function(e){})

tryCatch({
    dbWriteTable( con, name=c("motorizzazionecivile", "veicoloimmatricolato"), value=veicoloImmatricolato, append=T, row.names=F)
}, error=function(e){})

tryCatch({
    dbWriteTable( con, name=c("motorizzazionecivile", "cessione"), value=cessione, append=T, row.names=F)
}, error=function(e){})





dbDisconnect(con)