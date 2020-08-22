-- CREATE SCHEMA VehicleRegister;


DROP TABLE IF EXISTS Cessione;
DROP TABLE IF EXISTS VeicoloImmatricolato;
DROP TABLE IF EXISTS Versione;
DROP TABLE IF EXISTS Modello;
DROP TABLE IF EXISTS CasaProduttrice;
DROP TABLE IF EXISTS Propietario;

DROP SEQUENCE IF EXISTS id_pratica_serial;


DROP TYPE IF EXISTS alimentazioni;
DROP TYPE IF EXISTS veicoli;

DROP TYPE IF EXISTS enum_alimentazioni;
DROP TYPE IF EXISTS enum_veicoli;

DROP DOMAIN IF EXISTS id_propietario;
DROP DOMAIN IF EXISTS id_veicolo_immatricolato;
DROP DOMAIN IF EXISTS string;
DROP DOMAIN IF EXISTS numero_pezzi;

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


-- ---------------------------------------------------------------
-- RELAZIONI
-- ---------------------------------------------------------------

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
  id_modello integer,
  cilindrata real NOT NULL,
  cavalli_fiscali real NOT NULL,
  velocita_massima integer NOT NULL,
  numero_posti integer NOT NULL,
  alimentazione alimentazioni NOT NULL,
  classe_veicolo veicoli NOT NULL, -- tipo di veicolo auto, moto, camion
  
  casa_produttrice string , -- fk
  
  PRIMARY KEY(id_modello),
  
  FOREIGN KEY(casa_produttrice) REFERENCES CasaProduttrice(nome)
    on update cascade on delete cascade
);


create table Versione
(
  nome_versione string,
  data_inizio_produzione date NOT NULL,
  data_fine_produzione date,

  modello integer, --fk

  PRIMARY KEY(nome_versione, modello),

  CONSTRAINT fk_modello
		FOREIGN KEY(modello)
		  REFERENCES Modello(id_modello)
);


CREATE TABLE VeicoloImmatricolato
(
  targa id_veicolo_immatricolato,
  data_immatricolazione timestamp NOT NULL,
  rottamato boolean not null default false,
  
  propietario id_propietario, -- fk
  modello integer, -- fk
  versione string, -- fk
  
  PRIMARY KEY(targa),
  
  CONSTRAINT fk_propietario
    FOREIGN KEY(propietario) 
      REFERENCES Propietario(cf)
        on update cascade on delete no action,
  
  CONSTRAINT fk_modello
    FOREIGN KEY(modello)
      REFERENCES Modello(id_modello)
        on update cascade on delete no action,
  
  CONSTRAINT fk_versione
    FOREIGN KEY(versione, modello) 
      REFERENCES Versione(nome_versione, modello)
        on update cascade on delete no action
);

CREATE TABLE Cessione
(
	id_pratica integer DEFAULT nextval('id_pratica_serial'),
  data_passaggio timestamp NOT NULL,
	
  vecchio_propietario id_propietario, -- fk
	nuovo_propietario id_propietario, -- fk
  veicolo_immatricolato id_veicolo_immatricolato, -- fk
	
  PRIMARY KEY(id_pratica),

  CONSTRAINT fk_vecchio_propietario
		FOREIGN KEY(vecchio_propietario)
      REFERENCES Propietario(cf)
        on update cascade on delete set null,

  CONSTRAINT fk_nuovo_propietario
		FOREIGN KEY(nuovo_propietario)
      REFERENCES Propietario(cf)
        on update cascade on delete set null,

	CONSTRAINT fk_veicolo_immatricolato
		FOREIGN KEY(veicolo_immatricolato)
		  REFERENCES VeicoloImmatricolato(targa)
        on update cascade on delete cascade
);
