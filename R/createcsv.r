con = dbConnect(drv ,
                dbname = "postgres", 
                host =  "127.0.0.1", 
                port = "5432", 
                user = "postgres", 
                password = "admin")

print(con)


# Leggo i valori da inserire nelle tuple da file di testo
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
case = c("Fiat","Ford","Volkswagen","Suzuki","Audi","BMW","Ferrari","Dacia","Skoda","Seat","Toyota","Mazda","Tesla")



modelliAllestitiQuery = dbGetQuery(con,
                              "set search_path to MotorizzazioneCivile, public;
                   
                                select nome, modello
                                from Allestimento;")


write.csv(modelliAllestitiQuery, "./R/data/csv/modelliAllestiti.csv", row.names=FALSE)


# Genero un campione di tuple da inserire nella tabella della relazione Allestimento

numAllestimento = length(idModelli)
allestimento = data.frame(
    nome=sample(allestimenti, numAllestimento, replace = T),
    data_inizio_produzione=sample(data, numAllestimento, replace = T),
    data_fine_produzione=sample(data, numAllestimento, replace=T),
    modello=sample(idModelli, numAllestimento, replace = F)
)
write.csv(allestimento, "./R/data/csv/allestimento.csv", row.names=FALSE)

num = 30
cessione = data.frame(
    data_passaggio=sample(data, num, replace = T),
    vecchio_propietario=sample(codiciFiscali, num, replace = T),
    nuovo_propietario=sample(codiciFiscali, num, replace = T),
    veicolo_immatricolato=sample(targa, num, replace=T)
)

numVeicoloImmatricolato = length(targa)
veicoloImmatricolato = data.frame(
    targa=targa,
    data_immatricolazione=sample(data, numVeicoloImmatricolato, replace = T),
    propietario=sample(codiciFiscali, numVeicoloImmatricolato, replace = T),
    modello=modelliAllestitiQuery[,2],
    allestimento=modelliAllestitiQuery[,1]

)
write.csv(veicoloImmatricolato, "./R/data/csv/veicoloImmatricolato.csv", row.names=FALSE)

numModello = length(idModelli)
modello = data.frame(
    modello=idModelli,
    cilindrata=sample(cilindrate, numModello, replace = T),
    cavalli_fiscali=sample(cavalliFiscali, numModello, replace = T),
    velocita_massima=sample(velocitaMassime, numModello, replace = T),
    numero_posti=sample(numeroPosti, numModello, replace = T),
    alimentazione=sample(c('diesel', 'benzina', 'metano', 'gpl', 'elettrico', 'altro'), numModello, replace = T),
    classe_veicolo=sample(c('auto', 'moto', 'motociclo', 'camion', 'trattore', 'altro'), numModello, replace = T),
    casa_produttrice=caseProduttrici
)
write.csv(modello, "./R/data/csv/modello.csv", row.names=FALSE)

numCasaProduttrice = length(case)
casaProduttrice = data.frame(
    nome = case,
    direttore=sample(nomi, numCasaProduttrice, replace = T),
    contatto_telefonico=sample(contattiTelefonici, numCasaProduttrice, replace = T),
    indirizzo_sede=sample(indirizzi, numCasaProduttrice, replace= T)
)
write.csv(casaProduttrice, "./R/data/csv/casaProduttrice.csv", row.names=FALSE)

numProprietario = length(codiciFiscali)
proprietario = data.frame(
    cf=sample(codiciFiscali, numProprietario, replace = F),
    nome=sample(nomi, numProprietario, replace = T),
    cognome=sample(cognomi, numProprietario, replace=T),
    residenza=sample(indirizzi, numProprietario, replace = T)
)
write.csv(proprietario, "./R/data/csv/proprietario.csv", row.names=FALSE)


dbDisconnect(con)