CREATE DATABASE VehicleRegister;


DROP TABLE IF EXISTS Cessione;
DROP TABLE IF EXISTS Propietario;
DROP TABLE IF EXISTS VeicoloImmatricolato;
DROP TABLE IF EXISTS Modello;
DROP TABLE IF EXISTS CasaProduttrice;
DROP TABLE IF EXISTS Versione;

DROP SEQUENCE IF EXISTS id_pratica_serial;
DROP SEQUENCE IF EXISTS id_versione_serial;

CREATE SEQUENCE id_pratica_serial;
CREATE SEQUENCE id_versione_serial;

CREATE TABLE Propietario(
  cf varchar(20),
  nome varchar(20),
  cognome varchar(20),
  residenza varchar(50),
  PRIMARY KEY(cf)
);

CREATE TABLE CasaProduttrice
(
  nome varchar(20),
  direttore varchar(30),
  contatto_telefonico varchar(30),
  indirizzo_sede varchar(30),
  gruppo varchar(30),
  PRIMARY KEY(nome)
);

CREATE TABLE VeicoloImmatricolato
(
	targa varchar(10) not null,
	data_ummatricolazione timestamp not null,
  PRIMARY KEY(targa),
  CONSTRAINT propietario
    FOREIGN KEY(propietario)
      REFERENCES Propietario(cf),
  CONSTRAINT modello
    FOREIGN KEY(modello)
      REFERENCES Modello(id_modello)
);

CREATE TABLE Cessione
(
	id_pratica integer NOT NULL DEFAULT nextval('id_pratica_serial'),
	ex_propietario varchar(10),
	nuovo_propietario varchar(10),
	data_passaggio timestamp,
	PRIMARY KEY(id_pratica),
	CONSTRAINT veicolo_immatricolato
		FOREIGN KEY(veicolo_immatricolato)
		REFERENCES VeicoloImmatricolato(targa)
);

create table Versione
(
  id_versione integer NOT NULL DEFAULT nextval('id_versione_serial'),
  numero_versione int,
  numero_pezzi_prodotti int,
  data_inizio_produzione date,
  data_fine_produzione date,
  PRIMARY KEY(id_versione)
);

create table Modello
(
  id_modello integer,
  nome_modello varchar(10),
  alimentazione int,
  fabbrica int references vehicle_register.Fabbrica(ID_fabbrica),
  PRIMARY KEY(id_modello),
  CONSTRAINT casa_produttrice
    FOREIGN KEY(casa_produttrice)
      REFERENCES CasaProduttrice(nome)
);
