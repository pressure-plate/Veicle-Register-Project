start transaction;

DROP schema if EXISTS MotorizzazioneCivile CASCADE;
create schema MotorizzazioneCivile;
set search_path to MotorizzazioneCivile, public;


-- ---------------------------------------------
-- DEFINIZIONE DOMINI E TIPO
-- ---------------------------------------------

-- creazione delle sequenze auto incrementanti
CREATE SEQUENCE id_pratica_serial;

-- creazione di un tipo per l'enumerazione
CREATE TYPE enum_alimentazioni AS ENUM('diesel', 'benzina', 'metano', 'gpl', 'elettrico', 'altro');
CREATE TYPE enum_veicoli AS ENUM('auto', 'moto', 'motociclo', 'camion', 'trattore', 'altro');

-- creazione di tipi dedicati per le chiavi primarie 
-- che devono essere usate molteplici volte come fk
CREATE DOMAIN id_propietario AS varchar(20);
CREATE DOMAIN id_veicolo_immatricolato AS varchar(10);

-- altri dati molto usati
CREATE DOMAIN string AS varchar(60);
CREATE DOMAIN numero_pezzi as int
    not null
    check (value > 0);

CREATE DOMAIN alimentazioni AS enum_alimentazioni
  not null;

CREATE DOMAIN veicoli AS enum_veicoli
  not null;


-- ---------------------------------------------
-- DEFINIZIONE RELAZIONI
-- ---------------------------------------------


CREATE TABLE Propietario(
  cf id_propietario,
  nome string,
  cognome string,
  residenza string,
  PRIMARY KEY(cf)
);


CREATE TABLE CasaProduttrice
(
  nome string,
  direttore string,
  contatto_telefonico string,
  indirizzo_sede string,
  PRIMARY KEY(nome)
);


create table Modello
(
  modello string,
  cilindrata real NOT NULL,
  cavalli_fiscali real NOT NULL,
  velocita_massima integer NOT NULL,
  numero_posti integer NOT NULL,
  alimentazione alimentazioni NOT NULL, -- benzina, diesel, metano, etc.
  classe_veicolo veicoli NOT NULL, -- tipo di veicolo auto, moto, camion
  
  casa_produttrice string , -- fk
  
  PRIMARY KEY(modello),
  
  -- se la casa produttrice viene eliminata non rimuovere il riferimento
  FOREIGN KEY(casa_produttrice) 
    REFERENCES CasaProduttrice(nome)
      on update cascade on delete no action
);


create table Allestimento
(
  nome string,
  data_inizio_produzione date NOT NULL,
  data_fine_produzione date,

  modello string, --fk

  PRIMARY KEY(nome, modello),

  -- impedisci calcellazione modello se ci sono allestimenti
  CONSTRAINT fk_modello
		FOREIGN KEY(modello)
		  REFERENCES Modello(modello)
        on update cascade 
);


CREATE TABLE VeicoloImmatricolato
(
  targa id_veicolo_immatricolato,
  data_immatricolazione timestamp NOT NULL,
  rottamato boolean not null default false,
  
  propietario id_propietario, -- fk
  modello string, -- fk
  allestimento string, -- fk
  
  PRIMARY KEY(targa),
  
  -- impedisci cancellazioe del propietario
  CONSTRAINT fk_propietario
    FOREIGN KEY(propietario) 
      REFERENCES Propietario(cf)
        on update cascade,

  -- permetti la cancellazione di allestimento e modelo
  -- solo dopo che tutti i veicolo sono rottamati

  CONSTRAINT fk_modello
    FOREIGN KEY(modello)
      REFERENCES Modello(modello)
        on update cascade,

  CONSTRAINT fk_allestimento
    FOREIGN KEY(allestimento, modello) 
      REFERENCES Allestimento(nome, modello)
        on update cascade
);


CREATE TABLE Cessione
(
	id_pratica integer DEFAULT nextval('id_pratica_serial'),
  data_passaggio timestamp NOT NULL,
	
  vecchio_propietario id_propietario, -- fk
	nuovo_propietario id_propietario, -- fk
  veicolo_immatricolato id_veicolo_immatricolato, -- fk
	
  PRIMARY KEY(id_pratica),

  -- setta a null quando il propietario viene cancellato
  FOREIGN KEY(vecchio_propietario)
    REFERENCES Propietario(cf)
      on update cascade on delete set null,

  -- impedisci la cancellazione del nuovo propietario
  -- l'eliminazione puo' avvenire solo se prima si elimna il veicolo immatricolato
  CONSTRAINT fk_nuovo_propietario
		FOREIGN KEY(nuovo_propietario)
      REFERENCES Propietario(cf)
        on update cascade on delete set null,

  -- quando il veicolo viene cancellato
  -- cancella tutte le cessioni
  FOREIGN KEY(veicolo_immatricolato)
    REFERENCES VeicoloImmatricolato(targa)
      on update cascade on delete cascade
);


commit;
