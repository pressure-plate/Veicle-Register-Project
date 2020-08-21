num = 10
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
numeroPezzi = readLines("./R/data/numeroPezzi.txt")
numeroPosti = readLines("./R/data/numeroPosti.txt")
numeroVersioni = readLines("./R/data/numeroVersione.txt")
targa = readLines("./R/data/targa.txt")
velocitaMassime = readLines("./R/data/velocitaMassima.txt")
motorizzazioni = readLines("./R/data/motorizzazione.txt")


versione = data.frame(
    numero_versione = 1:num,
    numero_pezzi_prodotti=sample(numeroPezzi, num, replace = T),
    data_inizio_produzione=sample(data, num, replace = T),
    data_fine_produzione=sample(data, num, replace=T),
    modello=sample(idModelli, num, replace = F)
)

cessione = data.frame(
    id_pratica = 1:num,
    data_passaggio=sample(data, num, replace = T),
    vecchio_propietario=sample(codiciFiscali, num, replace = T),
    nuovo_propietario=sample(codiciFiscali, num, replace = T),
    veicolo_immatricolato=sample(targa, num, replace=T)
)

veicoloImmatricolato = data.frame(
    targa=sample(targa, num, replace = F),
    data_immatricolazione=sample(data, num, replace = T),
    rottamato=sample(c(T, F), num, replace=T),
    propietario=sample(codiciFiscali, num, replace = T),
    modello=sample(idModelli, num, replace = T),
    versione=sample(numeroVersioni, num, replace = T)
)

modello = data.frame(
    id_modello=sample(idModelli, num, replace = F),
    cilindrata=sample(cilindrate, num, replace = T),
    cavalli_fiscali=sample(cavalliFiscali, num, replace = T),
    velocita_massima=sample(velocitaMassime, num, replace = T),
    numero_posti=sample(numeroPosti, num, replace = T),
    alimentazione=sample(sample(0:5), num, replace = T),
    classe_veicolo=sample(sample(0:5), num, replace = T),
    motorizzazione=sample(motorizzazioni, num, replace = T),
    casa_produttrice=sample(caseProduttrici, num, replace = T)
)

casaProduttrice = data.frame(
    nome = sample(caseProduttrici, num, replace = F),
    direttore=sample(nomi, num, replace = T),
    contatto_telefonico=sample(contattiTelefonici, num, replace = T),
    indirizzo_sede=sample(indirizzi, num, replace= T)
)

proprietario = data.frame(
    cf=sample(codiciFiscali, num, replace = F),
    nome=sample(nomi, num, replace = T),
    cognome=sample(cognomi, num, replace=T),
    residenza=sample(indirizzi, num, replace = T)
)



#install.packages("RPostgreSQL")
#library("RPostgreSQL")
#drv = dbDriver("PostgreSQL")



con = dbConnect(drv , dbname = "postgres", host =  "127.0.0.1", port = "5432", user = "postgres", password = "admin")
print(con)

dbWriteTable( con, name=c("public", "Proprietario"), value=proprietario)
dbWriteTable( con, name=c("public", "CasaProduttrice"), value=casaProduttrice)
dbWriteTable( con, name=c("public", "Modello"), value=modello)
dbWriteTable( con, name=c("public", "Versione"), value=versione)
dbWriteTable( con, name=c("public", "VeicoloImmatricolato"), value=veicoloImmatricolato)
dbWriteTable( con, name=c("public", "Cessione"), value=cessione)

dbDisconnect(con)