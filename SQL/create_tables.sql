-- CREATE SCHEMA VehicleRegister;


DROP TABLE IF EXISTS Versione;
DROP TABLE IF EXISTS Cessione;
DROP TABLE IF EXISTS VeicoloImmatricolato;
DROP TABLE IF EXISTS Modello;
DROP TABLE IF EXISTS CasaProduttrice;
DROP TABLE IF EXISTS Propietario;

DROP SEQUENCE IF EXISTS id_pratica_serial;
DROP SEQUENCE IF EXISTS id_versione_serial;

DROP TYPE IF EXISTS alimentazioni;
DROP TYPE IF EXISTS veicoli;

DROP DOMAIN IF EXISTS id_propietario;
DROP DOMAIN IF EXISTS id_veicolo_immatricolato;

-- creazione delle 2 sequenza auto incrementanti
CREATE SEQUENCE id_pratica_serial;
CREATE SEQUENCE id_versione_serial;

-- creazione di un tipo per l'enumerazione
CREATE TYPE alimentazioni AS ENUM('diesel', 'benzina', 'metano', 'gpl', 'elettrico', 'altro');
CREATE TYPE veicoli AS ENUM('macchina', 'moto', 'motociclo', 'camion', 'trattore', 'altro');

-- creazione di tipi dedicati per le chiavi primarie che devono essere usate come fk
CREATE DOMAIN string AS varchar(60);
CREATE DOMAIN id_propietario AS varchar(20);
CREATE DOMAIN id_veicolo_immatricolato AS varchar(10);


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
  cilindrata real,
  cavalli_fiscali real,
  velocita_massima int,
  numero_posti int,
  alimentazione alimentazioni,
  classe_veicolo veicoli, -- tipo di veicolo auto, moto, camion
  motorizzazione string, -- dettagli sul tipo di motore
  
  casa_produttrice string, -- fk
  
  PRIMARY KEY(id_modello),
  
  CONSTRAINT fk_casa_produttrice
    FOREIGN KEY(casa_produttrice)
      REFERENCES CasaProduttrice(nome)
);

CREATE TABLE VeicoloImmatricolato
(
	targa id_veicolo_immatricolato not null,
	data_immatricolazione timestamp not null,
  
  propietario id_propietario, -- fk
  modello integer, -- fk
  
  PRIMARY KEY(targa),
  
  CONSTRAINT fk_propietario
    FOREIGN KEY(propietario)
      REFERENCES Propietario(cf),
  
  CONSTRAINT fk_modello
    FOREIGN KEY(modello)
      REFERENCES Modello(id_modello)
);

CREATE TABLE Cessione
(
	id_pratica integer NOT NULL DEFAULT nextval('id_pratica_serial'),
  data_passaggio timestamp,
	
  vecchio_propietario id_propietario, -- fk
	nuovo_propietario id_propietario, -- fk
  veicolo_immatricolato id_veicolo_immatricolato, -- fk
	
  PRIMARY KEY(id_pratica),

  CONSTRAINT fk_vecchio_propietario
		FOREIGN KEY(vecchio_propietario)
      REFERENCES Propietario(cf),

  CONSTRAINT fk_nuovo_propietario
		FOREIGN KEY(nuovo_propietario)
      REFERENCES Propietario(cf),

	CONSTRAINT fk_veicolo_immatricolato
		FOREIGN KEY(veicolo_immatricolato)
		  REFERENCES VeicoloImmatricolato(targa)
);

create table Versione
(
  numero_versione int,
  numero_pezzi_prodotti int,
  data_inizio_produzione date,
  data_fine_produzione date,

  modello integer, --fk

  PRIMARY KEY(numero_versione, modello),

  CONSTRAINT fk_modello
		FOREIGN KEY(modello)
		  REFERENCES Modello(id_modello)
);
